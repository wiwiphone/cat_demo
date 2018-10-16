//
//  UIImage+Addtions.h
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Addtions)

+ (UIImage *)imageWithFileName:(NSString *)fileName;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)aspectScaleToSize:(CGSize)size;

- (UIImage *)imageByCropping:(CGRect)rect;

- (UIImage *)imageByCroppingWithRatio:(float)value;

- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets;

- (UIImage *)leftMirrorImageToRight;

- (UIImage *)topMirrorImageToBottom;

- (BOOL)writeImageToFileAtPath:(NSString *)aPath;

- (UIImage *)clipsImageToSize:(CGSize)desSZ;

- (UIImage *)resetSquareImage;

- (UIImage *)resetSquareImage:(CGSize)desSZ;

+ (UIImage *)createImageWithColor:(UIColor *)color;

- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect;

- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size;

- (UIImage *)ajustOrientation:(UIImage *)image;

+ (UIImage *)imageWithView:(UIView *)view;



- (UIImage *)fixOrientation:(UIImage *)aImage Orientation:(ALAssetOrientation)imageOrientation;
- (UIImage *)scaleImage:(UIImage *)image maxSideLength:(int)iMaxSideLen;
- (UIImage *)cropImageWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;


- (UIImage*)getSubImage:(CGRect)rect;
- (UIImage*)blscaleToSize:(CGSize)size;
- (UIImage*)cbblScaleToSize:(CGSize)size;
- (NSString *)encodeToBase64String;
@end




