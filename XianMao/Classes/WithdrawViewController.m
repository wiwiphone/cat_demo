//
//  WithdrawViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WithdrawViewController.h"
#import "XMWebImageView.h"
#import "PasswordView.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "Wallet.h"
#import "NSString+AES.h"
#import "WCAlertView.h"
#import "ForgetSecretViewController.h"
#import "WithdrawSucViewController.h"
#import "NSString+AES.h"
#import "NSData+AES.h"
#import "Session.h"
#import "BlackView.h"
#import "ChooseAccountView.h"
#import "WithdrawalsAccountVo.h"
#import "NetworkAPI.h"

@interface WithdrawViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton * container1;
@property (nonatomic,strong) UIView * container2;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UIButton * finishBtn;
@property (nonatomic,strong) XMWebImageView * iconImg;
@property (nonatomic,strong) UILabel * bank;
@property (nonatomic,strong) UILabel * bankCard;
@property (nonatomic,strong) UILabel * WithdrawMoney;
@property (nonatomic,strong) UILabel * RMBIcon;
@property (nonatomic,strong) UITextField * moneyTf;
@property (nonatomic,strong) UILabel * totalMoney;
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UIButton * totalBtn;
@property (nonatomic,strong) HTTPRequest * request;
@property (nonatomic,strong) HTTPRequest * withdrawRequest;
@property (nonatomic,strong) Wallet * wallet;
@property (nonatomic,strong) UILabel * warnLbl;
@property (nonatomic,copy) NSString * amount;//金额
@property (nonatomic, strong) BlackView * blackVIew;
@property (nonatomic, strong) ChooseAccountView * chooseAccountView;
@property (nonatomic, strong) WithdrawalsAccountVo * withdrawaVo;
@property (nonatomic, strong) UILabel * surplusLabel;
@property (nonatomic, strong) UIImageView * arrowImg;

@end

@implementation WithdrawViewController


-(UIImageView *)arrowImg
{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"arrow_new"];
    }
    return _arrowImg;
}

-(UILabel *)surplusLabel
{
    if (!_surplusLabel) {
        _surplusLabel = [[UILabel alloc] init];
        _surplusLabel.textColor = [UIColor colorWithHexString:@"f4433e"];
        _surplusLabel.font = [UIFont systemFontOfSize:12];
        [_surplusLabel sizeToFit];
        _surplusLabel.hidden = YES;
    }
    return _surplusLabel;
}

-(ChooseAccountView *)chooseAccountView
{
    if (!_chooseAccountView) {
        _chooseAccountView = [[ChooseAccountView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 328)];
        _chooseAccountView.backgroundColor = [UIColor whiteColor];
    }
    return _chooseAccountView;
}

-(BlackView *)blackVIew
{
    if (!_blackVIew) {
        _blackVIew = [[BlackView alloc] initWithFrame:self.view.bounds];
        _blackVIew.alpha = 0.5;
        _blackVIew.alpha = 0;
        _blackVIew.hidden = YES;
    }
    return _blackVIew;
}

-(UILabel *)warnLbl
{
    if (!_warnLbl) {
        _warnLbl = [[UILabel alloc] init];
        _warnLbl.text = @"输入金额超过可提现总金额";
        _warnLbl.hidden = YES;
        _warnLbl.textColor = [UIColor redColor];
        _warnLbl.font = [UIFont systemFontOfSize:12];
        [_warnLbl sizeToFit];
    }
    return _warnLbl;
}

