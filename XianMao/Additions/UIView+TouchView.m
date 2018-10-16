//
//  UIView+TouchView.m
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UIView+TouchView.h"
#import <objc/runtime.h>

static const void *TouchEndedViewBlockKey          = &TouchEndedViewBlockKey;
static const void *TouchLongPressEndedViewBlockKey = &TouchLongPressEndedViewBlockKey;

@implementation UIView (TouchView)

- (void)touchEndedBlock:(void (^)(UIView *selfView))block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(touchEndedGesture)];
    tapped.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapped];
    objc_setAssociatedObject(self, TouchEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)touchEndedGesture {
    void (^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, TouchEndedViewBlockKey);
    if (_touchBlock) {
        _touchBlock(self);
    }
}

- (void)longPressEndedBlock:(void (^)(UIView *selfView))block {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEndedGesture:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
    objc_setAssociatedObject(self, TouchLongPressEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)longPressEndedGesture:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void (^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, TouchLongPressEndedViewBlockKey);
        if (_touchBlock) {
            _touchBlock(self);
        }
    }
}

@end
