//
//  LoginViewController.m
//  XianMao
//
//  Created by simon cai on 11/15/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Expanded.h"
#import "UIScrollView+KeyboardCtrl.h"
#import "NSString+Addtions.h"
#import "BaseViewController.h"

#import "DataSources.h"

#import "WCAlertView.h"
#import "Session.h"
#import "NetworkAPI.h"
#import "NetworkManager.h"
#import "Masonry.h"

#import "TTTAttributedLabel.h"

#import "UIImage+Resize.h"
#import "ActionSheet.h"
#import "AssetPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "AppDirs.h"

#import "WebViewController.h"

#import "EMSession.h"

#import "URLScheme.h"
#import "UIActionSheet+Blocks.h"
#import "AESCrypt.h"

#import "WeakTimerTarget.h"
#import "WXApi.h"

#import "ExploreViewController.h"
#import "WebViewController.h"

#import "UnCopyableTextField.h"
#import "AppDelegate.h"
#import "NSString+Validation.h"

#import "Command.h"
#import "AuthService.h"

#import "UMSocial.h"
#import "AppDelegate+UMeng.h"

#import <TencentOpenAPI/TencentOAuth.h>


@interface CheckPhoneViewController () <UITextFieldDelegate,TTTAttributedLabelDelegate,UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIView *contentView;
@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,weak) CommandButton *agreeBtn;
@end

@implementation CheckPhoneViewController

