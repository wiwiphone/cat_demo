//
//  WithdrawSucViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WithdrawSucViewController.h"

@interface WithdrawSucViewController ()

@property (nonatomic,strong) UIView * container;
@property (nonatomic,strong) UIView * container2;
@property (nonatomic,strong) UIView * container3;
@property (nonatomic,strong) UIImageView * iconImg;
@property (nonatomic,strong) UILabel * sucLal;
@property (nonatomic,strong) UILabel * bank;
@property (nonatomic,strong) UILabel * bankCardNum;
@property (nonatomic,strong) UILabel * total;
@property (nonatomic,strong) UILabel * money;
@property (nonatomic,strong) UIButton * finishBtn;

@end

@implementation WithdrawSucViewController


-(UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        _finishBtn.backgroundColor = [UIColor blackColor];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}


-(UILabel *)bankCardNum
{
    if (!_bankCardNum) {
        _bankCardNum = [[UILabel alloc] init];
        _bankCardNum.textColor = [UIColor colorWithHexString:@"434342"];
        _bankCardNum.font = [UIFont systemFontOfSize:14];
        [_bankCardNum sizeToFit];
    }
    return _bankCardNum;
}

-(UILabel *)money
{
    if (!_money) {
        _money = [[UILabel alloc] init];
        _money.textColor = [UIColor colorWithHexString:@"434342"];
        _money.font = [UIFont systemFontOfSize:14];
        [_money sizeToFit];
    }
    return _money;
}

-(UILabel *)total
{
    if (!_total) {
        _total = [[UILabel alloc] init];
        _total.textColor = [UIColor colorWithHexString:@"434342"];
        _total.font = [UIFont systemFontOfSize:14];
        _total.text = @"提现金额";
        [_total sizeToFit];
    }
    return _total;
}

-(UILabel *)bank
{
    if (!_bank) {
        _bank = [[UILabel alloc] init];
        _bank.textColor = [UIColor colorWithHexString:@"434342"];
        _bank.font = [UIFont systemFontOfSize:14];
        [_bank sizeToFit];
    }
    return _bank;
}

-(UILabel *)sucLal
{
    if (!_sucLal) {
        _sucLal = [[UILabel alloc] init];
        _sucLal.textColor = [UIColor colorWithHexString:@"434342"];
        _sucLal.font = [UIFont systemFontOfSize:14];
        _sucLal.text = @"提现申请已提交\n预计1-3个工作日到账";
        _sucLal.numberOfLines = 0;
        _sucLal.textAlignment = NSTextAlignmentCenter;
        [_sucLal sizeToFit];
    }
    return _sucLal;
}

-(UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage imageNamed:@"sub_suc"];
    }
    return _iconImg;
}

-(UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

-(UIView *)container2
{
    if (!_container2) {
        _container2 = [[UIView alloc] init];
        _container2.backgroundColor = [UIColor whiteColor];
    }
    return _container2;
}

-(UIView *)container3
{
    if (!_container3) {
        _container3 = [[UIView alloc] init];
        _container3.backgroundColor = [UIColor whiteColor];
    }
    return _container3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
//    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"余额提现"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    [self.view addSubview:self.container];
    [self.view addSubview:self.container2];
    [self.view addSubview:self.container3];
    
    [self.container addSubview:self.iconImg];
    [self.container addSubview:self.sucLal];
    [self.container2 addSubview:self.bank];
    [self.container3 addSubview:self.total];
    [self.container2 addSubview:self.bankCardNum];
    [self.container3 addSubview:self.money];
    
    [self.view addSubview:self.finishBtn];
    if (self.withdrawalsVo) {
        _bank.text = self.withdrawalsVo.bankName;
        _bankCardNum.text = self.withdrawalsVo.breviaryAccount;
    }
    if (self.WithdrawMoeny) {
        
        self.money.text = [NSString stringWithFormat:@"¥ %@",self.WithdrawMoeny];
    }
    
    [self setupUI];
}

-(void)buttonClick:(UIButton *)button
{
    NSArray * array = self.navigationController.childViewControllers;
    NSInteger num = array.count;
    [self.navigationController popToViewController:array[num-3] animated:YES];
}

-(void)setupUI
{
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(2);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(180);
    }];
    
    [self.container2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_bottom).offset(12);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(45);
    }];
    
    [self.container3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_bottom).offset(2);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(45);
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container.mas_centerX);
        make.top.equalTo(self.container.mas_top).offset(30);
    }];
    
    
    [self.sucLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.mas_bottom).offset(20);
        make.centerX.equalTo(self.container.mas_centerX);
    }];
    
    [self.bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.container2.mas_centerY);
        make.left.equalTo(self.container2.mas_left).offset(14);
    }];
    
    [self.total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.container3.mas_centerY);
        make.left.equalTo(self.container3.mas_left).offset(14);
    }];
    
    
    [self.bankCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.container2.mas_centerY);
        make.right.equalTo(self.container2.mas_right).offset(-14);
    }];
    
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.container3.mas_centerY);
        make.right.equalTo(self.container3.mas_right).offset(-14);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container3.mas_bottom).offset(50);
        make.left.equalTo (self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(40);
    }];

}



@end
