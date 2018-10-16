//
//  WalletTwoViewController.m
//  XianMao
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WalletTwoViewController.h"
#import "WithdrawalHistoryViewController.h"
#import "Masonry.h"
#import "Error.h"
#import "NetworkAPI.h"
#import "Wallet.h"
#import "Session.h"
#import "WCAlertView.h"
#import "LoginViewController.h"
#import "RechargeViewController.h"
#import "WalletViewController.h"
#import "RechargeADViewController.h"

@interface WalletTwoViewController ()

@property (nonatomic, strong) UIImageView *walletIconView;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *contentLbl2;
@property (nonatomic, strong) UILabel *moneyLbl;
@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, strong) UIButton *topUpBtn;
@property (nonatomic, strong) UIButton *withdrawCashBtn;

@property (nonatomic, strong) Wallet *wallet;
@end

@implementation WalletTwoViewController

-(UIButton *)withdrawCashBtn{
    if (!_withdrawCashBtn) {
        _withdrawCashBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _withdrawCashBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [_withdrawCashBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawCashBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _withdrawCashBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _withdrawCashBtn.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        _withdrawCashBtn.layer.borderWidth = 0.5f;
    }
    return _withdrawCashBtn;
}

-(UIButton *)topUpBtn{
    if (!_topUpBtn) {
        _topUpBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _topUpBtn.backgroundColor = [UIColor blackColor];
        [_topUpBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_topUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topUpBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _topUpBtn;
}

-(UILabel *)contentLbl2{
    if (!_contentLbl2) {
        _contentLbl2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl2.text = @"充值后，用钱包付款免受支付限额";
        _contentLbl2.font = [UIFont systemFontOfSize:13.f];
        _contentLbl2.textColor = [UIColor colorWithHexString:@"6a6868"];
        [_contentLbl2 sizeToFit];
    }
    return _contentLbl2;
}

-(UILabel *)moneyLbl{
    if (!_moneyLbl) {
        _moneyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyLbl.font = [UIFont systemFontOfSize:24.f];
        _moneyLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_moneyLbl sizeToFit];
    }
    return _moneyLbl;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.text = @"我的钱包余额";
        _contentLbl.font = [UIFont systemFontOfSize:15.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"d1d1d1"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UIImageView *)walletIconView{
    if (!_walletIconView) {
        _walletIconView = [[UIImageView alloc] init];
        _walletIconView.image = [UIImage imageNamed:@"wallet_icon_MF"];
    }
    return _walletIconView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"我的钱包"];
    [super setupTopBarBackButton];
    
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"明细" forState:UIControlStateNormal];
    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//    [self.topBarRightButton setImage:[UIImage imageNamed:@"ThreePoint"] forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    [self.view addSubview:self.walletIconView];
    [self.view addSubview:self.contentLbl];
    [self.view addSubview:self.moneyLbl];
//    [self.view addSubview:self.contentLbl2];
    [self.view addSubview:self.withdrawCashBtn];
//    [self.view addSubview:self.topUpBtn];
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
        [weakSelf hideLoadingView];
        self.wallet = wallet;
        self.moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",wallet.moneyInfo.availableMoney];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        
        [weakSelf loadEndWithError];
    }];
    
    [self.withdrawCashBtn addTarget:self action:@selector(withdrawCash) forControlEvents:UIControlEventTouchUpInside];
    [self.topUpBtn addTarget:self action:@selector(topUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpUI];
}

-(void)setUpUI{
    [self.walletIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(38);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletIconView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLbl.mas_bottom).offset(13);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
//    [self.contentLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.moneyLbl.mas_bottom).offset(22);
//        make.centerX.equalTo(self.view.mas_centerX);
//    }];
//    
//    [self.topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLbl2.mas_bottom).offset(17);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        make.height.equalTo(@40);
//    }];
    
    [self.withdrawCashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLbl.mas_bottom).offset(17);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
}

-(void)topUp{
    if (![Session sharedInstance].isBindingPhoneNumber) {
        [WCAlertView showAlertWithTitle:@"温馨提示" message:@"为了保证资金安全，请您绑定手机号，并设置密码" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex==0) {
                
            } else {
                //                        CheckPhoneViewController *presenedViewController = [[CheckPhoneViewController alloc] init];
                //                        presenedViewController.title = @"绑定手机号";
                //                        presenedViewController.isForBindPhoneNumber = YES;
                GetCaptchaCodeViewController *presenedViewController = [[GetCaptchaCodeViewController alloc] init];
                presenedViewController.title = @"绑定手机号";
                presenedViewController.isRetry = YES;
                presenedViewController.captchaType = 4;
                UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
                UIViewController *visibleController = [CoordinatingController sharedInstance].visibleController;
                [visibleController presentViewController:navController animated:YES completion:nil];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    } else {
        //add code
//        RechargeViewController *viewController = [[RechargeViewController alloc] init];
//        [self pushViewController:viewController animated:YES];
        
        RechargeADViewController *viewController = [[RechargeADViewController alloc] init];
        [self pushViewController:viewController animated:YES];
    }
}

-(void)withdrawCash{
    [MobClick event:@"click_withdrawals"];
    
    if (![Session sharedInstance].isBindingPhoneNumber) {
        [WCAlertView showAlertWithTitle:@"温馨提示" message:@"为了保证资金安全，请您绑定手机号，并设置密码" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex==0) {
                
            } else {
                //                        CheckPhoneViewController *presenedViewController = [[CheckPhoneViewController alloc] init];
                //                        presenedViewController.title = @"绑定手机号";
                //                        presenedViewController.isForBindPhoneNumber = YES;
                GetCaptchaCodeViewController *presenedViewController = [[GetCaptchaCodeViewController alloc] init];
                presenedViewController.title = @"绑定手机号";
                presenedViewController.isRetry = YES;
                presenedViewController.captchaType = 4;
                presenedViewController.index = 4;
                UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
                UIViewController *visibleController = [CoordinatingController sharedInstance].visibleController;
                [visibleController presentViewController:navController animated:YES completion:nil];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    } else {
        WithdrawApplyViewController *viewController = [[WithdrawApplyViewController alloc] init];
        viewController.wallet = self.wallet;
        [self pushViewController:viewController animated:YES];
    }
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    WithdrawalHistoryViewController *viewController = [[WithdrawalHistoryViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
