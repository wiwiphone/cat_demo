//
//  WashIllustrateCell.m
//  XianMao
//
//  Created by WJH on 16/10/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WashIllustrateCell.h"

@interface WashIllustrateCell()

@property (nonatomic, strong) XMWebImageView * icon;
@property (nonatomic, strong) UILabel * washLbl;
@property (nonatomic, strong) UILabel * washDesc;
@property (nonatomic, strong) UILabel * price;

@end

@implementation WashIllustrateCell

-(UILabel *)washLbl
{
    if (!_washLbl) {
        _washLbl = [[UILabel alloc] init];
        _washLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _washLbl.font = [UIFont systemFontOfSize:15];
        [_washLbl sizeToFit];
    }
    return _washLbl;
}

-(UILabel *)price
{
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.textColor = [UIColor colorWithHexString:@"434342"];
        _price.font = [UIFont systemFontOfSize:15];
        [_price sizeToFit];
    }
    return _price;
}

-(UILabel *)washDesc
{
    if (!_washDesc) {
        _washDesc = [[UILabel alloc] init];
        _washDesc.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _washDesc.font = [UIFont systemFontOfSize:12];
        [_washDesc sizeToFit];
    }
    return _washDesc;
}

-(XMWebImageView *)icon
{
    if (!_icon) {
        _icon = [[XMWebImageView alloc] init];
    }
    return _icon;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.washLbl];
        [self.contentView addSubview:self.washDesc];
        [self.contentView addSubview:self.price];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.washLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.top.equalTo(self.icon.mas_top).offset(-2.5);
    }];
    
    [self.washDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.bottom.equalTo(self.icon.mas_bottom).offset(2.5);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WashIllustrateCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 65;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsGuarantee *)guarantee
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WashIllustrateCell class]];
    if (guarantee) {
        [dict setObject:guarantee forKey:@"washGoodsInfo"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsGuarantee * guarantee = [dict objectForKey:@"washGoodsInfo"];
    if (guarantee.title.length > 0) {
        self.washLbl.text = guarantee.title;
    }
    
    if (guarantee.name.length > 0) {
        self.washDesc.text = guarantee.name;
    }
    
    if (guarantee.iconUrl.length > 0) {
        [self.icon setImageWithURL:guarantee.iconUrl XMWebImageScaleType:XMWebImageScaleNone];
    }
    
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",guarantee.extend];
    
}

@end