- (id)init {
    self = [super init];
    if (self) {
        _isForBindPhoneNumber = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.title?self.title:@"进入爱丁猫"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UIView *contentView = [self buildContentView];
    //    UIView *contentView = [self buildContentViewRevise];
    CGRect frame = contentView.frame;
    frame.origin.y = 20;//_scrollView.bounds.size.height/8;
    contentView.frame = frame;
    [_scrollView addSubview:contentView];
    _contentView = contentView;
    
    
    TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    agreementLbl.delegate = self;
    agreementLbl.font = [UIFont systemFontOfSize:11.f];
    agreementLbl.textColor = [UIColor colorWithHexString:@"282828"];
    agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
    agreementLbl.userInteractionEnabled = YES;
    agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"c2a79d"];
    agreementLbl.numberOfLines = 0;
    agreementLbl.linkAttributes = nil;
    [agreementLbl setText:@"已阅读并同意服务协议" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(mutableAttributedString.length-4,4);
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"f9384c"] CGColor] range:stringRange];
        return mutableAttributedString;
    }];
    
    [agreementLbl addLinkToURL:[NSURL URLWithString:kURLRecharge] withRange:NSMakeRange([agreementLbl.text length]-4,4)];
    [agreementLbl sizeToFit];
    agreementLbl.frame = CGRectMake((scrollView.bounds.size.width-agreementLbl.bounds.size.width)/2+16, scrollView.bounds.size.height-27-agreementLbl.bounds.size.height, agreementLbl.bounds.size.width, agreementLbl.bounds.size.height);
    [scrollView addSubview:agreementLbl];
    
    CommandButton *agreeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(agreementLbl.frame.origin.x-30, agreementLbl.frame.origin.y-(40.f-agreementLbl.bounds.size.height)/2-1, 40, 40)];
    agreeBtn.selected = YES;
    [agreeBtn setImage:[UIImage imageNamed:@"login_check_new.png"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"login_checked_new.png"] forState:UIControlStateSelected];
    [scrollView addSubview:agreeBtn];
    _agreeBtn = agreeBtn;
    
    agreeBtn.handleClickBlock = ^(CommandButton *sender) {
        sender.selected = !sender.selected;
    };
    
    if (!_isForBindPhoneNumber) {
        CGFloat marginTop = agreeBtn.top-112.5f;
        
        UILabel *loginViaThirdPartyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        loginViaThirdPartyLbl.font = [UIFont systemFontOfSize:12.f];
        loginViaThirdPartyLbl.textColor = [UIColor colorWithHexString:@"686868"];
        loginViaThirdPartyLbl.text = @"第三方登陆";
        [loginViaThirdPartyLbl sizeToFit];
        loginViaThirdPartyLbl.frame  = CGRectMake((scrollView.width-loginViaThirdPartyLbl.width)/2, marginTop, loginViaThirdPartyLbl.width, loginViaThirdPartyLbl.height);
        [scrollView addSubview:loginViaThirdPartyLbl];
        
        CALayer *leftLine = [CALayer layer];
        leftLine.frame = CGRectMake(0, loginViaThirdPartyLbl.top+loginViaThirdPartyLbl.height/2-0.5, loginViaThirdPartyLbl.left-16, 0.5);
        leftLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [scrollView.layer addSublayer:leftLine];
        
        CALayer *rightLine = [CALayer layer];
        rightLine.frame = CGRectMake(loginViaThirdPartyLbl.right+16, loginViaThirdPartyLbl.top+loginViaThirdPartyLbl.height/2-0.5, scrollView.width-(loginViaThirdPartyLbl.right+16), 0.5);
        rightLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [scrollView.layer addSublayer:rightLine];
        
        marginTop += loginViaThirdPartyLbl.height;
        marginTop += 20;
        
        CGFloat width = 63;
        CGFloat sepWidth = (scrollView.width-3*63)/4;
        CGFloat marginLeft2 = sepWidth;
        
        if (![TencentOAuth iphoneQQInstalled]) {
            marginLeft2 = (scrollView.width-2*63-sepWidth)/2;
        }
        
        CommandButton *loginWithWXBtn = [[CommandButton alloc] initWithFrame:CGRectMake(marginLeft2, marginTop, width, width)];
        [loginWithWXBtn setImage:[UIImage imageNamed:@"login_icon_wechat_default"] forState:UIControlStateNormal];
        [scrollView addSubview:loginWithWXBtn];
        
        marginLeft2 += loginWithWXBtn.width;
        marginLeft2 += sepWidth;
        
        CommandButton *loginWithWeiboBtn = [[CommandButton alloc] initWithFrame:CGRectMake(marginLeft2, marginTop, width, width)];
        [loginWithWeiboBtn setImage:[UIImage imageNamed:@"login_icon_weibo_default"] forState:UIControlStateNormal];
        [scrollView addSubview:loginWithWeiboBtn];
        
        marginLeft2 += loginWithWeiboBtn.width;
        marginLeft2 += sepWidth;
        
        CommandButton *loginWithQQBtn = [[CommandButton alloc] initWithFrame:CGRectMake(marginLeft2, marginTop, width, width)];
        [loginWithQQBtn setImage:[UIImage imageNamed:@"login_icon_qq_default"] forState:UIControlStateNormal];
        [scrollView addSubview:loginWithQQBtn];
        
        marginTop += width;
        marginTop += 20;
        
        if (![TencentOAuth iphoneQQInstalled]) {
            loginWithQQBtn.hidden = YES;
        }
        
        WEAKSELF;
        void(^loginBlock)(UMSocialAccountEntity *snsAccount, NSString *platform) = ^(UMSocialAccountEntity *snsAccount, NSString *platform){
            //            ConfirmLoginWithThirdPartyViewController *viewController = [[ConfirmLoginWithThirdPartyViewController alloc] init];
            //            viewController.title = @"进入爱丁猫";
            //            viewController.snsAccount = snsAccount;
            //            [weakSelf pushViewController:viewController animated:YES];
            
            ThirdPartyAccountInfo *accountInfo = [[ThirdPartyAccountInfo alloc] init];
            accountInfo.platform = platform;
            accountInfo.uid = snsAccount.usid;
            accountInfo.username = snsAccount.userName;
            accountInfo.icon_url = snsAccount.iconURL;
            accountInfo.xuid = snsAccount.unionId;
            if (!accountInfo.xuid) {
                accountInfo.xuid = accountInfo.uid;
            }
            [weakSelf showProcessingHUD:nil];
            
            [AuthService third_party_login:accountInfo completion:^(NSDictionary *data) {
                NSString *phoneNumber = @"";
                NSDictionary *userDict = [data dictionaryValueForKey:@"user"];
                if ([userDict isKindOfClass:[NSDictionary class]]) {
                    phoneNumber = [userDict stringValueForKey:@"phone"];
                }
                [[Session sharedInstance] setLoginInfo:phoneNumber data:data];
                
                EMAccount *account = [Session sharedInstance].emAccount;
                if (account && [account.emUserName length]>0) {
                    [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                        
                        [weakSelf hideHUD];
                        //                [weakSelf dismiss];
                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } failure:^(XMError *error) {
                        [weakSelf hideHUD];
                        
                        //                [weakSelf dismiss];
                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                } else {
                    [weakSelf hideHUD];
                    //            [weakSelf dismiss];
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
            }];
        };
        
        loginWithWXBtn.handleClickBlock = ^(CommandButton *sender) {
            if (!weakSelf.agreeBtn.selected) {
                [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
                return;
            }
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginWithThridParty:weakSelf platformName:UMShareToWechatSession completion:^(UMSocialAccountEntity *snsAccount) {
                loginBlock(snsAccount,@"weixin");
            }];
        };
        loginWithWeiboBtn.handleClickBlock = ^(CommandButton *sender) {
            if (!weakSelf.agreeBtn.selected) {
                [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
                return;
            }
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginWithThridParty:weakSelf platformName:UMShareToSina completion:^(UMSocialAccountEntity *snsAccount) {
                loginBlock(snsAccount,@"weibo");
            }];
        };
        loginWithQQBtn.handleClickBlock = ^(CommandButton *sender) {
            if (!weakSelf.agreeBtn.selected) {
                [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
                return;
            }
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginWithThridParty:weakSelf platformName:UMShareToQQ completion:^(UMSocialAccountEntity *snsAccount) {
                loginBlock(snsAccount,@"qq");
            }];
        };
    }
    
    [self.view bringSubviewToFront:self.topBar];
    
    
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
    
    [self.scrollView setFrame:CGRectMake(0, self.topBarHeight, self.scrollView.bounds.size.width, kScreenHeight-self.topBarHeight)];
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    UITextField *phoneNumberTextField = (UITextField*)[self.contentView viewWithTag:100];
    //    [phoneNumberTextField becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.title = @"服务协议";
    viewController.url = [url absoluteString];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIView *)buildContentViewRevise {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    contentView.backgroundColor = [UIColor grayColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor blackColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.placeholder = _isForBindPhoneNumber?@"输入手机号":@"输入手机号注册或登录";
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.textColor = [UIColor colorWithHexString:@"282828"];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.tag = 100;
    textField.delegate = self;
    
    [contentView addSubview:textField];
    [contentView addSubview:lineView];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.equalTo(textField.mas_left);
        make.right.equalTo(textField.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    return contentView;
}



//登录页面View
- (UIView*)buildContentView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    
    CGFloat marginTop = 0.f;
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, contentView.bounds.size.width, 60)];
    bgView1.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [contentView addSubview:bgView1];
    
    CGFloat marginLeft = 0.f;
    marginLeft += 23;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_id.png"]];
    CGFloat Y = bgView1.frame.origin.y+(bgView1.bounds.size.height-imageView.bounds.size.height)/2;
    imageView.frame = CGRectMake(marginLeft, Y, imageView.bounds.size.width, imageView.bounds.size.height);
    [contentView addSubview:imageView];
    
    marginLeft = 55;
    
    
    UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectMake(marginLeft, bgView1.frame.origin.y, bgView1.bounds.size.width-marginLeft, bgView1.bounds.size.height)];
    textField.placeholder = _isForBindPhoneNumber?@"输入手机号":@"输入手机号注册或登录";
    
    //            [textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = [UIFont systemFontOfSize:17.f];
    textField.textColor = [UIColor colorWithHexString:@"282828"];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.tag = 100;
    textField.delegate = self;
    [contentView addSubview:textField];
    
    marginTop += bgView1.height;
    marginTop += 40;
    
    
    CommandButton *loginBtn = [[CommandButton alloc] initWithFrame:CGRectMake((contentView.width-160)/2, marginTop, 160, 50)];
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=15;    //最重要的是这个地方要设成imgview高的一半
    loginBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];//[UIColor colorWithHexString:@"D0B87F"];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [contentView addSubview:loginBtn];
    
    marginTop += loginBtn.height;
    marginTop += 20.f;
    
    contentView.frame = CGRectMake(0, marginTop, self.view.bounds.size.width, marginTop);
    
    
    WEAKSELF;
    loginBtn.handleClickBlock = ^(CommandButton *sender) {
        if (!weakSelf.agreeBtn.selected) {
            [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
            return;
        }
        
        UITextField *phoneNumberTextField = (UITextField*)[weakSelf.contentView viewWithTag:100];
        
        NSString *phoneNumber = [phoneNumberTextField.text trim];
        
        if (![phoneNumber isValidMobilePhoneNumber]) {
            [super showHUD:@"请输入正确的手机号" hideAfterDelay:0.8f forView:self.view];
            return;
        }
        [weakSelf.view endEditing:YES];
        
        [weakSelf showProcessingHUD:nil];
        [AuthService checkPhone:phoneNumber completion:^(BOOL isExist) {
            [weakSelf hideHUD];
            if (weakSelf.isForBindPhoneNumber) {
                if (isExist) {
                    [weakSelf showHUD:@"该手机号已注册, 请绑定其他号码" hideAfterDelay:1.2f];
                } else {
                    NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",textField.text];
                    [WCAlertView showAlertWithTitle:@"确认手机号码"
                                            message:message
                                 customizationBlock:^(WCAlertView *alertView) {
                                     alertView.style = WCAlertViewStyleWhite;
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex == 0) {
                                         
                                     } else {
                                         [weakSelf showProcessingHUD:nil];
                                         weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:phoneNumber type:CaptchaTypeBindPhone sms_type:0 completion:^{
                                             [weakSelf hideHUD];
                                             
                                             VerifyCaptchaCodeViewController *newViewController = [[VerifyCaptchaCodeViewController alloc] init];
                                             newViewController.phoneNumber = phoneNumber;
                                             newViewController.captchaType = CaptchaTypeBindPhone;
                                             newViewController.verifyCaptchaCodeDoneBlock = ^(VerifyCaptchaCodeViewController *viewController, NSString *phoneNumber, NSString *captcha) {
                                                 ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc] init];
                                                 __weak __typeof(resetPasswordViewController) weak_resetPasswordViewController = resetPasswordViewController;
                                                 resetPasswordViewController.title = @"设置密码";
                                                 resetPasswordViewController.btnText = @"绑定";
                                                 resetPasswordViewController.phoneNumber = phoneNumber;
                                                 resetPasswordViewController.captcha = captcha;
                                                 resetPasswordViewController.isResetPassword = NO;
                                                 resetPasswordViewController.resetPasswordDoneBlock = ^(ResetPasswordViewController *viewController,NSString *password) {
                                                     [weak_resetPasswordViewController showProcessingHUD:nil];
                                                     [AuthService binding:phoneNumber password:password auth_code:captcha invitationCode:nil completion:^(NSDictionary *data) {
                                                         [[Session sharedInstance] bindingPhone:phoneNumber];
                                                         [weak_resetPasswordViewController hideHUD];
                                                         [weak_resetPasswordViewController.view endEditing:YES];
                                                         [weak_resetPasswordViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                     } failure:^(XMError *error) {
                                                         [weak_resetPasswordViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                                     }];
                                                 };
                                                 [weakSelf.navigationController pushViewController:resetPasswordViewController animated:YES];
                                                 
                                             };
                                             [weakSelf.navigationController pushViewController:newViewController animated:YES];
                                             
                                         } failure:^(XMError *error) {
                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
                                         }];
                                     }
                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                }
            } else {
                if (isExist) {
                    LoginViewController *viewController = [[LoginViewController alloc] init];
                    viewController.phoneNumber = phoneNumber;
                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                } else {
                    NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",textField.text];
                    [WCAlertView showAlertWithTitle:@"确认手机号码"
                                            message:message
                                 customizationBlock:^(WCAlertView *alertView) {
                                     alertView.style = WCAlertViewStyleWhite;
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex == 0) {
                                         
                                     } else {
                                         [weakSelf showProcessingHUD:nil];
                                         weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:textField.text type:CaptchaTypeRegistry sms_type:0 completion:^{
                                             [weakSelf hideHUD];
                                             
                                             VerifyCaptchaCodeViewController *newViewController = [[VerifyCaptchaCodeViewController alloc] init];
                                             newViewController.phoneNumber = phoneNumber;
                                             newViewController.captchaType = CaptchaTypeRegistry;
                                             newViewController.verifyCaptchaCodeDoneBlock = ^(VerifyCaptchaCodeViewController *viewController, NSString *phoneNumber, NSString *captcha) {
                                                 
                                                 ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc] init];
                                                 __weak __typeof(resetPasswordViewController) weak_resetPasswordViewController = resetPasswordViewController;
                                                 resetPasswordViewController.title = @"设置密码";
                                                 resetPasswordViewController.btnText = @"进入爱丁猫";
                                                 resetPasswordViewController.phoneNumber = phoneNumber;
                                                 resetPasswordViewController.captcha = captcha;
                                                 resetPasswordViewController.isResetPassword = NO;
                                                 resetPasswordViewController.resetPasswordDoneBlock = ^(ResetPasswordViewController *viewController,NSString *password) {
                                                     [weak_resetPasswordViewController showProcessingHUD:nil];
                                                     weakSelf.request = [[NetworkAPI sharedInstance] registerNewAccount:phoneNumber captchaCode:captcha userName:@"" password:password completion:^(NSDictionary *data){
                                                         [[Session sharedInstance] setRegisterInfo:phoneNumber data:data];
                                                         EMAccount *account = [Session sharedInstance].emAccount;
                                                         if (account && [account.emUserName length]>0) {
                                                             [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                                                                 [weak_resetPasswordViewController hideHUD];
                                                                 [weak_resetPasswordViewController.view endEditing:YES];
                                                                 [weak_resetPasswordViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                             } failure:^(XMError *error) {
                                                                 [weak_resetPasswordViewController hideHUD];
                                                                 [weak_resetPasswordViewController.view endEditing:YES];
                                                                 [weak_resetPasswordViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                             }];
                                                         } else {
                                                             [weak_resetPasswordViewController hideHUD];
                                                             [weak_resetPasswordViewController.view endEditing:YES];
                                                             [weak_resetPasswordViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                         }
                                                     } failure:^(XMError *error) {
                                                         [weak_resetPasswordViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                                     }];
                                                     
                                                     //                                                 RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
                                                     //                                                 registerViewController.title = @"设置头像";
                                                     //                                                 registerViewController.phoneNumber = phoneNumber;
                                                     //                                                 registerViewController.captcha = captcha;
                                                     //                                                 registerViewController.password = password;
                                                     //                                                 registerViewController.registerDoneBlock = ^(RegisterViewController *viewController) {
                                                     //                                                     [weakSelf.view endEditing:YES];
                                                     //                                                     [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                     //                                                 };
                                                     //                                                 [weakSelf.navigationController pushViewController:registerViewController animated:YES];
                                                 };
                                                 [weakSelf.navigationController pushViewController:resetPasswordViewController animated:YES];
                                                 
                                             };
                                             [weakSelf.navigationController pushViewController:newViewController animated:YES];
                                             
                                         } failure:^(XMError *error) {
                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
                                         }];
                                     }
                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                }
            }
            
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    };
    
    return contentView;
}

- (void)handleRegBtnClicked:(UIButton*)sender
{
    //    WEAKSELF;
    //    __block NSString *phoneNumber = self.phoneNumber;
    //
    //
    //    _request = [[NetworkAPI sharedInstance] registerNewAccount:phoneNumber captchaCode:self.captcha userName:userName password:self.password avatarFilePath:self.avatarFilePath completion:^(NSDictionary *data){
    //        [[Session sharedInstance] setRegisterInfo:phoneNumber data:data];
    //
    //        //        [weakSelf hideHUD];
    //        //        if (weakSelf.registerDoneBlock) {
    //        //            weakSelf.registerDoneBlock(weakSelf);
    //        //        }
    //
    //        EMAccount *account = [Session sharedInstance].emAccount;
    //        if (account && [account.emUserName length]>0) {
    //            [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
    //                [weakSelf hideHUD];
    //
    //            } failure:^(XMError *error) {
    //                [weakSelf hideHUD];
    //            }];
    //        } else {
    //            [weakSelf hideHUD];
    //        }
    //    } failure:^(XMError *error) {
    //        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.contentView];
    //    }];
}


@end


#import "UIImage+Addtions.h"

@implementation ConfirmLoginWithThirdPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.title];
    [super setupTopBarBackButton];
    
    CGFloat marginTop = topBarHeight+40;
    
    XMWebImageView *avatarView = [[XMWebImageView alloc] initWithFrame:CGRectMake((self.view.width-65)/2,marginTop, 65, 65)];
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.layer.masksToBounds=YES;
    avatarView.layer.cornerRadius=avatarView.bounds.size.height/2;
    avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
    avatarView.userInteractionEnabled = YES;
    avatarView.clipsToBounds = YES;
    [self.view addSubview:avatarView];
    [avatarView setImageWithURL:self.snsAccount.iconURL placeholderImage:[UIImage imageNamed:@"placeholder_mine"] XMWebImageScaleType:XMWebImageScale160x160];
    
    marginTop += avatarView.height;
    marginTop += 10;
    
    UILabel *nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    nickNameLbl.font = [UIFont boldSystemFontOfSize:15.f];
    nickNameLbl.textColor = [UIColor colorWithHexString:@"181818"];
    nickNameLbl.textAlignment = NSTextAlignmentCenter;
    nickNameLbl.text = self.snsAccount.userName;
    [nickNameLbl sizeToFit];
    nickNameLbl.frame = CGRectMake(15, marginTop, kScreenWidth-15-15, nickNameLbl.bounds.size.height);
    [self.view addSubview:nickNameLbl];
    
    marginTop += nickNameLbl.height;
    marginTop += 40;
    
    UILabel *noticeTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 0)];
    noticeTitleLbl.font = [UIFont boldSystemFontOfSize:13.f];
    noticeTitleLbl.textColor = [UIColor colorWithHexString:@"282828"];
    noticeTitleLbl.textAlignment = NSTextAlignmentLeft;
    noticeTitleLbl.text = @"登陆后该应用将获得以下权限";
    [noticeTitleLbl sizeToFit];
    noticeTitleLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, noticeTitleLbl.height);
    [self.view addSubview:noticeTitleLbl];
    
    marginTop += noticeTitleLbl.height;
    marginTop += 6;
    
    UIImage *icon = [UIImage imageNamed:@"shopping_cart_choosed"];
    UIImage *resizedIcon = [icon scaleToSize:CGSizeMake(icon.size.width*3/5, icon.size.width*3/5)];
    UIButton *noticeLbl = [[UIButton alloc] initWithFrame:CGRectZero];
    noticeLbl.enabled = NO;
    [noticeLbl setTitle:@"获得你的公开信息（昵称、头像等）" forState:UIControlStateDisabled];
    [noticeLbl setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    [noticeLbl setImage:resizedIcon forState:UIControlStateDisabled];
    noticeLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    noticeLbl.titleLabel.font = [UIFont boldSystemFontOfSize:11.f];
    noticeLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [noticeLbl sizeToFit];
    noticeLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, noticeLbl.height);
    [self.view addSubview:noticeLbl];
    
    
    marginTop += noticeLbl.height;
    marginTop += 20;
    
    CommandButton *confirmBtn = [[CommandButton alloc] initWithFrame:CGRectMake((self.view.width-160)/2, marginTop, 160, 50)];
    confirmBtn.layer.masksToBounds=YES;
    confirmBtn.layer.cornerRadius=15;    //最重要的是这个地方要设成imgview高的一半
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];//[UIColor colorWithHexString:@"D0B87F"];
    [confirmBtn setTitle:@"确认登陆" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:confirmBtn];
    
    
    WEAKSELF;
    confirmBtn.handleClickBlock = ^(CommandButton *sender) {
        UMSocialAccountEntity *snsAccount = weakSelf.snsAccount;
        ThirdPartyAccountInfo *accountInfo = [[ThirdPartyAccountInfo alloc] init];
        accountInfo.platform = snsAccount.platformName;
        accountInfo.uid = snsAccount.usid;
        accountInfo.username = snsAccount.userName;
        accountInfo.icon_url = snsAccount.iconURL;
        accountInfo.xuid = snsAccount.unionId;
        if (!accountInfo.xuid) {
            accountInfo.xuid = accountInfo.uid;
        }
        
        [weakSelf showProcessingHUD:nil];
        
        [AuthService third_party_login:accountInfo completion:^(NSDictionary *data) {
            NSString *phoneNumber = @"";
            NSDictionary *userDict = [data dictionaryValueForKey:@"user"];
            if ([userDict isKindOfClass:[NSDictionary class]]) {
                phoneNumber = [userDict stringValueForKey:@"phone"];
            }
            [[Session sharedInstance] setLoginInfo:phoneNumber data:data];
            
            EMAccount *account = [Session sharedInstance].emAccount;
            if (account && [account.emUserName length]>0) {
                [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                    
                    [weakSelf hideHUD];
                    //                [weakSelf dismiss];
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                } failure:^(XMError *error) {
                    [weakSelf hideHUD];
                    //                [weakSelf dismiss];
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
            } else {
                [weakSelf hideHUD];
                //            [weakSelf dismiss];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
        }];
    };
    //[weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end


@interface LoginViewController () <UITextFieldDelegate,TTTAttributedLabelDelegate,UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic, strong) UIButton *agreeBtn;

#if DEBUG
@property(nonatomic, assign) NSInteger debugCnt;
@property(nonatomic, strong) UILabel *serverLabel;
@property(nonatomic, strong) UITextField *serverTextField;
@property(nonatomic, strong) UIButton *changeServerBtn;
@property(nonatomic, strong) UIButton *changeBtn;
#endif

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *textFieldSecret;
@property (nonatomic, strong) TTTAttributedLabel *agreementLbl;
@property (nonatomic, assign) BOOL isForBindPhoneNumber;
@property (nonatomic, strong) UILabel *loginViaThirdPartyLbl;
@property (nonatomic, strong) UIView *bgViewbg;

@property (nonatomic, strong) XMWebImageView *forntThirdImageView;
@end

@implementation LoginViewController

-(XMWebImageView *)forntThirdImageView{
    if (!_forntThirdImageView) {
        _forntThirdImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _forntThirdImageView.image = [UIImage imageNamed:@"FrontThirdLogIn"];
        [_forntThirdImageView sizeToFit];
    }
    return _forntThirdImageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isForBindPhoneNumber = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    //    CGFloat topBarHeight = [super setupTopBar];
    //    [super setupTopBarTitle:self.title?self.title:@"登录爱丁猫"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"back_Log_MF"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"back_Log_MF"] imgPressed:nil];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;//_scrollView.bounds.size.height/8;
//    self.contentView.frame = frame;
    [_scrollView addSubview:self.contentView];
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, _contentView.height)];
    
    //防止scrollView滑动
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
                                 
                                 CGFloat visibleHeight = weakSelf.view.bounds.size.height-keyboardHeight;
                                 
                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
                                 
                                 if (visibleHeight<contentY+contentHeight+15) {
                                     targetEndY = contentY-15;
                                     
                                     [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, contentY+contentHeight)];
                                     if (IS_IPHONE_5) {
                                         [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-kScreenHeight/5-40, 0, 0, 0)];
                                     } else {
                                         [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-kScreenHeight/5+15, 0, 0, 0)];
                                     }
                                     [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height+contentY+15+(contentHeight-visibleHeight))];
                                 } else {
                                     if (IS_IPHONE_5) {
                                         [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-kScreenHeight/5-40, 0, 0, 0)];
                                     } else {
                                         [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-kScreenHeight/5+15, 0, 0, 0)];
                                     }
                                 }
                             } else {
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, weakSelf.view.bounds.size.height-weakSelf.scrollView.frame.origin.y)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.contentView.bounds.size.height)];
                             }
                         }
                         completion:nil];
    };
    
    _scrollView.keyboardDidChange = ^(BOOL didShowed) {
        
    };
    
    [self setupForDismissKeyboard];
    
#if DEBUG
    _debugCnt = 0;
#endif
    
}

- (void)handleAgreeBtnClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
#if DEBUG
    if((++_debugCnt) == 5) {
        _serverLabel.hidden = NO;
        _serverTextField.hidden = NO;
        _changeBtn.hidden = NO;
    }
    //    WebViewController *vc = [[WebViewController alloc] init];
    //    vc.url = @"http://192.168.2.157:8080/examples/1.html";
    //    [self.navigationController pushViewController:vc animated:YES];
    
#endif
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //    [self.scrollView setFrame:CGRectMake(0, self.topBarHeight, self.scrollView.bounds.size.width, kScreenHeight-self.topBarHeight)];
    //    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    UITextField *passwordTextField = (UITextField*)[self.contentView viewWithTag:200];
    //    UITextField *textField = (UITextField *)[self.contentView viewWithTag:100];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [textField becomeFirstResponder];
    //    });
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.title = @"服务协议";
    viewController.url = [url absoluteString];
    [self.navigationController pushViewController:viewController animated:YES];
}

