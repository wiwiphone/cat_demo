//
//  WalletViewController.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "WalletViewController.h"
#import "UIScrollView+KeyboardCtrl.h"
#import "WithdrawalHistoryViewController.h"

#import "NetworkAPI.h"
#import "Session.h"
#import "Command.h"

#import "Wallet.h"

#import "NSString+Addtions.h"

#import "WebViewController.h"

#import "WCAlertView.h"
#import "ActionSheet.h"
#import "URLScheme.h"
#import "DataSources.h"
#import "UIActionSheet+Blocks.h"

#import "WeakTimerTarget.h"

#import "UnCopyableTextField.h"

#import "BoughtViewController.h"
#import "AuthService.h"

#import "LoginViewController.h"
#import "TTTAttributedLabel.h"

#import "RechargeViewController.h"


@interface WalletViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) Wallet *wallet;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger timerPeriod;

@end

@implementation WalletViewController
- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"我的钱包"];
    [super setupTopBarBackButton];
    
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"账单" forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _scrollView.alwaysBounceVertical = YES;
    
    [self reloadData];
    
    [self bringTopBarToTop];
}

- (void)reloadData
{
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
        [weakSelf hideLoadingView];
        
        weakSelf.wallet = wallet;
        if (weakSelf.contentView) {
            [weakSelf.contentView removeFromSuperview];
            weakSelf.contentView = nil;
        }
        [weakSelf.scrollView addSubview:weakSelf.contentView];
        
        if (weakSelf.contentView.height>weakSelf.scrollView.height) {
            weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.width, weakSelf.contentView.height);
        }

        UILabel *moneyLbl = (UILabel*)[weakSelf.contentView viewWithTag:100];
        moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",wallet.moneyInfo.availableMoney];
        
    } failure:^(XMError *error) {
        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
            [weakSelf reloadData];
        };
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
    }];
}

- (void)$$handlePayResultCompletionNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl];
    
    //充值成功
}

- (void)$$handlePayResultCancelNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl];
}

- (void)$$handlePayResultFailureNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl];
}

- (void)handlePayDidFnishBlockImpl {
    
    WEAKSELF;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf showProcessingHUD:nil];
        weakSelf.request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
            [weakSelf hideHUD];
            
            weakSelf.wallet = wallet;
            if (weakSelf.contentView) {
                [weakSelf.contentView removeFromSuperview];
                weakSelf.contentView = nil;
            }
            [weakSelf.scrollView addSubview:weakSelf.contentView];
            
            if (weakSelf.contentView.height>weakSelf.scrollView.height) {
                weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.width, weakSelf.contentView.height);
            }
            
            UILabel *moneyLbl = (UILabel*)[weakSelf.contentView viewWithTag:100];
            moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",wallet.moneyInfo.availableMoney];
            
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        }];
    });
}

