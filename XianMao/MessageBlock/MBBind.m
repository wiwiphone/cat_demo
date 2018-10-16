//
//  MBBind.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <objc/runtime.h>
#import "MBBind.h"

static BOOL __is_need_auto_unbind = YES;

static BOOL __bindable_run_thread_is_binding_thread = NO;

static MBBindableRunSafeThreadStrategy __MBBindableRunSafeThreadStrategy =
MBBindableRunSafeThreadStrategy_Retain;

@implementation MBBindInitValue
+ (MBBindInitValue *)value {
    static MBBindInitValue *_instance = nil;
    static dispatch_once_t _oncePredicate_MBBindInitValue;
    
    dispatch_once(&_oncePredicate_MBBindInitValue, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
                  );
    
    return _instance;
}

- (NSString *)description {
    return @"MBBindInitValue";
}
@end

void MBSetAutoUnbind(BOOL yesOrNO) {
    __is_need_auto_unbind = yesOrNO;
}

void MBSetBindableRunThreadIsBindingThread(BOOL yesOrNO) {
    __bindable_run_thread_is_binding_thread = yesOrNO;
}

void MBSetBindableRunSafeThreadStrategy(MBBindableRunSafeThreadStrategy strategy) {
    __MBBindableRunSafeThreadStrategy = strategy;
}

@protocol MBBindHandlerProtocol <MBBindObserver>
- (void)removeObserver;

- (id)bindableObject;

- (NSString *)keyPath;
@end

@interface MBBindObjectHandler : NSObject <MBBindHandlerProtocol>

@property(nonatomic, assign) id bindableObject;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy) MB_CHANGE_BLOCK changeBlock;
@property(atomic) BOOL isBindableObjectUnbind;

- (id)initWithBindableObject:(id)bindableObject
                     keyPath:(NSString *)keyPath
                 changeBlock:(MB_CHANGE_BLOCK)changeBlock;

+ (id)objectWithBindableObject:(id)bindableObject
                       keyPath:(NSString *)keyPath
                   changeBlock:(MB_CHANGE_BLOCK)changeBlock;


- (void)removeObserver;

- (void)addObserver;

@end

@implementation MBBindObjectHandler {
@private
    MB_CHANGE_BLOCK _changeBlock;
    NSString *_keyPath;
    __unsafe_unretained id _bindableObject;
    NSOperationQueue *_bindingQueue;
    BOOL _isBindableObjectUnbind;
}

@synthesize changeBlock = _changeBlock;
@synthesize keyPath = _keyPath;
@synthesize bindableObject = _bindableObject;
@synthesize isBindableObjectUnbind = _isBindableObjectUnbind;


- (id)initWithBindableObject:(id)bindableObject
                     keyPath:(NSString *)keyPath
                 changeBlock:(MB_CHANGE_BLOCK)changeBlock {
    self = [super init];
    if (self) {
        self.isBindableObjectUnbind = NO;
        _bindableObject = bindableObject;
        _keyPath = keyPath;
        _changeBlock = changeBlock;
        if (__bindable_run_thread_is_binding_thread) {
            _bindingQueue = [NSOperationQueue currentQueue];
        }
    }
    
    return self;
}

+ (id)objectWithBindableObject:(id)bindableObject
                       keyPath:(NSString *)keyPath
                   changeBlock:(MB_CHANGE_BLOCK)changeBlock {
    return [[MBBindObjectHandler alloc]
            initWithBindableObject:bindableObject
            keyPath:keyPath
            changeBlock:changeBlock];
}


- (void)removeObserver {
    @synchronized (self) {
        if (!self.isBindableObjectUnbind) {
            self.isBindableObjectUnbind = YES;
            [(id) _bindableObject removeObserver:self
                                      forKeyPath:_keyPath];
            _changeBlock = nil;//remove后释放_changeBlock来释放一些内存
        }
    }
}

