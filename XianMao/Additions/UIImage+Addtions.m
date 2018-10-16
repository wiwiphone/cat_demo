//
//  UIImage+Addtions.m
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UIImage+Addtions.h"
#import <QuartzCore/QuartzCore.h>

#define TKBUNDLE(_URL) [TKGlobal fullBundlePath:[@"TapkuLibrary.bundle/Images" stringByAppendingPathComponent:_URL]]

@implementation UIImage (Addtions)

+ (UIImage *)imageWithFileName:(NSString *)fileName {
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
    NSString *imagePath       = [imageFolderPath stringByAppendingString:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (UIImage *)scaleToSize:(CGSize)size {
    CGFloat h = self.size.height;
    CGFloat w = self.size.width;
    if (h <= size.width && w <= size.height) {
        return self;
    }
    
    float  b        = (float)size.width/w < (float)size.height/h ? (float)size.width/w : (float)size.height/h;
    CGSize itemSize = CGSizeMake(b*w, b*h);
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(itemSize);
    }
    
    CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
    [self drawInRect:imageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)aspectScaleToSize:(CGSize)size {
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat hScaleFactor = imageSize.width / size.width;
    CGFloat vScaleFactor = imageSize.height / size.height;
    
    CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
    
    CGFloat newWidth  = imageSize.width   / scaleFactor;
    CGFloat newHeight = imageSize.height / scaleFactor;
    
    // center vertically or horizontally in size passed
    CGFloat leftOffset = (size.width - newWidth) / 2;
    CGFloat topOffset  = (size.height - newHeight) / 2;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    }
#else
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
#endif
    
    [self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)imageByCropping:(CGRect)rect {
    CGImageRef imageRef     = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage    *cropedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropedImage;
}

- (UIImage *)imageByCroppingWithRatio:(float)value {
    float width  = self.size.width;
    float height = self.size.height;
    
    if (height * value >= width) {
        height = width / value;
    } else {
        width = height * value;
    }
    
    return [self imageByCropping:CGRectMake(0, 0, width, height)];
}

- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets {
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *image        = nil;
    if (systemVersion >= 5.0) {
        image = [self resizableImageWithCapInsets:capInsets];
    } else {
        image = [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    
    return image;
}

- (UIImage *)leftMirrorImageToRight {
    return [self mirrorImage:NO];;
}

- (UIImage *)topMirrorImageToBottom {
    return [self mirrorImage:YES];
}

- (UIImage *)mirrorImage:(BOOL)flag {
    CGSize imageSize = self.size;
    CGRect rect      = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen
                                                           mainScreen].scale);
    
    CGContextRef      context   = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (flag) {
        transform = CGAffineTransformMakeTranslation(0, imageSize.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
    } else {
        transform = CGAffineTransformMakeTranslation(imageSize.width, 0);
        transform = CGAffineTransformScale(transform, -1.0, 1.0);
    }
    CGContextConcatCTM(context, transform);
    [self drawInRect:rect];
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

- (BOOL)writeImageToFileAtPath:(NSString *)aPath {
    if ((self == nil) || (aPath == nil) || ([aPath isEqualToString:@""])) {
        return NO;
    }
    
    @try {
        NSData   *imageData = nil;
        NSString *ext       = [aPath pathExtension];
        if ([ext isEqualToString:@"png"]) {
            imageData = UIImagePNGRepresentation(self);
        } else {
            imageData = UIImageJPEGRepresentation(self, 0);
        }
        
        if ((imageData == nil) || ([imageData length] <= 0)) {
            return NO;
        }
        
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    } @catch (NSException *e) {
        //NSLog(@"create thumbnail exception.");
    }
    return NO;
}

- (UIImage *)clipsImageToSize:(CGSize)desSZ {
    CGFloat w = CGImageGetWidth(self.CGImage);
    
    CGFloat t = desSZ.width;
    desSZ.width  = desSZ.height;
    desSZ.height = t;
    
    CGFloat x = (w - desSZ.width) / 2;
    CGFloat y = 0;
    
    CGRect     rc          = CGRectIntegral(CGRectMake(x, y, desSZ.width, desSZ.height));
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rc);
    
    UIImage *imageR = [UIImage imageWithCGImage:subImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(subImageRef);
    
    return imageR;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)resetSquareImage {
    float top    = 0.f;
    float left   = 0.f;
    float width  = self.size.width;
    float height = self.size.height;
    
    if (height > width) {
        top = (height - width) / 2.f;
        return [self imageByCropping:CGRectMake(left, top, width, width)];
    }
    
    if (width > height) {
        left = (width - height) / 2.f;
        return [self imageByCropping:CGRectMake(left, top, height, height)];
    }
    
    return self;
}

- (UIImage *)resetSquareImage:(CGSize)desSZ {
    float selfWidth  = self.size.width;
    float selfHeight = self.size.height;
    float desWidth   = desSZ.width * 2;
    float desHeight  = desSZ.height * 2;
    if (desWidth >= selfHeight && desHeight >= selfWidth) {
        return self;
    }
    
    float left = (selfWidth - desWidth) / 2 > 0 ? (selfWidth - desWidth) / 2 : 0;
    float top  = (selfHeight - desHeight) / 2 > 0 ? (selfHeight - desHeight) / 2 : 0;
    return [self imageByCropping:CGRectMake(left, top, desWidth, desHeight)];
}

- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect {
    return [self cropImage:image to:cropRect andScaleTo:cropRect.size];
}

- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGImageRef   subImage = CGImageCreateWithImageInRect([image CGImage], cropRect);
    CGRect       myRect   = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -size.height);
    CGContextDrawImage(context, myRect, subImage);
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(subImage);
    return croppedImage;
}

// 只用来做视频截图剪切
- (UIImage *)ajustOrientation:(UIImage *)image {
    int kMaxResolution = MAX(image.size.width, image.size.height);
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width  = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect            bounds    = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width  = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        } else {
            bounds.size.height = kMaxResolution;
            bounds.size.width  = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat            scaleRatio = bounds.size.width / width;
    CGSize             imageSize  = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat            boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch (orient) {
            
            case UIImageOrientationUp:     //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
            case UIImageOrientationUpMirrored:     //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
            case UIImageOrientationDown:     //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
            case UIImageOrientationDownMirrored:     //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
            case UIImageOrientationLeftMirrored:     //EXIF = 5
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform          = CGAffineTransformScale(transform, -1.0, 1.0);
            transform          = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
            case UIImageOrientationLeft:     //EXIF = 6
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform          = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
            case UIImageOrientationRightMirrored:     //EXIF = 7
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeScale(-1.0, 1.0);
            transform          = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
            case UIImageOrientationRight:     //EXIF = 8
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform          = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)fixOrientation:(UIImage *)aImage Orientation:(ALAssetOrientation)imageOrientation {
    CGImageRef imgRef = aImage.CGImage;
    CGFloat    width  = CGImageGetWidth(imgRef);
    CGFloat    height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect            bounds    = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    
    CGFloat            boundHeight;
    UIImageOrientation orient = imageOrientation;
    switch (orient) {
            case UIImageOrientationUp:     //0 EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
            case UIImageOrientationUpMirrored:     //4 EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
            case UIImageOrientationDown:     //1 EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
            case UIImageOrientationDownMirrored:     //5 EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
            case UIImageOrientationLeftMirrored:     //6 EXIF = 5
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeTranslation(height, width);
            transform          = CGAffineTransformScale(transform, -1.0, 1.0);
            transform          = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
            case UIImageOrientationLeft:     //2 EXIF = 6
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeTranslation(0.0, width); //(height, 0.0)
            transform          = CGAffineTransformRotate(transform, 3.0*M_PI/2.0);
            break;
            
            case UIImageOrientationRightMirrored:     //8 EXIF = 7
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeScale(-1.0, 1.0);
            transform          = CGAffineTransformRotate(transform, M_PI/2.0);
            break;
            
            case UIImageOrientationRight:     //3 EXIF = 8
            boundHeight        = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width  = boundHeight;
            transform          = CGAffineTransformMakeTranslation(height, 0.0); //(0.0, width)
            transform          = CGAffineTransformRotate(transform, M_PI/2.0); //3.0 * M_PI / 2.0
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        if (orient == UIImageOrientationLeftMirrored || orient == UIImageOrientationRightMirrored) {
            CGContextTranslateCTM(context, 0, -width);
        } else {
            CGContextTranslateCTM(context, 0, -height);
        }
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)scaleImage:(UIImage *)image maxSideLength:(int)iMaxSideLen {
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    
    int iMaxSide = MAX(width, height);
    if (iMaxSide <= iMaxSideLen || width <= 0 || height <= 0) {
        //TEST5
        if (image.imageOrientation == UIImageOrientationUp)
        return image;
        else {
            UIImage *newImage = [image fixOrientation:image Orientation:image.imageOrientation];
            return newImage;
        }
    } else {
        float ratio = (float)iMaxSideLen/iMaxSide;
        width  = width*ratio;
        height = height*ratio;
        {
            int iW = (int)(width+0.5);
            int iH = (int)(height+0.5);
            if (iW%2 != 0) iW -= 1;
            if (iH%2 != 0) iH -= 1;
            width  = iW;
            height = iH;
        }
        
        // 创建一个bitmap的context,并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        
        // 绘制改变大小的图片
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        // 从当前context中创建一个改变大小后的图片
        UIImage *newImage_scaled = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        
        // 返回新的改变大小后的图片
        return newImage_scaled;
    }
}

- (UIImage *)cropImageWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    
    UIImage *fixedImage = [self fixOrientation:self Orientation:self.imageOrientation];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(fixedImage.CGImage, rect);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:fixedImage.imageOrientation];
    
    CGImageRelease(imageRef);
    return image;
}





//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//等比例缩放
-(UIImage*)blscaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = ((size.width - width)/2 >0) ? 0:(size.width - width)/2;// 居左
    //    int xPos = (size.width - width)/2;
    //    int yPos = (size.height-height)/2;
    int yPos = ((size.height-height)/2 > 0) ? 0:(size.height-height)/2;// 居顶
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (UIImage *)cbblScaleToSize:(CGSize)size {
    CGFloat h = self.size.height;
    CGFloat w = self.size.width;
    if (h <= size.width && w <= size.height) {
        return self;
    }
    
    float  b        = (float)size.width/w < (float)size.height/h ? (float)size.width/w : (float)size.height/h;
    CGSize itemSize = CGSizeMake(b*w, b*h);
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(itemSize);
    }
    
    CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
    [self drawInRect:imageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (NSString *)encodeToBase64String
{
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end