-(void)$$handleWithDrawSuccess:(id<MBNotification>)notification available:(NSNumber *)money
{
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
        [weakSelf hideLoadingView];
        
        weakSelf.wallet = wallet;
        UILabel *moneyLbl = (UILabel*)[weakSelf.contentView viewWithTag:100];
        moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",wallet.moneyInfo.availableMoney];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        
        [weakSelf loadEndWithError];
    }];

}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    WithdrawalHistoryViewController *viewController = [[WithdrawalHistoryViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        CGFloat marginTop = 0.f;
        
        marginTop += 31.f;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, marginTop, kScreenWidth-60, 0)];
        titleLbl.text = @"可用余额（元）：";
        titleLbl.font = [UIFont systemFontOfSize:15.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(30, marginTop, kScreenWidth-60, titleLbl.height);
        [_contentView addSubview:titleLbl];
        
        marginTop += titleLbl.height;
        marginTop += 48;
        
        UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, marginTop, kScreenWidth-60, 0)];
        moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",0.f];
        moneyLbl.font = [UIFont systemFontOfSize:48.5f];
        moneyLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        moneyLbl.tag = 100;
        [moneyLbl sizeToFit];
        moneyLbl.frame = CGRectMake(30, marginTop, kScreenWidth-60, moneyLbl.height);
        [_contentView addSubview:moneyLbl];
        
        marginTop += moneyLbl.height;
        
        marginTop += 50;
        
        CALayer *bottomLine = [CALayer layer];
        bottomLine.backgroundColor = [UIColor whiteColor].CGColor;
        bottomLine.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
        [_contentView.layer addSublayer:bottomLine];
        
        marginTop += 1;
        
        marginTop += 50;
        
        CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake((kScreenWidth-220)/2, marginTop, 100, 44)];
        btn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"提现" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contentView addSubview:btn];
        marginTop += btn.height;
        
        CommandButton *rechargeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(btn.right+10, btn.top, 100, 44)];
        rechargeBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        rechargeBtn.layer.cornerRadius = 5.f;
        rechargeBtn.layer.masksToBounds = YES;
        [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contentView addSubview:rechargeBtn];
        
        marginTop += 15;
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 0)];
        textLbl.text = @"提现将在3个工作日内到账";
        textLbl.textColor = [UIColor colorWithHexString:@"666666"];
        textLbl.font = [UIFont systemFontOfSize:11.f];
        [textLbl sizeToFit];
        textLbl.frame = CGRectMake(0, marginTop, kScreenWidth, textLbl.height);
        textLbl.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:textLbl];
        marginTop += textLbl.height;
        marginTop += 50.f;
        
        _contentView.frame = CGRectMake(0, 0, kScreenWidth, marginTop);
        
        WEAKSELF;
        btn.handleClickBlock = ^(CommandButton *sender) {
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
                viewController.wallet = weakSelf.wallet;
                [weakSelf pushViewController:viewController animated:YES];
            }
        };
        
        rechargeBtn.handleClickBlock = ^(CommandButton *sender) {
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
                RechargeViewController *viewController = [[RechargeViewController alloc] init];
                [weakSelf pushViewController:viewController animated:YES];
            }
        };
    }
    return _contentView;
}

@end


@interface WithdrawApplyInfo : NSObject
@property(nonatomic,copy) NSString *withdrawMoney;
@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *withdrawCode;
@property(nonatomic,assign) NSInteger paymentType;
@end

@implementation WithdrawApplyInfo
@end


@interface WithdrawApplyViewController () <UITextFieldDelegate,TTTAttributedLabelDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,assign) BOOL isShowConfirmView;
@property(nonatomic,strong) WithdrawApplyInfo *applyInfo;
@property(nonatomic,strong) UIView *confirmView;

@property(nonatomic,assign) BOOL isAcountExist;
@property(nonatomic,assign) BOOL isShowFinishView;
@property(nonatomic,strong) UIView *finishedView;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger timerPeriod;

@property(nonatomic,strong) PaymentAccount *paymentAccount;

@property(nonatomic,strong) ADMActionSheet *actionSheet;

@end

