//
//  MBDefaultNotification.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultNotification.h"
#import "MBUtil.h"

@implementation MBDefaultNotification {
    
@private
    NSString *_name;
    id _body;
    NSUInteger _retryCount;
    NSDictionary *_userInfo;
    id <MBNotification> _lastNotification;
    NSUInteger _key;
    NSTimeInterval _delay;
}
@synthesize name = _name;
@synthesize body = _body;
@synthesize retryCount = _retryCount;
@synthesize userInfo = _userInfo;
@synthesize lastNotification = _lastNotification;
@synthesize key = _key;

@synthesize delay = _delay;


- (id)init {
    self = [super init];
    if (self) {
        _delay = -1;
    }
    return self;
}


- (id)initWithName:(NSString *)name key:(NSUInteger)key {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
        _key = key;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name key:(NSUInteger)key body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
        _key = key;
        _body = body;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
        _body = body;
    }
    
    return self;
}

- (id)initWithSEL:(SEL)SEL {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = NSStringFromSelector(SEL);
    }
    
    return self;
}

- (id)initWithSEL:(SEL)SEL body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = NSStringFromSelector(SEL);
        _body = body;
    }
    
    return self;
}

- (id)initWithSEL:(SEL)SEL key:(NSUInteger)key body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = NSStringFromSelector(SEL);
        _key = key;
        _body = body;
    }
    
    return self;
}

+ (id)objectWithSEL:(SEL)SEL key:(NSUInteger)key body:(id)body {
    return [[MBDefaultNotification alloc]
            initWithSEL:SEL
            key:key
            body:body];
}


+ (id)objectWithSEL:(SEL)SEL body:(id)body {
    return [[MBDefaultNotification alloc]
            initWithSEL:SEL
            body:body];
}


+ (id)objectWithSEL:(SEL)SEL {
    return [[MBDefaultNotification alloc] initWithSEL:SEL];
}


+ (id)objectWithName:(NSString *)name body:(id)body {
    return [[MBDefaultNotification alloc]
            initWithName:name
            body:body];
}


+ (id)objectWithName:(NSString *)name {
    return [[MBDefaultNotification alloc] initWithName:name];
}


+ (id)objectWithName:(NSString *)name key:(NSUInteger)key body:(id)body {
    return [[MBDefaultNotification alloc]
            initWithName:name
            key:key
            body:body];
}


+ (id)objectWithName:(NSString *)name key:(NSUInteger)key {
    return [[MBDefaultNotification alloc]
            initWithName:name
            key:key];
}

- (id <MBNotification>)createNextNotification:(NSString *)name {
    MBDefaultNotification *notification = [MBDefaultNotification objectWithName:name];
    notification.key = self.key;
    notification.lastNotification = self;
    notification.userInfo = self.userInfo;
    return notification;
}

- (id <MBNotification>)createNextNotification:(NSString *)name withBody:(id)body {
    MBDefaultNotification *notification = [MBDefaultNotification objectWithName:name
                                                                               body:body];
    notification.key = self.key;
    notification.lastNotification = self;
    notification.userInfo = self.userInfo;
    return notification;
}

- (id <MBNotification>)createNextNotificationForSEL:(SEL)selector {
    return [self createNextNotification:NSStringFromSelector(selector)];
}

- (id <MBNotification>)createNextNotificationForSEL:(SEL)selector withBody:(id)body {
    return [self createNextNotification:NSStringFromSelector(selector)
                               withBody:body];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"{Name:[%@] "
            "Body:[%@] "
            "Key:[%ld] "
            "retryCount:[%ld] "
            "userInfo:{%@} "
            "lastNotification:{\n\t%@\n}}"
            ,
            _name,
            _body,
            _key,
            _retryCount,
            _userInfo,
            _lastNotification];
}

- (void)dealloc {
    MB_LOG(@"dealloc [%@]", self);
}


@end

