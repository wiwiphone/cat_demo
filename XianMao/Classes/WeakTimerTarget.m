//
//  WeakTimerTarget.m
//  XianMao
//
//  Created by simon cai on 11/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "WeakTimerTarget.h"

@interface WeakTimerTarget ()
@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation WeakTimerTarget
{
    //    __weak NSObject *_target;
    //    SEL _selector;
}

- (id)initWithTarget:(id)target selector:(SEL)selector {
    self = [super init];
    if (self) {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (void)timerDidFire:(NSTimer *)timer
{
    if(_target && [_target respondsToSelector:@selector(performSelector:withObject:)])
    {
        [_target performSelector:_selector withObject:timer];
    }
    else
    {
        [timer invalidate];
    }
}
@end



