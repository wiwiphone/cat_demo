//
//  UIImage+RoundedCorner.h
//  DailyMemo
//
//  Created by simon cai on 7/10/14.
//  Copyright (c) 2014 wopaiapp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// Extends the UIImage class to support making rounded corners
@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;

@end

