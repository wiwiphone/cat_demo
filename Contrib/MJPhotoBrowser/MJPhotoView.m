//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SDImageCache.h"

#import "UIActionSheet+Blocks.h"
#import "CoordinatingController.h"

@interface MJPhotoView ()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
}
@property(nonatomic,strong) MJPhotoLoadingView *photoLoadingView;
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
		
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//        lpgr.minimumPressDuration = .5;
        [self addGestureRecognizer:lpgr];
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    if (_photo.firstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
        _photo.srcImageView.image = nil;
        
        // 不是gif，就马上开始下载
        if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
            __unsafe_unretained MJPhotoView *photoView = self;
            __unsafe_unretained MJPhoto *photo = _photo;
            [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                photo.image = image;
                
                // 调整frame参数
                [photoView adjustFrame];
            }];
//            [_imageView setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                photo.image = image;
//                
//                // 调整frame参数
//                [photoView adjustFrame];
//            }];
        }
    } else {
        [self photoStartLoad];
    }

    // 调整frame参数
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
//        __unsafe_unretained MJPhotoView *photoView = self;
//        __unsafe_unretained MJPhotoLoadingView *loading = _photoLoadingView;
        typeof(self) __weak weakSelf = self;
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize , NSInteger expectedSize) {
            if (receivedSize > kMinProgress) {
                if (weakSelf) {
                    weakSelf.photoLoadingView.progress = (float)receivedSize/expectedSize;
                }
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType , NSURL *imageUrl) {
            [weakSelf photoDidFinishLoadWithImage:image];
        }];
//        [_imageView setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
//            if (receivedSize > kMinProgress) {
//                loading.progress = (float)receivedSize/expectedSize;
//            }
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            [photoView photoDidFinishLoadWithImage:image];
//        }];
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        if ([_photo.url absoluteString].length >0) {
            [self addSubview:_photoLoadingView];
            [_photoLoadingView showFailure];
        } else {
             [_photoLoadingView hideLoading];
        }
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 3.0;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageViewFrame = _imageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (imageViewFrame.size.height > screenBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    } else {
        imageViewFrame.origin.y = (screenBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    _imageView.frame = imageViewFrame;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}
- (void)hide
{
    if (_doubleTap) return;
    
    // 移除进度条
    [_photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    
    // 清空底部的小图
    _photo.srcImageView.image = nil;
    
    CGFloat duration = 0.15;
    if (_photo.srcImageView.clipsToBounds) {
        [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
    }
    
    if (_imageView.image.images || _imageView.image) {
        [UIView animateWithDuration:duration + 0.1 animations:^{
            if (_photo.animHideToImageView) {
                _imageView.frame = [_photo.animHideToImageView convertRect:_photo.animHideToImageView.bounds toView:nil];
            } else {
                _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
            }
            
            // gif图片仅显示第0张
            if (_imageView.image.images) {
                _imageView.image = _imageView.image.images[0];
            }
            
            // 通知代理
            if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
                [self.photoViewDelegate photoViewSingleTap:self];
            }
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            
            // 通知代理
            if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
                [self.photoViewDelegate photoViewDidEndZoom:self];
            }
        }];
    } else {
        //不使用动画
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        // gif图片仅显示第0张
        if (_imageView.image.images) {
            _imageView.image = _imageView.image.images[0];
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
        
        // 设置底部的小图片
        _photo.srcImageView.image = _photo.placeholder;
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }
    
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)tap {
    if (tap.state == UIGestureRecognizerStateBegan) {
        WEAKSELF;
        [UIActionSheet showInView:self
                        withTitle:nil
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:[NSArray arrayWithObjects:@"保存图片", nil]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0 ) {
                                 [weakSelf saveImage];
                             }
                         }];
    }
}

- (void)dealloc
{
    // 取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photo;
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"无法保存"
                                                             message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
//        [[CoordinatingController sharedInstance] showHUD:@"图片已保存到系统相册" hideAfterDelay:0.8f];
//        WEAKSELF;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //图片已保存到系统相册
            [[CoordinatingController sharedInstance] showHUD:@"图片已保存到系统相册" hideAfterDelay:0.8f];
        });
    }
}

@end

