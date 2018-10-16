//
//  MBDefaultViewController.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultViewController.h"
#import "MBGlobalFacade.h"
#import "MBDefaultNotification.h"
#import "MBUtil.h"

@implementation MBDefaultViewController {
@private
    id <MBFacade> _$MBFacade;
    NSMutableSet *_$MBObserver;
}

- (const NSUInteger)notificationKey {
    return MBGetDefaultNotificationKey(self);
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.MBFacade unsubscribeNotification:self];
        [self.MBFacade subscribeNotification:self];
        [self propertyInit];
        [self autoBindingKeyPath];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.MBFacade unsubscribeNotification:self];
        [self.MBFacade subscribeNotification:self];
        [self propertyInit];
        [self autoBindingKeyPath];
    }
    return self;
}


- (void)propertyInit {
    
}

- (id)initWithMBFacade:(id <MBFacade>)MBFacade {
    self = [super init];
    if (self) {
        self.MBFacade = MBFacade;
    }
    return self;
}

+ (id)objectWithMBFacade:(id <MBFacade>)MBFacade {
    return [[MBDefaultViewController alloc] initWithMBFacade:MBFacade];
}

- (void)dealloc {
    [self.MBFacade unsubscribeNotification:self];
}

#pragma mark  - receiver ,need Overwrite

//默认自动匹配方法
- (void)handlerNotification:(id <MBNotification>)notification {
    MBAutoHandlerReceiverNotification(self, notification);
}

- (NSSet *)listReceiveNotifications {
    return MBListAllReceiverHandlerName(self, [MBDefaultViewController class]);
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

#pragma mark  - sender
- (void)sendNotification:(NSString *)notificationName {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:notificationName
                                                                              key:self.notificationKey]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:notificationName
                                                                              key:self.notificationKey
                                                                             body:body]];
}

- (void)sendMBNotification:(id <MBNotification>)notification {
    notification.key = self.notificationKey;
    [self.MBFacade sendMBNotification:notification];
}

- (void)sendNotificationForSEL:(SEL)selector {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:NSStringFromSelector(selector)
                                                                              key:self.notificationKey]];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:NSStringFromSelector(selector)
                                                                              key:self.notificationKey body:body]];
}

//自动扫描keyBinding
- (void)autoBindingKeyPath {
    MBAutoBindingKeyPath(self);
}


@end


