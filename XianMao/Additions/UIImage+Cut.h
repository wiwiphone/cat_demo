//
//  UIImage+Cut.h
//  DailyMemo
//
//  Created by simon cai on 7/10/14.
//  Copyright (c) 2014 wopaiapp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Cut)

- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize;
- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize roundedCornerImage:(NSInteger)roundedCornerImage borderSize:(NSInteger)borderSize;
@end