@implementation WithdrawApplyViewController

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"提现到支付宝"];
    [super setupTopBarBackButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    if ([self.wallet.paymentList count]>0) {
        _isAcountExist = YES;
        
        for (PaymentAccount *account in self.wallet.paymentList) {
            if (account.type == 0) {
                _paymentAccount = [[PaymentAccount alloc] init];
                _paymentAccount.account = account.account;
                _paymentAccount.accountName = account.accountName;
                
            }
        }
        
    }
    
    if (_isShowConfirmView)
    {
        [_scrollView addSubview:self.confirmView];
        if (self.confirmView.height>_scrollView.height) {
            _scrollView.contentSize = CGSizeMake(_scrollView.width, self.confirmView.height);
        }
        _scrollView.alwaysBounceVertical = YES;
    }
    else if (_isShowFinishView)
    {
        [_scrollView addSubview:self.finishedView];
        if (self.finishedView.height>_scrollView.height) {
            _scrollView.contentSize = CGSizeMake(_scrollView.width, self.finishedView.height);
        }
        _scrollView.alwaysBounceVertical = YES;
    }
    else
    {
        [_scrollView addSubview:self.contentView];
        if (self.contentView.height>_scrollView.height) {
            _scrollView.contentSize = CGSizeMake(_scrollView.width, self.contentView.height);
        }
        _scrollView.alwaysBounceVertical = YES;
    }
    
    WEAKSELF;
    _scrollView.keyboardWillChange = ^(CGRect beginKeyboardRect, CGRect endKeyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             
                             if (showKeyborad) {
                                 CGFloat keyboardHeight = [weakSelf.view convertRect:endKeyboardRect fromView:nil].size.height;
                                 CGFloat contentY = weakSelf.contentView.frame.origin.y;
                                 CGFloat contentHeight = weakSelf.contentView.bounds.size.height;
                                 
                                 CGFloat visibleHeight = weakSelf.view.bounds.size.height-keyboardHeight-weakSelf.topBarHeight;
                                 
                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
                                 
                                 if (visibleHeight<contentY+contentHeight+15) {
                                     targetEndY = contentY-15;
                                     
                                     [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, contentY+contentHeight)];
                                     [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
                                     [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height+contentY+15+(contentHeight-visibleHeight))];
                                 } else {
                                     [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
                                 }
                             } else {
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, weakSelf.view.bounds.size.height-weakSelf.scrollView.frame.origin.y)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height)];
                             }
                         }
                         completion:nil];
    };
    
    _scrollView.keyboardDidChange = ^(BOOL didShowed) {
        
    };
    
    [self setupForDismissKeyboard];
    
    [self bringTopBarToTop];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 设置键盘通知或者手势控制键盘消失
    //[_scrollView setupPanGestureControlKeyboardHide:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // remove键盘通知或者手势
    //[_scrollView disSetupPanGestureControlKeyboardHide:NO];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        CGFloat marginTop = 0.f;
        
         marginTop += 15.f;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 0)];
        titleLbl.font = [UIFont systemFontOfSize:13.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        titleLbl.numberOfLines = 0;
        titleLbl.text = @"请谨慎填写下列选项，否则可能提现失败哦~";
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, titleLbl.height);
        [_contentView addSubview:titleLbl];
        
        marginTop += titleLbl.height;
        marginTop += 10.f;
       
        
        UITextField *textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 0)];
        textFiled.enabled = YES;
        textFiled.font = [UIFont systemFontOfSize:14.f];
        textFiled.textColor = [UIColor colorWithHexString:@"181818"];
        textFiled.frame = CGRectMake(15, marginTop, kScreenWidth-30, 46);
        textFiled.tag = 200;
        NSMutableString *placeholder = [NSMutableString stringWithString:@"支付宝账号"];
        if (_isAcountExist) {
            [placeholder appendFormat:@": %@",_paymentAccount.account];
            textFiled.text = placeholder;
            textFiled.textColor = [UIColor blackColor];
            textFiled.enabled = NO;
        } else {
            textFiled.placeholder = placeholder;
        }
        
        [_contentView addSubview:textFiled];
        
        marginTop += textFiled.height;
        CALayer *bottomLine = [CALayer layer];
        if (!_isAcountExist) {
            bottomLine.frame = CGRectMake(15, marginTop, kScreenWidth-30, 1);
            bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
            [_contentView.layer addSublayer:bottomLine];
            
            marginTop += 1;
        }
        marginTop += 15.f;
        
        
        textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 0)];
        textFiled.enabled = YES;
        textFiled.font = [UIFont systemFontOfSize:14.f];
        textFiled.textColor = [UIColor colorWithHexString:@"181818"];
        textFiled.frame = CGRectMake(15, marginTop, kScreenWidth-30, 46);
        textFiled.tag = 300;
        textFiled.keyboardType = UIKeyboardTypeDefault;
        NSMutableString *namePlaceholder = [NSMutableString stringWithString:@"开户人姓名"];
        if (_isAcountExist) {
            [namePlaceholder appendFormat:@": %@",_paymentAccount.accountName];
            textFiled.text = namePlaceholder;
            textFiled.textColor = [UIColor blackColor];
            textFiled.enabled = NO;
        }else {
            textFiled.placeholder = namePlaceholder;
        }
        
        [_contentView addSubview:textFiled];
        
        marginTop += textFiled.height;
        
        if (!_isAcountExist) {
            bottomLine = [CALayer layer];
            bottomLine.frame = CGRectMake(15, marginTop, kScreenWidth-30, 1);
            bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
            [_contentView.layer addSublayer:bottomLine];
            
            marginTop += 1;
        }
        marginTop += 15.f;

        textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 0)];
        textFiled.enabled = YES;
        textFiled.placeholder = [NSString stringWithFormat:@"提现金额最多不超过 %.2f 元",self.wallet.moneyInfo.availableMoney];
        textFiled.font = [UIFont systemFontOfSize:13.f];
        textFiled.textColor = [UIColor colorWithHexString:@"181818"];
        textFiled.keyboardType = UIKeyboardTypeDecimalPad;
        textFiled.frame = CGRectMake(15, marginTop, kScreenWidth-30, 46);
        textFiled.tag = 100;
        textFiled.delegate = self;
