//
//  AddAlipayViewController.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AddAlipayViewController.h"
#import "AddBandCardViewController.h"
#import "NetworkAPI.h"
#import "WCAlertView.h"
#import "Session.h"
#import "NSString+Validation.h"
#import "NSString+Addtions.h"
#import "UserDetailInfo.h"


@interface AddAlipayViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * container1;
@property (nonatomic, strong) UIView * container2;
@property (nonatomic, strong) UILabel * alertLabel;

@property (nonatomic, strong) UILabel * alipayName;
@property (nonatomic, strong) liebetweenTextField * alipayNameTf;

@property (nonatomic, strong) UILabel * alipayAccount;
@property (nonatomic, strong) liebetweenTextField * alipayAccountTf;

@property (nonatomic, strong) UILabel * phone;
@property (nonatomic, strong) liebetweenTextField * phoneTf;

@property (nonatomic, strong) UILabel * verification;
@property (nonatomic, strong) liebetweenTextField * verificationTf;

@property (nonatomic, strong) UIButton * codeBtn;
@property (nonatomic, strong) HTTPRequest * request;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger timerPeriod;

@property (nonatomic ,strong) NSString * phoneNumber;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * accout;
@property (nonatomic, copy) NSString * auth_code;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic,strong) UserDetailInfo * userDetailInfo;
@property (nonatomic,strong) HTTPRequest * userDetailrequest;

@end

@implementation AddAlipayViewController

-(UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"完成" forState:UIControlStateNormal];
        _submitBtn.enabled = YES;
        [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"bbbbbb"]];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.selected = NO;
    }
    return _submitBtn;
}

-(UIButton *)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] init];
        _codeBtn.layer.borderWidth = 1;
        _codeBtn.layer.borderColor = [UIColor colorWithHexString:@"434342"].CGColor;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}

-(UILabel *)verification
{
    if (!_verification) {
        _verification = [[UILabel alloc] init];
        _verification.text = @"验证码";
        _verification.textColor = [UIColor colorWithHexString:@"434342"];
        _verification.font =[UIFont systemFontOfSize:14];
    }
    return _verification;
}

-(liebetweenTextField *)verificationTf
{
    if (!_verificationTf) {
        _verificationTf = [[liebetweenTextField alloc] init];
        [_verificationTf setPlaceholder:@"请输入你收到的短信验证码"];
        _verificationTf.textColor = [UIColor colorWithHexString:@"434342"];
        _verificationTf.delegate = self;
        _verificationTf.font = [UIFont systemFontOfSize:14];
    }
    return _verificationTf;
}

-(UILabel *)phone
{
    if (!_phone) {
        _phone = [[UILabel alloc] init];
        _phone.text = @"手机号码";
        _phone.textColor = [UIColor colorWithHexString:@"434342"];
        _phone.font =[UIFont systemFontOfSize:14];
    }
    return _phone;
}

-(liebetweenTextField *)phoneTf
{
    if (!_phoneTf) {
        _phoneTf = [[liebetweenTextField alloc] init];
        [_phoneTf setPlaceholder:@"请填写手机号码"];
        _phoneTf.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _phoneTf.delegate = self;
        _phoneTf.font = [UIFont systemFontOfSize:14];
    }
    return _phoneTf;
}

-(UILabel *)alipayAccount
{
    if (!_alipayAccount) {
        _alipayAccount = [[UILabel alloc] init];
        _alipayAccount.text = @"支付宝账号";
        _alipayAccount.textColor = [UIColor colorWithHexString:@"434342"];
        _alipayAccount.font =[UIFont systemFontOfSize:14];
    }
    return _alipayAccount;
}

-(liebetweenTextField *)alipayAccountTf
{
    if (!_alipayAccountTf) {
        _alipayAccountTf = [[liebetweenTextField alloc] init];
        [_alipayAccountTf setPlaceholder:@"请填写支付宝账号"];
        _alipayAccountTf.textColor = [UIColor colorWithHexString:@"434342"];
        _alipayAccountTf.font = [UIFont systemFontOfSize:14];
        _alipayAccountTf.delegate = self;
    }
    return _alipayAccountTf;
}

-(UILabel *)alipayName
{
    if (!_alipayName) {
        _alipayName = [[UILabel alloc] init];
        _alipayName.text = @"支付宝实名";
        _alipayName.textColor = [UIColor colorWithHexString:@"434342"];
        _alipayName.font =[UIFont systemFontOfSize:14];
    }
    return _alipayName;
}

-(liebetweenTextField *)alipayNameTf
{
    if (!_alipayNameTf) {
        _alipayNameTf = [[liebetweenTextField alloc] init];
        [_alipayNameTf setPlaceholder:@"请填写姓名"];
        _alipayNameTf.textColor = [UIColor colorWithHexString:@"434342"];
        _alipayNameTf.font = [UIFont systemFontOfSize:14];
        _alipayNameTf.delegate = self;
    }
    return _alipayNameTf;
}

-(UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.text = @"提醒:绑定的支付宝姓名和银行卡姓名须一致";
        _alertLabel.font = [UIFont systemFontOfSize:14];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return _alertLabel;
}

