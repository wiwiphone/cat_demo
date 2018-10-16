//
//  offeredUserInfoCell.m
//  XianMao
//
//  Created by 阿杜 on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "offeredUserInfoCell.h"

#import "Masonry.h"
#import "SDWebImageManager.h"
#import "SellerBasicInfo.h"

@interface offeredUserInfoCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UIButton *handleIconBtn;

@end

@implementation offeredUserInfoCell

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
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.font = [UIFont systemFontOfSize:13.f];
        _userName.textColor = [UIColor colorWithHexString:@"231815"];
        [_userName sizeToFit];
    }
    return _userName;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([offeredUserInfoCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[offeredUserInfoCell class]];
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
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    SellerBasicInfo *basicInfo = goodsVO.sellerBasicInfo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:basicInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"login_avatar"]];
    self.userName.text = basicInfo.username;
}


@end