//修改登录布局
- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        CGFloat marginTop = 0.f;
        
        {
            
            {
                marginTop += 90;
                
                UILabel * welLabel = [[UILabel alloc] init];
                welLabel.text = @"您好, 请登录/注册";
                welLabel.font = [UIFont boldSystemFontOfSize:30];
                [welLabel sizeToFit];
                welLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
                [self.contentView addSubview:welLabel];
                [welLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView.mas_top).offset(90);
                    make.right.equalTo(self.contentView.mas_right).offset(-25);
                    make.left.equalTo(self.contentView.mas_left).offset(25);
                }];
                marginTop += welLabel.height;
                marginTop += 5;
                
                UILabel * welfareLbl = [[UILabel alloc] init];
                welfareLbl.text = @"新人专享88优惠";
                welfareLbl.font = [UIFont systemFontOfSize:16];
                welfareLbl.textColor = [UIColor colorWithHexString:@"888888"];
                [welfareLbl sizeToFit];
                [self.contentView addSubview:welfareLbl];
                [welfareLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(welLabel.mas_bottom).offset(5);
                    make.right.equalTo(self.contentView.mas_right).offset(-25);
                    make.left.equalTo(self.contentView.mas_left).offset(25);
                }];
                marginTop += welfareLbl.height;
                marginTop += 80;
            }
            
            {
                
                UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectZero];                    textField.placeholder = @"输入11位手机号";
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"e5e5e5"];
                NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"输入11位手机号" attributes:dict];
                [textField setAttributedPlaceholder:attribute];
                textField.font = [UIFont systemFontOfSize:14.f];
                textField.textColor = [UIColor colorWithHexString:@"1a1a1a"];
                textField.textAlignment = NSTextAlignmentLeft;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.leftViewMode = UITextFieldViewModeAlways;
                textField.tintColor = [UIColor colorWithHexString:@"1a1a1a"];
                UIImageView *imageView1 = [[UIImageView alloc] init];
                imageView1.image = [UIImage imageNamed:@"LogIn_Phone_MF"];
                [imageView1 sizeToFit];
                textField.leftView = imageView1;
                textField.tag = 100;
                textField.delegate = self;
                self.textField = textField;
                [_contentView addSubview:textField];
                
                UIView * bottomLine = [[UIView alloc] init];
                bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
                [_contentView addSubview:bottomLine];
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView.mas_top).offset(marginTop);
                    make.left.equalTo(self.contentView.mas_left).offset(20);
                    make.right.equalTo(self.contentView.mas_right).offset(-20);
                }];
                marginTop += 20;
                marginTop += 10;
                [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentView.mas_top).offset(marginTop);
                    make.left.equalTo(self.contentView.mas_left).offset(20);
                    make.right.equalTo(self.contentView.mas_right).offset(-20);
                    make.height.mas_equalTo(@0.5);
                }];
                marginTop += 0.5;
            }
            
            marginTop += 30;
            
            {
                
                UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectZero];                    textField.placeholder = @"请输入密码";
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"e5e5e5"];
                NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:dict];
                [textField setAttributedPlaceholder:attribute];
                textField.font = [UIFont systemFontOfSize:14.f];
                textField.textColor = [UIColor colorWithHexString:@"1a1a1a"];
                textField.textAlignment = NSTextAlignmentLeft;
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.leftViewMode = UITextFieldViewModeAlways;
                textField.tintColor = [UIColor colorWithHexString:@"1a1a1a"];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageNamed:@"LogIn_Secret_MF"];
                [imageView sizeToFit];
                textField.leftView = imageView;
                textField.tag = 200;
                textField.delegate = self;
                textField.secureTextEntry = YES;
                [_contentView addSubview:textField];
                
                
                UIView * bottomLine = [[UIView alloc] init];
                bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
                [_contentView addSubview:bottomLine];
                
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentView.mas_top).offset(marginTop);
                    make.left.equalTo(self.contentView.mas_left).offset(20);
                    make.right.equalTo(self.contentView.mas_right).offset(-20);
                }];
                marginTop += 20;
                marginTop += 10;
                [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentView.mas_top).offset(marginTop);
                    make.left.equalTo(self.contentView.mas_left).offset(20);
                    make.right.equalTo(self.contentView.mas_right).offset(-20);
                    make.height.mas_equalTo(@1);
                }];
                marginTop += 1;
            }
            
            marginTop += 10;
            
            {
                TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];                    agreementLbl.delegate = self;
                agreementLbl.font = [UIFont systemFontOfSize:11.f];
                agreementLbl.textColor = [UIColor colorWithHexString:@"888888"];
                agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
                agreementLbl.userInteractionEnabled = YES;
                agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"c2a79d"];
                agreementLbl.numberOfLines = 0;
                agreementLbl.linkAttributes = nil;
                [agreementLbl setText:@"已阅读并同意服务协议" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange stringRange = NSMakeRange(mutableAttributedString.length-4,4);
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"f9384c"] CGColor] range:stringRange];
                    return mutableAttributedString;
                }];
                
                [agreementLbl addLinkToURL:[NSURL URLWithString:kURLAgreement] withRange:NSMakeRange([agreementLbl.text length]-4,4)];
                [agreementLbl sizeToFit];
                agreementLbl.frame = CGRectZero;
                [self.contentView addSubview:agreementLbl];
                
                
                _agreeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
                _agreeBtn.selected = YES;
                [_agreeBtn setImage:[UIImage imageNamed:@"login_check_new.png"] forState:UIControlStateNormal];
                [_agreeBtn setImage:[UIImage imageNamed:@"login_checked_new.png"] forState:UIControlStateSelected];
                [_agreeBtn addTarget:self action:@selector(handleAgreeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_agreeBtn];
                [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left).offset(3);
                    make.top.equalTo(self.contentView.mas_top).offset(marginTop);
                    make.width.equalTo(@45);
                    make.height.equalTo(@45);
                }];
                
                [agreementLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_agreeBtn.mas_centerY);
                    make.left.equalTo(_agreeBtn.mas_right).offset(-10);
                }];
                marginTop += 45;
            }
            
            
            UIButton *forgotBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            [forgotBtn addTarget:self action:@selector(handleForgotClick:) forControlEvents:UIControlEventTouchUpInside];
            [forgotBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
            [forgotBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
            forgotBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [forgotBtn sizeToFit];
            forgotBtn.frame = CGRectZero;
            [_contentView addSubview:forgotBtn];
            
            UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            [regBtn setTitle:@"注册" forState:UIControlStateNormal];
            [regBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
            regBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [regBtn addTarget:self action:@selector(handleRegClick:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:regBtn];
            
            UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            loginBtn.layer.masksToBounds = YES;
            loginBtn.layer.cornerRadius = 5;
            loginBtn.backgroundColor = [DataSources colorf9384c];
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
            [loginBtn addTarget:self action:@selector(handleLoginClick:) forControlEvents:UIControlEventTouchUpInside];
            loginBtn.userInteractionEnabled = YES;
            [_contentView addSubview:loginBtn];
            
            [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(marginTop);
                make.left.equalTo(self.contentView.mas_left).offset(20);
                make.right.equalTo(self.contentView.mas_right).offset(-20);
                make.height.equalTo(@50);
            }];
            
            marginTop += 50;
            
            [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(loginBtn.mas_bottom).offset(25);
                make.left.equalTo(loginBtn.mas_left);
            }];
            
            [forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(regBtn.mas_centerY);
                make.right.equalTo(loginBtn.mas_right);
            }];
            marginTop += 20;
            marginTop += 80;
            
            if (!_isForBindPhoneNumber) {

                CGFloat sepWidth = (self.contentView.width-3*63)/4;
                CGFloat marginLeft2 = sepWidth;
                
                if (![TencentOAuth iphoneQQInstalled]) {
                    marginLeft2 = (self.contentView.width-2*63-sepWidth)/2;
                }
                
                CommandButton *loginWithWXBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
                [loginWithWXBtn setImage:[UIImage imageNamed:@"LogIn_WX_New"] forState:UIControlStateNormal];
                [self.contentView addSubview:loginWithWXBtn];
                
                marginLeft2 += loginWithWXBtn.width;
                marginLeft2 += sepWidth;
                
                CommandButton *loginWithWeiboBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
                [loginWithWeiboBtn setImage:[UIImage imageNamed:@"LogIn_WB_New"] forState:UIControlStateNormal];
                [_contentView addSubview:loginWithWeiboBtn];
                
                marginLeft2 += loginWithWeiboBtn.width;
                marginLeft2 += sepWidth;
                
                CommandButton *loginWithQQBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
                [loginWithQQBtn setImage:[UIImage imageNamed:@"LogIn_QQ_New"] forState:UIControlStateNormal];
                [_contentView addSubview:loginWithQQBtn];
                
                if (![TencentOAuth iphoneQQInstalled]) {
                    loginWithQQBtn.hidden = YES;
                }
                
                [_contentView addSubview:self.forntThirdImageView];
                
                [loginWithQQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView.mas_top).offset(marginTop);
                    make.centerX.equalTo(self.contentView.mas_centerX);
                }];
                
                [loginWithWXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(loginWithQQBtn.mas_centerY);
                    make.right.equalTo(loginWithQQBtn.mas_left).offset(-28);
                }];
                
                [loginWithWeiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(loginWithQQBtn.mas_centerY);
                    make.left.equalTo(loginWithQQBtn.mas_right).offset(28);
                }];
                marginTop += loginWithQQBtn.imageView.image.size.height;
                
                NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
                if (type && type.length > 0) {
                    self.forntThirdImageView.hidden = NO;
                } else {
                    self.forntThirdImageView.hidden = YES;
                }
                [self.forntThirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(loginWithWXBtn.mas_bottom).offset(5);
                    if ([type isEqualToString:@"weixin"]) {
                        make.centerX.equalTo(loginWithWXBtn.mas_centerX);
                    } else if ([type isEqualToString:@"weibo"]) {
                        make.centerX.equalTo(loginWithWeiboBtn.mas_centerX);
                    } else if ([type isEqualToString:@"qq"]) {
                        make.centerX.equalTo(loginWithQQBtn.mas_centerX);
                    }
                }];
                marginTop += self.forntThirdImageView.image.size.height+10;
                
                
                
                WEAKSELF;
                void(^loginBlock)(UMSocialAccountEntity *snsAccount, NSString *platform) = ^(UMSocialAccountEntity *snsAccount, NSString *platform){
                    //            ConfirmLoginWithThirdPartyViewController *viewController = [[ConfirmLoginWithThirdPartyViewController alloc] init];
                    //            viewController.title = @"进入爱丁猫";
                    //            viewController.snsAccount = snsAccount;
                    //            [weakSelf pushViewController:viewController animated:YES];
                    
                    ThirdPartyAccountInfo *accountInfo = [[ThirdPartyAccountInfo alloc] init];
                    accountInfo.platform = platform;
                    accountInfo.uid = snsAccount.usid;
                    accountInfo.username = snsAccount.userName;
                    accountInfo.icon_url = snsAccount.iconURL;
                    accountInfo.xuid = snsAccount.unionId;
                    if (!accountInfo.xuid) {
                        accountInfo.xuid = accountInfo.uid;
                    }
                    
                    [weakSelf showProcessingHUD:nil];
                    
                    [AuthService third_party_login:accountInfo completion:^(NSDictionary *data) {
                        NSString *phoneNumber = @"";
                        NSDictionary *userDict = [data dictionaryValueForKey:@"user"];
                        if ([userDict isKindOfClass:[NSDictionary class]]) {
                            phoneNumber = [userDict stringValueForKey:@"phone"];
                        }
                        [[Session sharedInstance] setLoginInfo:phoneNumber data:data];
                        
                        EMAccount *account = [Session sharedInstance].emAccount;
                        if (account && [account.emUserName length]>0) {
                            [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                                [weakSelf hideHUD];
                                //                [weakSelf dismiss];
                                [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                                    if (phoneNumber && phoneNumber.length > 0) {
                                        
                                    } else {
                                        [weakSelf gotoBingController];
                                    }
                                }];
                            } failure:^(XMError *error) {
                                [weakSelf hideHUD];
                                
                                //                [weakSelf dismiss];
                                [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                                    if (phoneNumber && phoneNumber.length > 0) {
                                        
                                    } else {
                                        [weakSelf gotoBingController];
                                    }
                                }];
                            }];
                        } else {
                            [weakSelf hideHUD];
                            //            [weakSelf dismiss];
                            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                                if (phoneNumber && phoneNumber.length > 0) {
                                    
                                } else {
                                    [weakSelf gotoBingController];
                                }
                            }];
                        }
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
                    }];
                };
                
                loginWithWXBtn.handleClickBlock = ^(CommandButton *sender) {
                    if (!weakSelf.agreeBtn.selected) {
                        [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
                        return;
                    }
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate loginWithThridParty:weakSelf platformName:UMShareToWechatSession completion:^(UMSocialAccountEntity *snsAccount) {
                        loginBlock(snsAccount,@"weixin");
                        [[NSUserDefaults standardUserDefaults] setObject:@"weixin" forKey:@"type"];
                    }];
                };
                loginWithWeiboBtn.handleClickBlock = ^(CommandButton *sender) {
                    if (!weakSelf.agreeBtn.selected) {
                        [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
                        return;
                    }
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate loginWithThridParty:weakSelf platformName:UMShareToSina completion:^(UMSocialAccountEntity *snsAccount) {
                        loginBlock(snsAccount,@"weibo");
                        [[NSUserDefaults standardUserDefaults] setObject:@"weibo" forKey:@"type"];
                    }];
                };
                loginWithQQBtn.handleClickBlock = ^(CommandButton *sender) {
                    if (!weakSelf.agreeBtn.selected) {
                        [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:1.2f];
                        return;
                    }
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate loginWithThridParty:weakSelf platformName:UMShareToQQ completion:^(UMSocialAccountEntity *snsAccount) {
                        loginBlock(snsAccount,@"qq");
                        [[NSUserDefaults standardUserDefaults] setObject:@"qq" forKey:@"type"];
                    }];
                };
                
                
            }
        }
        
        
        
        
        
        
        
        
        CommandButton *closeBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [closeBtn setImage:[UIImage imageNamed:@"LogIn_Close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView.mas_top).offset(35);
            make.left.equalTo(_contentView.mas_left).offset(25);
        }];
        
        //        WEAKSELF;
        //        closeBtn.handleClickBlock = ^(CommandButton *sender){
        ////            [weakSelf dismiss];
        //
        //        };
        
        //