-(UIButton *)totalBtn
{
    if (!_totalBtn) {
        _totalBtn = [[UIButton alloc] init];
        [_totalBtn setTitle:@"全部提现" forState:UIControlStateNormal];
        _totalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_totalBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        [_totalBtn addTarget:self action:@selector(totalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_totalBtn sizeToFit];
    }
    return _totalBtn;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

-(UILabel *)totalMoney
{
    if (!_totalMoney) {
        _totalMoney = [[UILabel alloc] init];
        _totalMoney.font = [UIFont systemFontOfSize:12];
        _totalMoney.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        [_totalMoney sizeToFit];
    }
    return _totalMoney;
}

-(UITextField *)moneyTf
{
    if (!_moneyTf) {
        _moneyTf = [[UITextField alloc] init];
        _moneyTf.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyTf.textColor = [UIColor colorWithHexString:@"434342"];
        _moneyTf.font = [UIFont boldSystemFontOfSize:29];
        _moneyTf.delegate = self;
        [_moneyTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _moneyTf;
}

-(UILabel *)RMBIcon
{
    if (!_RMBIcon) {
        _RMBIcon = [[UILabel alloc] init];
        _RMBIcon.textColor = [UIColor colorWithHexString:@"434342"];
        _RMBIcon.font = [UIFont systemFontOfSize:20];
        _RMBIcon.text = @"¥";
        [_RMBIcon sizeToFit];
    }
    return _RMBIcon;
}


-(UILabel *)WithdrawMoney
{
    if (!_WithdrawMoney) {
        _WithdrawMoney = [[UILabel alloc] init];
        _WithdrawMoney.textColor = [UIColor colorWithHexString:@"434342"];
        _WithdrawMoney.font = [UIFont systemFontOfSize:14];
        _WithdrawMoney.text = @"提现金额";
        [_WithdrawMoney sizeToFit];
    }
    return _WithdrawMoney;
}


-(UILabel *)bankCard
{
    if (!_bankCard) {
        _bankCard = [[UILabel alloc] init];
        _bankCard.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _bankCard.font = [UIFont systemFontOfSize:14];
 
    }
    return _bankCard;
}

-(UILabel *)bank
{
    if (!_bank) {
        _bank = [[UILabel alloc] init];
        _bank.textColor = [UIColor colorWithHexString:@"434342"];
        _bank.font = [UIFont systemFontOfSize:14];
    }
    return _bank;
}

-(XMWebImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[XMWebImageView alloc] init];
        _iconImg.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
    }
    return _iconImg;
}

-(UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        [_finishBtn setTitle:@"提现" forState:UIControlStateNormal];
        _finishBtn.enabled = NO;
        [_finishBtn setBackgroundColor:[UIColor colorWithHexString:@"bbbbbb"]];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}


-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.text = @"1-3个工作日内到账";
        _time.textColor =[UIColor colorWithHexString:@"bbbbbb"];
        _time.font = [UIFont systemFontOfSize:12];
        _time.textAlignment = NSTextAlignmentCenter;
        [_time sizeToFit];
    }
    return _time;
}
-(UIButton *)container1
{
    if (!_container1) {
        _container1 = [[UIButton alloc] init];
        _container1.backgroundColor = [UIColor whiteColor];
    }
    return _container1;
}

-(UIView *)container2
{
    if (!_container2) {
        _container2 = [[UIView alloc] init];
        _container2.backgroundColor = [UIColor whiteColor];
    }
    return _container2;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber * type = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountType"];
    if (type) {
        for (WithdrawalsAccountVo * withdrawaVo in self.account.withdrawalsAccountVo) {
            if ([type integerValue] == withdrawaVo.type) {
                WithdrawalsAccountVo * withdrawaVo2 = withdrawaVo;
                [self updateDatasources:withdrawaVo2];
                break;
            }
        }
        
    }else{
        
        NSDictionary * parm = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
        [self showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"bank" path:@"account_list" parameters:parm completionBlock:^(NSDictionary *data) {
            [self hideLoadingView];
            NSDictionary * dict = data[@"account_list"];
            AccountList * account = [AccountList creatWithDict:dict];
            self.account = account;
            WithdrawalsAccountVo * withdrawaVo = self.account.withdrawalsAccountVo[0];
            [self updateDatasources:withdrawaVo];
        } failure:^(XMError *error) {
            [self showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"余额提现"];
    [super setupTopBarBackButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self netWorkRequest];
    [self.view addSubview:self.container1];
    [self.view addSubview:self.container2];
    [self.view addSubview:self.time];
    [self.container1 addSubview:self.iconImg];
    [self.container1 addSubview:self.bank];
    [self.container1 addSubview:self.bankCard];
    [self.container1 addSubview:self.arrowImg];
    [self.container1 addSubview:self.surplusLabel];
    [self.container2 addSubview:self.WithdrawMoney];
    [self.container2 addSubview:self.RMBIcon];
    [self.container2 addSubview:self.moneyTf];
    [self.container2 addSubview:self.line];
    [self.container2 addSubview:self.totalBtn];
    [self.container2 addSubview:self.totalMoney];
    [self.container2 addSubview:self.warnLbl];
    [self.view addSubview:self.finishBtn];
    [self setupUI];
    
    if (self.account.withdrawalsAccountVo.count == 1) {
        WithdrawalsAccountVo * withdrawaVo = self.account.withdrawalsAccountVo[0];
        if (withdrawaVo.type == 1) {
            self.container1.userInteractionEnabled = NO;
            self.arrowImg.hidden = YES;
        } else {
            self.container1.userInteractionEnabled = YES;
            self.arrowImg.hidden = NO;
        }
    }

    [self.container1 addTarget:self action:@selector(container1Click:) forControlEvents:UIControlEventTouchUpInside];
    
   
    

}

- (void)container1Click:(UIButton *)sender{
 
    [self.view addSubview:self.blackVIew];
    [self.view addSubview:self.chooseAccountView];
    
    [self.chooseAccountView getAccountList:self.account withdrawalsVo:self.withdrawaVo];
    
    [UIView animateWithDuration:0.25 animations:^{
        _blackVIew.hidden = NO;
        _blackVIew.alpha = 0.5;
        self.chooseAccountView.frame = CGRectMake(0, kScreenHeight-328, kScreenWidth, 328);
    }];
    
    WEAKSELF;
    _blackVIew.dissMissBlackView  = ^(){
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.chooseAccountView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 328);
            weakSelf.blackVIew.hidden = YES;
            weakSelf.blackVIew.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.chooseAccountView removeFromSuperview];
            [weakSelf.blackVIew removeFromSuperview];
        }];
    };
    
    self.chooseAccountView.handleCloseBtnBlock= ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.chooseAccountView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 328);
            weakSelf.blackVIew.hidden = YES;
            weakSelf.blackVIew.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.chooseAccountView removeFromSuperview];
            [weakSelf.blackVIew removeFromSuperview];
        }];
    };
    
    self.chooseAccountView.handleWithdrawaAccountBlock = ^(WithdrawalsAccountVo * withdrawaVo){
        [weakSelf updateDatasources:withdrawaVo];
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.chooseAccountView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 328);
            weakSelf.blackVIew.hidden = YES;
            weakSelf.blackVIew.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.chooseAccountView removeFromSuperview];
            [weakSelf.blackVIew removeFromSuperview];
        }];
    };
    
}


