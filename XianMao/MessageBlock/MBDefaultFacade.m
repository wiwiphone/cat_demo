//
//  MBDefaultFacade.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <objc/message.h>
#import <pthread.h>
#import "MBDefaultFacade.h"
#import "MBDefaultNotification.h"
#import "MBUtil.h"
#import "MBDefaultCommandInvocation.h"

typedef enum {
    MB_REG_COMMAND_INIT,
    MB_REG_COMMAND_ASYNC_DOING,
    MB_REG_COMMAND_DONE
} MB_REG_COMMAND_STATUE;

@implementation MBDefaultFacade {
@private
    NSNotificationCenter *_notificationCenter;
    dispatch_queue_t _command_queue;
    NSOperationQueue *_dispatch_message_queue;
    MB_REG_COMMAND_STATUE _regCommandStatus;
    NSMutableArray *_waitingNotification;
    
    NSArray *_interceptors;
    
    NSMutableSet *_subscribeReceivers;
}

static NSOperationQueue *_c_dispatch_queue = nil;

+ (void)setDispatchQueue:(NSOperationQueue *)queue {
    _c_dispatch_queue = queue;
}

static dispatch_queue_t _c_queue = NULL;

+ (void)setCommandQueue:(dispatch_queue_t)queue {
    _c_queue = queue;
}

static NSNotificationCenter *_c_NotificationCenter;

+ (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter {
    _c_NotificationCenter = notificationCenter;
}


static pthread_rwlock_t _subscribeReceiversLock;

+ (MBDefaultFacade *)instance {
    static MBDefaultFacade *_instance = nil;
    static dispatch_once_t _oncePredicate_MBDefaultFacade;
    
    dispatch_once(&_oncePredicate_MBDefaultFacade, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
                  );
    
    return _instance;
}

- (void)setInterceptors:(NSArray *)interceptors {
    _interceptors = interceptors;
}

- (id)init {
    self = [super init];
    if (self) {
        _waitingNotification = nil;
        pthread_rwlock_init(&_subscribeReceiversLock, NULL);
        _subscribeReceivers = [NSMutableSet setWithCapacity:3];
        _regCommandStatus = MB_REG_COMMAND_INIT;
        _notificationCenter = _c_NotificationCenter ? : [[NSNotificationCenter alloc] init];
        _command_queue = _c_queue ? : dispatch_queue_create([[NSString stringWithFormat:@"MB_DEFAULT_COMMAND_QUEUE.%@",
                                                              self]
                                                             UTF8String], DISPATCH_QUEUE_CONCURRENT
                                                            );
        if (_c_dispatch_queue) {
            _dispatch_message_queue = _c_dispatch_queue;
        } else {
            _dispatch_message_queue = [[NSOperationQueue alloc] init];
            [_dispatch_message_queue setName:[NSString stringWithFormat:@"MB_DEFAULT_DISPATCH_QUEUE.%@",
                                              self]];
        }
    }
    return self;
}

- (void)dealloc {
    pthread_rwlock_destroy(&_subscribeReceiversLock);
}


static inline NSString *subscribeReceiverName(unsigned long key, Class clazz) {
    return [NSString stringWithFormat:(@"%ld##%@"),
            key,
            clazz];
}


- (void)subscribeNotification:(id <MBMessageReceiver>)_receiver {
    if (!_receiver) {
        return;
    }
    NSString *receiverName = subscribeReceiverName(_receiver.notificationKey, [_receiver class]);
    //防止由于dispatch线程和receiver执行线程不一致导致的野指针被执行,就是在真正执行前再判断一次是否已经unsubscribe
    pthread_rwlock_wrlock(&_subscribeReceiversLock);
    [_subscribeReceivers addObject:receiverName];
    pthread_rwlock_unlock(&_subscribeReceiversLock);
    __block __unsafe_unretained id <MBMessageReceiver> receiver = _receiver;
    void (^OBSERVER_BLOCK)(NSNotification *);
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    if ([_dispatch_message_queue isEqual:currentQueue]) {
        OBSERVER_BLOCK = ^(NSNotification *note) {
            pthread_rwlock_rdlock(&_subscribeReceiversLock);
            BOOL receiverExist = [_subscribeReceivers containsObject:receiverName];
            pthread_rwlock_unlock(&_subscribeReceiversLock);
            if (receiverExist)
                [receiver handlerNotification:[note.userInfo objectForKey:MB_NOTIFICATION_KEY]];
        };
    } else {
        OBSERVER_BLOCK = ^(NSNotification *note) {
            if (!currentQueue || currentQueue.isSuspended) {
                NSLog(@"ERROR:Observer OperationQueue can't be Run![%@]", currentQueue);  //注册线程失效的情况下使用主线程执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    pthread_rwlock_rdlock(&_subscribeReceiversLock);
                    BOOL receiverExist = [_subscribeReceivers containsObject:receiverName];
                    pthread_rwlock_unlock(&_subscribeReceiversLock);
                    if (receiverExist)
                        [receiver handlerNotification:[note.userInfo objectForKey:MB_NOTIFICATION_KEY]];
                }
                               );
                return;
            }
            [currentQueue addOperationWithBlock:^{
                pthread_rwlock_rdlock(&_subscribeReceiversLock);
                BOOL receiverExist = [_subscribeReceivers containsObject:receiverName];
                pthread_rwlock_unlock(&_subscribeReceiversLock);
                if (receiverExist) {
                    if ([[NSThread currentThread] isMainThread]) {
                        [receiver handlerNotification:[note.userInfo objectForKey:MB_NOTIFICATION_KEY]];
                    }
                }
            }];
        };
    }
    NSSet *notificationNames = receiver.listReceiveNotifications;
    if (notificationNames && notificationNames.count > 0) {
        for (NSString *name in notificationNames) {
            id observer = [_notificationCenter addObserverForName:name
                                                           object:nil
                                                            queue:_dispatch_message_queue
                                                       usingBlock:OBSERVER_BLOCK];
            [_receiver _$addObserver:observer];
        }
    }
}