-(UIView *)container1
{
    if (!_container1) {
        _container1 = [[UIView alloc] init];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"添加支付宝"];
    [super setupTopBarBackButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    [self.view addSubview:self.container1];
    [self.view addSubview:self.container2];
    [self.view addSubview:self.alertLabel];
    
    [self.container1 addSubview:self.alipayName];
    [self.container1 addSubview:self.alipayNameTf];
    [self.container1 addSubview:self.alipayAccount];
    [self.container1 addSubview:self.alipayAccountTf];
    [self.container1 addSubview:self.phoneTf];
    [self.container1 addSubview:self.phone];
    
    [self.container1 addSubview:self.verification];
    [self.container1 addSubview:self.verificationTf];
    
    [self.container2 addSubview:self.verification];
    [self.container2 addSubview:self.verificationTf];
    
    [self.container1 addSubview:self.codeBtn];
    [self.view addSubview:self.submitBtn];
    [self setupUI];
    
    _phoneNumber = [Session sharedInstance].currentUser.phoneNumber;
    [self showLoadingView];
    NSInteger userId = [Session sharedInstance].currentUser.userId;
    _userDetailrequest = [[NetworkAPI sharedInstance] getUserDetail:userId completion:^(UserDetailInfo *userDetailInfo) {
        [self hideLoadingView];
        self.userDetailInfo = userDetailInfo;
        if (userDetailInfo.userInfo.realName.length > 0) {
            self.alipayNameTf.text = userDetailInfo.userInfo.realName;
            self.name = userDetailInfo.userInfo.realName;
        }
        
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
    self.alipayNameTf.text = _name;
    self.phoneTf.text = _phoneNumber;
}

-(void)codeBtnClick
{
    WEAKSELF;
    
    BOOL isValid = [self chectOutisValid];
    if (isValid) {
        if (_phoneTf.text.length > 0 && [_phoneTf.text isValidMobilePhoneNumber]) {
            NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",_phoneTf.text];
            [WCAlertView showAlertWithTitle:@"确认手机号码" message:message customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
                if (buttonIndex == 0) {
                    
                }else{
                    [weakSelf showProcessingHUD:nil forView:weakSelf.view];
                    weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:_phoneTf.text type:CaptchaTypeAddAlipy sms_type:0 completion:^{
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
    
}

- (void)run:(NSTimer *)timer
{
    
    if (self.timerPeriod > 0) {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"(%ld)",self.timerPeriod-= 1] forState:UIControlStateNormal];
        self.codeBtn.enabled = NO;
    }else{
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [timer setFireDate:[NSDate distantFuture]];
        self.codeBtn.enabled = YES;;
    }
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _phoneTf) {
        if (self.phoneNumber && self.phoneNumber.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }
    
    if (textField == _alipayNameTf) {
        if (self.name && self.name.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }

    return YES;
}





-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _alipayNameTf) {
        self.name = [_alipayNameTf.text trim];
    }
    
    if (textField == _alipayAccountTf) {
        self.accout = [_alipayAccountTf.text trim];
    }
    
    if (textField == _verificationTf) {
        self.auth_code = [_verificationTf.text trim];
    }

    if ([self.auth_code length] != 0 &&
        [self.accout length] != 0 &&
        [self.name length] != 0) {
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"434342"];
        _submitBtn.selected = YES;
    }else{
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
        _submitBtn.selected = NO;
    }
    
}


-(void)buttonClick:(UIButton *)button
{
    
    if (button.selected) {
        if ([self.auth_code length] != 0 && [self.accout length] != 0 && [self.name length] != 0 ) {
            NSInteger user_id = [Session sharedInstance].currentUser.userId;
            NSDictionary * parm = @{@"user_id":[NSNumber numberWithInteger:user_id],
                                    @"name":self.name?self.name: @"",
                                    @"accout":self.accout?self.accout:@"",
                                    @"auth_code":self.auth_code?self.auth_code:@""};
            
            _request = [[NetworkAPI sharedInstance] addPpdateAlipay:parm completion:^{
                [self showHUD:@"添加成功" hideAfterDelay:0.8];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(XMError *error) {
                [self showHUD:[error errorMsg] hideAfterDelay:0.8];
            }];
            
        }else{
            [self showHUD:@"请把信息填完整" hideAfterDelay:0.8];
        }
    }
}

-(BOOL)chectOutisValid
{
    BOOL isValid = YES;
    if (isValid) {
        if ([_alipayNameTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请填写姓名"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_alipayAccountTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请填写支付宝账号"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_phoneTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请填写手机号码"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    return isValid;
}


-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupUI {
    
    [self.container1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(80);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(@135);
    }];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container1.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(@40);
    }];
    
    [self.container2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertLabel.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(@45);
    }];
    
    
    [self.alipayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container1.mas_top).offset(15);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];

    [self.alipayNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayName.mas_top);
        make.left.equalTo(self.container1.mas_left).offset(100);
        make.right.equalTo(self.container1.mas_right).offset(-14);
        make.bottom.equalTo(self.alipayName.mas_bottom);
    }];
    
    [self.alipayAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayName.mas_bottom).offset(25);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];
    
    [self.alipayAccountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayAccount.mas_top);
        make.left.equalTo(self.container1.mas_left).offset(100);
        make.right.equalTo(self.container1.mas_right).offset(-14);
        make.bottom.equalTo(self.alipayAccount.mas_bottom);
    }];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayAccount.mas_bottom).offset(25);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phone.mas_top);
        make.left.equalTo(self.container1.mas_left).offset(100);
        make.right.equalTo(self.container1.mas_right).offset(-14);
        make.bottom.equalTo(self.phone.mas_bottom);
    }];
    
    [self.verification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_top).offset(15);
        make.left.equalTo(self.container2.mas_left).offset(14);
    }];
    
    [self.verificationTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verification.mas_top);
        make.left.equalTo(self.container2.mas_left).offset(100);
        make.right.equalTo(self.container2.mas_right).offset(-14);
        make.bottom.equalTo(self.verification.mas_bottom);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTf.mas_centerY);
        make.right.equalTo(self.container1.mas_right).offset(-18);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*100, 28));
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.left.equalTo(self.view.mas_left).offset(14);
        make.top.equalTo(self.container2.mas_bottom).offset(14);
        make.height.mas_equalTo(@40);
    }];
    
}



@end