- (void)addObserver {
    [_bindableObject addObserver:self
                      forKeyPath:_keyPath
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                         context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    MB_CHANGE_BLOCK changeBlock = _changeBlock;
    if (changeBlock) {
        id old = [change objectForKey:NSKeyValueChangeOldKey];
        id new = [change objectForKey:NSKeyValueChangeNewKey];
        old = old ? ([old isEqual:[NSNull null]] ? nil : old) : [MBBindInitValue value];
        new = [new isEqual:[NSNull null]] ? nil : new;
        if (_bindingQueue && _bindingQueue != [NSOperationQueue currentQueue] && !_bindingQueue.isSuspended) {
            __block id retainedObj = nil;
            if (__MBBindableRunSafeThreadStrategy == MBBindableRunSafeThreadStrategy_Retain) {
                retainedObj = _bindableObject;  //强制retain一把,防止由于bindable被dealloc导致异步执行crash
            }
            [_bindingQueue addOperationWithBlock:^{
                if (__MBBindableRunSafeThreadStrategy == MBBindableRunSafeThreadStrategy_Ignore) {
                    if (!self.isBindableObjectUnbind) {
                        changeBlock(old, new);
                    }
                } else {
                    changeBlock(old, new);
                }
                retainedObj = nil;
            }];
        } else {
            changeBlock(old, new);
        }
        
    }
}


@end

static char kMBBindableObjectKey;

@implementation NSObject (MBBindableObject)


- (NSMutableSet *)_$MBBindableObjectSet {
    return objc_getAssociatedObject(self, &kMBBindableObjectKey);
}

- (void)_$AddMBBindableObjectSet:(id <MBBindHandlerProtocol>)handler {
    NSMutableSet *v = objc_getAssociatedObject(self, &kMBBindableObjectKey);
    if (!v) {
        v = [[NSMutableSet alloc] init];
        objc_setAssociatedObject(self, &kMBBindableObjectKey, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [v addObject:handler];
}

- (void)_$MBBindableObject_dealloc {
    NSSet *objectSet;
    if (__is_need_auto_unbind && (objectSet = [self _$MBBindableObjectSet]) && objectSet.count > 0) {
        for (id <MBBindHandlerProtocol> handler in objectSet) {
            [handler removeObserver];
        }
    }
    objc_setAssociatedObject(self, &kMBBindableObjectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // Call original implementation
    [self _$MBBindableObject_dealloc];
}
@end

static inline void _initBind() {
    if (!__is_need_auto_unbind) {
        return;
    }
    static dispatch_once_t _oncePredicate_MBBindableObject;
    dispatch_once(&_oncePredicate_MBBindableObject, ^{
        Class class = [NSObject class];
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method newMethod = class_getInstanceMethod(class, @selector(_$MBBindableObject_dealloc));
        method_exchangeImplementations(originalMethod, newMethod);
    }
                  );
}

inline id <MBBindObserver> MBBindObject(id bindable, NSString *keyPath, MB_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        _initBind();
        MBBindObjectHandler *handler = [MBBindObjectHandler objectWithBindableObject:bindable
                                                                                 keyPath:keyPath
                                                                             changeBlock:changeBlock];
        [handler addObserver];
        [bindable _$AddMBBindableObjectSet:handler];
        return handler;
    }
    return nil;
}

inline id <MBBindObserver> MBBindObjectWeak(id bindable, NSString *keyPath, id host, MB_HOST_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        __block __unsafe_unretained id _host = host;
        id <MBBindObserver> observer = MBBindObject(bindable, keyPath, ^(id old, id new) {
            changeBlock(_host, old, new);
        }
                                                        );
        if (bindable != host) {       //弱引用则自动挂载 避免弱引用导致野指针 最后crash
            MBAttachBindObserver(observer, host);
        }
        return observer;
    }
    return nil;
}

inline id <MBBindObserver> MBBindObjectStrong(id bindable, NSString *keyPath, id host, MB_HOST_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        return MBBindObject(bindable, keyPath, ^(id old, id new) {
            changeBlock(host, old, new);
        }
                              );
    }
    return nil;
}

inline void MBAttachBindObserver(id <MBBindObserver> observer, id obj) {
    if ([observer conformsToProtocol:@protocol(MBBindHandlerProtocol)]) {
        [obj _$AddMBBindableObjectSet:(id <MBBindHandlerProtocol>) observer];
    }
}

inline void MBUnbindObject(id bindable) {
    if (!bindable) {
        return;
    }
    NSMutableSet *objectSet;
    if ((objectSet = [bindable _$MBBindableObjectSet]) && objectSet.count > 0) {
        NSSet *objectSetCopy = [NSSet setWithSet:objectSet];
        for (id <MBBindHandlerProtocol> handler in objectSetCopy) {
            [handler removeObserver];
            [objectSet removeObject:handler];
        }
    }
}

inline void MBUnbindObjectWithKeyPath(id bindable, NSString *keyPath) {
    if (!bindable || !keyPath) {
        return;
    }
    NSMutableSet *objectSet;
    if ((objectSet = [bindable _$MBBindableObjectSet]) && objectSet.count > 0) {
        NSSet *objectSetCopy = [NSSet setWithSet:objectSet];
        for (id <MBBindHandlerProtocol> handler in objectSetCopy) {
            if ([handler.keyPath isEqualToString:keyPath]) {
                [handler removeObserver];
                [objectSet removeObject:handler];
            }
        }
    }
}

inline void MBUnbindObserver(id <MBBindObserver> observer) {
    if (!observer) {
        return;
    }
    if ([observer conformsToProtocol:@protocol(MBBindHandlerProtocol)]) {
        id <MBBindHandlerProtocol> _observer = (id <MBBindHandlerProtocol>) observer;
        id bindable = _observer.bindableObject;
        NSMutableSet *objectSet;
        if ((objectSet = [bindable _$MBBindableObjectSet]) && objectSet.count > 0) {
            [objectSet removeObject:_observer];
        }
        [_observer removeObserver];
    } else {
        MB_LOG(@"Unkown observer[%@]", observer);
    }
}


@interface MBDeallocObserver : NSObject <MBBindHandlerProtocol>
@property(nonatomic, assign) id bindableObject;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy) MB_DEALLOC_BLOCK deallocBlock;
@property(atomic) BOOL isBindableObjectUnbind;