#if DEBUG
//        marginTop += 20;
        _serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        _serverLabel.font = [UIFont systemFontOfSize:11.f];
        _serverLabel.textColor = [UIColor colorWithHexString:@"282828"];
        _serverLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _serverLabel.numberOfLines = 0;
        _serverLabel.text = @"当前服务器地址为如下";
        [_serverLabel sizeToFit];
        
        _serverLabel.frame = CGRectMake((_contentView.bounds.size.width-_serverLabel.bounds.size.width)/2,
                                        marginTop,
                                        _serverLabel.bounds.size.width,
                                        _serverLabel.bounds.size.height);
        
        [_contentView addSubview:_serverLabel];
        
        _serverLabel.hidden = YES;
        
//        marginTop += _serverLabel.bounds.size.height;
//        marginTop += 20;
        
        _serverTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,marginTop , _contentView.bounds.size.width, 60)];
        _serverTextField.placeholder = [Session sharedInstance].debugServerUrl;
        _serverTextField.font = [UIFont systemFontOfSize:17.f];
        _serverTextField.textColor = [UIColor colorWithHexString:@"282828"];
        _serverTextField.textAlignment = NSTextAlignmentLeft;
        _serverTextField.keyboardType = UIKeyboardTypeURL;
        _serverTextField.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _serverTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _serverTextField.tag = 400;
        _serverTextField.delegate = self;
        _serverTextField.returnKeyType = UIReturnKeyDone;
        [_contentView addSubview:_serverTextField];
        
        _serverTextField.hidden = YES;
        
        _changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _contentView.bounds.size.width, 0)];
        [_changeBtn addTarget:self action:@selector(handleChangeUrlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_changeBtn sizeToFit];
        _changeBtn.frame = CGRectMake(_contentView.bounds.size.width-20.5-_changeBtn.bounds.size.width, marginTop ,
                                      _changeBtn.bounds.size.width, _serverTextField.bounds.size.height);
        [_contentView addSubview:_changeBtn];
        _changeBtn.hidden = YES;
        
//        marginTop += _serverTextField.bounds.size.height;
        
#endif
        
        
    _contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, marginTop);
    }
    return _contentView;
}

-(void)clickCloseBtn:(CommandButton *)sender{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self dismiss];
}

-(void)gotoBingController{
    
    GetCaptchaCodeViewController *viewController = [[GetCaptchaCodeViewController alloc] init];
    viewController.index = 4;
    viewController.title = @"绑定手机";
    viewController.isThirdLogIn = YES;
    viewController.isRetry = YES;
    viewController.captchaType = CaptchaTypeBindPhone;
    [self pushViewController:viewController animated:YES];
    WEAKSELF;
    viewController.resetPasswordDoneBlocks = ^(GetCaptchaCodeViewController *viewController,NSString *password) {
        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
        if ([viewControllers count]>0) {
            [weakSelf.navigationController popToViewController:[viewControllers objectAtIndex:0]animated:YES];
        }
    };
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

- (void)handleLoginClick:(UIButton*)sender
{
    
    UITextField *phoneNumberTextField = (UITextField*)[self.contentView viewWithTag:100];
    UITextField *passwordTextField = (UITextField*)[self.contentView viewWithTag:200];
    
    NSString *phoneNumber = [phoneNumberTextField.text trim];
    NSString *password = [passwordTextField.text trim];
    
    //这里居然能写反  脑残吗。。。。。。害我找了好久……
    //    phoneNumber = self.phoneNumber;
    self.phoneNumber = phoneNumber;
    
    //    phoneNumber = @"13515819812";
    //    password = @"111111";
    //
    if (![phoneNumber isValidMobilePhoneNumber]) {
        [super showHUD:@"请输入正确的手机号" hideAfterDelay:0.8f forView:self.view];
        return;
    }
    if ([password length]<6) {
        [super showHUD:@"请输入至少6位密码" hideAfterDelay:0.8f forView:self.view];
        return;
    }
    [self.view endEditing:YES];
    WEAKSELF;
    [super showProcessingHUD:nil forView:self.scrollView];
    _request = [[NetworkAPI sharedInstance] login:phoneNumber password:password completion:^(NSDictionary *data){
        [weakSelf.view endEditing:YES];
        //        [weakSelf hideHUD];
        [weakSelf dismiss];
        
        [[Session sharedInstance] setLoginInfo:phoneNumber data:data];
        
        EMAccount *account = [Session sharedInstance].emAccount;
        if (account && [account.emUserName length]>0) {
            [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                
                [weakSelf hideHUD];
                //                [weakSelf dismiss];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            } failure:^(XMError *error) {
                [weakSelf hideHUD];
                //                [weakSelf dismiss];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [weakSelf hideHUD];
            //            [weakSelf dismiss];
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(XMError *error) {
        [weakSelf hideHUD];
        if (error.errorCode == 40007) {
            [WCAlertView showAlertWithTitle:@"提示" message:@"该手机号尚未注册，请先注册？" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==0) {
                    
                } else {
                    [weakSelf handleRegClick:nil];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"注册", nil];
        } else {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.contentView];
        }
    }];
}

- (void)handleRegClick:(UIButton*)sender
{
    if (!_agreeBtn.selected) {
        [self showHUD:@"请阅读并同意爱丁猫服务协议" hideAfterDelay:2.f];
        return;
    }
    
    UITextField *phoneNumberTextField = (UITextField*)[self.contentView viewWithTag:100];
    NSString *phoneNumber = [phoneNumberTextField.text trim];
    
    WEAKSELF;
    GetCaptchaCodeViewController *viewController = [[GetCaptchaCodeViewController alloc] init];
    viewController.index = 1;
    viewController.title = @"注册";
    //    viewController.phoneNumber = phoneNumber;
    viewController.captchaType = CaptchaTypeRegistry;
    viewController.getCaptchaCodeDoneBlock = ^(GetCaptchaCodeViewController *viewController,NSString *phoneNumber) {
        VerifyCaptchaCodeViewController *newViewController = [[VerifyCaptchaCodeViewController alloc] init];
        newViewController.phoneNumber = phoneNumber;
        newViewController.captchaType = CaptchaTypeRegistry;
        newViewController.verifyCaptchaCodeDoneBlock = ^(VerifyCaptchaCodeViewController *viewController,NSString *phoneNumber,NSString *captcha) {
            
            ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc] init];
            resetPasswordViewController.title = @"设置登录密码";
            resetPasswordViewController.phoneNumber = phoneNumber;
            resetPasswordViewController.captcha = captcha;
            resetPasswordViewController.isResetPassword = NO;
            resetPasswordViewController.resetPasswordDoneBlock = ^(ResetPasswordViewController *viewController,NSString *password) {
                RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
                registerViewController.title = @"设置头像";
                registerViewController.phoneNumber = phoneNumber;
                registerViewController.captcha = captcha;
                registerViewController.password = password;
                registerViewController.registerDoneBlock = ^(RegisterViewController *viewController) {
                    [weakSelf.view endEditing:YES];
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                };
                //                [weakSelf.navigationController pushViewController:registerViewController animated:YES];
            };
            //            [weakSelf.navigationController pushViewController:resetPasswordViewController animated:YES];
        };
        //        [weakSelf.navigationController pushViewController:newViewController animated:YES];
    };
    //    [weakSelf dismissViewControllerAnimated:YES completion:^{
    [weakSelf.navigationController pushViewController:viewController animated:YES];
    viewController.resetPasswordDoneBlocks = ^(GetCaptchaCodeViewController *viewController,NSString *password){
        [weakSelf dismiss];
        [viewController dismiss];
    };
    //    }];
}

- (void)handleForgotClick:(UIButton*)sender
{
    WEAKSELF;
    
    UITextField *phoneNumberTextField = (UITextField*)[self.contentView viewWithTag:100];
    NSString *phoneNumber = [phoneNumberTextField.text trim];
    phoneNumber = self.phoneNumber;
    
    [weakSelf.view endEditing:YES];
    GetCaptchaCodeViewController *viewController = [[GetCaptchaCodeViewController alloc] init];
    viewController.index = 2;
    
    viewController.resetPasswordDoneBlocks = ^(GetCaptchaCodeViewController *viewController,NSString *password) {
        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
        //                if ([viewControllers count]>1) {
        //                    [weakSelf.navigationController popToViewController:[viewControllers objectAtIndex:1]animated:YES];
        //                } else
        if ([viewControllers count]>0) {
            [weakSelf.navigationController popToViewController:[viewControllers objectAtIndex:0]animated:YES];
        }
    };
    
    viewController.title = @"获取验证码";
    viewController.phoneNumber = phoneNumber;
    viewController.captchaType = CaptchaTypeResetPassword;
    viewController.getCaptchaCodeDoneBlock = ^(GetCaptchaCodeViewController *viewController,NSString *phoneNumber) {
        VerifyCaptchaCodeViewController *newViewController = [[VerifyCaptchaCodeViewController alloc] init];
        newViewController.phoneNumber = phoneNumber;
        newViewController.captchaType = CaptchaTypeResetPassword;
        newViewController.verifyCaptchaCodeDoneBlock = ^(VerifyCaptchaCodeViewController *viewController,NSString *phoneNumber,NSString *captcha) {
            
            ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc] init];
            resetPasswordViewController.title = @"设置登录密码";
            resetPasswordViewController.phoneNumber = phoneNumber;
            resetPasswordViewController.captcha = captcha;
            resetPasswordViewController.isResetPassword = YES;
            resetPasswordViewController.resetPasswordDoneBlock = ^(ResetPasswordViewController *viewController,NSString *password) {
                NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                //                if ([viewControllers count]>1) {
                //                    [weakSelf.navigationController popToViewController:[viewControllers objectAtIndex:1]animated:YES];
                //                } else
                if ([viewControllers count]>0) {
                    [weakSelf.navigationController popToViewController:[viewControllers objectAtIndex:0]animated:YES];
                }
            };
            [weakSelf.navigationController pushViewController:resetPasswordViewController animated:YES];
        };
        [weakSelf.navigationController pushViewController:newViewController animated:YES];
    };
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#if DEBUG
- (void)handleChangeUrlClick:(UIButton *)sender
{
    NSString *serverUrl = _serverTextField.text;
    [[Session sharedInstance] setDebugServerUrl:serverUrl];
    [NetworkManager sharedInstance].dynamicServerUrl = serverUrl;
    [self showHUD:@"修改服务器地址成功" hideAfterDelay:1.5f];
}
#endif

@end


@interface RegisterViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,copy) NSString *avatarFilePath;

@property(nonatomic,strong) ADMActionSheet *actionSheet;

@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    
    [super setupTopBarTitle:self.title&&[self.title length]>0?self.title:@"设置昵称"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = _scrollView.bounds.size.height/8;
    self.contentView.frame = frame;
    [_scrollView addSubview:self.contentView];
    
    [self.view bringSubviewToFront:self.topBar];
    
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
                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
                                 
                                 CGFloat visibleHeight = weakSelf.view.bounds.size.height-keyboardHeight-weakSelf.topBarHeight;
                                 if (visibleHeight<contentHeight) {
                                     targetEndY = contentY-15;
                                 }
                                 
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, contentY+contentHeight)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height+contentY+15+(contentHeight-visibleHeight))];
                                 
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UITextField *textFiled = (UITextField*)[self.contentView viewWithTag:100];
    //        [textFiled becomeFirstResponder];
    //    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        CGFloat marginTop = 0.f;
        //        UIButton *avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-100)/2, marginTop, 100, 100)];
        //        avatarBtn.tag = 100;
        //        avatarBtn.layer.masksToBounds = YES;
        //        avatarBtn.layer.masksToBounds=YES;
        //        avatarBtn.layer.cornerRadius=50;    //最重要的是这个地方要设成imgview高的一半
        //        avatarBtn.layer.borderColor = [UIColor colorWithHexString:@"D0B87F"].CGColor;
        //        avatarBtn.layer.borderWidth = 2.0f;
        //        [avatarBtn setImage:[UIImage imageNamed:@"login_avatar.png"] forState:UIControlStateNormal];
        //        [avatarBtn addTarget:self action:@selector(setAvatar:) forControlEvents:UIControlEventTouchUpInside];
        //        [_contentView addSubview:avatarBtn];
        //
        //        marginTop += avatarBtn.bounds.size.height;
        //        marginTop += 38.f;
        
        UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 60)];
        textField.placeholder = @"设置昵称";
        //        [textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
        textField.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        textField.font = [UIFont systemFontOfSize:17.f];
        textField.textColor = [UIColor colorWithHexString:@"282828"];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.tag = 200;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        [_contentView addSubview:textField];
        
        marginTop += textField.bounds.size.height;
        marginTop += 40.f;
        
        
        UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth - 30, 50)];//CGRectMake((_contentView.bounds.size.width-160)/2, marginTop, 160, 50)];
        //        regBtn.layer.masksToBounds=YES;
        //        regBtn.layer.cornerRadius=15;    //最重要的是这个地方要设成imgview高的一半
        regBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];// [UIColor colorWithHexString:@"D0B87F"];
        [regBtn setTitle:@"进入爱丁猫" forState:UIControlStateNormal];
        [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        regBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [regBtn addTarget:self action:@selector(handleRegBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:regBtn];
        
        marginTop += regBtn.bounds.size.height;
        
        
        _contentView.frame = CGRectMake(0, marginTop, self.view.bounds.size.width, kScreenHeight);
        
    }
    return _contentView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "] || [string rangeOfString:@" "].length>0) {
        return NO;
    } else if ([string isEqualToString:@"\n"]) {
        
        return NO;
    }
    return YES;
}