- (void) textFieldDidChange:(id) sender {
    
    UITextField *_field = (UITextField *)sender;
    NSUInteger length = [[_field text] length];
    if (length > 0 ) {
        _finishBtn.backgroundColor = [UIColor blackColor];
        _finishBtn.enabled = YES;
        if ([[_field text] doubleValue] > self.wallet.moneyInfo.availableMoney) {
            self.totalBtn.hidden = YES;
            self.totalMoney.hidden = YES;
            self.warnLbl.hidden = NO;
            _finishBtn.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
            _finishBtn.enabled = NO;
        }else{
            self.totalBtn.hidden = NO;
            self.totalMoney.hidden = NO;
            self.warnLbl.hidden = YES;
            _finishBtn.backgroundColor = [UIColor blackColor];
            _finishBtn.enabled = YES;
        }
    }else{
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
        _finishBtn.enabled = NO;
    }
    self.amount = [_field text];
}


-(void)totalBtnClick
{
    self.moneyTf.text = [NSString stringWithFormat:@"%.2f",self.wallet.moneyInfo.availableMoney];
    self.amount = [NSString stringWithFormat:@"%.2f",self.wallet.moneyInfo.availableMoney];
    _finishBtn.backgroundColor = [UIColor blackColor];
    _finishBtn.enabled = YES;
}

-(void)netWorkRequest
{
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
        [weakSelf hideLoadingView];
        self.wallet = wallet;
        self.totalMoney.text = [NSString stringWithFormat:@"可提现¥%.2f",wallet.moneyInfo.availableMoney];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        [weakSelf loadEndWithError];
    }];
    
}


-(void)updateDatasources:(WithdrawalsAccountVo *)withdrawaVo
{
    if (withdrawaVo) {
        self.withdrawaVo = withdrawaVo;
        [self.iconImg setImageWithURL:withdrawaVo.icon XMWebImageScaleType:XMWebImageScale120x120];
        _bankCard.text = [NSString stringWithFormat:@"%@",withdrawaVo.breviaryAccount];
        _bank.text = withdrawaVo.bankName;
        
        
        if (withdrawaVo.type == 0) {
            self.surplusLabel.hidden = NO;
            self.surplusLabel.text = [NSString stringWithFormat:@"剩余%.2f额度",withdrawaVo.surplusAvailable];
        }else{
            self.surplusLabel.hidden = YES;
        }
        
    }
}


