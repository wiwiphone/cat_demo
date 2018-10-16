//
//  PayWaySelectedView.m
//  XianMao
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayWaySelectedView.h"

@interface PayWaySelectedView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *payWayTitle;
@property (nonatomic, strong) UILabel *payWayContent;
@property (nonatomic, strong) PayWayDO *payWayDo;
@property (nonatomic, strong) UILabel *avaMoneyLbl;
@end

@implementation PayWaySelectedView

-(UILabel *)avaMoneyLbl{
    if (!_avaMoneyLbl) {
        _avaMoneyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _avaMoneyLbl.font = [UIFont systemFontOfSize:13.f];
        _avaMoneyLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_avaMoneyLbl sizeToFit];
    }
    return _avaMoneyLbl;
}

-(UILabel *)payWayContent{
    if (!_payWayContent) {
        _payWayContent = [[UILabel alloc] initWithFrame:CGRectZero];
        _payWayContent.font = [UIFont systemFontOfSize:13.f];
        _payWayContent.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_payWayContent sizeToFit];
    }
    return _payWayContent;
}

-(UILabel *)payWayTitle{
    if (!_payWayTitle) {
        _payWayTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _payWayTitle.font = [UIFont systemFontOfSize:14.f];
        _payWayTitle.textColor = [UIColor colorWithHexString:@"333333"];
        [_payWayTitle sizeToFit];
    }
    return _payWayTitle;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 32/2;
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.payWayTitle];
        [self addSubview:self.payWayContent];
        [self addSubview:self.avaMoneyLbl];
        self.avaMoneyLbl.hidden = YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.changeSelectedPayWay) {
        self.changeSelectedPayWay(self.payWayDo);
    }
}

-(void)getPayWayDo:(PayWayDO *)payWayDo{
    self.payWayDo = payWayDo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:payWayDo.icon_url] placeholderImage:nil];
    self.payWayContent.text = payWayDo.desc;
    self.payWayTitle.text = payWayDo.pay_name;
    
    if (payWayDo.pay_way == 10) {
        self.avaMoneyLbl.hidden = NO;
    } else {
        self.avaMoneyLbl.hidden = YES;
    }
}

-(void)setAvaMoneyCent:(NSInteger)avaMoneyCent{
    _avaMoneyCent = avaMoneyCent;
    self.avaMoneyLbl.text = [NSString stringWithFormat:@"(¥%ld可用)", avaMoneyCent/100];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    [self.payWayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(18);
    }];
    
    [self.payWayContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(18);
    }];
    
    [self.avaMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
}

@end
