//
//  LoginViewController.h
//  XianMao
//
//  Created by simon cai on 11/15/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkAPI.h"

//登录页面
@interface CheckPhoneViewController : BaseViewController
@property(nonatomic,assign) BOOL isForBindPhoneNumber;
@end

@interface LoginViewController : BaseViewController

@property(nonatomic,copy) NSString *phoneNumber;

@end

@class UMSocialAccountEntity;
@interface ConfirmLoginWithThirdPartyViewController : BaseViewController
@property(nonatomic,strong) UMSocialAccountEntity *snsAccount;
@end


@class RegisterViewController;
typedef void(^RegisterDoneBlock)(RegisterViewController *viewController);

@interface RegisterViewController : BaseViewController

@property(nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,copy) NSString *captcha;
@property(nonatomic,copy) NSString *password;
@property (nonatomic, copy) NSString *inviteNum;

@property(nonatomic,copy) RegisterDoneBlock registerDoneBlock;

@end

@class ResetPasswordViewController;

typedef void(^ResetPasswordDoneBlock)(ResetPasswordViewController *viewController,NSString *password);

@interface ResetPasswordViewController : BaseViewController

@property(nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,copy) NSString *captcha;
@property(nonatomic,copy) NSString *btnText;

@property(nonatomic,copy) ResetPasswordDoneBlock resetPasswordDoneBlock;
@property(nonatomic,assign) BOOL isResetPassword;

@end


@class GetCaptchaCodeViewController;


typedef void(^ResetPasswordDoneBlocks)(GetCaptchaCodeViewController *viewController,NSString *password);
typedef void(^GetCaptchaCodeDoneBlock)(GetCaptchaCodeViewController *viewController, NSString *phoneNumber);
typedef void(^ChangeDisMiss)(GetCaptchaCodeViewController *viewController);

@interface GetCaptchaCodeViewController : BaseViewController

@property (nonatomic, assign) BOOL isRetry;
@property(nonatomic,copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *yaoqingNum;
@property(nonatomic,assign) CaptchaType captchaType;
@property (nonatomic, assign) BOOL isThirdLogIn;
@property(nonatomic,copy) GetCaptchaCodeDoneBlock getCaptchaCodeDoneBlock;
@property(nonatomic,copy) ResetPasswordDoneBlocks resetPasswordDoneBlocks;
@property (nonatomic, copy) ChangeDisMiss changeDisMiss;

@property (nonatomic, assign) NSInteger index;

@end


@class VerifyCaptchaCodeViewController;
typedef void(^VerifyCaptchaCodeDoneBlock)(VerifyCaptchaCodeViewController *viewController, NSString *phoneNumber, NSString *captcha);

@interface VerifyCaptchaCodeViewController : BaseViewController

@property(nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,assign) NSInteger captchaType;

@property(nonatomic,copy) VerifyCaptchaCodeDoneBlock verifyCaptchaCodeDoneBlock;

@end





