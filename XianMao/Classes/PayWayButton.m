//
//  PayWayButton.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayWayButton.h"

@interface PayWayButton()

@property (nonatomic, strong) XMWebImageView * icon;
@property (nonatomic, strong) UILabel * payWay;
@property (nonatomic, strong) UIView * line;

@end

@implementation PayWayButton

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

-(XMWebImageView *)icon
{
    if (!_icon) {
        _icon = [[XMWebImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 15;
    }
    return _icon;
}

-(UILabel *)payWay
{
    if (!_payWay) {
        _payWay = [[UILabel alloc] init];
        _payWay.font = [UIFont systemFontOfSize:14];
        _payWay.textColor = [UIColor blackColor];
        [_payWay sizeToFit];
    }
    return _payWay;
}

-(UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc] init];
        [_selectedButton setImage:[UIImage imageNamed:@"shopping_cart_uncgoose_new"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"shopping_cart_choosed_new"] forState:UIControlStateSelected];
    }
    return _selectedButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.payWay];
        [self addSubview:self.selectedButton];
        [self addSubview:self.line];
    
    }
    return self;
}

-(void)setPayWayDO:(PayWayDO *)payWayDO
{
    _payWayDO = payWayDO;
    [self.icon setImageWithURL:payWayDO.icon_url XMWebImageScaleType:XMWebImageScaleNone];
    self.payWay.text = payWayDO.pay_name;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.icon.mas_right).offset(12);
    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-14);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(14);
        make.right.equalTo(self.mas_right).offset(-14);
        make.height.mas_equalTo(@1);
    }];
}

@end
