//
//  MBGlobalFacade.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//


#import "MBGlobalFacade.h"
#import "MBDefaultFacade.h"
#import "MBUtil.h"

@implementation MBGlobalFacade {
@private
    id <MBFacade> _facade;
}

static Class _facadeClass = nil;

+ (BOOL)setDefaultFacade:(Class)facadeClass {
    if (MBClassHasProtocol(facadeClass, @protocol(MBFacade))) {
        _facadeClass = facadeClass;
        return YES;
    }
    else {
        return NO;
    }
}

+ (MBGlobalFacade *)instance {
    static MBGlobalFacade *_instance = nil;
    static dispatch_once_t _oncePredicate_MBGlobalFacade;
    
    dispatch_once(&_oncePredicate_MBGlobalFacade, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
                  );
    
    return _instance;
}

- (void)setInterceptors:(NSArray *)interceptors {
    [_facade setInterceptors:interceptors];
}

- (id)init {
    self = [super init];
    if (self) {
        if (_facadeClass) {
            _facade = [_facadeClass instance];
        } else {
            _facade = [MBDefaultFacade instance];
        }
    }
    return self;
}


- (void)subscribeNotification:(id <MBMessageReceiver>)receiver {
    [_facade subscribeNotification:receiver];
}

- (void)unsubscribeNotification:(id <MBMessageReceiver>)receiver {
    [_facade unsubscribeNotification:receiver];
}

- (void)registerCommand:(Class)commandClass {
    [_facade registerCommand:commandClass];
}

- (void)registerCommandAuto {
    [_facade registerCommandAuto];
}

- (void)registerCommandAutoAsync {
    [_facade registerCommandAutoAsync];
}

- (void)sendNotification:(NSString *)notificationName {
    [_facade sendNotification:notificationName];
}

- (void)sendNotification:(NSString *)notificationName
                    body:(id)body {
    [_facade sendNotification:notificationName body:body];
}

- (void)sendMBNotification:(id <MBNotification>)notification {
    [_facade sendMBNotification:notification];
}

- (void)sendNotificationForSEL:(SEL)selector {
    [_facade sendNotificationForSEL:selector];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [_facade sendNotificationForSEL:selector body:body];
}

//-(void)sendNotificationForPaySEL:(SEL)selector body:(id)body{
//    [_facade sendNotificationForPaySEL:selector body:body];
//}

@end

inline void MBGlobalSendNotification(NSString *notificationName) {
    [[MBGlobalFacade instance] sendNotification:notificationName];
}

inline void MBGlobalSendNotificationWithBody(NSString *notificationName, id body) {
    [[MBGlobalFacade instance] sendNotification:notificationName body:body];
}

inline void MBGlobalSendNotificationForSEL(SEL selector) {
    [[MBGlobalFacade instance] sendNotificationForSEL:selector];
}

inline void MBGlobalSendNotificationForSELWithBody(SEL selector, id body) {
    [[MBGlobalFacade instance] sendNotificationForSEL:selector body:body];
}

//inline void MBGlobalSendNotificationForSELWithForBody(SEL selector, id body) {
//    [[MBGlobalFacade instance] sendNotificationForPaySEL:selector body:body];
//}

inline void MBGlobalSendMBNotification(id <MBNotification> notification) {
    [[MBGlobalFacade instance] sendMBNotification:notification];
}


