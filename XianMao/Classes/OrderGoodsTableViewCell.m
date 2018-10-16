//
//  OrderGoodsTableViewCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderGoodsTableViewCell.h"
#import "Masonry.h"

@interface OrderGoodsTableViewCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *gradeLbl;
@property (nonatomic, strong) UIImageView *determine;
@property (nonatomic, strong) UIImageView *washIcon;

@end

@implementation OrderGoodsTableViewCell

-(UIImageView *)washIcon
{
    if (!_washIcon) {
        _washIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _washIcon.image = [UIImage imageNamed:@"washIcon_wjh"];
        _washIcon.hidden = YES;
    }
    return _washIcon;
}

-(UIImageView *)determine{
    if (!_determine) {
        _determine = [[UIImageView alloc] initWithFrame:CGRectZero];
        _determine.image = [UIImage imageNamed:@"Wrist_Determine"];
        [_determine sizeToFit];
    }
    return _determine;
}

-(UILabel *)gradeLbl{
    if (!_gradeLbl) {
        _gradeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _gradeLbl.font = [UIFont systemFontOfSize:12.f];
        _gradeLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_gradeLbl sizeToFit];
    }
    return _gradeLbl;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:12.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)goodsName{
    if (!_goodsName) {
        _goodsName = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsName.font = [UIFont systemFontOfSize:12.f];
        _goodsName.textColor = [UIColor colorWithHexString:@"000000"];
        [_goodsName sizeToFit];
    }
    return _goodsName;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderGoodsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(GoodsInfo *)goodsInfo{
    CGFloat height = 100.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo orderInfo:(OrderInfo *)orderInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderGoodsTableViewCell class]];
    if (goodsInfo) {
        [dict setObject:goodsInfo forKey:@"goodsInfo"];
    }
    if (orderInfo) {
        [dict setObject:orderInfo forKey:@"orderInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.goodsName];
        [self.contentView addSubview:self.priceLbl];
        [self.contentView addSubview:self.gradeLbl];
        [self.contentView addSubview:self.determine];
        [self.contentView addSubview:self.washIcon];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.width.equalTo(@(kScreenWidth/375*60));
        make.height.equalTo(@(kScreenWidth/375*60));
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/375*75);
    }];
    
    [self.gradeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
    }];
    
    [self.determine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
    }];
    
    [self.washIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.determine.mas_right).offset(5);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    OrderInfo * orderInfo = dict[@"orderInfo"];
    [self.iconImageView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.priceLbl.text = [NSString stringWithFormat:@"¥%.2f", goodsInfo.shopPrice];
    self.goodsName.text = goodsInfo.goodsName;
    self.gradeLbl.text = [NSString stringWithFormat:@"成色：%@", [goodsInfo gradeText]];
    
    if (goodsInfo.guarantee.iconUrl.length > 0) {
        self.washIcon.hidden = NO;
    }else{
        self.washIcon.hidden = YES;
    }
    
    if (orderInfo.tradeType == 9) {
        self.determine.hidden = YES;
    }else{
        self.determine.hidden = NO;
    }
    
}

@end