#define KEY_VALUE @"AbcdEfgHijkLmnOp"
-(void)buttonClick:(UIButton *)button
{
    
    BOOL isVluad = YES;
//    if (self.withdrawaVo.type == 0) {
//        if (isVluad) {
//            if (self.amount.integerValue > self.withdrawaVo.surplusAvailable) {
//                isVluad = NO;
//                [self showHUD:@"支付宝提现额度不够，请提现到银行卡吧。" hideAfterDelay:0.8];
//            }
//        }
//    }
    
    if (isVluad) {
        WEAKSELF;
        PasswordView * Password = [[PasswordView alloc]init];
        Password.textFileDidEndedit = ^(NSString * password){
            
            if ([password length] > 0) {
                _request = [[NetworkAPI sharedInstance] WithdrawPasswrd:password completion:^(NSDictionary *data) {
                    NSInteger user_id = [Session sharedInstance].currentUser.userId;
                    NSString *encryCard = [self.withdrawaVo.account AES128EncryptWithKey:KEY_VALUE];
                    NSDictionary * parm = [[NSDictionary alloc] init];
                    parm = @{@"user_id":[NSNumber numberWithInteger:user_id],
                             @"type":self.withdrawaVo.type==0?[NSNumber numberWithInteger:0]:[NSNumber numberWithInteger:1],
                             @"account":encryCard,
                             @"amount":self.amount,
                             @"account_name":self.withdrawaVo.belong};
                    _withdrawRequest = [[NetworkAPI sharedInstance] withdrawDeposit:parm completion:^{
                        [Password dismiss];
                        NSNumber * accountType = [NSNumber numberWithInteger:self.withdrawaVo.type];
                        [[NSUserDefaults standardUserDefaults] setObject:accountType forKey:@"accountType"];
                        WithdrawSucViewController * sucView = [[WithdrawSucViewController alloc] init];
                        sucView.WithdrawMoeny = weakSelf.amount;
                        sucView.withdrawalsVo = self.withdrawaVo;
                        [weakSelf pushViewController:sucView animated:YES];
                    } failure:^(XMError *error) {
                        [Password dismiss];
                        [self showHUD:[error errorMsg] hideAfterDelay:0.8 forView:[UIApplication sharedApplication].keyWindow];
                    }];
                    
                } failure:^(XMError *error) {
                    [Password dismiss];
                    [WCAlertView showAlertWithTitle:nil message:[error errorMsg] customizationBlock:^(WCAlertView *alertView) {
                        
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        if (buttonIndex == 0) {
                            
                        }else{
                            ForgetSecretViewController * forget = [[ForgetSecretViewController alloc] init];
                            forget.topBarTitle = @"忘记密码";
                            [weakSelf pushViewController:forget animated:YES];
                        }
                    } cancelButtonTitle:@"重试" otherButtonTitles:@"忘记密码", nil];
                }];
            }else{
                
                [self showHUD:@"请输入密码" hideAfterDelay:0.8 forView:[UIApplication sharedApplication].keyWindow];
            }
            
        };
        Password.title = @"输入登录密码已提现";
        [Password show];
    }
}

- (void)setupUI {
    [self.container1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15+64);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(70);
    }];
    
    [self.container2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container1.mas_bottom).offset(15);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(125);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container1.mas_left).offset(18);
        make.centerY.equalTo(self.container1.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.mas_top);
        make.left.equalTo(self.iconImg.mas_right).offset(15);
    }];
    
    [self.bankCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.mas_centerY).offset(2);
        make.left.equalTo(self.iconImg.mas_right).offset(15);
    }];
    
    [self.WithdrawMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_top).offset(15);
        make.left.equalTo(self.container2.mas_left).offset(15);
    }];
    
    [self.RMBIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.WithdrawMoney.mas_bottom).offset(15);
        make.left.equalTo(self.container2.mas_left).offset(15);
        make.width.mas_equalTo(20);
    }];
    
    [self.moneyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RMBIcon.mas_centerY).offset(-10);
        make.left.equalTo(self.RMBIcon.mas_right).offset(5);
        make.right.equalTo(self.container2.mas_right).offset(-14);
        make.height.mas_equalTo(30);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyTf.mas_bottom).offset(10);
        make.right.equalTo(self.container2.mas_right).offset(-14);
        make.left.equalTo(self.container2.mas_left).offset(14);
        make.height.mas_equalTo(1);
    }];
    
    [self.totalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.container2.mas_bottom).offset(-10);
        make.left.equalTo(self.container2.mas_left).offset(15);
    }];
    
    [self.totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.equalTo(self.totalMoney.mas_right).offset(15);
        make.bottom.equalTo(self.container2.mas_bottom).offset(-10);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(34);
        make.right.equalTo(self.view.mas_right).offset(-34);
        make.height.mas_equalTo(40);
    }];
    
    [self.warnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalMoney.mas_top);
        make.left.equalTo(self.totalMoney.mas_left);
    }];
    
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.container1.mas_centerY);
        make.right.equalTo(self.container1.mas_right).offset(-14);
    }];
    
    [self.surplusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bank.mas_centerY);
        make.left.equalTo(self.bank.mas_right).offset(5);
    }];
}



@end
