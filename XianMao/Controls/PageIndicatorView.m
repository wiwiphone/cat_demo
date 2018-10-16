//
//  PageIndicatorView.m
//  XianMao
//
//  Created by simon cai on 18/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PageIndicatorView.h"

@implementation PageIndicatorView

- (void)setColor:(UIColor *)color
{
    if (![_color isEqual:color]) {
        _color = color;
    }
}

@end

@implementation PageIndicatorRectangleView

- (void)setColor:(UIColor *)color
{
    [super setColor:color];
    self.backgroundColor = color;
}

@end

@implementation PageIndicatorArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        super.color = [UIColor blackColor];
    }
    return self;
}

#pragma mark - Public

- (void)setColor:(UIColor *)color
{
    if (![super.color isEqual:color]) {
        super.color = color;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint   (context, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
}

@end