- (void)setAvatar:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    WEAKSELF;
    [UIActionSheet showInView:weakSelf.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex == 0) {
                             ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
                             if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                     UIImagePickerController *imagePicker =  [UIImagePickerController new];
                                     imagePicker.delegate = weakSelf;
                                     imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     
                                     imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                                     imagePicker.allowsEditing = YES;
                                     [weakSelf presentViewController:imagePicker animated:YES completion:^{
                                     }];
                                 }];
                                 
                             } else {
                                 UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                                                      message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                                                                                     delegate:self
                                                                            cancelButtonTitle:nil
                                                                            otherButtonTitles:@"确定", nil];
                                 [alertView show];
                             }
                             
                         } else if (buttonIndex==1) {
                             
                             AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                             if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
                                 //拍照
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                         NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
                                         UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                         imagePicker.delegate = weakSelf;
                                         imagePicker.allowsEditing = YES;
                                         imagePicker.sourceType = sourceType;
                                         imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                                         imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                                         imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                                         imagePicker.showsCameraControls = YES;
                                         [weakSelf presentViewController:imagePicker animated:YES completion:^{
                                         }];
                                     }];
                                 }
                                 
                             } else {
                                 UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                                                      message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许爱丁猫访问你的相机"
                                                                                     delegate:self
                                                                            cancelButtonTitle:nil
                                                                            otherButtonTitles:@"确定", nil];
                                 [alertView show];
                             }
                         }
                         
                     }];
    
    
    //    self.actionSheet = [[ADMActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil] cancelBlock:^{
    //
    //    } destructiveBlock:nil otherBlock:^(NSInteger index) {
    //        if (index == 0) {
    //            //从手机相册选择
    ////            AssetPickerController * imagePicker =  [[AssetPickerController alloc] init];
    ////            imagePicker.minimumNumberOfSelection = 1;
    ////            imagePicker.maximumNumberOfSelection = 4;
    ////            imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
    ////            imagePicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    ////                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
    ////                    return NO;
    ////                } else {
    ////                    return YES;
    ////                }
    ////            }];
    ////            [weakSelf presentViewController:imagePicker animated:YES completion:^{
    ////            }];
    //
    //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                UIImagePickerController *imagePicker =  [UIImagePickerController new];
    //                imagePicker.delegate = weakSelf;
    //                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //                imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //                imagePicker.allowsEditing = YES;
    //                [weakSelf presentViewController:imagePicker animated:YES completion:^{
    //                }];
    //            }];
    //        } else if (index==1) {
    //            //拍照
    //            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    //                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                    NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    //                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //                    imagePicker.delegate = weakSelf;
    //                    imagePicker.allowsEditing = YES;
    //                    imagePicker.sourceType = sourceType;
    //                    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //                    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    //                    imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    //                    imagePicker.showsCameraControls = YES;
    //                    [weakSelf presentViewController:imagePicker animated:YES completion:^{
    //                    }];
    //                }];
    //            } else {
    //
    //            }
    //        }
    //    } tapMaskBlock:nil];
    //    [self.actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WEAKSELF;
    UIImage *image= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
    if (image) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *newImage = [image resizedImage:CGSizeMake(kADMAvatarSize, kADMAvatarSize) interpolationQuality:kCGInterpolationHigh];
            
            [AppDirs cleanupTempDir];
            NSString *filePath = [AppDirs saveImage:newImage dir:[AppDirs tempDir] fileName:@"avatar" fileExtention:@"jpg"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.avatarFilePath = filePath;
                
                UIButton *avatarBtn = (UIButton*)[weakSelf.contentView viewWithTag:100];
                [avatarBtn setImage:newImage forState:UIControlStateNormal];
            });
        });
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)handleRegBtnClicked:(UIButton*)sender
{
    UITextField *userNameTextFiled = (UITextField*)[self.contentView viewWithTag:200];
    NSString *userName = [userNameTextFiled.text trim];
    
    if ([userName length]==0) {
        [super showHUD:@"请输入昵称" hideAfterDelay:0.8f forView:self.contentView];
        return;
    }
    
    WEAKSELF;
    
    __block NSString *phoneNumber = self.phoneNumber;
    
    [super showProcessingHUD:nil forView:self.contentView];
    _request = [[NetworkAPI sharedInstance] registerNewAccount:phoneNumber captchaCode:self.captcha userName:userName password:self.password avatarFilePath:self.avatarFilePath invitationCode:self.inviteNum completion:^(NSDictionary *data){
        [[Session sharedInstance] setRegisterInfo:phoneNumber data:data];
        
        [weakSelf hideHUD];
        if (weakSelf.registerDoneBlock) {
            weakSelf.registerDoneBlock(weakSelf);
        }
        EMAccount *account = [Session sharedInstance].emAccount;
        if (account && [account.emUserName length]>0) {
            [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                [weakSelf hideHUD];
                //                                if (weakSelf.registerDoneBlock) {
                //                                    weakSelf.registerDoneBlock(weakSelf);
                //                                }
                [weakSelf.view endEditing:YES];
                //                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            } failure:^(XMError *error) {
                [weakSelf hideHUD];
                //                                if (weakSelf.registerDoneBlock) {
                //                                    weakSelf.registerDoneBlock(weakSelf);
                //                                }
                [weakSelf.view endEditing:YES];
                //                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [weakSelf hideHUD];
            //                        if (weakSelf.registerDoneBlock) {
            //                            weakSelf.registerDoneBlock(weakSelf);
            //                        }
            [weakSelf.view endEditing:YES];
            //            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.contentView];
    }];
}

@end


@interface ResetPasswordViewController () <UITextFieldDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.title];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = _scrollView.bounds.size.height/6;
    self.contentView.frame = frame;
    [_scrollView addSubview:self.contentView];
    
    [self.view bringSubviewToFront:self.topBar];
    
    
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
                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
                                 
                                 CGFloat visibleHeight = weakSelf.view.bounds.size.height-keyboardHeight-weakSelf.topBarHeight;
                                 if (visibleHeight<contentHeight) {
                                     targetEndY = contentY-15;
                                 }
                                 
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, contentY+contentHeight)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height+contentY+15+(contentHeight-visibleHeight))];
                                 
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
    //
    //    UITextField *textFiled = (UITextField*)[self.contentView viewWithTag:100];
    //    [textFiled becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UITextField *textFiled = (UITextField*)[self.contentView viewWithTag:100];
    //        [textFiled becomeFirstResponder];
    //    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _scrollView = nil;
}


- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        CGFloat marginTop = 0;
        UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 60)];
        textField.placeholder = @"设置登录密码";
        // [textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
        textField.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        textField.font = [UIFont systemFontOfSize:17.f];
        textField.textColor = [UIColor colorWithHexString:@"282828"];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.clearButtonMode = UITextFieldViewModeNever;
        textField.tag = 100;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyNext;
        textField.secureTextEntry = YES;
        [_contentView addSubview:textField];
        
        marginTop += textField.bounds.size.height;
        
        
        WEAKSELF;
        CommandButton *showPasswordBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-52, textField.top, 52, textField.height)];
        [_contentView addSubview:showPasswordBtn];
        [showPasswordBtn setImage:[UIImage imageNamed:@"show_password_normal"] forState:UIControlStateNormal];
        showPasswordBtn.handleClickBlock = ^(CommandButton *sender) {
            sender.selected = ![sender isSelected];
            if ([sender isSelected]) {
                [sender setImage:[UIImage imageNamed:@"show_password_selected"] forState:UIControlStateNormal];
                ((UnCopyableTextField*)[weakSelf.contentView viewWithTag:100]).secureTextEntry = NO;
            } else {
                [sender setImage:[UIImage imageNamed:@"show_password_normal"] forState:UIControlStateNormal];
                ((UnCopyableTextField*)[weakSelf.contentView viewWithTag:100]).secureTextEntry = YES;
            }
        };
        
        //        marginTop += 15;
        //
        //        UITextField *textField2 = [[UnCopyableTextField alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 60)];
        //        textField2.placeholder = @"确认密码";
        //        [textField2 setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
        //        textField2.backgroundColor = [UIColor colorWithHexString:@"4A2F32"];
        //        textField2.font = [UIFont systemFontOfSize:17.f];
        //        textField2.textColor = [UIColor colorWithHexString:@"D0B87F"];
        //        textField2.textAlignment = NSTextAlignmentCenter;
        //        textField2.keyboardType = UIKeyboardTypeEmailAddress;
        //        textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        textField2.tag = 200;
        //        textField2.delegate = self;
        //        textField2.returnKeyType = UIReturnKeyDone;
        //        textField2.secureTextEntry = YES;
        //        [_contentView addSubview:textField2];
        //
        //        marginTop += textField2.bounds.size.height;
        marginTop += 40;
        
        UIButton *nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake((_contentView.bounds.size.width-160)/2, marginTop, 160, 50)];
        nextStepBtn.layer.masksToBounds=YES;
        nextStepBtn.layer.cornerRadius=25;    //最重要的是这个地方要设成imgview高的一半
        nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];;//[UIColor colorWithHexString:@"D0B87F"];
        [nextStepBtn setTitle:self.title?self.title:@"注册" forState:UIControlStateNormal];
        if ([_btnText length]>0) {
            [nextStepBtn setTitle:_btnText forState:UIControlStateNormal];
        }
        [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [nextStepBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:nextStepBtn];
        
        marginTop += nextStepBtn.bounds.size.height;
        
        _contentView.bounds = CGRectMake(0, 0, kScreenWidth, marginTop);
    }
    return _contentView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "] || [string rangeOfString:@" "].length>0) {
        return NO;
    } else if ([string isEqualToString:@"\n"]) {
        if (textField.tag == 100) {
            UITextField *textField2 = (UITextField*)[self.contentView viewWithTag:200];
            [textField2 becomeFirstResponder];
        }
        
        return NO;
    }
    return YES;
}

- (void)nextStep:(UIButton*)sender
{
    WEAKSELF;
    [self.view endEditing:YES];
    UITextField *textField1 = (UITextField*)[self.contentView viewWithTag:100];
    //UITextField *textField2 = (UITextField*)[self.contentView viewWithTag:200];
    
    NSString *string1 = [textField1.text trim];
    //NSString *string2 = [textField2.text trim];
    if (string1.length >= 6 ) {
        //if ([string1 isEqualToString:string2]) {
        
        if (self.isResetPassword && _resetPasswordDoneBlock) {
            _request = [[NetworkAPI sharedInstance] resetPassword:_phoneNumber password:string1 authcode:self.captcha completion:^{
                [weakSelf showHUD:@"修改成功,请重新登录" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
                _resetPasswordDoneBlock(weakSelf,string1);
            } failure:^(XMError *error) {
                [super showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self.contentView];
            }];
            
        } else {
            if (_resetPasswordDoneBlock) {
                _resetPasswordDoneBlock(self,string1);
            }
        }
        //        } else {
        //            [super showHUD:@"输入的密码不匹配" hideAfterDelay:0.8f forView:self.contentView];
        //        }
    } else {
        [super showHUD:@"请输入至少6位密码" hideAfterDelay:0.8f forView:self.contentView];
    }
}

@end

//1注册，2，重置密码

#import "Command.h"

@interface GetCaptchaCodeViewController () <UIAlertViewDelegate,TTTAttributedLabelDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *textFieldSecret;
@property (nonatomic, strong) UITextField *textFieldVerify;
@property (nonatomic, weak) UIView *bgView1;
@property (nonatomic, weak) UIView *bgView2;
@property (nonatomic, weak) UIView *bgView3;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger timerPeriod;
@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic, weak) UIButton *retryBtn;

@property (nonatomic, assign) BOOL isResetPassword;

@property (nonatomic, strong) CommandButton *agreeBtn;
@property (nonatomic, strong) UITextField *invitTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) CommandButton *inviteOpenBtn;
@end

@implementation GetCaptchaCodeViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    
    if (self.index == 1) {
        [super setupTopBarTitle:@"注册"];
    } else if (self.index == 2) {
        [super setupTopBarTitle:@"忘记密码"];
    } else if (self.index == 3) {
        [super setupTopBarTitle:@"重置密码"];
    } else if (self.index == 4) {
        [super setupTopBarTitle:@"绑定手机"];
    } else if (self.index == 5) {
        [super setupTopBarTitle:@"更换手机"];
    } else if (self.index == 6) {
        [super setupTopBarTitle:@"更换手机"];
    }
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;//_scrollView.bounds.size.height/4;
    self.contentView.frame = frame;
    [_scrollView addSubview:self.contentView];
    
    if (self.isThirdLogIn) {
        self.contentView.frame = CGRectMake(0, 50, kScreenWidth, kScreenHeight-topBarHeight-50);
        UILabel *promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        promptLbl.font = [UIFont systemFontOfSize:15.f];
        promptLbl.textColor = [UIColor colorWithHexString:@"999999"];
        promptLbl.text = @"为账号安全，请绑定手机号";
        [_scrollView addSubview:promptLbl];
        [promptLbl sizeToFit];
        promptLbl.frame = CGRectMake((kScreenWidth-promptLbl.width)/2, 50/2, promptLbl.width, promptLbl.height);
    }
    
    if (self.index == 5) {
        self.contentView.frame = CGRectMake(0, 50, kScreenWidth, kScreenHeight-topBarHeight-50);
        UILabel *promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        promptLbl.font = [UIFont systemFontOfSize:15.f];
        promptLbl.textColor = [UIColor colorWithHexString:@"999999"];
        promptLbl.text = @"钱包余额为0才能更换手机号";
        [_scrollView addSubview:promptLbl];
        [promptLbl sizeToFit];
        promptLbl.frame = CGRectMake((kScreenWidth-promptLbl.width)/2, 50/2, promptLbl.width, promptLbl.height);
    }
    
    [self.view bringSubviewToFront:self.topBar];
    
    
    //    WEAKSELF;
    //    _scrollView.keyboardWillChange = ^(CGRect beginKeyboardRect, CGRect endKeyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
    //        [UIView animateWithDuration:duration
    //                              delay:0.0
    //                            options:options
    //                         animations:^{
    //                             if (showKeyborad) {
    //                                 CGFloat keyboardHeight = [weakSelf.view convertRect:endKeyboardRect fromView:nil].size.height;
    //                                 CGFloat contentY = weakSelf.contentView.frame.origin.y;
    //                                 CGFloat contentHeight = weakSelf.contentView.bounds.size.height;
    //                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
    //                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
    //                             } else {
    //                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //                             }
    //                         }
    //                         completion:nil];
    //    };
    //
    //    _scrollView.keyboardDidChange = ^(BOOL didShowed) {
    //
    //    };
    
    
    
    [self setupForDismissKeyboard];
    
    UITextField *textFiled = (UITextField*)[self.contentView viewWithTag:100];
    //    [textFiled becomeFirstResponder];
}

-(void)handleTopBarBackButtonClicked:(UIButton *)sender{
    [self dismiss];
    if (self.index == 4 && self.isThirdLogIn == YES) {
        //        [WCAlertView showAlertWithTitle:@"提示" message:@"请绑定手机号，否则将无法登陆" customizationBlock:^(WCAlertView *alertView) {
        //
        //        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        //
        //        } cancelButtonTitle:@"退出" otherButtonTitles:@"绑定", nil];
        [[NetworkAPI sharedInstance] logout:^{
            
        } failure:^(XMError *error) {
            
        }];
    }
}

