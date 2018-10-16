//
//  GoodsDetailSelfEngageCell.m
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsDetailSelfEngageCell.h"
#import "Masonry.h"

@interface GoodsDetailSelfEngageCell ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *subLbL;
@property (nonatomic, strong) UIImageView * arrowImg;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;

@end

@implementation GoodsDetailSelfEngageCell

-(UILabel *)subLbL{
    if (!_subLbL) {
        _subLbL = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbL.textColor = [UIColor colorWithHexString:@"333333"];
        _subLbL.font = [UIFont systemFontOfSize:12.f];
        _subLbL.text = @"爱丁猫严格品控，顾问服务";
        [_subLbL sizeToFit];
    }
    return _subLbL;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
//        _iconImageView.image = [UIImage imageNamed:@"optional_adm"];
    }
    return _iconImageView;
}

-(UIImageView *)arrowImg
{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
    }
    return _arrowImg;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _bottomView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailSelfEngageCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailSelfEngageCell class]];
    if (detailInfo) {
        [dict setObject:detailInfo forKey:@"detailInfo"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsDetailInfo * detailInfo = dict[@"detailInfo"];
    if (detailInfo.goodsInfo.seller.autotrophyGoodsVo.title) {
        self.height = detailInfo.goodsInfo.seller.autotrophyGoodsVo.height;
        self.weight = detailInfo.goodsInfo.seller.autotrophyGoodsVo.weight;
        [self.iconImageView setImageWithURL:[NSString stringWithFormat:@"%@",detailInfo.goodsInfo.seller.autotrophyGoodsVo.title] placeholderImage:nil XMWebImageScaleType:XMWebImageScale100x100];
        NSInteger iconImageWeight = 24*self.weight/self.height;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.width.mas_equalTo(iconImageWeight);
        }];
    }

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.arrowImg];
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
//    [self.subLbL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(7);
//        make.centerY.equalTo(self.iconImageView.mas_centerY);
//    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
