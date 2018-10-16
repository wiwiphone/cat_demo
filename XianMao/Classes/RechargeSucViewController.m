//
//  RechargeSucViewController.m
//  XianMao
//
//  Created by WJH on 16/10/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RechargeSucViewController.h"
#import "ItemizedAccountViewController.h"
#import "Command.h"

@interface RechargeSucViewController ()

@property (nonatomic, strong) UIImageView * sucIcon;
@property (nonatomic, strong) CommandButton * repeatBtn;
@property (nonatomic, strong) CommandButton * detailBtn;
@property (nonatomic, strong) UILabel * sucLbl;

@end

@implementation RechargeSucViewController

-(UILabel *)sucLbl
{
    if (!_sucLbl) {
        _sucLbl = [[UILabel alloc] init];
        _sucLbl.text = @"充值成功";
        _sucLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _sucLbl.font = [UIFont systemFontOfSize:15];
        [_sucLbl sizeToFit];
    }
    return _sucLbl;
}

-(CommandButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [[CommandButton alloc] init];
        [_repeatBtn setTitle:@"继续充值" forState:UIControlStateNormal];
        _repeatBtn.layer.borderWidth = 1;
        _repeatBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        [_repeatBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _repeatBtn.backgroundColor = [UIColor whiteColor];
        _repeatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _repeatBtn;
}

-(CommandButton *)detailBtn
{
    if (!_detailBtn) {
        _detailBtn = [[CommandButton alloc] init];
        [_detailBtn setTitle:@"查看明细" forState:UIControlStateNormal];
        _detailBtn.layer.borderWidth = 1;
        _detailBtn.backgroundColor = [UIColor whiteColor];
        _detailBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        [_detailBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _detailBtn;
}

-(UIImageView *)sucIcon
{
    if (!_sucIcon) {
        _sucIcon = [[UIImageView alloc] init];
        _sucIcon.image = [UIImage imageNamed:@"repeat"];
    }
    return _sucIcon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [super setupTopBar];
    [super setupTopBarTitle:@"充值成功"];
    [super setupTopBarBackButton];
    
    [self.view addSubview:self.sucIcon];
    [self.view addSubview:self.repeatBtn];
    [self.view addSubview:self.detailBtn];
    [self.view addSubview:self.sucLbl];
    
    WEAKSELF;
    self.repeatBtn.handleClickBlock = ^(CommandButton * sender){
        [weakSelf dismiss:YES];
    };
    
    self.detailBtn.handleClickBlock = ^(CommandButton * sender){
        ItemizedAccountViewController * account = [[ItemizedAccountViewController alloc] init];
        [account getAccountCard:weakSelf.accountCard];
        [weakSelf pushViewController:account animated:YES];
    };
    
    [self customUI];
}

-(void)setAccountCard:(AccountCard *)accountCard{
    _accountCard = accountCard;
}

- (void)customUI {
    
    [self.sucIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(65+117);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/375*50);
        make.top.equalTo(self.sucIcon.mas_bottom).offset(90);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*119, 33));
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sucIcon.mas_bottom).offset(90);
        make.right.equalTo(self.view.mas_right).offset(-(kScreenWidth/375*50));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*119, 33));
    }];
    
    [self.sucLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sucIcon.mas_bottom).offset(35);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