- (id)initWithBindableObject:(id)bindableObject deallocBlock:(MB_DEALLOC_BLOCK)deallocBlock;

+ (id)objectWithBindableObject:(id)bindableObject deallocBlock:(MB_DEALLOC_BLOCK)deallocBlock;


@end

@implementation MBDeallocObserver {
@private
    __unsafe_unretained id _bindableObject;
    NSString *_keyPath;
    MB_DEALLOC_BLOCK _deallocBlock;
    BOOL _isBindableObjectUnbind;
}
@synthesize bindableObject = _bindableObject;
@synthesize keyPath = _keyPath;
@synthesize deallocBlock = _deallocBlock;
@synthesize isBindableObjectUnbind = _isBindableObjectUnbind;

- (id)initWithBindableObject:(id)bindableObject deallocBlock:(MB_DEALLOC_BLOCK)deallocBlock {
    self = [super init];
    if (self) {
        self.isBindableObjectUnbind = NO;
        _bindableObject = bindableObject;
        _deallocBlock = deallocBlock;
        
    }
    
    return self;
}

+ (id)objectWithBindableObject:(id)bindableObject deallocBlock:(MB_DEALLOC_BLOCK)deallocBlock {
    return [[MBDeallocObserver alloc]
            initWithBindableObject:bindableObject
            deallocBlock:deallocBlock];
}

- (void)removeObserver {
    @synchronized (self) {
        if (!self.isBindableObjectUnbind) {
            self.isBindableObjectUnbind = YES;
            if (_deallocBlock) {
                _deallocBlock();
            }
        }
    }
    
}


@end


inline id <MBBindObserver> MBCreateDeallocObserver(id bindable, MB_DEALLOC_BLOCK deallocBlock) {
    MBDeallocObserver *deallocObserver = [MBDeallocObserver objectWithBindableObject:bindable
                                                                            deallocBlock:deallocBlock];
    [bindable _$AddMBBindableObjectSet:deallocObserver];
    return deallocObserver;
}


inline void MBCancelDeallocObserver(id <MBBindObserver> observer) {
    if (observer && [observer isKindOfClass:[MBDeallocObserver class]]) {
        MBDeallocObserver *deallocObserver = (MBDeallocObserver *) observer;
        deallocObserver.isBindableObjectUnbind = YES;
        deallocObserver.deallocBlock = NULL;
    }
}


