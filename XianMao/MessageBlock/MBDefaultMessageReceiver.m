//
//  MBDefaultMessageReceiver.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultMessageReceiver.h"
#import "MBFacade.h"
#import "MBGlobalFacade.h"
#import "MBUtil.h"

@implementation MBDefaultMessageReceiver {
@private
    id <MBFacade> _$MBFacade;
    NSMutableSet *_$MBObserver;
}

- (id <MBFacade>)MBFacade {
    return _$MBFacade ? : [MBGlobalFacade instance];
}

- (void)setMBFacade:(id <MBFacade>)MBFacade {
    if (self.MBFacade != MBFacade) {
        [self.MBFacade unsubscribeNotification:self];
        _$MBFacade = MBFacade;
        [self.MBFacade subscribeNotification:self];
    }
}

- (const NSUInteger)notificationKey {
    return MBGetDefaultNotificationKey(self);
}

- (id)initWithMBFacade:(id <MBFacade>)MBFacade {
    self = [super init];
    if (self) {
        self.MBFacade = MBFacade;
    }
    return self;
}

+ (id)objectWithMBFacade:(id <MBFacade>)MBFacade {
    return [[MBDefaultMessageReceiver alloc] initWithMBFacade:MBFacade];
}

#pragma mark  - receiver ,need Overwrite

//默认自动匹配方法
- (void)handlerNotification:(id <MBNotification>)notification {
    MBAutoHandlerReceiverNotification(self, notification);
}

- (NSSet *)listReceiveNotifications {
    return MBListAllReceiverHandlerName(self, [MBDefaultMessageReceiver class]);
}

- (NSSet *)_$listObserver {
    return _$MBObserver;
}

- (void)_$addObserver:(id)observer {
    _$MBObserver = _$MBObserver ? : [NSMutableSet setWithCapacity:1];
    [_$MBObserver addObject:observer];
}

- (void)_$removeObserver:(id)observer {
    [_$MBObserver removeObject:observer];
}

//自动扫描keyBinding
- (void)autoBindingKeyPath {
    MBAutoBindingKeyPath(self);
}


@end

