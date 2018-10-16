//
//  CardView.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CardView.h"
#import "ItemizedAccountViewController.h"

@interface CardView()

@property (nonatomic, strong) UILabel * cardType;
@property (nonatomic, strong) UILabel * balance;
@property (nonatomic, strong) UILabel * RMBIcon;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIButton * detailBtn;

@end

@implementation CardView

-(UIButton *)detailBtn
{
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc] init];
        _detailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _detailBtn.layer.borderWidth = 1;
        [_detailBtn setTitle:@"明细" forState:UIControlStateNormal];
        _detailBtn.layer.masksToBounds = YES;
        _detailBtn.layer.cornerRadius = 2;
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailBtn;
}

-(UILabel *)amount
{
    if (!_amount) {
        _amount = [[UILabel alloc] init];
        _amount.font = [UIFont boldSystemFontOfSize:44];
        _amount.textColor = [UIColor whiteColor];
        [_amount sizeToFit];
    }
    return _amount;
}

-(UILabel *)RMBIcon
{
    if (!_RMBIcon) {
        _RMBIcon = [[UILabel alloc] init];
        _RMBIcon.text = @"¥";
        _RMBIcon.font = [UIFont systemFontOfSize:23];
        _RMBIcon.textColor = [UIColor whiteColor];
        [_RMBIcon sizeToFit];
    }
    return _RMBIcon;
}

-(UILabel *)cardType
{
    if (!_cardType) {
        _cardType = [[UILabel alloc] init];
        _cardType.textColor = [UIColor whiteColor];
        _cardType.font = [UIFont systemFontOfSize:15];
        [_cardType size];
    }
    return _cardType;
}

-(UILabel *)balance
{
    if (!_balance) {
        _balance = [[UILabel alloc] init];
        _balance.text = @"余额:";
        _balance.font = [UIFont systemFontOfSize:14];
        _balance.textColor = [UIColor whiteColor];
        [_balance sizeToFit];
    }
    return _balance;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"333333"];
        
        [self addSubview:self.cardType];
        [self addSubview:self.balance];
        [self addSubview:self.RMBIcon];
        [self addSubview:self.amount];
        [self addSubview:self.detailBtn];
        
        [self.detailBtn addTarget:self action:@selector(clickDetailBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickDetailBtn{
    ItemizedAccountViewController *viewController = [[ItemizedAccountViewController alloc] init];
    [viewController getAccountCard:self.accountCard];
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

-(void)setAccountCard:(AccountCard *)accountCard
{
    _accountCard = accountCard;
    self.cardType.text = [NSString stringWithFormat:@"%@",accountCard.cardName];
    self.amount.text = [NSString stringWithFormat:@"%.2f",accountCard.cardMoney];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cardType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.left.equalTo(self.mas_left).offset(14);
    }];
    
    [self.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.equalTo(self.mas_left).offset(14);
    }];
    
    [self.RMBIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-18);
        make.left.equalTo(self.balance.mas_right);
    }];
    
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.RMBIcon.mas_right).offset(5);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.balance.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(46, 20));
    }];
}
@end
