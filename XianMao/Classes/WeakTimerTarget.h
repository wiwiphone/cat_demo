//
//  WeakTimerTarget.h
//  XianMao
//
//  Created by simon cai on 11/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimerTarget : NSObject

- (id)initWithTarget:(id)target selector:(SEL)selector;
- (void)timerDidFire:(NSTimer *)timer;
@end