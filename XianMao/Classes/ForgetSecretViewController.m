//
//  ForgetSecretViewController.m
//  yuncangcat
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ForgetSecretViewController.h"
#import "WCAlertView.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "NSString+Validation.h"


@interface ForgetSecretViewController ()

@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic, strong) UIView *phoneNumBottomView;
@property (nonatomic, strong) UITextField *verifyTextField;
@property (nonatomic, strong) UIView *verifyBottomView;
@property (nonatomic, strong) UITextField *secretNewTextField;
@property (nonatomic, strong) UIView *secretNewBottomView;

@property (nonatomic, strong) UILabel *verifyLbl;
@property (nonatomic, strong) UIButton *verifyBtn;

@property (nonatomic, strong) UIButton *sureBtn;


@property (nonatomic,strong) HTTPRequest * request; //发送验证码
@property (nonatomic,strong) HTTPRequest * register_request; //重置密码
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger timerPeriod;
@end

@implementation ForgetSecretViewController

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"000000"];
        [_sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(UIView *)phoneNumBottomView{
    if (!_phoneNumBottomView) {
        _phoneNumBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _phoneNumBottomView.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _phoneNumBottomView;
}

-(UITextField *)phoneNumField{
    if (!_phoneNumField) {
        _phoneNumField = [[UITextField alloc] initWithFrame:CGRectZero];
        _phoneNumField.borderStyle = UITextBorderStyleNone;
        _phoneNumField.leftViewMode = UITextFieldViewModeAlways;
        _phoneNumField.font = [UIFont systemFontOfSize:15.f];
        _phoneNumField.placeholder = @"请输入手机号码";
    }
    return _phoneNumField;
}

-(UIButton *)verifyBtn{
    if (!_verifyBtn) {
        _verifyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}

-(UILabel *)verifyLbl{
    if (!_verifyLbl) {
        _verifyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _verifyLbl.font = [UIFont systemFontOfSize:15.f];
        _verifyLbl.text = @"获取验证码";
        [_verifyLbl sizeToFit];
    }
    return _verifyLbl;
}

-(UIView *)verifyBottomView{
    if (!_verifyBottomView) {
        _verifyBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _verifyBottomView.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _verifyBottomView;
}

-(UITextField *)verifyTextField{
    if (!_verifyTextField) {
        _verifyTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _verifyTextField.borderStyle = UITextBorderStyleNone;
        _verifyTextField.leftViewMode = UITextFieldViewModeAlways;
        _verifyTextField.font = [UIFont systemFontOfSize:15.f];
        _verifyTextField.placeholder = @"请输入验证码";
    }
    return _verifyTextField;
}

-(UIView *)secretNewBottomView{
    if (!_secretNewBottomView) {
        _secretNewBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _secretNewBottomView.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _secretNewBottomView;
}

-(UITextField *)secretNewTextField{
    if (!_secretNewTextField) {
        _secretNewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _secretNewTextField.borderStyle = UITextBorderStyleNone;
        _secretNewTextField.leftViewMode = UITextFieldViewModeAlways;
        _secretNewTextField.font = [UIFont systemFontOfSize:15.f];
        _secretNewTextField.placeholder = @"密码";
        _secretNewTextField.secureTextEntry = YES;
    }
    return _secretNewTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:self.topBarTitle];
    
    [self.view addSubview:self.phoneNumField];
    [self.view addSubview:self.phoneNumBottomView];
    [self.view addSubview:self.verifyTextField];
    [self.view addSubview:self.verifyBottomView];
    [self.view addSubview:self.verifyLbl];
    [self.view addSubview:self.verifyBtn];
    [self.view addSubview:self.secretNewTextField];
    [self.view addSubview:self.secretNewBottomView];
    
    [self.view addSubview:self.sureBtn];
    
    [self setUpUI];
}

//重置密码 忘记密码
-(void)sureBtnClick
{
    if ([self.phoneNumField.text length] == 0) {
        [self showHUD:@"手机号码不能为空" hideAfterDelay:0.8f forView:self.view];
        return;
    }
    
    if ([self.secretNewTextField.text length] < 6) {
        [self showHUD:@"请输入6位以上密码" hideAfterDelay:0.8f forView:self.view];
        return;
    }
    
    
    if (self.phoneNumField.text.length > 0 && [self.phoneNumField.text isValidMobilePhoneNumber]) {
        
        
        
        if (self.verifyTextField.text.length == 6) {
            
            
            WEAKSELF;
            if (self.secretNewTextField.text.length >= 6) {
                _register_request = [[NetworkAPI sharedInstance] resetPassword:weakSelf.phoneNumField.text password:self.secretNewTextField.text authcode:self.verifyTextField.text completion:^{
                    
                    [weakSelf dismiss];
                    [weakSelf showHUD:@"修改成功" hideAfterDelay:0.8];
                    
                } failure:^(XMError *error) {
                    [super showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self.view];
                }];
                
            }
            
        }else{
            [self showHUD:@"请输入6位验证码" hideAfterDelay:0.8f forView:self.view];
        }
        
        
    }
}



-(void)verifyBtnClick
{
    //获取验证码

        WEAKSELF;
        if (_phoneNumField.text.length > 0 && [_phoneNumField.text isValidMobilePhoneNumber]) {
            NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",_phoneNumField.text];
            [WCAlertView showAlertWithTitle:@"确认手机号码" message:message customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
                if (buttonIndex == 0) {
                    
                }else{
                    [weakSelf showProcessingHUD:nil forView:weakSelf.view];
                    weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:_phoneNumField.text type:CaptchaTypeResetPassword sms_type:0 completion:^{
                        [weakSelf hideHUD];
                        
                        self.timerPeriod = 60;
                        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run:) userInfo:nil repeats:YES];
                        [_timer setFireDate:[NSDate distantPast]];
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.view];
                    }];
                }
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            
            
        }else{
            [self showHUD:@"请输入正确的电话号码" hideAfterDelay:0.8 forView:self.view];
        }

}

- (void)run:(NSTimer *)timer
{
    
    if (self.timerPeriod > 0) {
        _verifyLbl.text = [NSString stringWithFormat:@"(%ld)",self.timerPeriod-= 1];
        self.verifyBtn.hidden = YES;
    }else{
        _verifyLbl.text = [NSString stringWithFormat:@"再次发送验证码"];
        [timer setFireDate:[NSDate distantFuture]];
        self.verifyBtn.hidden = NO;
    }
    
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

-(void)setUpUI{
    
    [self.phoneNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [self.phoneNumBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumBottomView.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [self.verifyBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyTextField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.verifyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.verifyTextField.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.verifyLbl.mas_centerY);
        make.centerX.equalTo(self.verifyLbl.mas_centerX);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    [self.secretNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyBottomView.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [self.secretNewBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secretNewTextField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/375*45);
        make.right.equalTo(self.view.mas_right).offset(-kScreenWidth/375*45);
        make.height.equalTo(@40);
    }];
    
}

@end