- (void)onTimer:(NSTimer*)theTimer
{
    //    UIButton *retryBtn = (UIButton*)[self.contentView viewWithTag:200];
    //    TTTAttributedLabel *attrLbl = (TTTAttributedLabel*)[self.contentView viewWithTag:600];
    self.timerPeriod -= 1;
    if (self.timerPeriod <= 0) {
        self.timerPeriod = 60;
        [self.sendButton setTitle:[NSString stringWithFormat:@"短信接收"] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.sendButton.enabled = YES;
        self.retryBtn.hidden = NO;
        self.retryBtn.enabled = YES;
        [theTimer setFireDate:[NSDate distantFuture]];
    } else {
        [self.sendButton setTitle:[NSString stringWithFormat:@"(%ld)", self.timerPeriod] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        self.sendButton.enabled = NO;
        self.retryBtn.hidden = YES;
        self.retryBtn.enabled = YES;
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UITextField *textFiled = (UITextField*)[self.contentView viewWithTag:100];
    //        [textFiled becomeFirstResponder];
    //    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _scrollView = nil;
    _request = nil;
}


- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.title = @"服务协议";
    viewController.url = [url absoluteString];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (UIView*)contentView {
    
    //修改之前的代码
    //    if (!_contentView) {
    //        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    //
    //        CGFloat marginTop = 0;
    //        UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 60)];
    //        textField.placeholder = @"输入手机号";
    //        textField.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    ////        [textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
    ////        textField.backgroundColor = [UIColor colorWithHexString:@"4A2F32"];
    //        textField.font = [UIFont systemFontOfSize:17.f];
    //        textField.textColor = [UIColor colorWithHexString:@"282828"];
    //        textField.text = [_phoneNumber length]>0?_phoneNumber:@"";
    //
    //        textField.textAlignment = NSTextAlignmentCenter;
    //        textField.keyboardType = UIKeyboardTypeDecimalPad;
    //        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //        textField.tag = 100;
    //        [_contentView addSubview:textField];
    //
    //        marginTop += textField.bounds.size.height;
    //        marginTop += 40;
    //
    //        UIButton *captchaBtn = [[UIButton alloc] initWithFrame:CGRectMake((_contentView.bounds.size.width-160)/2, marginTop, 160, 50)];
    //        captchaBtn.layer.masksToBounds=YES;
    //        captchaBtn.layer.cornerRadius=25;    //最重要的是这个地方要设成imgview高的一半
    //        captchaBtn.backgroundColor = [UIColor colorWithHexString:@"e2bb66"];//[UIColor colorWithHexString:@"D0B87F"];
    //        [captchaBtn setTitle:self.title?self.title:@"注册" forState:UIControlStateNormal];
    //        [captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        captchaBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    //        [captchaBtn addTarget:self action:@selector(handleCaptchaClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [_contentView addSubview:captchaBtn];
    //
    //        marginTop += captchaBtn.bounds.size.height;
    //
    //        _contentView.bounds = CGRectMake(0, 0, kScreenWidth, marginTop);
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
        
        {
            
            UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectZero];//CGRectMake(marginLeft, bgView1.frame.origin.y, _contentView.bounds.size.width-marginLeft, 20)];//bgView1.bounds.size.height)];
            textField.placeholder = @"11位手机号";
            textField.font = [UIFont systemFontOfSize:14.f];
            textField.textColor = [UIColor colorWithHexString:@"282828"];
            textField.textAlignment = NSTextAlignmentLeft;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.image = [UIImage imageNamed:@"LogIn_Left_Jiantou"];
            [imageView sizeToFit];
            textField.leftView = imageView;
            //            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.tag = 100;
            textField.delegate = self;
            [_contentView addSubview:textField];
            self.textField = textField;
            if (self.index == 2 || self.index == 3 || self.index == 5) {
                if ([[Session sharedInstance] isLoggedIn]) {
                    textField.text = [Session sharedInstance].currentUser.phoneNumber;
                    textField.userInteractionEnabled = NO;
                    [textField endEditing:YES];
                }
            } else {
                textField.text = @"";
                textField.userInteractionEnabled = YES;
                [textField becomeFirstResponder];
            }
            
            if (self.index == 2) {
                textField.userInteractionEnabled = YES;
                [textField becomeFirstResponder];
            }
            
            if (self.index == 6) {
                textField.placeholder = @"请输入新手机号";
            } else {
                textField.placeholder = @"请输入手机号";
            }
            
            UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectZero];
            bgView1.backgroundColor = [UIColor colorWithHexString:@"c8c9ca"];
            [_contentView addSubview:bgView1];
            self.bgView1 = bgView1;
            
            UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [sendButton setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
            [sendButton sizeToFit];
            [sendButton addTarget:self action:@selector(handleCaptchaClick:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:sendButton];
            self.sendButton = sendButton;
            
            UIButton *retryBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            retryBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [retryBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [retryBtn setTitle:@"语音收听" forState:UIControlStateNormal];
            [retryBtn sizeToFit];
            [retryBtn addTarget:self action:@selector(handleRetryClick:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:retryBtn];
            
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(25);
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.right.equalTo(self.contentView.mas_right).offset(-120);
                make.height.equalTo(@30);
            }];
            
            [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(textField.mas_bottom);
                make.left.equalTo(textField.mas_left);
                make.right.equalTo(self.contentView.mas_right).offset(-15);
                make.height.equalTo(@0.5);
            }];
            
            [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(bgView1.mas_right).offset(-2);
                make.bottom.equalTo(bgView1.mas_top).offset(-2);
            }];
            
            [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(sendButton.mas_left).offset(-5);
                make.centerY.equalTo(sendButton.mas_centerY);
            }];
            retryBtn.hidden = YES;
            self.retryBtn = retryBtn;
        }
        
        {
            
            UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectZero];//CGRectMake(marginLeft, bgView2.frame.origin.y, forgotBtn.frame.origin.x-8-marginLeft, bgView2.bounds.size.height)];
            textField.placeholder = @"验证码";
            //[textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
            textField.font = [UIFont systemFontOfSize:14.f];
            textField.textColor = [UIColor colorWithHexString:@"282828"];
            textField.textAlignment = NSTextAlignmentLeft;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.image = [UIImage imageNamed:@"LogIn_Left_Jiantou"];
            [imageView sizeToFit];
            textField.leftView = imageView;
            textField.tag = 200;
            textField.delegate = self;
            //            textField.secureTextEntry = YES;
            [_contentView addSubview:textField];
            self.textFieldVerify = textField;
            
            if (self.index == 3 || self.index == 5) {
                [textField becomeFirstResponder];
            } else {
                [textField endEditing:YES];
            }
            
            UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectZero];//CGRectMake(0, marginTop, _contentView.bounds.size.width, 60)];
            bgView2.backgroundColor = [UIColor colorWithHexString:@"c8c9ca"];//[UIColor colorWithHexString:@"f7f7f7"];
            [_contentView addSubview:bgView2];
            self.bgView2 = bgView2;
            
            WEAKSELF;
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.bgView1.mas_bottom).offset(15);
                make.left.equalTo(weakSelf.bgView1.mas_left);
                make.right.equalTo(weakSelf.bgView1.mas_right);
                make.height.equalTo(weakSelf.textField.mas_height);
            }];
            
            [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(textField.mas_bottom);
                make.left.equalTo(textField.mas_left);
                make.right.equalTo(textField.mas_right);
                make.height.equalTo(@1);
            }];
            
        }
        
        {
            if (self.index == 6) {
                
            } else {
                UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectZero];
                textField.placeholder = @"密码(6-16位数字、字母或符号)";
                textField.font = [UIFont systemFontOfSize:14.f];
                textField.textColor = [UIColor colorWithHexString:@"282828"];
                textField.textAlignment = NSTextAlignmentLeft;
                textField.keyboardType = UIKeyboardAppearanceDefault;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.leftViewMode = UITextFieldViewModeAlways;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                imageView.image = [UIImage imageNamed:@"LogIn_Left_Jiantou"];
                [imageView sizeToFit];
                textField.leftView = imageView;
                textField.secureTextEntry = YES;
                [_contentView addSubview:textField];
                self.textFieldSecret = textField;
                
                if (self.index == 5) {
                    textField.placeholder = @"登录密码";
                }
                
                UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectZero];//CGRectMake(0, marginTop, _contentView.bounds.size.width, 60)];
                bgView3.backgroundColor = [UIColor colorWithHexString:@"c8c9ca"];//[UIColor colorWithHexString:@"f7f7f7"];
                [_contentView addSubview:bgView3];
                self.bgView3 = bgView3;
                
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                switchView.onTintColor = [DataSources colorf9384c];
                switchView.on = NO;
                [switchView addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                [_contentView addSubview:switchView];
                
                
                WEAKSELF;
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.bgView2.mas_bottom).offset(15);
                    make.left.equalTo(weakSelf.bgView2.mas_left);
                    make.right.equalTo(weakSelf.bgView2.mas_right).offset(-45);
                    make.height.equalTo(weakSelf.textField.mas_height);
                }];
                
                [bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(textField.mas_bottom);
                    make.left.equalTo(textField.mas_left);
                    make.right.equalTo(weakSelf.bgView2.mas_right);
                    make.height.equalTo(@0.5);
                }];
                
                [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bgView3.mas_right);
                    make.bottom.equalTo(bgView3.mas_top).offset(-3);
                }];
            }
        }
        
