//
//  XMWebImageView.m
//  XianMao
//
//  Created by simon on 2/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "XMWebImageView.h"
#import "NSString+URLEncoding.h"

#define kMaxRetryCount      1 //数据校验失败后最大重试次数

@interface XMWebImageView() <UIGestureRecognizerDelegate>
{
    id<SDWebImageOperation> _sdOperation;
}

@property(nonatomic,assign) NSInteger retriedCount;
@property(nonatomic,copy) NSString *QNDownloadUrl;
@property (nonatomic, strong) UIView *back;

@end


@implementation XMWebImageView

- (void)dealloc
{
    [self cancelCurrentWebImageLoad];
    
    _handleSingleTapDetected = nil;
}

- (id)init {
    if ((self = [super init])) {
        self.userInteractionEnabled = YES;
        self.needlessAnimation = YES;   
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.needlessAnimation = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        back.backgroundColor = [UIColor redColor];
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = 10;
        [self addSubview:back];
        back.hidden = YES;
        self.back = back;
        
    }
    return self;
}

-(void)setIsSelectBack:(NSInteger)isSelectBack{
    _isSelectBack = isSelectBack;
    if (isSelectBack == 1) {
        self.back.hidden = NO;
    } else {
        self.back.hidden = YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_handleSingleTapDetected) {
        return YES;
    }
    return NO;
}

- (void)handleTapFrom:(UIGestureRecognizer *)recognizer
{
    if (_handleSingleTapDetected) {
        _handleSingleTapDetected(self,nil);
    }
}

- (void)setImageWithURL:(NSString *)aUrl XMWebImageScaleType:(XMWebImageScaleType)scaleType
{
    [self setImageWithURL:aUrl placeholderImage:nil XMWebImageScaleType:scaleType];
}

- (void)resetComponent
{
    [self cancelCurrentWebImageLoad];
    self.image = nil;
    self.QNDownloadUrl = nil;
}

- (void)setImageWithURL:(NSString *)aUrl placeholderImage:(UIImage *)aPlaceholder XMWebImageScaleType:(XMWebImageScaleType)scaleType
{
    [self setImageWithURL:aUrl
         placeholderImage:aPlaceholder
      XMWebImageScaleType:scaleType
            progressBlock:nil
             succeedBlock:nil
              failedBlock:nil];
}

/************************************添加图片类型参数*********************************/
- (void)mf_setImageWithURL:(NSString *)aUrl placeholderImage:(UIImage *)aPlaceholder XMWebImageScaleType:(XMWebImageScaleType)scaleType modeType:(QNImageModeType)type
{
    [self mf_setImageWithURL:aUrl
            placeholderImage:aPlaceholder
                    modeType:type
         XMWebImageScaleType:scaleType
               progressBlock:nil
                succeedBlock:nil
                 failedBlock:nil];
}

- (void)mf_setImageWithURL:(NSString *)aUrl
          placeholderImage:(UIImage *)aPlaceholder
                  modeType:(QNImageModeType)type
       XMWebImageScaleType:(XMWebImageScaleType)scaleType
             progressBlock:(XMWebImageProgressBlock)progressBlock
              succeedBlock:(XMWebImageSucceedBlock)succeedBlock
               failedBlock:(XMWebImageFailedBlock)failedBlock
{
    [self cancelCurrentWebImageLoad];
    
    NSString *QNDownloadUrl = [[XMWebImageView class] mf_imageUrlToQNImageUrl:aUrl isWebP:NO scaleType:scaleType modeType:type];
    [self setImageWithQNDownloadURL:QNDownloadUrl placeholderImage:aPlaceholder progressBlock:progressBlock succeedBlock:succeedBlock failedBlock:failedBlock];
}
/***********************************************************************************/

- (void)setImageWithURL:(NSString *)aUrl
       placeholderImage:(UIImage *)aPlaceholder
                   size:(CGSize)size
          progressBlock:(XMWebImageProgressBlock)progressBlock
           succeedBlock:(XMWebImageSucceedBlock)succeedBlock
            failedBlock:(XMWebImageFailedBlock)failedBlock
{
    [self cancelCurrentWebImageLoad];
    
    NSString *QNDownloadUrl = [[XMWebImageView class] imageUrlToQNImageUrl:aUrl isWebP:NO size:size];
    [self setImageWithQNDownloadURL:QNDownloadUrl placeholderImage:aPlaceholder progressBlock:progressBlock succeedBlock:succeedBlock failedBlock:failedBlock];
}

