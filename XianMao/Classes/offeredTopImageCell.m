//
//  offeredTopImageCell.m
//  XianMao
//
//  Created by 阿杜 on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "offeredTopImageCell.h"
#import "Masonry.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ASScroll.h"
#import "DataSources.h"
@interface offeredTopImageCell () <ASScrollViewDelegate, MJPhotoBrowserDelegate>

@property (nonatomic, strong) UILabel *statusLB;

@property (nonatomic, strong) RecoveryGoodsVo *goodVO;
@property (nonatomic, assign) BOOL flag;

@end

@implementation offeredTopImageCell

- (UILabel *)statusLB {
    if (!_statusLB) {
        _statusLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLB.layer.cornerRadius = 40;
        _statusLB.backgroundColor = [UIColor blackColor];
        _statusLB.alpha = 0.7;
        _statusLB.textColor = [UIColor whiteColor];
        _statusLB.font = [UIFont systemFontOfSize:13];
        _statusLB.textAlignment = NSTextAlignmentCenter;
        _statusLB.clipsToBounds = YES;
    }
    return _statusLB;
}


- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArr;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([offeredTopImageCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[offeredTopImageCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = kScreenWidth - 80;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.asScroll = [[ASScroll alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth - 80)];
        self.asScroll.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.asScroll];
        self.asScroll.delegate = self;
    }
    return self;
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    self.imageArr = [NSMutableArray arrayWithCapacity:0];
    if (goodsVO.mainPic) {
        [self.imageArr addObject:goodsVO.mainPic.pic_url];
    }
    for (int i = 0; i < goodsVO.gallary.count; i++) {
        [self.imageArr addObject:((MainPic *)goodsVO.gallary[i]).pic_url];
    }
    
    [self.asScroll setCurrentPage:0];
    //        self.asScroll.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.asScroll.height - 50, self.asScroll.width, 50)];
    imageView.image = [UIImage imageNamed:@"gradually-MF"];
    [self.asScroll addSubview:imageView];
    
    [self.contentView addSubview:self.asScroll];
    [self.asScroll setArrOfImages:self.imageArr];
    
    if (goodsVO.status != 1) {
        self.goodVO = goodsVO;
        self.flag = YES;
        [self.contentView addSubview:self.statusLB];
        switch (goodsVO.status) {
            case 0:
                self.statusLB.text = @"已下架";
                break;
            case 2:
                self.statusLB.text = @"已锁定";
                break;
            case 3:
                self.statusLB.text = @"已售出";
                break;
            default:
//                self.statusLB.text = @"状态无效";
                break;
        }
    }
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.asScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
//    if (self.goodVO.status != 1) {
    if (self.flag) {
        
        [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
    }
}



- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [self.asScroll setCurrentPage:index];
}

-(void)didClickViewPage:(UIImageView *)imageView imageViewArray:(NSArray *)imageViewArray{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.imageArr count]];
    for (NSInteger i=0;i< [self.imageArr count];i++) {
        
        //        MainPic *item = (MainPic*)[self.gallaryItems objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *QNDownloadUrl = nil;
        
        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:self.imageArr[i] isWebP:NO scaleType:XMWebImageScale750x750];
        
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
        browser.photos = photos;
        
        // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }

}


@end
