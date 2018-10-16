//
//  OfferedTitleCell.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedTitleCell.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import "SellerBasicInfo.h"

@interface OfferedTitleCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UIButton *handleIconBtn;

@property (nonatomic, strong) UIImageView *shareBtn;

//@property (nonatomic, strong) SellerBasicInfo *basicInfo;

@property (nonatomic, strong) RecoveryGoodsVo *goodsVo;

@property (nonatomic, strong) NSString *goodsSn;

@end

@implementation OfferedTitleCell

- (UIImageView *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _shareBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"offeredShare_Button"]];
        _shareBtn.image = [UIImage imageNamed:@"Share_New_MF_T"];
        _shareBtn.contentMode = UIViewContentModeScaleAspectFit;
        
//        _shareBtn.tintColor = [UIColor clearColor];
//        _shareBtn.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBtnAction:)];
        
        _shareBtn.userInteractionEnabled = YES;
        [_shareBtn addGestureRecognizer:tap];
        
        [_shareBtn sizeToFit];
    }
    return _shareBtn;
}

-(UIButton *)handleIconBtn{
    if (!_handleIconBtn) {
        _handleIconBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _handleIconBtn.layer.masksToBounds = YES;
        _handleIconBtn.layer.cornerRadius = 13;
    }
    return _handleIconBtn;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 13;
    }
    return _iconImageView;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.font = [UIFont systemFontOfSize:11.f];
        _userName.textColor = [UIColor colorWithHexString:@"231815"];
        [_userName sizeToFit];
    }
    return _userName;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OfferedTitleCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OfferedTitleCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 47;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.userName];
        self.iconImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.shareBtn];
        [self.iconImageView addSubview:self.handleIconBtn];
        [self.handleIconBtn addTarget:self action:@selector(clickIconImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickIconImage{
    if (self.handleIcon) {
        self.handleIcon();
    }
}

- (void)shareBtnAction:(UIImageView *)imageView {
    //add code
    NSLog(@"shareAction");
    NSString *str = [NSString stringWithFormat:@"activity.aidingmao.com/huishou/goods/%@", self.goodsSn];
//    [[CoordinatingController sharedInstance] shareWithTitle:@"爱丁猫分享"
//                                                      image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.goodsVo.mainPic.pic_url]]] //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:postVO.attachments[0][@"pic_url"]]]]
//                                                        url:str
//                                                    content:self.goodsVo.goodsName];
    
    //map.put("type", mType);
//    *     map.put("ref",mRef);
//    *     map.put("dst",mPlatform);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"type":@7, @"ref":self.goodsSn}];
    [[CoordinatingController sharedInstance] shareNetWithTitle:@"爱丁猫分享" image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.goodsVo.mainPic.pic_url]]] url:str content:self.goodsVo.goodsName parament:dict];
}



- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
    }];
    
    [self.handleIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconImageView);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.iconImageView.mas_top);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    _goodsVo = goodsVO;
    SellerBasicInfo *basicInfo = goodsVO.sellerBasicInfo;
    self.goodsSn = goodsVO.goodsSn;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:basicInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"login_avatar"]];
    self.userName.text = basicInfo.username;
}

@end