//        textFiled.keyboardType = UIKeyboardTypeDecimalPad;
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_contentView addSubview:textFiled];
        
        marginTop += textFiled.height;
        
        bottomLine = [CALayer layer];
        bottomLine.frame = CGRectMake(15, marginTop, kScreenWidth-30, 1);
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [_contentView.layer addSublayer:bottomLine];
        
        marginTop += 1;
        marginTop += 15.f;
        
        
        //获取验证码 (30)
        
        textFiled = [[UnCopyableTextField alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-15-15, 46)];
        textFiled.enabled = YES;
        textFiled.keyboardType = UIKeyboardTypeDecimalPad;
        textFiled.placeholder = @"输入验证码";
        textFiled.font = [UIFont systemFontOfSize:13.f];
        textFiled.textColor = [UIColor colorWithHexString:@"181818"];
        textFiled.tag = 400;
        textFiled.delegate = self;
        [_contentView addSubview:textFiled];
        
        marginTop += textFiled.height;
        
        bottomLine = [CALayer layer];
        bottomLine.frame = CGRectMake(textFiled.left, marginTop, textFiled.width, 1);
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [_contentView.layer addSublayer:bottomLine];
        
        marginTop += 15;
        
        CommandButton *captchaBtn = [[CommandButton alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 40)];
        captchaBtn.backgroundColor = [UIColor clearColor];
        [captchaBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        [captchaBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        [captchaBtn setTitleColor:[UIColor colorWithHexString:@"C7AF7A"] forState:UIControlStateDisabled];
//        captchaBtn.layer.masksToBounds = YES;
//        captchaBtn.layer.cornerRadius = 6.f;
//        captchaBtn.layer.borderWidth = 1;
//        captchaBtn.layer.borderColor = [UIColor colorWithHexString:@"C7AF7A"].CGColor;
        captchaBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        captchaBtn.tag = 600;
        [_contentView addSubview:captchaBtn];
        
        TTTAttributedLabel *attrLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, captchaBtn.top, self.view.bounds.size.width, captchaBtn.height)];
        attrLabel.delegate = self;
        attrLabel.tag = 800;
        attrLabel.font = [UIFont systemFontOfSize:13.f];
        attrLabel.textColor = [UIColor colorWithHexString:@"282828"];
        attrLabel.lineBreakMode = NSLineBreakByWordWrapping;
        attrLabel.userInteractionEnabled = YES;
        attrLabel.highlightedTextColor = [UIColor colorWithHexString:@"c2a79d"];
        attrLabel.numberOfLines = 0;
        attrLabel.textAlignment = NSTextAlignmentCenter;
        attrLabel.linkAttributes = nil;
        attrLabel.activeLinkAttributes = nil;
        [attrLabel setText:@"收不到验证码? 重新短信 或 接听电话 获取验证码" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(7,6);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];
            
            stringRange = NSMakeRange([mutableAttributedString length]-11,6);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];
            return mutableAttributedString;
        }];
        [attrLabel addLinkToURL:[NSURL URLWithString:@"admCaptcha://getWithSMS"] withRange:NSMakeRange(7,6)];
        [attrLabel addLinkToURL:[NSURL URLWithString:@"admCaptcha://getWithPhone"] withRange:NSMakeRange([attrLabel.text length]-11,6)];
        [_contentView addSubview:attrLabel];
        
        attrLabel.hidden = YES;
        
        marginTop += captchaBtn.height;
        
        marginTop += 15;
        
        WEAKSELF;
    
        CommandButton *submitBtn = [[CommandButton alloc] initWithFrame:CGRectMake((kScreenWidth-158)/2, marginTop, 158, 50)];
        submitBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.cornerRadius = 6.f;
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [submitBtn setTitle:@"申请提现" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contentView addSubview:submitBtn];
        
        marginTop += submitBtn.height;
        
        if (_isAcountExist) {
            marginTop += 18;
            
            CommandButton *changeAccountBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, marginTop, _contentView.width, 40)];
            [changeAccountBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [changeAccountBtn setTitle:@"我想修改支付宝账号 >" forState:UIControlStateNormal];
            changeAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [_contentView addSubview:changeAccountBtn];
            
            marginTop += changeAccountBtn.height;
            
            changeAccountBtn.handleClickBlock = ^(CommandButton *sender) {
              
                [UIActionSheet showInView:weakSelf.view
                                withTitle:nil
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:[NSArray arrayWithObjects:@"呼叫客服(工作日9点到20点)", nil]
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     if (buttonIndex == 0) {
                                         NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                     }
                                 }];
            };
            

        }
        
        
        marginTop += 50;
        
        _contentView.frame = CGRectMake(0, 0, kScreenWidth, marginTop);
        
        
        captchaBtn.handleClickBlock = ^(CommandButton *sender) {
            
            NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",[Session sharedInstance].currentUser.phoneNumber];
            [WCAlertView showAlertWithTitle:@"确认手机号码"
                                    message:message
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 UIButton *retryBtn = (UIButton*)([weakSelf.contentView viewWithTag:600]);
                                 retryBtn.enabled = NO;
                                 [retryBtn setTitle:@"点击再次发送(60)" forState:UIControlStateDisabled];
                                 
                                 [weakSelf.timer invalidate];
                                 weakSelf.timerPeriod = 60;
                                 
                                 WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
                                 weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:[weakSelf.contentView viewWithTag:600] repeats:YES];
                                 
                                 weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:[Session sharedInstance].currentUser.phoneNumber type:CaptchaTypeWithdrawCash sms_type:0 completion:^{
                                     
                                 } failure:^(XMError *error) {
                                     [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                                 }];
                             }
                         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        };
        
        submitBtn.handleClickBlock = ^(CommandButton *sender) {
            
            UITextField *withdrawMoneyTextField = (UITextField*)[weakSelf.scrollView viewWithTag:100];
            UITextField *accountTextField = (UITextField*)[weakSelf.scrollView viewWithTag:200];
            UITextField *nameTextField = (UITextField*)[weakSelf.scrollView viewWithTag:300];
            UITextField *withdrawCodeField = (UITextField*)[weakSelf.scrollView viewWithTag:400];
            
            NSString *withdrawMoney = [withdrawMoneyTextField.text trim];
            
            BOOL isValidInput = YES;
            if (withdrawMoney.length == 0) {
                withdrawMoneyTextField.text = @"";
                withdrawMoneyTextField.placeholder = @"请输入提现金额";
                [withdrawMoneyTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                isValidInput = NO;
            } else {
                if (([withdrawMoney isNumeric] && [withdrawMoney doubleValue] > 0) ||
                    ([withdrawMoney isPureFloat] && [withdrawMoney doubleValue] > 0) ) {
                    if (withdrawMoney.doubleValue > weakSelf.wallet.moneyInfo.availableMoney) {
                        [weakSelf showHUD:@"余额不足" hideAfterDelay:0.8f forView:weakSelf.view];
                        return ;
                    }
                } else {
                    [weakSelf showHUD:@"请输入正确的提现金额" hideAfterDelay:0.8f forView:weakSelf.view];
                    return ;
                }
            }
            
            if (!weakSelf.isAcountExist && [accountTextField.text trim].length == 0) {
                accountTextField.text = @"";
                accountTextField.placeholder = @"请输入支付宝账号";
                [accountTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                isValidInput = NO;
            }
            if (!weakSelf.isAcountExist && [nameTextField.text trim].length == 0) {
                nameTextField.text = @"";
                nameTextField.placeholder = @"请输入支付宝账户名";
                [nameTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                isValidInput = NO;
            }
            if ([withdrawCodeField.text trim].length == 0) {
                withdrawCodeField.text = @"";
                withdrawCodeField.placeholder = @"请输入6位验证码";
                [withdrawCodeField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                isValidInput = NO;
            }
            if (!isValidInput) {
                [weakSelf showHUD:@"请检查必要填写项" hideAfterDelay:1.2f forView:weakSelf.view];
                return;
            }
            if ([withdrawCodeField.text trim].length!=6) {
                [weakSelf showHUD:@"请输入6位验证码" hideAfterDelay:1.2f forView:weakSelf.view];
                return;
            }
            
            if (isValidInput) {
                
                [weakSelf showProcessingHUD:nil forView:weakSelf.view];
                weakSelf.request = [[NetworkAPI sharedInstance] verifyCaptchaCode:[Session sharedInstance].currentUser.phoneNumber captchaCode:[withdrawCodeField.text trim] type:CaptchaTypeWithdrawCash completion:^{
                    
                    [weakSelf hideHUD];
                    WithdrawApplyInfo *applyInfo = [[WithdrawApplyInfo alloc] init];
                    if (weakSelf.isAcountExist) {
                        applyInfo.account = weakSelf.paymentAccount.account;
                        applyInfo.name = weakSelf.paymentAccount.accountName;
                    } else {
                        applyInfo.account = [accountTextField.text trim];
                        applyInfo.name = [nameTextField.text trim];
                    }
                    applyInfo.withdrawMoney = [withdrawMoneyTextField.text trim];
                    applyInfo.withdrawCode = [withdrawCodeField.text trim];
                    applyInfo.paymentType = 0;
                    
                    WithdrawApplyViewController *viewController = [[WithdrawApplyViewController alloc] init];
                    viewController.isShowConfirmView = YES;
                    viewController.applyInfo = applyInfo;
                    [weakSelf pushViewController:viewController animated:YES];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f forView:weakSelf.view];
                }];
            }
            

        };
    }
    return _contentView;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    WEAKSELF;
    if ([[url absoluteString] isEqualToString:@"admCaptcha://getWithSMS"]) {
        [self getCaptchaCodeEncrypt:0];
    } else {
        [WCAlertView showAlertWithTitle:@"确认手机号码" message:@"你将收到爱丁猫电话播报的语音\n验证码，请注意接听" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 1) {
                [weakSelf getCaptchaCodeEncrypt:1];
            } else {
                
            }
            
            TTTAttributedLabel *attrLabel = (TTTAttributedLabel*)[weakSelf.contentView viewWithTag:800];
            [attrLabel setText:@"收不到验证码? 重新短信 或 接听电话 获取验证码" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(7,6);
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];
                
                stringRange = NSMakeRange([mutableAttributedString length]-11,6);
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];
                return mutableAttributedString;
            }];
            [attrLabel addLinkToURL:[NSURL URLWithString:@"admCaptcha://getWithSMS"] withRange:NSMakeRange(7,6)];
            [attrLabel addLinkToURL:[NSURL URLWithString:@"admCaptcha://getWithPhone"] withRange:NSMakeRange([attrLabel.text length]-11,6)];
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认接听", nil];
    }
}

