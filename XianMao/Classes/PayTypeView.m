//
//  PayTypeView.m
//  XianMao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayTypeView.h"

@interface PayTypeView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *chooseLbl;

@property (nonatomic, strong) UILabel *avaMoneyLbl;
@end

@implementation PayTypeView

-(UILabel *)avaMoneyLbl{
    if (!_avaMoneyLbl) {
        _avaMoneyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _avaMoneyLbl.font = [UIFont systemFontOfSize:13.f];
        _avaMoneyLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_avaMoneyLbl sizeToFit];
    }
    return _avaMoneyLbl;
}

-(UILabel *)chooseLbl{
    if (!_chooseLbl) {
        _chooseLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _chooseLbl.font = [UIFont systemFontOfSize:15.f];
        _chooseLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        [_chooseLbl sizeToFit];
        _chooseLbl.text = @"请选择本次支付方式";
    }
    return _chooseLbl;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_White_MF"];
        [_rightImageView sizeToFit];
    }
    return _rightImageView;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
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
        [self addSubview:self.titleLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.rightImageView];
        [self addSubview:self.chooseLbl];
        [self addSubview:self.avaMoneyLbl];
        self.avaMoneyLbl.hidden = YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.showPayWayView) {
        self.showPayWayView();
    }
}

-(void)getPartialDo:(ParyialDo *)partialDo{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:partialDo.payWayIconUrl] placeholderImage:nil];
    self.contentLbl.text = partialDo.payWayContent;
    self.titleLbl.text = partialDo.payWayTitle;
    self.avaMoneyLbl.text = [NSString stringWithFormat:@"(¥%ld可用)", partialDo.avaMoneyCent/100];
    if (partialDo.payType == 20) {
        self.iconImageView.hidden = YES;
        self.titleLbl.hidden = YES;
        self.contentLbl.hidden = YES;
        self.chooseLbl.hidden = NO;
    } else {
        self.iconImageView.hidden = NO;
        self.titleLbl.hidden = NO;
        self.contentLbl.hidden = NO;
        self.chooseLbl.hidden = YES;
    }
    
    if (partialDo.payType == 10) {
        self.avaMoneyLbl.hidden = NO;
    } else {
        self.avaMoneyLbl.hidden = YES;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(18);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(18);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
    [self.chooseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
    [self.avaMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.rightImageView.mas_left).offset(-8);
    }];
}

@end
