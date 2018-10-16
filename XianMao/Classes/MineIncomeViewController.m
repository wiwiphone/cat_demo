//
//  MineIncomeViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/7/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MineIncomeViewController.h"
#import "WCAlertView.h"
#import "NetworkAPI.h"
#import "Wallet.h"
#import "Error.h"
#import "CCPActionSheetView.h"
#import "BankCardManagerCtrl.h"
#import "IncomeDetailViewController.h"
#import "AddBandCardViewController.h"
#import "WithdrawViewController.h"
#import "BankCard.h"
#import "Session.h"
#import "AddAlipayViewController.h"
#import "AccountList.h"
#import "LoginViewController.h"


@interface MineIncomeViewController ()

@property (nonatomic,strong) UIButton * topBarRightBtn;
@property (nonatomic,strong) UIButton * depositsBtn; //体现
@property (nonatomic,strong) UILabel * incomeLbl;
@property (nonatomic,strong) UILabel * moneyLbl;
@property (nonatomic,strong) UIImageView * RMBIcon;
@property (nonatomic,strong) HTTPRequest * request;
@property (nonatomic,strong) Wallet * wallet;
@property (nonatomic,assign) BOOL isAcountExist;
@property (nonatomic,strong) AccountList * account;

@end

@implementation MineIncomeViewController

-(UIButton *)topBarRightBtn
{
    if (!_topBarRightBtn) {
        _topBarRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 30, 30, 30)];
        [_topBarRightBtn setImage:[[UIImage imageNamed:@"more_wjh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
        _topBarRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _topBarRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_topBarRightBtn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [self.topBarRightBtn addTarget:self action:@selector(topBarRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBarRightBtn;
}

-(void)topBarRightBtnClick
{
    
    NSArray *dataArray = [NSArray arrayWithObjects:@"钱包明细", @"提现账号管理",@"取消",nil];
    
    CCPActionSheetView *actionSheetView = [[CCPActionSheetView alloc]initWithActionSheetArray:dataArray];
    
    [actionSheetView cellDidSelectBlock:^(NSString *indexString, NSInteger index) {
        
        if (index == 0) {
            
            IncomeDetailViewController * income = [[IncomeDetailViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:income animated:YES];
        }else if (index == 1){
            BankCardManagerCtrl * bank = [[BankCardManagerCtrl alloc] init];
            bank.account = self.account;
            [[CoordinatingController sharedInstance] pushViewController:bank animated:YES];
        }
        
        
    }];
}


-(UIButton *)depositsBtn
{
    if (!_depositsBtn) {
        _depositsBtn = [[UIButton alloc] init];
        [_depositsBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_depositsBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        [_depositsBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
        _depositsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _depositsBtn.layer.borderWidth = 1;
        _depositsBtn.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
        [_depositsBtn addTarget:self action:@selector(depositsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _depositsBtn;
}

-(UIImageView *)RMBIcon
{
    if (!_RMBIcon) {
        _RMBIcon = [[UIImageView alloc] init];
        _RMBIcon.image = [UIImage imageNamed:@"money_income"];
    }
    return _RMBIcon;
}

-(UILabel *)incomeLbl
{
    if (!_incomeLbl) {
        _incomeLbl = [[UILabel alloc] init];
        _incomeLbl.font = [UIFont systemFontOfSize:14];
        _incomeLbl.textAlignment = NSTextAlignmentCenter;
        _incomeLbl.text = @"可提现金额(元)";
        _incomeLbl.textColor = [UIColor colorWithHexString:@"c0c0c0"];
    }
    return _incomeLbl;
}

-(UILabel *)moneyLbl
{
    if (!_moneyLbl) {
        _moneyLbl = [[UILabel alloc] init];
        _moneyLbl.font = [UIFont systemFontOfSize:20];
        _moneyLbl.textAlignment = NSTextAlignmentCenter;
        _moneyLbl.textColor = [UIColor redColor];
    }
    return _moneyLbl;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self netWorkRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"钱包"];
    [super setupTopBarBackButton];
    
    [self.topBar addSubview:self.topBarRightBtn];
    
    [self.view addSubview:self.RMBIcon];
    [self.view addSubview:self.incomeLbl];
    [self.view addSubview:self.moneyLbl];
    [self.view addSubview:self.depositsBtn];
    
    [self setupUI];
}


-(void)netWorkRequest
{
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
        [weakSelf hideLoadingView];
        self.wallet = wallet;
        self.moneyLbl.text = [NSString stringWithFormat:@"%.2f",wallet.moneyInfo.availableMoney];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        [weakSelf loadEndWithError];
    }];
    
    NSDictionary * parm = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"bank" path:@"account_list" parameters:parm completionBlock:^(NSDictionary *data) {
        
        NSDictionary * dict = data[@"account_list"];
        AccountList * account = [AccountList creatWithDict:dict];
        self.account = account;
        
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
}


-(void)setupUI
{
    [self.RMBIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+40);
    }];
    
    [self.incomeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RMBIcon.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 20));
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.incomeLbl.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 20));
    }];
    
    [self.depositsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLbl.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(45);
    }];
    
}


//余额提现
-(void)depositsBtnClick:(UIButton *)button
{
 
    if (![Session sharedInstance].isBindingPhoneNumber) {
        [WCAlertView showAlertWithTitle:@"温馨提示" message:@"为了保证交易安全，请您绑定手机号，并设置密码" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex==0) {
                
            } else {
                
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
        
    }else{
        
        if ([self.account.withdrawalsAccountVo count] > 0 &&
            self.account.withdrawalsAccountVo) {
            
            
            for (WithdrawalsAccountVo * withdrawalsVo in self.account.withdrawalsAccountVo) {
                if (withdrawalsVo.type == 1 && withdrawalsVo.region.length == 0) {
                    [WCAlertView showAlertWithTitle:nil message:@"您的银行开户行信息不完整" customizationBlock:^(WCAlertView *alertView) {
                        
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        
                        if (buttonIndex == 0) {
                            
                        }else{
                            AddBandCardViewController * addBank = [[AddBandCardViewController alloc] init];
                            addBank.withdrawalsVo = withdrawalsVo;
                            [self pushViewController:addBank animated:YES];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:@"立即补充", nil];
                    return;
                }
            }
            
            WithdrawViewController * withdraw = [[WithdrawViewController alloc] init];
            withdraw.account = self.account;
            [self pushViewController:withdraw animated:YES];
            
            
        }else{
            
            [WCAlertView showAlertWithTitle:nil message:@"提现需要添加一个提现账号" customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
                if (buttonIndex == 0) {
                    
                }else{
                    AddBandCardViewController * bankCard = [[AddBandCardViewController alloc] init];
                    bankCard.isFirst = YES;
                    [self.navigationController pushViewController:bankCard animated:YES];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"添加银行卡", nil ];
        }
    }
}
@end