- (void)setImageWithURL:(NSString *)aUrl
       placeholderImage:(UIImage *)aPlaceholder
    XMWebImageScaleType:(XMWebImageScaleType)scaleType
          progressBlock:(XMWebImageProgressBlock)progressBlock
           succeedBlock:(XMWebImageSucceedBlock)succeedBlock
            failedBlock:(XMWebImageFailedBlock)failedBlock
{
    [self cancelCurrentWebImageLoad];
    
    NSString *QNDownloadUrl = [[XMWebImageView class] imageUrlToQNImageUrl:aUrl isWebP:NO scaleType:scaleType];
    [self setImageWithQNDownloadURL:QNDownloadUrl placeholderImage:aPlaceholder progressBlock:progressBlock succeedBlock:succeedBlock failedBlock:failedBlock];
}

- (void)setImageWithQNDownloadURL:(NSString *)QNDownloadUrl
                 placeholderImage:(UIImage *)aPlaceholder
                    progressBlock:(XMWebImageProgressBlock)progressBlock
                     succeedBlock:(XMWebImageSucceedBlock)succeedBlock
                      failedBlock:(XMWebImageFailedBlock)failedBlock
{
    self.QNDownloadUrl = QNDownloadUrl;
    
    //检查内存缓存
    UIImage * memoryImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:self.QNDownloadUrl];
    if (!memoryImage) {
        memoryImage = [[SDWebImageManager.sharedManager imageCache] imageFromDiskCacheForKey:self.QNDownloadUrl];
    }
    if (memoryImage)
    {
//        if (self.needlessAnimation) {
//            [self imageAnimation:memoryImage];
//        } else {
            self.image = memoryImage;
//        }
        
        if (succeedBlock) {
            succeedBlock(memoryImage, SDImageCacheTypeMemory);
        }
        if ([self.delegate respondsToSelector:@selector(webImageDidLoad:url:)]) {
            [self.delegate webImageDidLoad:memoryImage url:self.QNDownloadUrl];
        }
        return;
    }
    
    //磁盘加载或者下载
    __weak typeof(self) wself = self;
    __block NSString * downloadUrl = [self.QNDownloadUrl copy];
    
    self.image = aPlaceholder;
    NSURL *nsUrl = [NSURL URLWithString:self.QNDownloadUrl];
    
    _sdOperation = [SDWebImageManager.sharedManager downloadImageWithURL:nsUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_main_sync_safe(^{
            if (progressBlock) {
                progressBlock(receivedSize, expectedSize);
            }
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) {
            return;
        }
        
        dispatch_main_sync_safe(^{
            
            if (!wself) {
                return;
            }
            
            if (![wself.QNDownloadUrl isEqualToString:downloadUrl]) {
                return;
            }
            
            if (image) {
                if (wself.needlessAnimation) {
                    wself.image = nil;
                    [wself imageAnimation:image];
                } else {
                    wself.image = image;
                }
                if (succeedBlock) {
                    succeedBlock(image, cacheType);
                }
                if ([wself.delegate respondsToSelector:@selector(webImageDidLoad:url:)]) {
                    [wself.delegate webImageDidLoad:image url:wself.QNDownloadUrl];
                }
            }
            else if (error)
            {
//                if (wself.retriedCount < kMaxRetryCount)
//                {
//                    NSInteger oldRetriedCount = wself.retriedCount;
//                    wself.retriedCount = oldRetriedCount+1;
//                    
//                    [wself setImageWithQNDownloadURL:QNDownloadUrl
//                                    placeholderImage:aPlaceholder
//                                       progressBlock:progressBlock
//                                        succeedBlock:succeedBlock
//                                         failedBlock:failedBlock];
//                } else {
//                    if (failedBlock) {
//                        failedBlock(error);
//                    }
//                    if ([wself.delegate respondsToSelector:@selector(webImageLoadFailed:url:)]) {
//                        [self.delegate webImageLoadFailed:error url:wself.QNDownloadUrl];
//                    }
//                }
                if (failedBlock) {
                    failedBlock(error);
                }
                if ([wself.delegate respondsToSelector:@selector(webImageLoadFailed:url:)]) {
                    [self.delegate webImageLoadFailed:error url:wself.QNDownloadUrl];
                }
            }
        });
    }];
}

