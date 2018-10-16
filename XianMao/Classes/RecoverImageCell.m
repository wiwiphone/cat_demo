//
//  RecoverImageCell.m
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverImageCell.h"
#import "Masonry.h"
#import "DataSources.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ASScroll.h"

@interface RecoverImageCell () <ASScrollViewDelegate, MJPhotoBrowserDelegate>

@property (nonatomic, strong) XMWebImageView *otherImageView;
@property (nonatomic, strong) NSMutableArray *gallaryItems;
@property (nonatomic, strong) NSMutableArray *imageViewItems;
@property (nonatomic, strong) ASScroll *scrollImageView;

@end

@implementation RecoverImageCell

//-(XMWebImageView *)otherImageView{
//    if (!_otherImageView) {
//        _otherImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
//        _otherImageView.userInteractionEnabled = YES;
//        _otherImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
//        _otherImageView.clipsToBounds = YES;
//        _otherImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _otherImageView;
//}

-(NSMutableArray *)gallaryItems{
    if (!_gallaryItems) {
        _gallaryItems = [[NSMutableArray alloc] init];
    }
    return _gallaryItems;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverImageCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverImageCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    if (dict) {
        RecoveryGoodsVo *goodsVO = dict[@"recoveryGoodsVo"];
        height = 206 * goodsVO.gallary.count;
    }
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        XMWebImageView *otherImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
//        otherImageView.userInteractionEnabled = YES;
//        otherImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
//        otherImageView.clipsToBounds = YES;
//        otherImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.contentView addSubview:otherImageView];
//        self.otherImageView = otherImageView;
        
        
        
    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self.otherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(5);
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
////        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
//        make.height.equalTo(@201);
//    }];
//}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [_scrollImageView setCurrentPage:index];
}

-(void)didClickViewPage:(UIImageView *)imageView imageViewImage:(NSArray *)imageViewArray
{
    // 1.封装图片数据
//    NSMutableArray *imageViewArray = [NSMutableArray arrayWithObject:XMImageView];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.gallaryItems count]];
    for (NSInteger i=0;i< [self.gallaryItems count];i++) {
        
//        MainPic *item = (MainPic*)[self.gallaryItems objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *QNDownloadUrl = nil;
        
        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:self.gallaryItems[i] isWebP:NO scaleType:XMWebImageScale750x750];
        
        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
        if (i<imageViewArray.count) {
            photo.srcImageView = [imageViewArray objectAtIndex:i];
        } else {
            photo.srcImageView = imageView; // 来源于哪个UIImageView
        }
        [photos addObject:photo];
    }
    
    if ([photos count]>0) {
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    WEAKSELF;
    MainPic *pic = goodsVO.mainPic;
    [self.gallaryItems addObject:pic.pic_url];
    XMWebImageView *mainImageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(15, 206, kScreenWidth-30, 201)];
    mainImageView.userInteractionEnabled = YES;
    mainImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
    mainImageView.clipsToBounds = YES;
    mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [mainImageView setImageWithURL:pic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    mainImageView.tag = 0;
    [self.imageViewItems addObject:mainImageView];
    
    for (int i = 0; i < goodsVO.gallary.count; i++) {
        XMWebImageView *otherImageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(15, (206 * i), kScreenWidth-30, 201)];
        otherImageView.userInteractionEnabled = YES;
        otherImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        otherImageView.clipsToBounds = YES;
        otherImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:otherImageView];
        otherImageView.tag = i + 1;
        
        MainPic *mainPic = goodsVO.gallary[i];
        [otherImageView setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        self.otherImageView = otherImageView;
        [self.gallaryItems addObject:mainPic.pic_url];
        [self.imageViewItems addObject:otherImageView];
        
        self.otherImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            [weakSelf didClickViewPage:view imageViewImage:weakSelf.imageViewItems];
        };
    }
    
}

@end
