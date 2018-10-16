//
//  UIView+TouchView.h
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (TouchView)


- (void)touchEndedBlock:(void (^)(UIView *selfView))block;

- (void)touchEndedGesture;

- (void)longPressEndedBlock:(void (^)(UIView *selfView))block;

- (void)longPressEndedGesture:(UIGestureRecognizer *)gesture;

@end