- (void)cancelCurrentWebImageLoad
{
    if (_sdOperation) {
        [_sdOperation cancel];
        _sdOperation = nil;
    }
    _retriedCount = 0;
}

- (void)imageAnimation:(UIImage *)image {
    if (!image) {
        return;
    }
    CATransition *animation = [CATransition animation];
    animation.delegate       = nil;
    animation.duration       = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type           = kCATransitionFade;
    self.image               = image;
    [[self layer] addAnimation:animation forKey:@"animation"];
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    NSUInteger tapCount = touch.tapCount;
//    switch (tapCount) {
//        case 1:
//            if (_handleSingleTapDetected) {
//                _handleSingleTapDetected(self,touch);
//            }
//            break;
//        default:
//            break;
//    }
//    if (!_handleSingleTapDetected) {
//        [[self nextResponder] touchesEnded:touches withEvent:event];
//    }
//}


+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP QNSizeString:(NSString*)QNSizeString modeType:(QNImageModeType)type {
    
    if ([url containsString:@"static99.aidingmao.com"]) {
        return url;
    }
    if ([url length]>0) {
        NSString *format = isWebP?@"webp":@"jpg";
        NSInteger modeType = type;
        
        //aidingmao.com  qiniudn.com
        
        //if ([url hasPrefix:@"http://aidingmao.qiniudn.com/"]) //全部走cdn，如果有问题配置http://static99.aidingmao.com
        if ([url containsString:@"aidingmao.com"] || [url containsString:@"qiniudn.com"])
        {
            NSMutableString *targetUrl = [NSMutableString stringWithString:url];
            [targetUrl appendFormat:@"?imageView2/%ld/" ,(long)modeType] ;
            
            if ([QNSizeString length]>0) {
                [targetUrl appendString:QNSizeString];
            }
            
            NSArray *formatArray = @[@"jpg",@"gif",@"png",@"webp"];
            if (format && [formatArray containsObject:format]) {
                [targetUrl appendFormat:@"format/%@/",format];
            }
            
            [targetUrl appendFormat:@"q/%lu/",(unsigned long)85];
            [targetUrl appendFormat:@"interlace/%lu/",(unsigned long)1];
            return [[targetUrl URLDecodedString] URLEncodedString];
            //return targetUrl;//[targetUrl URLEncodedString];
        }
        return [[url URLDecodedString] URLEncodedString];;//[url URLEncodedString]; url
    }
    return @"";

}


+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP QNSizeString:(NSString*)QNSizeString {
    return [[self class] imageUrlToQNImageUrl:url isWebP:isWebP QNSizeString:QNSizeString modeType:QNImageMode1];
}

+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP size:(CGSize)size {
    
    NSString *QNSizeString = nil;
    if (size.width>0 && size.height>0) {
        QNSizeString = [NSString stringWithFormat:@"w/%lu/h/%lu/",(unsigned long)size.width,(unsigned long)size.height];
    }
    
    return [self imageUrlToQNImageUrl:url isWebP:isWebP QNSizeString:QNSizeString];
}

/*******************************************************添加方法 添加图片类型***************************************************/
+ (NSString*)mf_imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP scaleType:(XMWebImageScaleType)scaleType modeType:(QNImageModeType)type{
    
    NSString *QNSizeString = [self getWebImageScaleWithType:scaleType];
    
    return [self mf_imageUrlToQNImageUrl:url isWebP:isWebP QNSizeString:QNSizeString modeType:type];
}

+ (NSString*)mf_imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP QNSizeString:(NSString*)QNSizeString modeType:(QNImageModeType)type{
    return [[self class] imageUrlToQNImageUrl:url isWebP:isWebP QNSizeString:QNSizeString modeType:type];
}
/*****************************************************************************************************************************/

+ (NSString*)imageUrlToQNImageUrl:(NSString*)url isWebP:(BOOL)isWebP scaleType:(XMWebImageScaleType)scaleType {
    
    NSString *QNSizeString = [self getWebImageScaleWithType:scaleType];
    
    return [self imageUrlToQNImageUrl:url isWebP:isWebP QNSizeString:QNSizeString];
}

+ (NSString *)getWebImageScaleWithType:(XMWebImageScaleType)scaleType {
    NSString *strScale = @"";
    switch (scaleType) {
        case XMWebImageScaleNone:
            strScale = @"";
            break;
        case XMWebImageScale40x40:
            strScale = @"w/40/h/40/";
            break;
            
        case XMWebImageScale60x60:
            strScale = @"w/60/h/60/";
            break;
            
        case XMWebImageScale80x80:
            strScale = @"w/80/h/80/";
            break;
            
        case XMWebImageScale100x100:
            strScale = @"w/100/h/100/";
            break;
            
        case XMWebImageScale120x120:
            strScale = @"w/120/h/120/";
            break;
            
        case XMWebImageScale160x160:
            strScale = @"w/160/h/160/";
            break;
            
        case XMWebImageScale200x200:
            strScale = @"w/200/h/200/";
            break;
        case XMWebImageScale240x240:
            strScale = @"w/240/h/240/";
            break;
            
        case XMWebImageScale300x300:
            strScale = @"w/300/h/300/";
            break;
            
        case XMWebImageScale320x320:
            strScale = @"w/320/h/320/";
            break;
            
        case XMWebImageScale400x400:
            strScale = @"w/400/h/400/";
            break;
            
        case XMWebImageScale480x480:
            strScale = @"w/480/h/480/";
            break;
            
        case XMWebImageScale640x640:
            strScale = @"w/640/h/640/";
            break;
        case XMWebImageScale750x750:
            strScale = @"w/750/h750/";
            break;
        case XMWebImageScale960x960:
            strScale = @"w/960/h/960/";
            break;
    }
    return strScale;
}

@end


#include <zlib.h>


#define kMaxCRC32FailedCount    10

@interface LWSDWebImageCheckHandler : NSObject <SDWebImageManagerDelegate>

@property (nonatomic, assign) NSInteger crc32FailedCount;

+ (instancetype)sharedHandler;

@end

@implementation LWSDWebImageCheckHandler

+ (instancetype)sharedHandler
{
    static LWSDWebImageCheckHandler * __sharedHandler = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedHandler = [[LWSDWebImageCheckHandler alloc] init];
    });
    
    return __sharedHandler;
}

