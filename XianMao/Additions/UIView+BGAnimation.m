//
//  UIView+BGAnimation.h
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kBGAnimationDuration     0.4

@implementation UIView (BGAnimation)

- (void)animationWithStartRect:(CGRect)startRect
                       endRect:(CGRect)endRec {
    self.userInteractionEnabled = YES;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = kBGAnimationDuration;
    animation.values   = [self getValuesWithStartRect:startRect endRect:endRec];
    //    animation.keyTimes = [self getKeyTimes];
    animation.timingFunctions = [self getTimingFunctions];;
    [self.layer addAnimation:animation forKey:@"move"];
}

- (NSArray *)getValuesWithStartRect:(CGRect)startRect
                            endRect:(CGRect)endRect {
    CGFloat centerX = endRect.origin.x + endRect.size.width / 2;
    CGPoint p0      = CGPointMake(centerX, startRect.origin.y + startRect.size.height / 2);
    //    CGPoint p1 = CGPointMake(centerX, endRect.origin.y + endRect.size.height / 2 + 40);
    CGPoint p2      = CGPointMake(centerX, endRect.origin.y + endRect.size.height / 2 + 15);
    CGPoint p3      = CGPointMake(centerX, endRect.origin.y + endRect.size.height / 2 - 5);
    CGPoint p4      = CGPointMake(centerX, endRect.origin.y + endRect.size.height / 2 + 1);
    CGPoint p5      = CGPointMake(centerX, endRect.origin.y + endRect.size.height / 2 - 1);
    CGPoint p6      = CGPointMake(centerX, endRect.origin.y + endRect.size.height / 2);
    NSArray *values = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:p0],
                       //            [NSValue valueWithCGPoint:p1],
                       [NSValue valueWithCGPoint:p2],
                       [NSValue valueWithCGPoint:p3],
                       [NSValue valueWithCGPoint:p4],
                       [NSValue valueWithCGPoint:p5],
                       [NSValue valueWithCGPoint:p6], nil];
    return values;
}

- (NSArray *)getKeyTimes {
    NSArray *array = [NSArray arrayWithObjects:
                      [NSNumber numberWithFloat:0.0],
                      [NSNumber numberWithFloat:0.50],
                      [NSNumber numberWithFloat:0.75], [NSNumber numberWithFloat:1.0], nil];
    return array;
}

- (NSArray *)getTimingFunctions {
    NSArray *array = [NSArray arrayWithObjects:
                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
    return array;
}

@end