- (void)getCaptchaCodeEncrypt:(NSInteger)sms_type {
    WEAKSELF;
    [weakSelf.timer invalidate];
    weakSelf.timer = nil;
    [weakSelf showProcessingHUD:nil forView:weakSelf.contentView];
    _request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:[Session sharedInstance].currentUser.phoneNumber type:CaptchaTypeWithdrawCash sms_type:sms_type completion:^{
        [weakSelf hideHUD];
        
        //        VerifyCaptchaCodeViewController *viewController = [[VerifyCaptchaCodeViewController alloc] init];
        //        viewController.phoneNumber = weakSelf.phoneNumber;//((UITextField*)[weakSelf.scrollView viewWithTag:100]).text;
        //        viewController.captchaType = CaptchaTypeRegistry;
        //        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
        weakSelf.timerPeriod = 60;
        
        UIButton *retryBtn = (UIButton*)[weakSelf.contentView viewWithTag:600];
        retryBtn.enabled = NO;
        retryBtn.hidden = NO;
        
        TTTAttributedLabel *attrLbl = (TTTAttributedLabel*)[weakSelf.contentView viewWithTag:800];
        attrLbl.hidden = YES;
        
        WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        [weakSelf.timer invalidate];
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.contentView];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    WEAKSELF;
    UITextField *withdrawMoneyTextField = (UITextField*)[weakSelf.scrollView viewWithTag:100];
    if (withdrawMoneyTextField == textField) {
        double value = [withdrawMoneyTextField.text  doubleValue];
        if (value > weakSelf.wallet.moneyInfo.availableMoney) {
            withdrawMoneyTextField.text = [NSString stringWithFormat:@"%.2f",weakSelf.wallet.moneyInfo.availableMoney];
        }
    }
}

