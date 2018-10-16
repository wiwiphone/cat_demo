//
//  TopBarRightCancelButton.m
//  XianMao
//
//  Created by simon cai on 21/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "TopBarRightCancelButton.h"

@implementation TopBarRightCancelButton

- (id)init {
    self = [super init];
    if (self) {
        _isInEditing = NO;
    }
    return self;
}

- (void)setIsInEditing:(BOOL)isInEditing {
    if (_isInEditing!=isInEditing) {
        _isInEditing = isInEditing;
        
        if (isInEditing) {
            [self setImage:nil forState:UIControlStateNormal];
            [self setTitle:@"取消" forState:UIControlStateNormal];
            [self addSubviewWithZoomInAnimation:self duration:0.2f option:UIViewAnimationOptionCurveLinear];
        } else {
            [self setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
            [self setTitle:nil forState:UIControlStateNormal];
            [self addSubviewWithZoomInAnimation:self duration:0.2f option:UIViewAnimationOptionCurveLinear];
        }
    }
}

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
    view.transform = CGAffineTransformIdentity;
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    
    view.transform = trans; // do it instantly, no animation
    if (view!=self)[self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
                     }
                     completion:^(BOOL finished) {
                         //NSLog(@"done");
                     } ];
}


- (void) removeSubviewWithZoomOutAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
    view.transform = CGAffineTransformIdentity;
    // now return the view to normal dimension, animating this tranformation
    WEAKSELF;
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         if (view!=weakSelf)[view removeFromSuperview];
                     }];
}

@end