//业务需要去掉注册填写邀请码
//        {
//            CommandButton *inviteOpenBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
//            [inviteOpenBtn setTitle:@"填写邀请码" forState:UIControlStateNormal];
//            [inviteOpenBtn setTitle:@"填写邀请码" forState:UIControlStateSelected];
//            inviteOpenBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//            [inviteOpenBtn setTitleColor:[UIColor colorWithHexString:@"7ea6ce"] forState:UIControlStateNormal];
//            [inviteOpenBtn setTitleColor:[UIColor colorWithHexString:@"7ea6ce"] forState:UIControlStateSelected];
//            [inviteOpenBtn setImage:[UIImage imageNamed:@"Return_Choose_Down"] forState:UIControlStateNormal];
//            [inviteOpenBtn setImage:[UIImage imageNamed:@"Return_Choose_Down"] forState:UIControlStateSelected];
//            inviteOpenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, -90);
//            inviteOpenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -inviteOpenBtn.imageView.frame.size.width, 0, inviteOpenBtn.imageView.frame.size.width);
//            [inviteOpenBtn sizeToFit];
//            [_contentView addSubview:inviteOpenBtn];
//            self.inviteOpenBtn = inviteOpenBtn;
//            
//            if (self.index == 1 || (self.index == 4 && self.isThirdLogIn)) {
//                inviteOpenBtn.hidden = NO;
//                
//                UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectZero];//CGRectMake(marginLeft, bgView2.frame.origin.y, forgotBtn.frame.origin.x-8-marginLeft, bgView2.bounds.size.height)];
//                textField.placeholder = @"填写邀请码，可多领88元商城券(选填)";
//                //[textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
//                textField.font = [UIFont systemFontOfSize:14.f];
//                textField.textColor = [UIColor colorWithHexString:@"282828"];
//                textField.textAlignment = NSTextAlignmentLeft;
//                textField.keyboardType = UIKeyboardTypeEmailAddress;
//                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                textField.tag = 400;
//                textField.delegate = self;
//                self.invitTextField = textField;
//                //            textField.secureTextEntry = YES;
//                [_contentView addSubview:textField];
//                
//                UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectZero];//CGRectMake(0, marginTop, _contentView.bounds.size.width, 60)];
//                bgView2.backgroundColor = [UIColor colorWithHexString:@"c8c9ca"];//[UIColor colorWithHexString:@"f7f7f7"];
//                [_contentView addSubview:bgView2];
//                //            self.bgView2 = bgView2;
//                
//                WEAKSELF;
//                [inviteOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(weakSelf.bgView3.mas_bottom).offset(15);
//                    make.left.equalTo(weakSelf.bgView3.mas_left).offset(0);
//                }];
//                
//                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(inviteOpenBtn.mas_bottom).offset(10);
//                    make.left.equalTo(weakSelf.bgView3.mas_left).offset(15);
//                    make.right.equalTo(_contentView.mas_right).offset(-15);
//                    make.height.equalTo(weakSelf.textField.mas_height);
//                }];
//                
//                [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(textField.mas_bottom);
//                    make.left.equalTo(textField.mas_left).offset(-5);
//                    make.right.equalTo(textField.mas_right);
//                    make.height.equalTo(@0.5);
//                }];
//                inviteOpenBtn.selected = NO;
//                textField.hidden = YES;
//                bgView2.hidden = YES;
//                
//                inviteOpenBtn.handleClickBlock = ^(CommandButton *sender){
//                    if (sender.selected == YES) {
//                        sender.selected = NO;
//                        textField.hidden = YES;
//                        bgView2.hidden = YES;
//                        [UIView animateWithDuration:0.25 animations:^{
//                            sender.imageView.transform = CGAffineTransformMakeRotation(0);
//                        }];
//                    } else {
//                        sender.selected = YES;
//                        textField.hidden = NO;
//                        bgView2.hidden = NO;
//                        [UIView animateWithDuration:0.25 animations:^{
//                            sender.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
//                        }];
//                    }
//                };
//                
//            } else {
//                inviteOpenBtn.hidden = YES;
//            }
//        }
        
        CGFloat marginLeft = (_contentView.bounds.size.width-130-20-130)/2;
        
        if (self.isRetry == NO) {
            UIButton *customerBtn = [[UIButton alloc] initWithFrame:CGRectZero];//CGRectMake(0, 0, _contentView.bounds.size.width, 0)];
            [customerBtn addTarget:self action:@selector(handleCustomerClick:) forControlEvents:UIControlEventTouchUpInside];
            [customerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            [customerBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
            customerBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [customerBtn sizeToFit];
            customerBtn.frame = CGRectZero;//CGRectMake(_contentView.bounds.size.width-20.5-forgotBtn.bounds.size.width, bgView2.frame.origin.y, forgotBtn.bounds.size.width, bgView2.bounds.size.height);
            [_contentView addSubview:customerBtn];
            
            
            UIButton *alHaveBtn = [[UIButton alloc] initWithFrame:CGRectZero];//CGRectMake(marginLeft, marginTop, 130, 50)];
            [alHaveBtn setTitle:@"已有爱丁猫账号？直接登录" forState:UIControlStateNormal];
            [alHaveBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
            alHaveBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [alHaveBtn addTarget:self action:@selector(handleAlHaveClick:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:alHaveBtn];
            
            if (self.index == 2) {
                alHaveBtn.hidden = YES;
            }else{
                alHaveBtn.hidden = NO;
            }
            
            marginLeft += alHaveBtn.bounds.size.width;
            marginLeft += 20;
            
            UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectZero];//CGRectMake(marginLeft, marginTop, 130, 50)];
            loginBtn.layer.cornerRadius = 6;
            loginBtn.layer.masksToBounds = YES;
            
            loginBtn.backgroundColor = [DataSources colorf9384c];//[UIColor colorWithHexString:@"D0B87F"];
            if (self.index == 1) {
                [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
            } else if (self.index == 2 || self.index == 3 || self.index == 6) {
                [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
            } else if (self.index == 4) {
                [loginBtn setTitle:@"绑定" forState:UIControlStateNormal];
            } else if (self.index == 5) {
                [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
            
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
            [loginBtn addTarget:self action:@selector(handleLoginClick:) forControlEvents:UIControlEventTouchUpInside];
            loginBtn.userInteractionEnabled = YES;
            [_contentView addSubview:loginBtn];
            self.loginBtn = loginBtn;
            
            if (self.index == 1 || (self.index == 4 && self.isThirdLogIn)) {
                //                if (self.inviteOpenBtn.selected == YES) {
                [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    //make.top.equalTo(self.invitTextField.mas_bottom).offset(55);
                    make.top.equalTo(self.bgView3.mas_bottom).offset(70);
                    make.left.equalTo(_contentView.mas_left).offset(15);
                    make.right.equalTo(_contentView.mas_right).offset(-15);
                    make.height.equalTo(@50);
                }];
                //                } else {
                //                    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                //                        make.top.equalTo(self.inviteOpenBtn.mas_bottom).offset(76);
                //                        make.left.equalTo(_contentView.mas_left).offset(15);
                //                        make.right.equalTo(_contentView.mas_right).offset(-15);
                //                        make.height.equalTo(@50);
                //                    }];
                //                }
            } else {
                [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.textFieldSecret.mas_bottom).offset(100);
                    make.left.equalTo(_contentView.mas_left).offset(15);
                    make.right.equalTo(_contentView.mas_right).offset(-15);
                    make.height.equalTo(@50);
                }];
            }
            
            [alHaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(loginBtn.mas_bottom).offset(10);
                make.left.equalTo(loginBtn.mas_left);
            }];
            
            [customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(alHaveBtn.mas_centerY);
                make.right.equalTo(loginBtn.mas_right);
            }];
        } else {
            UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectZero];//CGRectMake(marginLeft, marginTop, 130, 50)];
            loginBtn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];//[UIColor colorWithHexString:@"D0B87F"];
            [loginBtn setTitle:@"确认" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
            [loginBtn addTarget:self action:@selector(handleLoginClick:) forControlEvents:UIControlEventTouchUpInside];
            loginBtn.userInteractionEnabled = YES;
            loginBtn.layer.cornerRadius = 25;
            loginBtn.layer.masksToBounds = YES;
            [_contentView addSubview:loginBtn];
            self.loginBtn = loginBtn;
            if (self.index == 1) {
                [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
            } else if (self.index == 2 || self.index == 3 || self.index == 6) {
                [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
            } else if (self.index == 4) {
                [loginBtn setTitle:@"绑定" forState:UIControlStateNormal];
            } else if (self.index == 5) {
                [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
            if (self.index == 1 || (self.index == 4 && self.isThirdLogIn)) {
                //                if (self.inviteOpenBtn.selected == YES) {
                [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    //make.top.equalTo(self.invitTextField.mas_bottom).offset(55);
                    make.top.equalTo(self.bgView3.mas_bottom).offset(70);
                    make.left.equalTo(_contentView.mas_left).offset(15);
                    make.right.equalTo(_contentView.mas_right).offset(-15);
                    make.height.equalTo(@50);
                }];
                //                } else {
                //                    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                //                        make.top.equalTo(self.inviteOpenBtn.mas_bottom).offset(76);
                //                        make.left.equalTo(_contentView.mas_left).offset(15);
                //                        make.right.equalTo(_contentView.mas_right).offset(-15);
                //                        make.height.equalTo(@50);
                //                    }];
                //                }
                
            } else {
                if (self.index == 6) {
                    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.textFieldVerify.mas_bottom).offset(100);
                        make.left.equalTo(_contentView.mas_left).offset(15);
                        make.right.equalTo(_contentView.mas_right).offset(-15);
                        make.height.equalTo(@50);
                    }];
                } else {
                    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.textFieldSecret.mas_bottom).offset(100);
                        make.left.equalTo(_contentView.mas_left).offset(15);
                        make.right.equalTo(_contentView.mas_right).offset(-15);
                        make.height.equalTo(@50);
                    }];
                }
            }
        }
        
        if (self.index == 5 || self.index == 6 || self.index == 3) {
            UIButton *customerBtn = [[UIButton alloc] initWithFrame:CGRectZero];//CGRectMake(0, 0, _contentView.bounds.size.width, 0)];
            [customerBtn addTarget:self action:@selector(handleCustomerClick:) forControlEvents:UIControlEventTouchUpInside];
            [customerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            [customerBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
            customerBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [customerBtn sizeToFit];
            customerBtn.frame = CGRectZero;//CGRectMake(_contentView.bounds.size.width-20.5-forgotBtn.bounds.size.width, bgView2.frame.origin.y, forgotBtn.bounds.size.width, bgView2.bounds.size.height);
            [_contentView addSubview:customerBtn];
            
            [customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.loginBtn.mas_bottom).offset(10);
                make.right.equalTo(self.loginBtn.mas_right);
            }];
        }
        
        TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];//CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        agreementLbl.delegate = self;
        agreementLbl.font = [UIFont systemFontOfSize:11.f];
        agreementLbl.textColor = [UIColor colorWithHexString:@"88666A"];
        agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
        agreementLbl.userInteractionEnabled = YES;
        agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"06a6a6"];
        agreementLbl.numberOfLines = 0;
        agreementLbl.linkAttributes = nil;
        NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:agreementLbl.activeLinkAttributes];
        [attributes setObject:(__bridge id)[UIColor colorWithHexString:@"D0B87F"].CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
        agreementLbl.activeLinkAttributes = attributes;
        [agreementLbl setText:@"已阅读并同意服务协议" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-4,4);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"f9384c"] CGColor] range:stringRange];
            return mutableAttributedString;
        }];
        
        [agreementLbl addLinkToURL:[NSURL URLWithString:@""] withRange:NSMakeRange([agreementLbl.text length]-4,4)];
        [agreementLbl sizeToFit];
        agreementLbl.frame = CGRectZero;//CGRectMake((_scrollView.bounds.size.width-agreementLbl.bounds.size.width)/2+16, _scrollView.bounds.size.height-27-agreementLbl.bounds.size.height, agreementLbl.bounds.size.width, agreementLbl.bounds.size.height);
        [self.contentView addSubview:agreementLbl];
        
        
        CommandButton *agreeBtn = [[CommandButton alloc] initWithFrame:CGRectZero];//CGRectMake(agreementLbl.frame.origin.x-30, agreementLbl.frame.origin.y-(40.f-agreementLbl.bounds.size.height)/2-1, 40, 40)];
        agreeBtn.selected = YES;
        [self.contentView addSubview:agreeBtn];
        [agreeBtn setImage:[UIImage imageNamed:@"login_check_new.png"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"login_checked_new.png"] forState:UIControlStateSelected];
        self.agreeBtn = agreeBtn;
        agreeBtn.handleClickBlock = ^(CommandButton *sender) {
            sender.selected = !sender.isSelected;
            //        if ([sender isSelected]) {
            //            [sender setImage:[UIImage imageNamed:@"login_check_new.png"] forState:UIControlStateNormal];
            //        } else {
            //            [sender setImage:[UIImage imageNamed:@"login_checked_new.png"] forState:UIControlStateNormal];
            //        }
        };
        
        if (self.isRetry == NO) {
            WEAKSELF;
            [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView.mas_centerX).offset(-60);
                //            make.centerY.equalTo(weakSelf.scrollView.mas_centerY).offset(-120);
                make.bottom.equalTo(self.loginBtn.mas_top).offset(-10);
                make.width.equalTo(@45);
                make.height.equalTo(@45);
            }];
            
            [agreementLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(agreeBtn.mas_centerY).offset(1);
                make.left.equalTo(agreeBtn.mas_right).offset(-10);
            }];
        } else {
            
        }
        
    }
    return _contentView;
}

-(void)handleLoginClick:(UIButton *)sender{
    UITextField *textField = (UITextField*)[self.contentView viewWithTag:100];
    UITextField *textFieldYaoQ = (UITextField*)[self.contentView viewWithTag:400];
    self.phoneNumber = textField.text;
    self.yaoqingNum = textFieldYaoQ ? textFieldYaoQ.text : @"";
    WEAKSELF;
    
    if (!self.agreeBtn.isSelected) {
        [self showHUD:@"请先阅读爱丁猫注册协议" hideAfterDelay:0.8f forView:self.view];
        return;
    }
    
    if ([self.phoneNumber length] == 0) {
        [self showHUD:@"手机号码不能为空" hideAfterDelay:0.8f forView:self.view];
        return;
    }
    
    if (self.index == 6) {
        
    } else {
        if ([self.textFieldSecret.text length] < 6) {
            [self showHUD:@"请输入6位以上密码" hideAfterDelay:0.8f forView:self.view];
            return;
        }
    }
    
    if ([self.phoneNumber length]>0 && [self.phoneNumber isValidMobilePhoneNumber]) {
        if ([self.textFieldVerify.text length] == 6) {
            [super showProcessingHUD:nil forView:self.contentView];
            if (self.index == 1) {
                
                //                weakSelf.isResetPassword = YES;
                //                RegisterViewController *regis = [[RegisterViewController alloc] init];
                //                regis.phoneNumber = weakSelf.phoneNumber;
                //                regis.captcha = weakSelf.textFieldVerify.text;
                //                regis.password = weakSelf.textFieldSecret.text;
                //                regis.inviteNum = weakSelf.yaoqingNum;
                //                [weakSelf.navigationController pushViewController:regis animated:YES];
                //                [weakSelf removeFromParentViewController];
                //                regis.registerDoneBlock = ^(RegisterViewController *regis){
                //                    [self.navigationController popToRootViewControllerAnimated:YES];
                //                };
                
                _request = [[NetworkAPI sharedInstance] registerNewAccount:weakSelf.phoneNumber captchaCode:weakSelf.textFieldVerify.text userName:@"" password:weakSelf.textFieldSecret.text avatarFilePath:nil invitationCode:weakSelf.yaoqingNum completion:^(NSDictionary *data){
                    [[Session sharedInstance] setRegisterInfo:weakSelf.phoneNumber data:data];
                    
                    [weakSelf hideHUD];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    EMAccount *account = [Session sharedInstance].emAccount;
                    if (account && [account.emUserName length]>0) {
                        [[EMSession sharedInstance] loginWithUsername:account.emUserName password:account.emPassword completion:^{
                            [weakSelf hideHUD];
                            [self.navigationController popoverPresentationController];
                            [weakSelf.view endEditing:YES];
                            //                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                            if (_resetPasswordDoneBlocks) {
                                _resetPasswordDoneBlocks(weakSelf,self.textFieldSecret.text);
                            }
                        } failure:^(XMError *error) {
                            [weakSelf hideHUD];
                            [self.navigationController popoverPresentationController];
                            [weakSelf.view endEditing:YES];
                            //                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                            if (_resetPasswordDoneBlocks) {
                                _resetPasswordDoneBlocks(weakSelf,self.textFieldSecret.text);
                            }
                        }];
                    } else {
                        [weakSelf hideHUD];
                        [self.navigationController popoverPresentationController];
                        [weakSelf.view endEditing:YES];
                        //                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                        if (_resetPasswordDoneBlocks) {
                            _resetPasswordDoneBlocks(weakSelf,self.textFieldSecret.text);
                        }
                    }
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.contentView];
                }];
                
            } else if (self.index == 2 || self.index == 3) {
                WEAKSELF;
                [self.view endEditing:YES];
                weakSelf.isResetPassword = YES;
                if (self.textFieldSecret.text.length >= 6 ) {
                    if (self.isResetPassword){ //&& _resetPasswordDoneBlocks) {
                        _request = [[NetworkAPI sharedInstance] resetPassword:weakSelf.phoneNumber password:self.textFieldSecret.text authcode:self.textFieldVerify.text completion:^{
                            if (self.index == 2){
                                [weakSelf showHUD:@"修改成功" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
                            } else if (self.index == 3) {
                                [weakSelf showHUD:@"重置成功" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
                            }
                            if (_resetPasswordDoneBlocks) {
                                _resetPasswordDoneBlocks(weakSelf,self.textFieldSecret.text);
                            }
                        } failure:^(XMError *error) {
                            [super showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self.contentView];
                        }];
                        
                    } else {
                        if (_resetPasswordDoneBlocks) {
                            _resetPasswordDoneBlocks(self,self.textFieldSecret.text);
                        }
                    }
                    //        } else {
                    //            [super showHUD:@"输入的密码不匹配" hideAfterDelay:0.8f forView:self.contentView];
                    //        }
                } else {
                    [super showHUD:@"请输入至少6位密码" hideAfterDelay:0.8f forView:weakSelf.contentView];
                }
            } else if (self.index == 4) {
                [AuthService binding:weakSelf.phoneNumber password:weakSelf.textFieldSecret.text auth_code:weakSelf.textFieldVerify.text invitationCode:weakSelf.yaoqingNum completion:^(NSDictionary *data) {
                    
                    [[Session sharedInstance] bindingPhone:weakSelf.phoneNumber];
                    [weakSelf showHUD:@"绑定成功" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
                    if (data[@"meow"]) {
                        NSString * string = [data stringValueForKey:@"meow"];
                        [weakSelf showHUD:string hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
                    }
                    [weakSelf dismiss];
                    
                    if (_resetPasswordDoneBlocks) {
                        _resetPasswordDoneBlocks(self,self.textFieldSecret.text);
                    }
                    
                } failure:^(XMError *error) {
                    [super showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self.contentView];
                }];
            } else if (self.index == 5) {
                //更换手机
                [AuthService renewPhoneNum:weakSelf.phoneNumber password:weakSelf.textFieldSecret.text auth_code:weakSelf.textFieldVerify.text completion:^(NSDictionary *data) {
                    
                    //                    if (weakSelf.changeDisMiss) {
                    //                        weakSelf.changeDisMiss(weakSelf);
                    //                    }
                    //                    controller.changeDisMiss = ^(GetCaptchaCodeViewController *viewController){
                    //                        [viewController dismiss];
                    //                    };
                    if (weakSelf.changeDisMiss) {
                        weakSelf.changeDisMiss(weakSelf);
                    }
                } failure:^(XMError *error) {
                    [super showHUD:[error errorMsg] hideAfterDelay:1.2f forView:self.contentView];
                }];
            } else if (self.index == 6) {
                [AuthService surePhoneNum:weakSelf.phoneNumber auth_code:weakSelf.textFieldVerify.text completion:^(NSDictionary *data) {
                    [[Session sharedInstance] bindingPhone:weakSelf.phoneNumber];
                    [weakSelf showHUD:@"更换成功" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
                    [weakSelf dismiss];
                } failure:^(XMError *error) {
                    [super showHUD:[error errorMsg] hideAfterDelay:1.2f forView:self.contentView];
                }];
                
            }
            
        } else {
            [weakSelf showHUD:@"请输入6位验证码" hideAfterDelay:0.8f forView:self.view];
        }
    } else {
        //
    }
}

//#pragma mark --------------------------这里可能需要修改一下
//-(void)regSuccess{
//    WEAKSELF;
//    [self.view endEditing:YES];
//
//    NSString *string1 = [self.textFieldSecret.text trim];
//    //NSString *string2 = [textField2.text trim];
//    if (string1.length >= 6 ) {
//        //if ([string1 isEqualToString:string2]) {
//
//        if (self.isResetPassword && _resetPasswordDoneBlocks) {
//            _request = [[NetworkAPI sharedInstance] resetPassword:_phoneNumber password:string1 authcode:[NSString stringWithFormat:@"%ld", weakSelf.captchaType] completion:^{
//
//                [weakSelf showHUD:@"修改成功,请重新登录" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
//
//                _resetPasswordDoneBlocks(weakSelf,string1);
//
//            } failure:^(XMError *error) {
//                [super showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self.contentView];
//            }];
//
//        } else {
//            if (_resetPasswordDoneBlocks) {
//                _resetPasswordDoneBlocks(weakSelf, string1);
//            }
//        }
//        //        } else {
//        //            [super showHUD:@"输入的密码不匹配" hideAfterDelay:0.8f forView:self.contentView];
//        //        }
//    } else {
//        [super showHUD:@"请输入至少6位密码" hideAfterDelay:0.8f forView:self.contentView];
//    }
//}

-(void)handleRetryClick:(UIButton *)sender{
    
    UITextField *textField = (UITextField*)[_scrollView viewWithTag:100];
    [self.view endEditing:YES];
    self.phoneNumber = textField.text;
    
    WEAKSELF;
    if ([textField.text length] > 0 && [textField.text isValidMobilePhoneNumber]) {
        NSString *message = [NSString stringWithFormat:@"\n我们将电话播报验证码短信到这个号码:\n+86 %@\n",textField.text];
        [WCAlertView showAlertWithTitle:@"确认手机号码"
                                message:message
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 0) {
                             
                         } else {
                             [weakSelf showProcessingHUD:nil forView:weakSelf.contentView];
                             [weakSelf getCaptchaCodeEncrypt:self.captchaType];
                         }
                     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    } else {
        [self showHUD:@"请输入正确的电话号码" hideAfterDelay:0.8 forView:self.view];
    }
    
}

- (void)getCaptchaCodeEncrypt:(NSInteger)sms_type {
    WEAKSELF;
    [weakSelf.timer invalidate];
    weakSelf.timer = nil;
    [weakSelf showProcessingHUD:nil forView:weakSelf.contentView];
    _request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:self.phoneNumber type:self.captchaType sms_type:sms_type completion:^{
        [weakSelf hideHUD];
        
        //        VerifyCaptchaCodeViewController *viewController = [[VerifyCaptchaCodeViewController alloc] init];
        //        viewController.phoneNumber = weakSelf.phoneNumber;//((UITextField*)[weakSelf.scrollView viewWithTag:100]).text;
        //        viewController.captchaType = CaptchaTypeRegistry;
        //        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
        weakSelf.timerPeriod = 60;
        
        UIButton *retryBtn = (UIButton*)[weakSelf.contentView viewWithTag:200];
        retryBtn.enabled = NO;
        retryBtn.hidden = NO;
        
        TTTAttributedLabel *attrLbl = (TTTAttributedLabel*)[weakSelf.contentView viewWithTag:600];
        attrLbl.hidden = YES;
        
        WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        [weakSelf.timer invalidate];
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.contentView];
    }];
}