- (void)onTimer:(NSTimer*)theTimer
{
    UIButton *retryBtn = (UIButton*)[self.contentView viewWithTag:600];
    TTTAttributedLabel *attrLbl = (TTTAttributedLabel*)[self.contentView viewWithTag:800];
    self.timerPeriod -= 1;
    if (self.timerPeriod <= 0) {
        self.timerPeriod = 60;
        
        [retryBtn setTitle:@"点击再次发送(60)" forState:UIControlStateDisabled];
        retryBtn.hidden = YES;
        attrLbl.hidden = NO;
        
        [theTimer setFireDate:[NSDate distantFuture]];
    } else {
        [retryBtn setTitle:[NSString stringWithFormat:@"点击再次发送(%ld)",(long)self.timerPeriod] forState:UIControlStateDisabled];
    }
}

- (UIView*)confirmView {
    if (!_confirmView) {
        _confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        CGFloat marginTop = 0.f;
        
        marginTop += 15.f;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 0)];
        titleLbl.font = [UIFont systemFontOfSize:13.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        titleLbl.numberOfLines = 0;
        titleLbl.text = @"你将提现到下面的支付宝：";
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, titleLbl.height);
        [_confirmView addSubview:titleLbl];
        
        marginTop += titleLbl.height;
        marginTop += 20.f;
        
        UILabel *withdrawMoneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 32)];
        withdrawMoneyLbl.backgroundColor = [UIColor clearColor];
        withdrawMoneyLbl.font = [UIFont systemFontOfSize:15.f];
        withdrawMoneyLbl.textColor = [UIColor colorWithHexString:@"181818"];
        withdrawMoneyLbl.text = [NSString stringWithFormat:@"金       额：%@", self.applyInfo.withdrawMoney?self.applyInfo.withdrawMoney:@""];
        [_confirmView addSubview:withdrawMoneyLbl];
        
        marginTop += withdrawMoneyLbl.height;
        
        UILabel *accountLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 32)];
        accountLbl.backgroundColor = [UIColor clearColor];
        accountLbl.font = [UIFont systemFontOfSize:15.f];
        accountLbl.textColor = [UIColor colorWithHexString:@"181818"];
        accountLbl.text = [NSString stringWithFormat:@"账       号：%@",self.applyInfo.account?self.applyInfo.account:@""];
        [_confirmView addSubview:accountLbl];
        
        marginTop += accountLbl.height;
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 32)];
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.font = [UIFont systemFontOfSize:15.f];
        nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        nameLbl.text = [NSString stringWithFormat:@"开户姓名：%@",self.applyInfo.name?self.applyInfo.name:@""];
        [_confirmView addSubview:nameLbl];
        
        marginTop += nameLbl.height;
        
        marginTop += 68;
        
        CommandButton *submitBtn = [[CommandButton alloc] initWithFrame:CGRectMake((kScreenWidth-158)/2, marginTop, 158, 50)];
        submitBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.cornerRadius = 6.f;
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [submitBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmView addSubview:submitBtn];
        
        marginTop += submitBtn.height;
        marginTop += 18;
        
        _confirmView.frame = CGRectMake(0, 0, kScreenWidth, marginTop);
        
        WEAKSELF;
        submitBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf showValidatePassword];
        };
        
    }
    return _confirmView;
}