#pragma mark - SDWebImageManagerDelegate

- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldCacheByCheckingData:(NSData *)imageData response:(NSHTTPURLResponse *)response imageURL:(NSURL *)imageURL
{
    if (self.crc32FailedCount >= kMaxCRC32FailedCount) {
        return YES; //如果crc32校验失败次数超限，就不校验，防止因为服务器问题导致的大面积校验失败
    }
    
    //服务端返回的crc32
    __block NSString * crc32Key = nil;
    [response.allHeaderFields.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * key = obj;
        if ([[key lowercaseString] isEqualToString:@"x-tfs-crc32"])
        {
            crc32Key = key;
            *stop = YES;
        }
    }];
    
    NSString * crc32string = [response.allHeaderFields valueForKey:crc32Key];
    if (!crc32string.length) {
        return YES; //如果服务器不返回crc32就不校验
    }
    
    unsigned long long ullCRC32 = 0;
    NSScanner * scanner = [NSScanner scannerWithString:crc32string];
    [scanner scanHexLongLong:&ullCRC32];
    
    //计算NSData的crc32
    uLong dataCRC32 = ~crc32(0L, Z_NULL, 0);
    dataCRC32 = ~crc32(dataCRC32, [imageData bytes], [imageData length]);
    
    if (ullCRC32 != (unsigned long long)dataCRC32) //校验不通过
    {
        //删除可能已经存在的缓存
        [SDWebImageManager lw_removeImageForURL:imageURL];
        
        //        //日志上报
        //        LWLogErrorType(LOG_TYPE_DOWNLOAD, LogErrorCodeDownloadImageError, @"crc32 check failed , imageUrl = %@ fileSize = %d, serverCrcValue = %ul, clientCrcValue = %ul",[imageURL absoluteString],[imageData length],ullCRC32,dataCRC32);
        
        //记录次数，如果超限，则上报对应日志
        self.crc32FailedCount ++;
        if (self.crc32FailedCount == kMaxCRC32FailedCount) {
            //            LWLogErrorType(LOG_TYPE_DOWNLOAD, LogErrorCodeDownloadImageError, @"crc32 check failed over %d times, imageUrl = %@ fileSize = %d, serverCrcValue = %ul, clientCrcValue = %ul",kMaxCRC32FailedCount,[imageURL absoluteString],[imageData length],ullCRC32,dataCRC32);
        }
        
        //返回NO：不缓存此次的下载数据
        return NO;
    }
    
    return YES;
}

