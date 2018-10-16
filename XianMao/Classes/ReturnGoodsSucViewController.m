//
//  ReturnGoodsSucViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsSucViewController.h"
#import "OrderDetailNewViewController.h"

@interface ReturnGoodsSucViewController ()

@property (nonatomic,strong) UIImageView * sucImageview;
@property (nonatomic,strong) UIButton * goBackBtn;
@property (nonatomic,strong) UILabel * sucLbl;
@property (nonatomic,strong) UILabel * alertLbl;


@end

@implementation ReturnGoodsSucViewController


-(UIImageView *)sucImageview
{
    if (!_sucImageview) {
        _sucImageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sucImageview.image = [UIImage imageNamed:@"group-565"];
        [_sucImageview sizeToFit];
    }
    return _sucImageview;
}

-(UILabel *)sucLbl
{
    if (!_sucLbl) {
        _sucLbl = [[UILabel alloc] init];
        _sucLbl.textColor = [UIColor colorWithHexString:@"545453"];
        _sucLbl.font = [UIFont systemFontOfSize:14];
        _sucLbl.text = @"提交成功";
    }
    return _sucLbl;
}

-(UILabel *)alertLbl
{
    if (!_alertLbl) {
        _alertLbl = [[UILabel alloc] init];
        _alertLbl.textColor = [UIColor colorWithHexString:@"545453"];
        _alertLbl.font = [UIFont systemFontOfSize:14];
        _alertLbl.numberOfLines = 0;
        _alertLbl.textAlignment = NSTextAlignmentCenter;
        _alertLbl.text = @"我们收到退货后,\n出具验收结果,请及时关注.";
    }
    return _alertLbl;
}


-(UIButton *)goBackBtn
{
    if (!_goBackBtn) {
        _goBackBtn = [[UIButton alloc] init];
        _goBackBtn.backgroundColor = [UIColor colorWithHexString:@"000000"];
        [_goBackBtn setTitle:@"返回订单详情页" forState:UIControlStateNormal];
        [_goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goBackBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_goBackBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBackBtn;
}

-(void)buttonClick
{
    NSArray * array = self.navigationController.childViewControllers;
    NSInteger num = array.count;
    [self.navigationController popToViewController:array[num-4] animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"提交成功"];
    
    [self.view addSubview:self.sucImageview];
    [self.view addSubview:self.sucLbl];
    [self.view addSubview:self.alertLbl];
    [self.view addSubview:self.goBackBtn];
    
    [self settingUI];
}

-(void)settingUI
{
    [self.sucImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(75+64);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.sucLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sucImageview.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 15));
    }];
    
    [self.alertLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(260);
        make.center.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(@200);
        make.height.mas_equalTo(@100);
    }];
    
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.alertLbl).offset(260);
        make.top.equalTo(self.view.mas_bottom).offset(-144);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(@190);
        make.height.mas_equalTo(@42);
    }];
}

@end
