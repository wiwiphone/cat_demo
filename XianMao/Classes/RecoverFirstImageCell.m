//
//  RecoverFirstImageCell.m
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverFirstImageCell.h"
#import "Masonry.h"
#import "MainPic.h"
#import "SDWebImageManager.h"
#import "DataSources.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ASScroll.h"

@interface RecoverFirstImageCell () <MJPhotoBrowserDelegate>

@property (nonatomic, strong) XMWebImageView *recoverImageView;
@property (nonatomic, strong) ASScroll *scrollImageView;

@property (nonatomic, strong) NSMutableArray *gallaryItems;
@property (nonatomic, strong) NSMutableArray *imageViewItems;

@end

@implementation RecoverFirstImageCell

-(NSMutableArray *)imageViewItems{
    if (!_imageViewItems) {
        _imageViewItems = [NSMutableArray array];
    }
    return _imageViewItems;
}

-(NSMutableArray *)gallaryItems{
    if (!_gallaryItems) {
        _gallaryItems = [NSMutableArray array];
    }
    return _gallaryItems;
}

-(XMWebImageView *)recoverImageView{
    if (!_recoverImageView) {
        _recoverImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _recoverImageView.userInteractionEnabled = YES;
        _recoverImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _recoverImageView.clipsToBounds = YES;
        _recoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _recoverImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverFirstImageCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverFirstImageCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 201;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.recoverImageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.recoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

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
    MainPic *mainPic = goodsVO.mainPic;
    [self.recoverImageView setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.recoverImageView.tag = 0;
    [self.gallaryItems addObject:mainPic.pic_url];
    [self.imageViewItems addObject:self.recoverImageView];
    
    if (goodsVO.gallary.count > 0) {
        for (int i = 0; i < goodsVO.gallary.count; i++) {
            MainPic *otherPic = goodsVO.gallary[i];
            [self.gallaryItems addObject:otherPic.pic_url];
            
            XMWebImageView *otherImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
            otherImageView.userInteractionEnabled = YES;
            otherImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
            otherImageView.clipsToBounds = YES;
            otherImageView.contentMode = UIViewContentModeScaleAspectFill;
            [otherImageView setImageWithURL:otherPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            [self.imageViewItems addObject:otherImageView];
            otherImageView.tag = i + 1;
        }
    }
    
    self.recoverImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
        [weakSelf didClickViewPage:view imageViewImage:weakSelf.imageViewItems];
    };
    
}

@end