- (UIView*)finishedView {
    if (!_finishedView) {
        _finishedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        CGFloat marginTop = 0.f;

        _finishedView.frame = CGRectMake(0, 0, kScreenWidth, marginTop);
    }
    return _finishedView;
}

- (void)showConfirmAlertView
{
   
//    
//    NSString *message = @"";
//    WEAKSELF;
//    [WCAlertView showAlertWithTitle:@""
//                            message:message&&[message length]>0?message:@"确认延长收货时间？\n每笔订单只能延长一次哦"
//                 customizationBlock:^(WCAlertView *alertView) {
//                     alertView.style = WCAlertViewStyleWhite;
//                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                     if (buttonIndex == 0) {
//                         
//                     } else {
//                         weakSelf.request = [[NetworkAPI sharedInstance] delayReceipt:orderId completion:^(NSInteger delayDays) {
//                             [weakSelf showHUD:[NSString stringWithFormat:@"已成功延长 %d天 收货",delayDays] hideAfterDelay:0.8f forView:weakSelf.view];
//                         } failure:^(XMError *error) {
//                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
//                         }];
//                     }
//                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)showValidatePassword {
    
    WEAKSELF;
    [VerifyPasswordView showInView:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
        [weakSelf showProcessingHUD:nil];
        [AuthService validatePassword:password completion:^{
            weakSelf.request = [[NetworkAPI sharedInstance] withdraw:weakSelf.applyInfo.account accountName:weakSelf.applyInfo.name type:weakSelf.applyInfo.paymentType amount:weakSelf.applyInfo.withdrawMoney authCode:weakSelf.applyInfo.withdrawCode completion:^(NSInteger result, NSString *message,Wallet *wallet) {
//                [weakSelf showHUD:message?message:@"提现申请成功，小喵会及时为你处理" hideAfterDelay:1.5f forView:[UIApplication sharedApplication].keyWindow];
                [weakSelf hideHUD];
                [WCAlertView showAlertWithTitle:@"温馨提示" message:@"提现申请成功，小喵会及时为你处理" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                } cancelButtonTitle:@"取消" otherButtonTitles:nil];
                
                SEL selector = @selector($$handleWithDrawSuccess:available:);
                MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithDouble:wallet.moneyInfo.availableMoney]);
                
                if ([[weakSelf.navigationController viewControllers] count]>=2) {
                    [weakSelf.navigationController popToViewController:[[weakSelf.navigationController viewControllers] objectAtIndex:1] animated:YES];
                } else {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f forView:weakSelf.view];
            }];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
        
    }];
}

@end