-(void)changeSwitch:(UISwitch *)switchView{
    if (switchView.isOn) {
        self.textFieldSecret.secureTextEntry = NO;
    } else {
        self.textFieldSecret.secureTextEntry = YES;
    }
}

-(void)handleAlHaveClick:(UIButton *)sender{
    [self dismiss];
}

-(void)handleCustomerClick:(UIButton *)sender{
    
    NSString *title1 = kCustomServicePhoneDisplay;
    NSMutableArray *arr = [NSMutableArray arrayWithObject:title1];
    WEAKSELF;
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:arr
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         
                         if (buttonIndex == 0) {
                             //在这里拨打电话
                             UIWebView*callWebview =[[UIWebView alloc] init];
                             NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", title1]];// 貌似tel:// 或者 tel: 都行
                             [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                             [weakSelf.view addSubview:callWebview];
                         }
                         
                     }];
}

- (void)handleCaptchaClick:(UIButton*)sender
{
    UITextField *textField = (UITextField*)[_scrollView viewWithTag:100];
    
    [self.view endEditing:YES];
    
    WEAKSELF;
    if ([textField.text length] > 0 && [textField.text isValidMobilePhoneNumber]) {
        NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",textField.text];
        [WCAlertView showAlertWithTitle:@"确认手机号码"
                                message:message
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 0) {
                             
                         } else {
                             [weakSelf showProcessingHUD:nil forView:weakSelf.contentView];
                             weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:textField.text type:weakSelf.captchaType sms_type:0 completion:^{
                                 [weakSelf hideHUD];
                                 
                                 self.timerPeriod = 60;
                                 WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
                                 [_timer invalidate];
                                 self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:[weakSelf.contentView viewWithTag:200] repeats:YES];
                                 
                                 //                                 if (weakSelf.getCaptchaCodeDoneBlock) {
                                 //                                     weakSelf.getCaptchaCodeDoneBlock(weakSelf,((UITextField*)[weakSelf.scrollView viewWithTag:100]).text);
                                 //                                 }
                             } failure:^(XMError *error) {
                                 [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.contentView];
                             }];
                         }
                     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    } else {
        [self showHUD:@"请输入正确的电话号码" hideAfterDelay:0.8 forView:self.view];
    }
}

@end


@interface VerifyCaptchaCodeViewController () <TTTAttributedLabelDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,assign) NSInteger timerPeriod;
@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,strong) HTTPRequest *request;


@end

@implementation VerifyCaptchaCodeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.timerPeriod = 60;
    }
    return self;
}

- (void)dealloc
{
    _verifyCaptchaCodeDoneBlock = nil;
    
    [_timer invalidate];
    _scrollView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"填写验证码"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    CGFloat marginTop = _scrollView.bounds.size.height/6;
    
    self.contentView.frame = CGRectMake(0, marginTop, self.contentView.bounds.size.width,self.contentView.bounds.size.height);
    [_scrollView addSubview:self.contentView];
    
    
    [self.view bringSubviewToFront:self.topBar];
    
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
                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
                                 
                                 CGFloat visibleHeight = weakSelf.view.bounds.size.height-keyboardHeight-weakSelf.topBarHeight;
                                 if (visibleHeight<contentHeight) {
                                     targetEndY = contentY-15;
                                 }
                                 
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, contentY+contentHeight)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height+contentY+15+(contentHeight-visibleHeight))];
                                 
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
    
    //    UITextField *textFiled = (UITextField*)[self.contentView viewWithTag:100];
    //    [textFiled becomeFirstResponder];
    
    WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
    [_timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:[weakSelf.contentView viewWithTag:200] repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    UITextField *textField = (UITextField*)[self.contentView viewWithTag:100];
    //    [textField becomeFirstResponder];
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        CGFloat marginTop = 0.f;
        
        UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, marginTop, _contentView.bounds.size.width, 0)];
        descLbl.textColor = [UIColor colorWithHexString:@"D0B87F"];
        descLbl.font = [UIFont systemFontOfSize:13.f];
        descLbl.text = [NSString stringWithFormat:@"我们已发送验证码短信到\n+86 %@",self.phoneNumber];
        descLbl.textAlignment = NSTextAlignmentCenter;
        descLbl.numberOfLines = 0;
        [descLbl sizeToFit];
        descLbl.frame = CGRectMake(0, marginTop, _contentView.bounds.size.width, descLbl.bounds.size.height);
        [_contentView addSubview:descLbl];
        
        marginTop += descLbl.bounds.size.height;
        marginTop += 33.f;
        
        UITextField *textField = [[UnCopyableTextField alloc] initWithFrame:CGRectNull];
        textField.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        textField.font = [UIFont systemFontOfSize:17.f];
        textField.textColor = [UIColor colorWithHexString:@"282828"];
        textField.placeholder = @"输入验证码";
        //[textField setValue:[UIColor colorWithHexString:@"745659"] forKeyPath:@"_placeholderLabel.textColor"];
        textField.frame = CGRectMake(0, marginTop, _contentView.bounds.size.width, 60);
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.tag = 100;
        [_contentView addSubview:textField];
        
        marginTop += textField.bounds.size.height;
        marginTop += 15.f;
        
        UIButton *retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, marginTop, _contentView.bounds.size.width, 40)];
        [retryBtn setTitle:@"点击再次发送(60)" forState:UIControlStateNormal];
        [retryBtn setTitleColor:[UIColor colorWithHexString:@"C7AF7A"] forState:UIControlStateNormal];
        [retryBtn setTitleColor:[UIColor colorWithHexString:@"745659"] forState:UIControlStateDisabled];
        [retryBtn addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
        retryBtn.enabled = NO;
        retryBtn.tag = 200;
        retryBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        retryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [retryBtn sizeToFit];
        retryBtn.frame = CGRectMake((_contentView.bounds.size.width-retryBtn.bounds.size.width)/2, marginTop, retryBtn.bounds.size.width, 40);
        [_contentView addSubview:retryBtn];
        
        marginTop += retryBtn.bounds.size.height;
        marginTop += 15;
        
        //        TTTAttributedLabel *attrLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, marginTop, _contentView.width, 40)];
        //        attrLabel.font = [UIFont systemFontOfSize:12.f];
        
        
        TTTAttributedLabel *attrLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, retryBtn.top, self.view.bounds.size.width, retryBtn.height)];
        attrLabel.delegate = self;
        attrLabel.tag = 600;
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
        
        
        UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake((_contentView.bounds.size.width-160)/2, marginTop, 160, 50)];
        [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        //        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.tag = 300;
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        submitBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];//[UIColor colorWithHexString:@"D0B87F"];
        submitBtn.layer.masksToBounds=YES;
        submitBtn.layer.cornerRadius=15;    //最重要的是这个地方要设成imgview高的一半
        [_contentView addSubview:submitBtn];
        
        marginTop += submitBtn.bounds.size.height;
        
        
        _contentView.frame = CGRectMake(0, 0, _contentView.bounds.size.width, marginTop);
    }
    return _contentView;
}

- (void)onTimer:(NSTimer*)theTimer
{
    UIButton *retryBtn = (UIButton*)[self.contentView viewWithTag:200];
    TTTAttributedLabel *attrLbl = (TTTAttributedLabel*)[self.contentView viewWithTag:600];
    self.timerPeriod -= 1;
    if (self.timerPeriod <= 0) {
        self.timerPeriod = 60;
        
        [retryBtn setTitle:@"点击再次发送(60)" forState:UIControlStateDisabled];
        //            retryBtn.enabled = YES;
        retryBtn.hidden = YES;
        attrLbl.hidden = NO;
        
        [theTimer setFireDate:[NSDate distantFuture]];
    } else {
        [retryBtn setTitle:[NSString stringWithFormat:@"点击再次发送(%ld)",(long)self.timerPeriod] forState:UIControlStateDisabled];
    }
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
            
            TTTAttributedLabel *attrLabel = (TTTAttributedLabel*)[weakSelf.contentView viewWithTag:600];
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

- (void)retry:(UIButton*)sender
{
    [self getCaptchaCodeEncrypt:0];
}

- (void)getCaptchaCodeEncrypt:(NSInteger)sms_type {
    WEAKSELF;
    [weakSelf.timer invalidate];
    weakSelf.timer = nil;
    [weakSelf showProcessingHUD:nil forView:weakSelf.contentView];
    _request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:self.phoneNumber type:self.captchaType sms_type:sms_type completion:^{
        [weakSelf hideHUD];
        
        //        VerifyCaptchaCodeViewController *viewController = [[VerifyCaptchaCodeViewController alloc] init];
        //        viewController.phoneNumber = weakSelf.phoneNumber;//((UITextField*)[weakSelf.scrollView viewWithTag:100]).text;
        //        viewController.captchaType = CaptchaTypeRegistry;
        //        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
        weakSelf.timerPeriod = 60;
        
        UIButton *retryBtn = (UIButton*)[weakSelf.contentView viewWithTag:200];
        retryBtn.enabled = NO;
        retryBtn.hidden = NO;
        
        TTTAttributedLabel *attrLbl = (TTTAttributedLabel*)[weakSelf.contentView viewWithTag:600];
        attrLbl.hidden = YES;
        
        WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        [weakSelf.timer invalidate];
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.contentView];
    }];
}

- (void)submit:(UIButton*)sender
{
    UITextField *textField = (UITextField*)[self.contentView viewWithTag:100];
    WEAKSELF;
    if ([self.phoneNumber length]>0 && [self.phoneNumber isValidMobilePhoneNumber]) {
        if ([textField.text length] == 6) {
            [super showProcessingHUD:nil forView:self.contentView];
            _request = [[NetworkAPI sharedInstance] verifyCaptchaCode:self.phoneNumber captchaCode:textField.text type:self.captchaType completion:^{
                [weakSelf hideHUD];
                
                if (weakSelf.verifyCaptchaCodeDoneBlock) {
                    weakSelf.verifyCaptchaCodeDoneBlock(weakSelf,weakSelf.phoneNumber,((UITextField*)[weakSelf.contentView viewWithTag:100]).text);
                }
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.contentView];
                
            }];
        } else {
            [self showHUD:@"请输入6位验证码" hideAfterDelay:0.8f forView:self.contentView];
        }
    } else {
        //
    }
}



@end







