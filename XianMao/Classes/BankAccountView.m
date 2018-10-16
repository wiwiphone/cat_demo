//
//  BankAccountView.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BankAccountView.h"
#import "WithdrawalsAccountVo.h"

@interface BankAccountView()

@property (nonatomic, strong) XMWebImageView * icon;
@property (nonatomic, strong) UILabel * accountName;
@property (nonatomic, strong) UILabel * breviary;
@property (nonatomic, strong) UILabel * desc;
@property (nonatomic, strong) UIButton * chooseBtn;
@property (nonatomic, strong) UIView * line;

@property (nonatomic, copy) NSString * account;

@end

@implementation BankAccountView

-(XMWebImageView *)icon
{
    if (!_icon) {
        _icon = [[XMWebImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 15;
    }
    return _icon;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
    }
    return _line;
}


-(UIButton *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn setImage:[UIImage imageNamed:@"unchoose"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        _chooseBtn.userInteractionEnabled = NO;
    }
    return _chooseBtn;
}


-(UILabel *)breviary
{
    if (!_breviary) {
        _breviary = [[UILabel alloc] init];
        _breviary.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _breviary.font = [UIFont systemFontOfSize:12];
        [_breviary sizeToFit];
    }
    return _breviary;
}

-(UILabel *)accountName
{
    if (!_accountName) {
        _accountName = [[UILabel alloc] init];
        _accountName.textColor = [UIColor colorWithHexString:@"434342"];
        _accountName.font = [UIFont systemFontOfSize:14];
        [_accountName sizeToFit];
    }
    return _accountName;
}

-(UILabel *)desc
{
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.font = [UIFont systemFontOfSize:13];
        _desc.textColor = [UIColor colorWithHexString:@"434342"];
        [_desc sizeToFit];
    }
    return _desc;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.icon];
        [self addSubview:self.accountName];
        [self addSubview:self.breviary];
        [self addSubview:self.desc];
        [self addSubview:self.chooseBtn];
        [self addSubview:self.line];
    }
    return self;
}

- (void)getWithdrawaVo:(WithdrawalsAccountVo *)withdrawaVo account:(NSString *)account
{
    _withdrawaVo = withdrawaVo;
    _account = account;
    
    [self.icon setImageWithURL:withdrawaVo.icon XMWebImageScaleType:XMWebImageScale120x120];
    self.accountName.text = withdrawaVo.bankName;
    self.breviary.text = withdrawaVo.breviaryAccount;
    if (withdrawaVo.type == 0) {
        self.desc.text = [NSString stringWithFormat:@"%.2f提现额度",withdrawaVo.surplusAvailable];
    }else if (withdrawaVo.type == 1) {
        self.desc.text = withdrawaVo.withdrawalsEexplain;
    }
    if ([_withdrawaVo.account isEqualToString:self.account]) {
        self.chooseBtn.selected = YES;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.accountName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self.icon.mas_right).offset(15);
    }];
    
    [self.breviary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(5);
        make.left.equalTo(self.icon.mas_right).offset(15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(@1);
    }];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-14);
    }];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.chooseBtn.mas_left).offset(-10);
    }];
}

@end
