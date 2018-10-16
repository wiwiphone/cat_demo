//
//  UIImage+Color.h
//  alover
//
//  Created by simon cai on 8/19/14.
//  Copyright (c) 2014 alover.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Color1)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)tintImage:(UIImage *)baseImage color:(UIColor *)theColor;
- (UIImage *)imageTintedWithColor:(UIColor *)color;

@end