- (void)unsubscribeNotification:(id <MBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    pthread_rwlock_wrlock(&_subscribeReceiversLock);
    [_subscribeReceivers removeObject:subscribeReceiverName(receiver.notificationKey, [receiver class])];
    pthread_rwlock_unlock(&_subscribeReceiversLock);
    if (receiver._$listObserver.count == 0) {
        return;
    }
    NSSet *_observers = [NSSet setWithSet:receiver._$listObserver];
    for (id observer in _observers) {
        [_notificationCenter removeObserver:observer];
        [receiver _$removeObserver:observer];
    }
}


- (void)registerCommand:(Class)commandClass {
    if (MBClassHasProtocol(commandClass, @protocol(MBCommand))) {
        dispatch_queue_t queue = _command_queue;
        NSSet *names = objc_msgSend(commandClass, @selector(listReceiveNotifications));
        for (NSString *name in names) {
            [_notificationCenter addObserverForName:name
                                             object:nil
                                              queue:_dispatch_message_queue
                                         usingBlock:^(NSNotification *note) {
                                             id <MBNotification> notification = [note.userInfo
                                                                                   objectForKey:MB_NOTIFICATION_KEY];
                                             dispatch_async(queue, ^{
                                                 //这样写就不会循环引用
                                                 NSArray *interceptors = [NSArray arrayWithArray:[MBDefaultFacade instance]->_interceptors];
                                                 MBDefaultCommandInvocation *invocation = [MBDefaultCommandInvocation objectWithCommandClass:commandClass
                                                                                                                                    notification:notification
                                                                                                                                    interceptors:interceptors];
                                                 [invocation invoke];
                                             }
                                                            );
                                         }];
        }
    } else {
        NSAssert(NO, @"Unknown commandClass[%@] to register", commandClass);
    }
}

- (void)registerCommandAuto {
    static dispatch_once_t _oncePredicate_registerCommandAuto;
    dispatch_once(&_oncePredicate_registerCommandAuto, ^{
        Class *classes = NULL;
        int numClasses = objc_getClassList(NULL, 0);
        if (numClasses > 0) {
            classes = (Class *) malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                Class clazz = classes[i];
                if (MBClassHasProtocol(clazz, @protocol(MBCommand))) {
                    [self registerCommand:clazz];
                }
            }
            free(classes);
        }
    }
                  );
}

- (void)registerCommandAutoAsync {
    static dispatch_once_t _oncePredicate_registerCommandAutoAsync;
    dispatch_once(&_oncePredicate_registerCommandAutoAsync, ^{
        _waitingNotification = [[NSMutableArray alloc] initWithCapacity:0];
        _regCommandStatus = MB_REG_COMMAND_ASYNC_DOING;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self registerCommandAuto];
            _regCommandStatus = MB_REG_COMMAND_DONE;
            NSArray *waitingNotification = nil;
            @synchronized (self) {
                if ([_waitingNotification count] > 0) {
                    waitingNotification = [[NSArray alloc] initWithArray:_waitingNotification];
                    [_waitingNotification removeAllObjects];
                }
                _waitingNotification = nil;
            }
            if (waitingNotification) {
                for (id <MBNotification> notification in waitingNotification) {
                    [self sendMBNotification:notification];
                }
            }
        }
                       );
    }
                  );
}


- (void)sendNotification:(NSString *)notificationName {
    [self sendMBNotification:[MBDefaultNotification objectWithName:notificationName]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self sendMBNotification:[MBDefaultNotification objectWithName:notificationName
                                                                  body:body]];
}

- (void)sendMBNotification:(id <MBNotification>)notification {
    if (_regCommandStatus == MB_REG_COMMAND_ASYNC_DOING) {
        @synchronized (self) {
            if (_regCommandStatus == MB_REG_COMMAND_ASYNC_DOING && _waitingNotification) {
                [_waitingNotification addObject:notification];
                return;
            }
        }
    }
    NSNotification *sysNotification = [NSNotification notificationWithName:notification.name
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObject:notification
                                                                                                       forKey:MB_NOTIFICATION_KEY]];
    if (notification.delay >= 0) {
        [_notificationCenter performSelector:@selector(postNotification:)
                                  withObject:sysNotification
                                  afterDelay:notification.delay];
    } else {
        [_notificationCenter postNotification:sysNotification];
    }
}

- (void)sendNotificationForSEL:(SEL)selector {
    [self sendNotification:NSStringFromSelector(selector)];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [self sendNotification:NSStringFromSelector(selector)
                      body:body];
}


@end
