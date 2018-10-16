//
//  XMWebImageView.h
//  XianMao
//
//  Created by simon on 2/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDImageCache.h"
#import "SDWebImageManager.h"

////////////////////////////////////////////////////////////////////////////////

@protocol XMWebImageViewDelegate <NSObject>
@optional
- (void)webImageDidLoad:(UIImage *)image url:(NSString *)url;
- (void)webGifDataDidLoad:(UIImage *)image gifAddress:(NSString *)address;
- (void)webImageLoadFailed:(NSError *)error url:(NSString *)url;
- (void)updateProgress:(NSNumber*)totalBytesReadNumber
               ofTotal:(NSNumber*)totalSizeNumber;
@end

////////////////////////////////////////////////////////////////////////////////

typedef void(^XMWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^XMWebImageSucceedBlock)(UIImage *image, SDImageCacheType cacheType);
typedef void(^XMWebImageFailedBlock)(NSError *error);

typedef enum {
    XMWebImageScaleNone    = 0,
    XMWebImageScale40x40   = 2,
    XMWebImageScale60x60   = 3,
    XMWebImageScale80x80   = 4,
    XMWebImageScale100x100 = 5,
    XMWebImageScale120x120 = 6,
    XMWebImageScale160x160 = 8,
    XMWebImageScale200x200 = 10,
    XMWebImageScale240x240 = 12,
    XMWebImageScale300x300 = 15,
    XMWebImageScale400x400 = 20,
    XMWebImageScale320x320 = 16,
    XMWebImageScale480x480 = 24,
    XMWebImageScale640x640 = 32,
    XMWebImageScale750x750 = 37,
    XMWebImageScale960x960 = 48
} XMWebImageScaleType;

typedef enum {
    QNImageMode0 = 0,  //限定缩略图的长边最多为<LongEdge>，短边最多为<ShortEdge>，进行等比缩放，不裁剪。
    QNImageMode1 = 1,  //限定缩略图的宽最少为<Width>，高最少为<Height>，进行等比缩放，居中裁剪
    QNImageMode2 = 2,  //限定缩略图的宽最多为<Width>，高最多为<Height>，进行等比缩放，不裁剪
    QNImageMode3 = 3,  //限定缩略图的宽最少为<Width>，高最少为<Height>，进行等比缩放，不裁剪
    QNImageMode4 = 4,  //限定缩略图的长边最少为<LongEdge>，短边最少为<ShortEdge>，进行等比缩放，不裁剪。
    QNImageMode5 = 5,  //限定缩略图的长边最少为<LongEdge>，短边最少为<ShortEdge>，进行等比缩放，居中裁剪。
    QNImageModeNone = 10,
} QNImageModeType;

@interface XMWebImageView : UIImageView
@property (nonatomic, assign) NSInteger isSelectBack;
@property (nonatomic, assign) NSInteger valueId;
@property (nonatomic, assign) NSInteger attrId;
@property (nonatomic, copy) NSString *valueName;
@property (nonatomic, assign) NSInteger isMutCho;
@property (nonatomic, assign) NSInteger isSelecet;
@property(nonatomic, weak) id<XMWebImageViewDelegate> delegate;
@property(nonatomic, assign) BOOL needlessAnimation;
@property(nonatomic, copy) void(^handleSingleTapDetected)(XMWebImageView *view, UITouch *touch);

+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP size:(CGSize)size;
;
+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP QNSizeString:(NSString*)QNSizeString modeType:(QNImageModeType)type;

+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP scaleType:(XMWebImageScaleType)scaleType;

- (void)setImageWithURL:(NSString *)aUrl XMWebImageScaleType:(XMWebImageScaleType)scaleType;
- (void)setImageWithURL:(NSString *)aUrl placeholderImage:(UIImage *)aPlaceholder XMWebImageScaleType:(XMWebImageScaleType)scaleType;
//修改方法  添加type参数 图片显示形式
- (void)mf_setImageWithURL:(NSString *)aUrl placeholderImage:(UIImage *)aPlaceholder XMWebImageScaleType:(XMWebImageScaleType)scaleType modeType:(QNImageModeType)type;

- (void)setImageWithURL:(NSString *)aUrl
       placeholderImage:(UIImage *)aPlaceholder
    XMWebImageScaleType:(XMWebImageScaleType)scaleType
          progressBlock:(XMWebImageProgressBlock)progressBlock
           succeedBlock:(XMWebImageSucceedBlock)succeedBlock
            failedBlock:(XMWebImageFailedBlock)failedBlock;

- (void)setImageWithURL:(NSString *)aUrl
       placeholderImage:(UIImage *)aPlaceholder
                   size:(CGSize)size
          progressBlock:(XMWebImageProgressBlock)progressBlock
           succeedBlock:(XMWebImageSucceedBlock)succeedBlock
            failedBlock:(XMWebImageFailedBlock)failedBlock;

- (void)setImageWithQNDownloadURL:(NSString *)QNDownloadUrl
                 placeholderImage:(UIImage *)aPlaceholder
                    progressBlock:(XMWebImageProgressBlock)progressBlock
                     succeedBlock:(XMWebImageSucceedBlock)succeedBlock
                      failedBlock:(XMWebImageFailedBlock)failedBlock;

- (void)cancelCurrentWebImageLoad;
- (void)resetComponent;

@end

@interface SDWebImageManager (LW)

/**
 *  给SDWebImageManager配置数据校验处理
 */
+ (void)lw_configDataCheckHandler;


/**
 *  获取指定URL在SDWebImage中对应的cache key
 *
 *  @param url 普通URL
 *
 *  @return cache key
 */
+ (NSString *)lw_cacheKeyForURL:(NSURL *)url;


/**
 *  将image缓存到SDWebImage中
 *
 *  @param image 要缓存的UIImage对象
 *  @param url   普通URL
 */
+ (void)lw_storeImage:(UIImage *)image forURL:(NSURL *)url;
+ (void)lw_storeImage:(UIImage *)image forURL:(NSURL *)url toDisk:(BOOL)toDisk;

+ (void)lw_storeImageFile:(NSString *)filePath forURL:(NSURL *)url toDisk:(BOOL)toDisk;

/**
 *  删除对应url的缓存
 */
+ (void)lw_removeImageForURL:(NSURL *)url;

+ (BOOL)imageExistInDisk:(id)imgUrl;
+ (BOOL)imageExistInMemory:(id)imgUrl;
+ (long long)imageFileSizeInDisk:(id)imgUrl;
@end



