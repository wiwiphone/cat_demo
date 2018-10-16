//
//  MBDefaultMediator.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultMediator.h"
#import "MBUtil.h"
#import "MBFacade.h"
#import "MBGlobalFacade.h"

@implementation MBDefaultMediator {
@private
    id <MBFacade> _$MBFacade;
    NSMutableSet *_$MBObserver;
    
    __unsafe_unretained id _realReceiver;
}

@synthesize realReceiver = _realReceiver;

- (id <MBFacade>)MBFacade {
    return _$MBFacade ? : [MBGlobalFacade instance];
}

- (void)setMBFacade:(id <MBFacade>)MBFacade {
    [self.MBFacade unsubscribeNotification:self];
    _$MBFacade = MBFacade;
    [self.MBFacade subscribeNotification:self];
}

- (id)initWithRealReceiver:(id)realReceiver MBFacade:(id <MBFacade>)MBFacade {
    self = [super init];
    if (self) {
        _realReceiver = realReceiver;
        self.MBFacade = MBFacade;
    }
    
    return self;
}

+ (id)mediatorWithRealReceiver:(id)realReceiver MBFacade:(id <MBFacade>)MBFacade {
    return [[self alloc]
            initWithRealReceiver:realReceiver
            MBFacade:MBFacade];
}


- (void)close {
    _realReceiver = nil;
}

- (id)initWithRealReceiver:(id)realReceiver {
    self = [super init];
    if (self) {
        _realReceiver = realReceiver;
        [self.MBFacade unsubscribeNotification:self];
        [self.MBFacade subscribeNotification:self];
    }
    return self;
}

+ (id)mediatorWithRealReceiver:(id)realReceiver {
    return [[self alloc] initWithRealReceiver:realReceiver];
}


- (NSUInteger const)notificationKey {
    if (_realReceiver) {
        return MBGetDefaultNotificationKey(_realReceiver);
    } else {
        return 0;
    }
    
}

- (void)handlerNotification:(id <MBNotification>)notification {
    if (_realReceiver) {
        MBInternalAutoHandlerReceiverNotification(_realReceiver, self, notification);
    }
}

- (NSSet *)listReceiveNotifications {
    if (_realReceiver) {
        return MBInternalListAllReceiverHandlerName(_realReceiver, self, [NSObject class]);
    } else {
        return [NSSet set];
    }
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

- (void)dealloc {
    [self.MBFacade unsubscribeNotification:self];
}

@end