@end


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation SDWebImageManager (LW)

+ (void)lw_configDataCheckHandler
{
    LWSDWebImageCheckHandler * sharedHandler = [LWSDWebImageCheckHandler sharedHandler];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SDWebImageManager.sharedManager.delegate = sharedHandler;
    });
}

+ (NSString *)lw_cacheKeyForURL:(NSURL *)url
{
    if (SDWebImageManager.sharedManager.cacheKeyFilter) {
        return SDWebImageManager.sharedManager.cacheKeyFilter(url);
    }
    
    return [url absoluteString];
}

+ (BOOL)imageExistInDisk:(id)imgUrl
{
    NSURL *urlObj = nil;
    if ([imgUrl isKindOfClass:[NSString class]]) {
        urlObj = [NSURL URLWithString:imgUrl];
    } else if ([imgUrl isKindOfClass:[NSURL class]]) {
        urlObj = imgUrl;
    } else {
        return NO;
    }
    NSString *cacheKey = [self lw_cacheKeyForURL:urlObj];
    [[SDWebImageManager sharedManager].imageCache defaultCachePathForKey:cacheKey];
    NSString *path = [[SDWebImageManager sharedManager].imageCache defaultCachePathForKey:cacheKey];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return exists;
}

+ (long long)imageFileSizeInDisk:(id)imgUrl
{
    NSURL *urlObj = nil;
    if ([imgUrl isKindOfClass:[NSString class]]) {
        urlObj = [NSURL URLWithString:imgUrl];
    } else if ([imgUrl isKindOfClass:[NSURL class]]) {
        urlObj = imgUrl;
    } else {
        return NO;
    }
    
    NSString *cacheKey = [self lw_cacheKeyForURL:urlObj];
    NSString *filePath = [[SDWebImageManager sharedManager].imageCache defaultCachePathForKey:cacheKey];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!exists) {
        return 0;
    }
    
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
}


+ (BOOL)imageExistInMemory:(id)imgUrl
{
    NSURL *urlObj = nil;
    if ([imgUrl isKindOfClass:[NSString class]]) {
        urlObj = [NSURL URLWithString:imgUrl];
    } else if ([imgUrl isKindOfClass:[NSURL class]]) {
        urlObj = imgUrl;
    } else {
        return NO;
    }
    return [SDWebImageManager.sharedManager.imageCache
            imageFromMemoryCacheForKey:[SDWebImageManager lw_cacheKeyForURL:urlObj]]?YES:NO;
}

+ (void)lw_storeImage:(UIImage *)image forURL:(NSURL *)url
{
    [self lw_storeImage:image forURL:url toDisk:YES];
}

+ (void)lw_storeImage:(UIImage *)image forURL:(NSURL *)url toDisk:(BOOL)toDisk
{
    [SDWebImageManager.sharedManager.imageCache storeImage:image
                                                    forKey:[self lw_cacheKeyForURL:url]
                                                    toDisk:toDisk];
}

+ (void)lw_storeImageFile:(NSString *)filePath forURL:(NSURL *)url toDisk:(BOOL)toDisk
{
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    
    if (toDisk) {
        NSString *cacheKey = [self lw_cacheKeyForURL:url];
        NSString *cachePath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:cacheKey];
        NSError *err = nil;
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:cachePath error:&err];
    }
}

+ (void)lw_removeImageForURL:(NSURL *)url
{
    [SDWebImageManager.sharedManager.imageCache removeImageForKey:[self lw_cacheKeyForURL:url]];
}


@end





