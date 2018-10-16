//
//  XMEmptyView.m
//  XianMao
//
//  Created by darren on 15/1/21.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "XMEmptyView.h"
#import "UIImage+Addtions.h"
#import "SynthesizeSingleton.h"

FOUNDATION_STATIC_INLINE CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size){
    CGRect r; r.origin.x = x; r.origin.y = y; r.size = size; return r;
}

#pragma mark - UIView+TKEmptyViewCategory
@implementation UIView (XMEmptyViewCategory)



+ (void) drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) [ar addObject:(id)c.CGColor];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ar, NULL);
    
    
    CGContextClipToRect(context, rect);
    
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(0.0, rect.size.height);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
}

@end

#pragma mark - UIImage+TKEmptyViewCategory
@implementation UIImage (XMEmptyViewCategory)

- (void) drawMaskedGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    rect.origin.y = rect.origin.y * -1;
    
    CGContextClipToMask(context, rect, self.CGImage);
    
    [UIView drawGradientInRect:rect withColors:colors];
    
    CGContextRestoreGState(context);
}

@end


@implementation XMEmptyView

#pragma mark Init & Friends
- (instancetype)initWithFrame:(CGRect)frame mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    self.backgroundColor = [UIColor clearColor];

    UIColor* top = [UIColor clearColor];
    UIColor* bot = [UIColor clearColor];

    self.colors = @[ top, bot ];
    self.startPoint = CGPointZero;
    self.endPoint = CGPointMake(0, 1);

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor colorWithRed:170 / 255. green:170 / 255. blue:170 / 255. alpha:1];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.shadowColor = [UIColor whiteColor];
    _titleLabel.shadowOffset = CGSizeMake(0, 1);

    _titleLabel.text = titleString;

    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
    _subtitleLabel.textColor = [UIColor colorWithRed:170 / 255. green:170 / 255. blue:170 / 255. alpha:1];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.shadowColor = [UIColor whiteColor];
    _subtitleLabel.shadowOffset = CGSizeMake(0, 1);

    _subtitleLabel.text = subtitleString;

    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame = CGRectMakeWithSize((int)(CGRectGetWidth(frame) / 2) - (CGRectGetWidth(_imageView.frame) / 2),
                                          (int)(CGRectGetHeight(frame) / 2) - (CGRectGetHeight(_imageView.frame) / 2),
                                          _imageView.image.size);

    [self addSubview:_imageView];
    [self addSubview:_subtitleLabel];
    [self addSubview:_titleLabel];

    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame emptyViewImage:(XMEmptyViewImage)image title:(NSString*)titleString subtitle:(NSString*)subtitleString
{
    return [self initWithFrame:frame mask:[self predefinedImage:image] title:titleString subtitle:subtitleString];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame emptyViewImage:XMEmptyViewImageNone title:@"" subtitle:@""];
}

- (void)layoutSubviews
{
    CGSize s = self.frame.size;
    CGRect ir = _imageView.bounds;

    NSInteger sh = s.height / 2;

    ir.origin = CGPointMake((int)(s.width / 2) - (ir.size.width / 2), (int)(sh / 2 ) );

    _imageView.frame = ir;

    _titleLabel.frame = CGRectMake(0, (int)(ir.origin.y + ir.size.height + 25), s.width, 30);
    _subtitleLabel.frame = CGRectMake((int)0, CGRectGetMaxY(_titleLabel.frame), s.width, 16);
}

#pragma mark Properties
- (void)setImage:(UIImage*)image
{
    _imageView.image = [self maskedImageWithImage:image];
    [self setNeedsLayout];
}
- (void)setEmptyImage:(XMEmptyViewImage)image
{
    [self setImage:[self predefinedImage:image]];
}
- (UIImage*)maskedImageWithImage:(UIImage*)m
{
    if (m == nil)
        return nil;

    UIGraphicsBeginImageContext(CGSizeMake((m.size.width) * m.scale, (m.size.height + 2) * m.scale));
    CGContextRef context = UIGraphicsGetCurrentContext();

    NSArray* colors = @[ [UIColor colorWithRed:174 / 255.0 green:182 / 255.0 blue:195 / 255.0 alpha:1], [UIColor colorWithRed:197 / 255.0 green:202 / 255.0 blue:211 / 255.0 alpha:1] ];

    CGContextSetShadowWithColor(context, CGSizeMake(1, 4), 4, [UIColor colorWithWhite:0 alpha:0.1].CGColor);
    [m drawInRect:CGRectMake(0, 0 + (1 * m.scale), m.size.width * m.scale, m.size.height * m.scale)];
    [m drawMaskedGradientInRect:CGRectMake(0, 0, m.size.width * m.scale, m.size.height * m.scale) withColors:colors];

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage* scaledImage = [UIImage imageWithCGImage:image.CGImage scale:m.scale orientation:UIImageOrientationUp];

    return scaledImage;
}

- (UIImage*)predefinedImage:(XMEmptyViewImage)img
{

    NSString* str;

    switch (img) {
    case XMEmptyViewImageNone:
        str = @"Cat_nonepage";
        break;
    case XMEmptyViewImageWrong:
        str = @"Cat_wrong";
        break;
    case XMEmptyViewImageNetError:
        str = @"net_wrong";
        break;
    default:
        str = @"star";
        break;
    }

    return [UIImage imageNamed:[NSString stringWithFormat:@"%@", str]];
}



@end
