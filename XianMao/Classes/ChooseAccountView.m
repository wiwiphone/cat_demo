//
//  ChooseAccountView.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ChooseAccountView.h"
#import "AddAccountButton.h"
#import "BankAccountView.h"
#import "AddAlipayViewController.h"
#import "AddBandCardViewController.h"

@interface ChooseAccountView()

@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) AccountList * account;
@property (nonatomic, strong) UIView * line;


@end

@implementation ChooseAccountView


-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"选择提现账户";
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
        [_title sizeToFit];
    }
    return _title;
}

-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _closeBtn;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.closeBtn];
        [self addSubview:self.title];
        [self addSubview:self.line];
    }
    return self;
}


-(void)getAccountList:(AccountList *)account withdrawalsVo:(WithdrawalsAccountVo *)withdrawalsVo
{
    _account = account;
    
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[BankAccountView class]] ||
            [obj isKindOfClass:[AddAccountButton class]]) {
            [obj removeFromSuperview];
        }
    }
    
    NSArray * withdrawalsArr = account.withdrawalsAccountVo;
    NSArray * addAccountArr = account.addAccountIconVo;
    
    CGFloat marginTop = 40;
    for (int i = 0; i < withdrawalsArr.count; i++) {
        WithdrawalsAccountVo * withdrawaVo = [withdrawalsArr objectAtIndex:i];
        BankAccountView * bankAccount = [[BankAccountView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 68)];
        bankAccount.withdrawaVo = withdrawaVo;
        [bankAccount getWithdrawaVo:withdrawaVo account:withdrawalsVo.account];
        marginTop += 68;
        [bankAccount addTarget:self action:@selector(bankAccountClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bankAccount];
    }
    
    for (int i = 0; i < addAccountArr.count; i++) {
        
        AddAccountIconVo * addVo = [addAccountArr objectAtIndex:i];
        AddAccountButton * button = [[AddAccountButton alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 68)];
        button.addAccountVo = addVo;
        [button addTarget:self action:@selector(addAccountButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

}

-(void)bankAccountClick:(BankAccountView *)button
{
    if (button.withdrawaVo.type == 0 && button.withdrawaVo.surplusAvailable == 0) {
        [[CoordinatingController sharedInstance] showHUD:@"支付宝提现额度已用完" hideAfterDelay:0.8 forView:[UIApplication sharedApplication].keyWindow];
        return;
    }else{
        if (self.handleWithdrawaAccountBlock) {
            self.handleWithdrawaAccountBlock(button.withdrawaVo);
        }
    }
}

-(void)addAccountButtonClick:(AddAccountButton *)button{
    NSInteger type = button.addAccountVo.type;
    switch (type) {
        case 0:
        {
            AddAlipayViewController * alipay = [[AddAlipayViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:alipay animated:YES];
            [self dismiss];
            break;
        }
        case 1:
        {
            AddBandCardViewController * bank = [[AddBandCardViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:bank animated:YES];
            [self dismiss];
            break;
        }
            
        default:
            break;
    }
}

-(void)dismiss
{
    if (self.handleCloseBtnBlock) {
        self.handleCloseBtnBlock();
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(40);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
}

@end
