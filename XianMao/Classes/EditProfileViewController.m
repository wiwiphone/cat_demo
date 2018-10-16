//
//  EditProfileViewController.m
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "EditProfileViewController.h"
#import "DataSources.h"
#import <AVFoundation/AVFoundation.h>
#import "Wallet.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SettingsViewController.h"
#import "Command.h"
#import "HooDatePicker.h"
#import "NetworkManager.h"
#import "NetworkAPI.h"
#import "Session.h"
#import "UserAddressViewController.h"
#import "UIImage+Resize.h"
#import "ActionSheet.h"
#import "AssetPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AreaViewController.h"
#import "MyQRCodeViewController.h"
#import "AppDirs.h"

#import "UIInsetCtrls.h"
#import "UIActionSheet+Blocks.h"

#import "PictureItemsEditView.h"
#import "NetworkAPI.h"
#import "UserDetailInfo.h"
#import "HPGrowingTextView.h"

#import "NSDate+Category.h"
#import "NSString+Addtions.h"
#import "WCAlertView.h"

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+UMeng.h"
#import "AuthService.h"

@interface EditProfileViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserProfileChangedReceiver,PictureItemsEditViewDelegate, UIAlertViewDelegate,HooDatePickerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) ADMActionSheet *actionSheet;
@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,assign) BOOL galleryDataChanged;
@property (nonatomic, strong) HooDatePicker *hooDatePicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *birStr;

@property (nonatomic, assign) NSInteger viewCode;
@end

@implementation EditProfileViewController {
    UIBirthdayPicker *_birthdayPicker;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self reloadData];
}

-(HooDatePicker *)hooDatePicker{
    if (!_hooDatePicker) {
        _hooDatePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
        _hooDatePicker.delegate = self;
        _hooDatePicker.datePickerMode = HooDatePickerModeDate;
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
        NSDate *maxDate = [NSDate date];
        NSDate *minDate = [dateFormatter dateFromString:@"1900-01-01"];
        [_hooDatePicker setDate:[NSDate date] animated:YES];
        self.datePicker.minimumDate = minDate;
        self.datePicker.maximumDate = maxDate;
    }
    return _hooDatePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewCode = MineMeansViewCode;
    [[Session sharedInstance] client:self.viewCode data:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216)];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"我的资料"];
    [super setupTopBarBackButton];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    
    _galleryDataChanged = NO;
    
    [self bringTopBarToTop];
    
    [self reloadData];
    
    if (!_userDetailInfo) {
        if ([Session sharedInstance].isLoggedIn && [Session sharedInstance].currentUserId>0) {
            NSInteger userId = [Session sharedInstance].currentUserId;
            WEAKSELF;
            _request = [[NetworkAPI sharedInstance] getUserDetail:userId completion:^(UserDetailInfo *userDetailInfo) {
                [LoadingView hideLoadingView:weakSelf.view];
                weakSelf.userDetailInfo = userDetailInfo;
                [weakSelf reloadData];
                [weakSelf.tableView reloadData];
            } failure:^(XMError *error) {
                //[weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    [super handleTopBarBackButtonClicked:sender];
    
    if (_galleryDataChanged) {
        if (_delegate && [_delegate respondsToSelector:@selector(editProfileGalleryChanged:gallery:)]) {
            [_delegate editProfileGalleryChanged:self gallery:self.userDetailInfo.gallary];
        }
    }
}

- (void)reloadData
{
    WEAKSELF;
    
    NSInteger weixinType = 0;
    NSInteger weiboType = 0;
    NSInteger qqType = 0;
    for (int i = 0; i < self.userDetailInfo.userInfo.thirdPart.count; i++) {
        NSString *platform = self.userDetailInfo.userInfo.thirdPart[i];
        if ([platform isEqualToString:@"weixin"]) {
            weixinType = 1;
        } else if ([platform isEqualToString:@"weibo"]){
            weiboType = 1;
        } else if ([platform isEqualToString:@"qq"]) {
            qqType = 1;
        }
    }
    
    void(^bindBlock)(UMSocialAccountEntity *snsAccount, NSString *platform) = ^(UMSocialAccountEntity *snsAccount, NSString *platform){
        //            ConfirmLoginWithThirdPartyViewController *viewController = [[ConfirmLoginWithThirdPartyViewController alloc] init];
        //            viewController.title = @"进入爱丁猫";
        //            viewController.snsAccount = snsAccount;
        //            [weakSelf pushViewController:viewController animated:YES];
        
        ThirdPartyAccountInfo *accountInfo = [[ThirdPartyAccountInfo alloc] init];
        accountInfo.platform = platform;
        accountInfo.uid = snsAccount.usid;
        accountInfo.username = [Session sharedInstance].currentUser.userName;
        accountInfo.icon_url = snsAccount.iconURL;
        accountInfo.xuid = snsAccount.unionId;
        if (!accountInfo.xuid) {
            accountInfo.xuid = accountInfo.uid;
        }
        
        [weakSelf showProcessingHUD:nil];
        
        NSInteger type = 0;
        for (int i = 0; i < self.userDetailInfo.userInfo.thirdPart.count; i++) {
            NSString *platformHave = self.userDetailInfo.userInfo.thirdPart[i];
            if ([platform isEqualToString:platformHave]) {
                type = 1;
                break;
            } else {
                type = 0;
            }
        }
        
        //0 绑定  1 解绑
        [AuthService bind_third:accountInfo type:@(type) completion:^(NSDictionary *data) {
            NSInteger isShowAlert = [data integerValueForKey:@"type"]; //1弹窗  0不弹窗  -1没有手机号
            NSString * message = [data stringValueForKey:@"message"];
            NSInteger unbindUserId = [data intValueForKey:@"unbind_userId"];
            if (isShowAlert == 1) {
                
                [WCAlertView showAlertWithTitle:@"" message:message customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    [self hideHUD];
                    if (buttonIndex == 0) {
                        
                    } else {
                        
                        [AuthService authUnbindthird:platform unbindUserId:unbindUserId completion:^(NSDictionary *data) {
                            [self hideHUD];
                            if (type == 0) {
                                [weakSelf showHUD:@"绑定成功" hideAfterDelay:1.2];
                                [weakSelf.userDetailInfo.userInfo.thirdPart addObject:platform];
                            }
                            [weakSelf reloadData];
                            [weakSelf.tableView reloadData];
                        } failure:^(XMError *error) {
                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"继续绑定", nil];
                return ;
            } else if (isShowAlert == -1) {
                [WCAlertView showAlertWithTitle:@"提示" message:message customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    [self hideHUD];
                    if (buttonIndex == 1) {
                        GetCaptchaCodeViewController *resetPasswordViewController = [[GetCaptchaCodeViewController alloc] init];
                        resetPasswordViewController.title = @"绑定手机号";
                        resetPasswordViewController.isRetry = YES;
                        resetPasswordViewController.index = 4;
                        //        resetPasswordViewController.phoneNumber = phoneNumber;
                        resetPasswordViewController.captchaType = CaptchaTypeBindPhone;
                        //        resetPasswordViewController.isResetPassword = YES;
                        [weakSelf pushViewController:resetPasswordViewController animated:YES];
                    }
                    
                } cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                return;
            }
            
            if (type == 0) {
                [weakSelf showHUD:@"绑定成功" hideAfterDelay:1.2];
                [weakSelf.userDetailInfo.userInfo.thirdPart addObject:platform];
            } else if (type == 1) {
                [weakSelf showHUD:@"解绑成功" hideAfterDelay:1.2];
                [weakSelf.userDetailInfo.userInfo.thirdPart removeObject:platform];
            }
            [weakSelf reloadData];
            [weakSelf.tableView reloadData];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
        }];
    };
    
    NSString *summary = [[Session sharedInstance].currentUser.summary isEqual:[NSNull class]]?@"+20喵钻":[Session sharedInstance].currentUser.summary;
    if (self.userDetailInfo) {
        summary = [self.userDetailInfo.userInfo.summary isEqual:[NSNull class]]?@"+20喵钻":self.userDetailInfo.userInfo.summary;
    }
    NSString *galleryTitle = [NSString stringWithFormat:@"介绍图片(%ld/9)",(long)(_userDetailInfo&&_userDetailInfo.gallary?[_userDetailInfo.gallary count]:0)];
    
    //    NSString *birthday = @"未知";
    //        long long birthday = [Session sharedInstance].currentUser.birthday;
    //        if (birthday==0) birthday = @"未知";
    
    NSString *gender = @"+20喵钻";
    if ([Session sharedInstance].currentUser.gender==1) {
        gender = @"男";
    } else if ([Session sharedInstance].currentUser.gender==2) {
        gender = @"女";
    }
    
    NSLog(@"------------------%lld", [Session sharedInstance].currentUser.birthday);
    
    NSString *birthdayStr = [NSString stringWithFormat:@"%lld", [Session sharedInstance].currentUser.birthday/1000];
    if ([birthdayStr isEqualToString:@"0"]) {
        birthdayStr = @"+20喵钻";
    }else{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[birthdayStr longLongValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        birthdayStr = [dateFormatter stringFromDate:date];
    }
    
    NSString * weixinId;
    if ([Session sharedInstance].currentUser.weixinId.length > 0) {
        weixinId = [Session sharedInstance].currentUser.weixinId;
    }else{
        weixinId = @"+20喵钻";
    }
    
    NSString *value = @"";
    value = birthdayStr;
    
    NSString *phoneTitle = @"绑定手机";
    if (![Session sharedInstance].isBindingPhoneNumber) {
        phoneTitle = @"绑定手机";
    } else {
        phoneTitle = @"更换手机";
    }
    
    NSString *phoneNumber;
    if ([Session sharedInstance].currentUser.phoneNumber.length > 0) {
        phoneNumber = [Session sharedInstance].currentUser.phoneNumber;
    }else{
        phoneNumber = @"+50喵钻";
    }
    
    NSMutableArray *dataSources = [NSMutableArray arrayWithObjects:
                                   [[EditAvatarTableViewCell buildCellDict:EditProfileTypeAvatar
                                                                     title:@"头像"
                                                                     value:[Session sharedInstance].currentUser.avatarUrl] fillAction:^{
        [weakSelf editAvatar];
    }],
                                   [[EditProfileTableViewCell buildCellDict:EditProfileTypeOther
                                                                      title:@"用户名"
                                                                      value:[Session sharedInstance].currentUser.userName
                                                                isShowArrow:[Session sharedInstance].modify_username_enable] fillAction:^{
        if ([Session sharedInstance].modify_username_enable) {
            EditUserNameViewController *viewController = [[EditUserNameViewController alloc] init];
            viewController.isEditUserName = YES;
            viewController.handleDidEditUserName = ^(EditUserNameViewController *viewController, NSString *userName) {
                [weakSelf showProcessingHUD:nil];
                weakSelf.request = [[NetworkAPI sharedInstance] setUserName:userName completion:^{
                    [weakSelf hideHUD];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[Session sharedInstance] setUserUserName:userName];
                    });
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                }];
            };
            [weakSelf pushViewController:viewController animated:YES];
        }
        
    }],
//我的收款二维码暂停下线
                                   [[EditAvatarTableViewCell buildCellDict:EditProfileTypeOther title:@"收款二维码" value:@"" isShowArrow:YES] fillAction:^{
        MyQRCodeViewController * viewController = [[MyQRCodeViewController alloc] init];
        [self pushViewController:viewController animated:YES];
    }],
                                   [SegTableViewCell buildCellDict:EditProfileTypeOther title:@"" value:@""],
                                   [[EditProfileTableViewCell buildCellDict:EditProfileTypeOther
                                                                      title:@"性别"
                                                                      value:gender] fillAction:^{
        EditGenderViewController *viewController = [[EditGenderViewController alloc] init];
        viewController.handleDidEditGender = ^(EditGenderViewController *viewController, NSInteger gender) {
            [weakSelf showProcessingHUD:nil];
            weakSelf.request = [[NetworkAPI sharedInstance] setGender:gender completion:^(NSDictionary *data){
                [weakSelf hideHUD];
                if (data[@"meow"]) {
                    NSString * meow = data[@"meow"];
                    [weakSelf showHUD:meow hideAfterDelay:0.8];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Session sharedInstance] setUserGender:gender];
                });
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        };
        [weakSelf pushViewController:viewController animated:YES];
    }],
                                   
                                   [[EditBirthdayTableViewCell buildCellDict:EditProfileTypeOther title:@"生日" value:value] fillAction:^{
        //做一些操作
//        weakSelf.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        weakSelf.datePicker.datePickerMode = UIDatePickerModeDate;
//        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//        weakSelf.datePicker.locale = local;
//        [weakSelf.view addSubview:weakSelf.datePicker];
//        
//        [weakSelf.datePicker addTarget:self action:@selector(datePickerClick:) forControlEvents:UIControlEventValueChanged];
        [self.hooDatePicker show];
 
    }],
                                   
                                   [[EditWecatIDTableViewCell buildCellDict:EditProfileTypeOther title:@"微信ID" value:weixinId] fillAction:^{
        
        EditUserNameViewController *viewController = [[EditUserNameViewController alloc] init];
        viewController.isEditUserName = NO;
        viewController.handleDidEditUserName = ^(EditUserNameViewController *viewController, NSString *wecatId) {
            [weakSelf showProcessingHUD:nil];
            weakSelf.request = [[NetworkAPI sharedInstance] bindingWecat:wecatId completion:^(NSDictionary *data){
                
                [weakSelf hideHUD];
                if (data[@"meow"]) {
                    NSString * meow = data[@"meow"];
                    [weakSelf showHUD:meow hideAfterDelay:0.8 forView:weakSelf.view];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Session sharedInstance] setUserweixinId:wecatId];
                });
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
            
        };
        [weakSelf pushViewController:viewController animated:YES];
        
    }],
                                   
                                   //                                   [[EditProfileTableViewCell buildCellDict:EditProfileTypeOther
                                   //                                                                      title:@"出生日期"
                                   //                                                                      value:birthdayStr] fillAction:^{
                                   //        [weakSelf editBirthday];
                                   //    }],
                                   
                                   [[EditSummaryTableViewCell buildCellDict:EditProfileTypeOther title:@"个性签名" value:summary] fillAction:^{
        EditSummaryViewController *viewController = [[EditSummaryViewController alloc] init];
        viewController.summary = weakSelf.userDetailInfo.userInfo.summary;
        [weakSelf pushViewController:viewController animated:YES];
        viewController.handleDidEditSummary = ^(EditSummaryViewController *viewController, NSString *summary){
            if (![weakSelf.userDetailInfo.userInfo.summary isEqualToString:summary]) {
                [weakSelf showProcessingHUD:nil];
                weakSelf.request = [[NetworkAPI sharedInstance] setSummary:summary completion:^(NSDictionary *data){
                    [weakSelf hideHUD];
                    if (data[@"meow"]) {
                        NSString * meow = data[@"meow"];
                        [weakSelf showHUD:meow hideAfterDelay:0.8];
                    }
                    weakSelf.userDetailInfo.userInfo.summary = summary;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[Session sharedInstance] setUserSummary:summary];
                    });
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                }];
            }
        };
    }],
                                   [SegTableViewCell buildCellDict:EditProfileTypeOther title:@"" value:@""],
                                   
                                   [[EditSafeTableViewCell buildCellDict:EditProfileTypeOther title:@"账号安全" value:@""] fillAction:^{
        //这里执行方法
    }],
                                   
                                   [[EditPhoneTableViewCell buildCellDict:EditProfileTypeOther title:phoneTitle value:phoneNumber] fillAction:^{
        if (![Session sharedInstance].isBindingPhoneNumber) {
            
            GetCaptchaCodeViewController *resetPasswordViewController = [[GetCaptchaCodeViewController alloc] init];
            resetPasswordViewController.title = @"绑定手机号";
            resetPasswordViewController.isRetry = YES;
            resetPasswordViewController.index = 4;
            //        resetPasswordViewController.phoneNumber = phoneNumber;
            resetPasswordViewController.captchaType = CaptchaTypeBindPhone;
            //        resetPasswordViewController.isResetPassword = YES;
            [weakSelf pushViewController:resetPasswordViewController animated:YES];
            
        } else {
            _request = [[NetworkAPI sharedInstance] getWallet:^(Wallet *wallet) {
                [weakSelf hideLoadingView];
                if (wallet.moneyInfo.availableMoney > 0) {
                    [self showHUD:@"钱包余额为0才能更换手机号" hideAfterDelay:1.2];
                }else{
                    GetCaptchaCodeViewController *resetPasswordViewController = [[GetCaptchaCodeViewController alloc] init];
                    resetPasswordViewController.title = @"更换手机";
                    resetPasswordViewController.isRetry = YES;
                    resetPasswordViewController.index = 5;
                    resetPasswordViewController.captchaType = CaptchaTypeVerifyPhoneNum;
                    [weakSelf pushViewController:resetPasswordViewController animated:YES];
                    resetPasswordViewController.changeDisMiss = ^(GetCaptchaCodeViewController *viewController){
                        [viewController dismiss];
                        GetCaptchaCodeViewController *controller = [[GetCaptchaCodeViewController alloc] init];
                        controller.title = @"更换手机";
                        controller.isRetry = YES;
                        controller.index = 6;
                        controller.captchaType = CaptchaTypeAlterPhoneNum;
                        [[CoordinatingController sharedInstance] pushViewController:controller animated:YES];
                    };
                }
                
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        }
    }],
                                   
                                   [[EditRetryPasswordTableViewCell buildCellDict:EditProfileTypeOther title:@"重置密码" value:@""] fillAction:^{
        if (![Session sharedInstance].isBindingPhoneNumber) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有绑定手机号，请先绑定手机号" delegate:self cancelButtonTitle:@"稍后绑定" otherButtonTitles:@"去绑定", nil];
            
            [alert show];
            
        } else {
            
            [weakSelf.view endEditing:YES];
            GetCaptchaCodeViewController *viewController = [[GetCaptchaCodeViewController alloc] init];
            viewController.index = 3;
            viewController.isRetry = YES;
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
            //            viewController.phoneNumber = phoneNumber;
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
            
            //            GetCaptchaCodeViewController *resetPasswordViewController = [[GetCaptchaCodeViewController alloc] init];
            //            resetPasswordViewController.index = 3;
            //            resetPasswordViewController.title = @"重置密码";
            //            resetPasswordViewController.isRetry = YES;
            //            //        resetPasswordViewController.phoneNumber = phoneNumber;
            //            resetPasswordViewController.captchaType = 2;
            //            //        resetPasswordViewController.isResetPassword = YES;
            //            [weakSelf pushViewController:resetPasswordViewController animated:YES];
        }
        
        
    }],
                                   [SegTableViewCell buildCellDict:EditProfileTypeOther title:@"" value:@""],
                                   [[SettingsTableViewCell buildCellDictWithRightArrow:@"管理收货地址"] fillAction:^{
        [MobClick event:@"click_manage_my_address"];
        [ClientReportObject clientReportObjectWithViewCode:MineSettingViewCode regionCode:ManagePutGoodsAddrViewCode referPageCode:ManagePutGoodsAddrViewCode andData:nil];
        UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
        
    }],
                                   [[SettingsTableViewCell buildCellDictWithRightArrow:@"管理退货地址"] fillAction:^{
        [MobClick event:@"click_manage_my_address_send"];
        [ClientReportObject clientReportObjectWithViewCode:MineSettingViewCode regionCode:ManageOutGoodsAddrViewCode referPageCode:ManageOutGoodsAddrViewCode andData:nil];
        UserAddressViewController *viewController = [[UserAddressViewControllerReturn alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
        
    }],
                                   [SegTableViewCell buildCellDict:EditProfileTypeOther title:@"" value:@""],
                                   
                                   [[EditUserCountTableViewCell buildCellDict:EditProfileTypeOther title:@"微信" value:@"" isBind:weixinType] fillAction:^{
        if (weixinType == 0) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginWithThridParty:weakSelf platformName:UMShareToWechatSession completion:^(UMSocialAccountEntity *snsAccount) {
                bindBlock(snsAccount,@"weixin");
                
            }];
        } else if (weixinType == 1){
            bindBlock(nil,@"weixin");
        }
    }],
                                   
                                   [[EditUserCountTableViewCell buildCellDict:EditProfileTypeOther title:@"QQ" value:@"" isBind:qqType] fillAction:^{
        if (qqType == 0) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginWithThridParty:weakSelf platformName:UMShareToQQ completion:^(UMSocialAccountEntity *snsAccount) {
                bindBlock(snsAccount,@"qq");
                
            }];
        } else if (qqType == 1) {
            bindBlock(nil,@"qq");
        }
    }],
                                   [[EditUserCountTableViewCell buildCellDict:EditProfileTypeOther title:@"微博" value:@"" isBind:weiboType] fillAction:^{
        if (weiboType == 0) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginWithThridParty:weakSelf platformName:UMShareToSina completion:^(UMSocialAccountEntity *snsAccount) {
                bindBlock(snsAccount,@"weibo");
                
            }];
        } else if (weiboType == 1) {
            bindBlock(nil,@"weibo");
        }
    }],
                                   nil];
    
    //                                   [EditGalleryTableViewCell buildCellDict:EditProfileTypeOther title:galleryTitle value:@"将展示在个人首页" userDetailInfo:weakSelf.userDetailInfo],
    //                                                           [[EditProfileTableViewCell buildCellDict:EditProfileTypeOther
    //                                                                                              title:@"出生日期"
    //                                                                                              value:birthday] fillAction:^{
    //                                           [weakSelf editBirthday];
    //                                       }],
    //                                   nil];
    
    
    
    self.dataSources = dataSources;
    [self.tableView reloadData];
}

- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    if (timeSp && timeSp.length > 0) {
        [self showProcessingHUD:nil];
        self.request = [[NetworkAPI sharedInstance] setBirthday:[timeSp longLongValue]*1000 completion:^(NSDictionary *data){
            [self hideHUD];
            if (data[@"meow"]) {
                NSString * meow = data[@"meow"];
                [self showHUD:meow hideAfterDelay:0.8];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Session sharedInstance] setUserBirthday:[timeSp longLongValue]*1000];
            });
        } failure:^(XMError *error) {
            [self showHUD:[error errorMsg] hideAfterDelay:0.8];
        }];
    }
}

-(void)datePickerClick:(UIDatePicker *)datePicker{
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birStr = [dateFormatter stringFromDate:date];
    self.birStr = birStr;
    
    //转成时间戳
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    if (timeSp && timeSp.length > 0) {
//        [self showProcessingHUD:nil];
//        self.request = [[NetworkAPI sharedInstance] setBirthday:[timeSp longLongValue] completion:^{
//            [self hideHUD];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[Session sharedInstance] setUserBirthday:[timeSp longLongValue]];
//            });
//        } failure:^(XMError *error) {
//            [self showHUD:[error errorMsg] hideAfterDelay:0.8];
//        }];
//    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1) {
        GetCaptchaCodeViewController *resetPasswordViewController = [[GetCaptchaCodeViewController alloc] init];
        resetPasswordViewController.title = @"绑定手机号";
        resetPasswordViewController.isRetry = YES;
        //        resetPasswordViewController.phoneNumber = phoneNumber;
        resetPasswordViewController.captchaType = 4;
        //        resetPasswordViewController.isResetPassword = YES;
        [self pushViewController:resetPasswordViewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[EditGalleryTableViewCell class]]) {
        ((EditGalleryTableViewCell*)tableViewCell).viewController = self;
        ((EditGalleryTableViewCell*)tableViewCell).editView.delegate = self;
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    [dict doAction];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.datePicker removeFromSuperview];
}

- (void)editAvatar {
    WEAKSELF;
    
    [UIActionSheet showInView:weakSelf.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex == 0 ) {
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
    //
    //
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
                [weakSelf showProcessingHUD:nil];
                weakSelf.request = [[NetworkAPI sharedInstance] setAvatar:filePath completion:^(NSString *avatarUrl) {
                    [[Session sharedInstance] setUserAvatar:avatarUrl];
                    [weakSelf hideHUD];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                }];
            });
        });
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Processing the status bar
//-(void)navigationController:(UINavigationController *)navigationController
//     willShowViewController:(UIViewController *)viewController
//                   animated:(BOOL)animated
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//}

//-(BOOL)prefersStatusBarHidden   // iOS8 definitely needs this one. checked.
//{
//    return YES;
//}
//
//-(UIViewController *)childViewControllerForStatusBarHidden
//{
//    return nil;
//}


- (void)editBirthday
{
    if (!_birthdayPicker) {
        _birthdayPicker = [[UIBirthdayPicker alloc] initWithFrame:CGRectMake(0, self.view.height-160, self.view.width, 160)];
        _birthdayPicker.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
        
        [_birthdayPicker setDatePickerMode:UIDatePickerModeDate];
        //    NSLog(@"%@",[NSLocale availableLocaleIdentifiers]);
        [_birthdayPicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        _birthdayPicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _birthdayPicker.datePickerMode = UIDatePickerModeDate;
        
        
        //设置生日文本输入时使用的试图
        [_birthdayPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        //设置日期控件初始值
        //4.1 指定字符串
        NSString *beforeString = @"1995-01-01";
        //4.2 字符串转化成日期
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* inputDate = [inputFormatter dateFromString:beforeString];
        //4.3 转化后字符串给日期选择控件
        [_birthdayPicker setDate:inputDate animated:YES];
    }
    [self.view addSubview:_birthdayPicker];
}

#pragma mark -日期选择器的监听方法
-(void) dateChanged:(UIDatePicker *)datePicker{
    //    NSDate *date = datePicker.date;
    //    NSLog(@"%@", date);
    //    //设计日期格式
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    //设置日期格式
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *str = [formatter stringFromDate:date];
    //    _textField.text = str;
    //    NSLog(@"%@", _textField.text);
}

- (void)$$handleUserNameChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    [self reloadData];
}

- (void)$$handleAvatarChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    [self reloadData];
}

- (void)$$handleUserProfileChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    [self reloadData];
}

- (void)picturesEditViewHeightChanged:(PictureItemsEditView*)view height:(CGFloat)height
{
    
}

- (void)picturesEditViewPictureItemDeleted:(PictureItemsEditView*)view item:(PictureItem*)item
{
    self.userDetailInfo.gallary = [[NSMutableArray alloc] initWithArray:view.picItemsArray];
    [self reloadData];
    _galleryDataChanged = YES;
}

- (void)picturesEditViewPictureItemAdded:(PictureItemsEditView*)view
{
    self.userDetailInfo.gallary = [[NSMutableArray alloc] initWithArray:view.picItemsArray];
    [self reloadData];
    _galleryDataChanged = YES;
}

- (void)picturesEditViewPictureItemOrdersChanged:(PictureItemsEditView*)view
{
    self.userDetailInfo.gallary = [[NSMutableArray alloc] initWithArray:view.picItemsArray];
    _galleryDataChanged = YES;
}

@end


@interface EditProfileTableViewCell ()

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UILabel *valueLbl;
@property(nonatomic,strong) CALayer *rightArrow;
@property(nonatomic,strong) CALayer *bottomLine;
@property(nonatomic,assign) BOOL isShowArrow;
@end

@implementation EditProfileTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditProfileTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    if ([dict integerValueForKey:@"type"]==EditProfileTypeAvatar) {
        rowHeight = 51.f;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES];
}
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[EditProfileTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    return dict;
}
+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        [self.contentView addSubview:_titleLbl];
        
        
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _valueLbl.font = [UIFont systemFontOfSize:13.f];
        _valueLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _valueLbl.backgroundColor = [UIColor clearColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
        _valueLbl.numberOfLines = 2;
        [self.contentView addSubview:_valueLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)rightArrow.CGImage;
        _rightArrow.frame = CGRectMake(0, 0, rightArrow.size.width, rightArrow.size.height);
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        _bottomLine.borderWidth = 1.f;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _isShowArrow = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLbl.frame = CGRectNull;
    _valueLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width-30, 1);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(25.f, 0, _titleLbl.width, self.contentView.height);
    
    CGFloat rightArrowX = self.contentView.width;
    if (![_rightArrow isHidden]) {
        rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
        _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    }
    
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, 0);
    [_valueLbl sizeToFit];
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        _titleLbl.text = title;
        
        _valueLbl.hidden = NO;
        _valueLbl.text = value;
        
        _isShowArrow = [dict boolValueForKey:@"showArrow" defaultValue:YES];
        _rightArrow.hidden = !_isShowArrow;
        
        [self setNeedsLayout];
    }
}

@end

@implementation SegTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SegTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES];
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 12.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SegTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    return dict;
}

+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end


@interface EditBirthdayTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;
@property (nonatomic, strong) CALayer *rightArrow;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, assign) BOOL isShowArrow;

@end

@implementation EditBirthdayTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditBirthdayTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    if ([dict integerValueForKey:@"type"]==EditProfileTypeAvatar) {
        rowHeight = 44.f;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES];
}
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[EditBirthdayTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    return dict;
}
+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        [self.contentView addSubview:_titleLbl];
        
        
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _valueLbl.font = [UIFont systemFontOfSize:13.f];
        _valueLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _valueLbl.backgroundColor = [UIColor clearColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
        _valueLbl.numberOfLines = 2;
        [self.contentView addSubview:_valueLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)rightArrow.CGImage;
        _rightArrow.frame = CGRectMake(0, 0, rightArrow.size.width, rightArrow.size.height);
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        _bottomLine.borderWidth = 1.f;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _isShowArrow = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLbl.frame = CGRectNull;
    _valueLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width - 30, 1);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(25.f, 0, _titleLbl.width, self.contentView.height);
    
    CGFloat rightArrowX = self.contentView.width;
    if (![_rightArrow isHidden]) {
        rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
        _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    }
    
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, 0);
    [_valueLbl sizeToFit];
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        _titleLbl.text = title;
        
        _valueLbl.hidden = NO;
        _valueLbl.text = value;
        
        _isShowArrow = [dict boolValueForKey:@"showArrow" defaultValue:YES];
        _rightArrow.hidden = !_isShowArrow;
        
        [self setNeedsLayout];
    }
}

@end


@interface EditPhoneTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;
@property (nonatomic, strong) CALayer *rightArrow;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, assign) BOOL isShowArrow;

@end

@implementation EditPhoneTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditPhoneTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    if ([dict integerValueForKey:@"type"]==EditProfileTypeAvatar) {
        rowHeight = 51.f;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES];
}
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[EditPhoneTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    return dict;
}
+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        [self.contentView addSubview:_titleLbl];
        
        
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _valueLbl.font = [UIFont systemFontOfSize:13.f];
        _valueLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _valueLbl.backgroundColor = [UIColor clearColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
        _valueLbl.numberOfLines = 2;
        [self.contentView addSubview:_valueLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)rightArrow.CGImage;
        _rightArrow.frame = CGRectMake(0, 0, rightArrow.size.width, rightArrow.size.height);
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        _bottomLine.borderWidth = 1.f;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _isShowArrow = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLbl.frame = CGRectNull;
    _valueLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width - 30, 1);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(25.f, 0, _titleLbl.width, self.contentView.height);
    
    CGFloat rightArrowX = self.contentView.width;
    if (![_rightArrow isHidden]) {
        rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
        _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    }
    
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, 0);
    [_valueLbl sizeToFit];
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        _titleLbl.text = title;
        
        _valueLbl.hidden = NO;
        _valueLbl.text = value;
        
        _isShowArrow = [dict boolValueForKey:@"showArrow" defaultValue:YES];
        _rightArrow.hidden = !_isShowArrow;
        
        [self setNeedsLayout];
    }
}

@end


@interface EditUserCountTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;
@property (nonatomic, strong) UIImageView *rightArrow;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, assign) BOOL isShowArrow;
@property (nonatomic, strong) UILabel *label;

@end

@implementation EditUserCountTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditUserCountTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    if ([dict integerValueForKey:@"type"]==EditProfileTypeAvatar) {
        rowHeight = 51.f;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                               isBind:(NSInteger)isBind
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES isBind:isBind];
}
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
                               isBind:(NSInteger)isBind
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[EditUserCountTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    [dict setObject:[NSNumber numberWithInteger:isBind] forKey:@"isBind"];
    return dict;
}
+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        [self.contentView addSubview:_titleLbl];
        
        
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _valueLbl.font = [UIFont systemFontOfSize:13.f];
        _valueLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _valueLbl.backgroundColor = [UIColor clearColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
        _valueLbl.numberOfLines = 2;
        [self.contentView addSubview:_valueLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@""];//Lock_MF2
        //        _rightArrow = [CALayer layer];
        //        _rightArrow.contents = (id)rightArrow.CGImage;
        _rightArrow = [[UIImageView alloc] init];
        _rightArrow.frame = CGRectMake(0, 0, 65, 25);
        _rightArrow.image = rightArrow;
        [self.contentView addSubview:_rightArrow];
        
        UILabel *label = [[UILabel alloc] init];
        label.layer.shadowColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        label.text = @"绑定";
        label.font = [UIFont boldSystemFontOfSize:12.f];
        [label sizeToFit];
        label.frame = CGRectMake(_rightArrow.right - label.width-4, _rightArrow.centerY - label.height / 2, label.width+8, label.height+6);
        label.textColor = [UIColor colorWithHexString:@"434342"];
        [_rightArrow addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor colorWithHexString:@"434342"].CGColor;
        label.layer.borderWidth = 1.f;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        self.label = label;
        
        _bottomLine = [CALayer layer];
        _bottomLine.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        _bottomLine.borderWidth = 1.f;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _isShowArrow = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLbl.frame = CGRectNull;
    _valueLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width - 30, 1);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(25.f, 0, _titleLbl.width, self.contentView.height);
    
    CGFloat rightArrowX = self.contentView.width;
    if (![_rightArrow isHidden]) {
        rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
        _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    }
    
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, 0);
    [_valueLbl sizeToFit];
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        _titleLbl.text = title;
        
        _valueLbl.hidden = NO;
        _valueLbl.text = value;
        
        _isShowArrow = [dict boolValueForKey:@"showArrow" defaultValue:YES];
        _rightArrow.hidden = !_isShowArrow;
        
        NSInteger isBind = [dict integerValueForKey:@"isBind"];
        if (isBind == 0) {
            self.label.text = @"绑定";
            self.label.layer.borderColor = [UIColor colorWithHexString:@"434342"].CGColor;
            self.label.textColor = [UIColor colorWithHexString:@"434342"];
        } else {
            self.label.text = @"解绑";
            self.label.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
            self.label.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        }
        
        [self setNeedsLayout];
    }
}

@end


@interface EditRetryPasswordTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;
@property (nonatomic, strong) CALayer *rightArrow;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, assign) BOOL isShowArrow;

@end

@implementation EditRetryPasswordTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditRetryPasswordTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    if ([dict integerValueForKey:@"type"]==EditProfileTypeAvatar) {
        rowHeight = 51.f;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES];
}
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[EditRetryPasswordTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    return dict;
}
+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        [self.contentView addSubview:_titleLbl];
        
        
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _valueLbl.font = [UIFont systemFontOfSize:13.f];
        _valueLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _valueLbl.backgroundColor = [UIColor clearColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
        _valueLbl.numberOfLines = 2;
        [self.contentView addSubview:_valueLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)rightArrow.CGImage;
        _rightArrow.frame = CGRectMake(0, 0, rightArrow.size.width, rightArrow.size.height);
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        _bottomLine.borderWidth = 1.f;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _isShowArrow = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLbl.frame = CGRectNull;
    _valueLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width - 30, 1);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(25.f, 0, _titleLbl.width, self.contentView.height);
    
    CGFloat rightArrowX = self.contentView.width;
    if (![_rightArrow isHidden]) {
        rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
        _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    }
    
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, 0);
    [_valueLbl sizeToFit];
    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        _titleLbl.text = title;
        
        _valueLbl.hidden = NO;
        _valueLbl.text = value;
        
        _isShowArrow = [dict boolValueForKey:@"showArrow" defaultValue:YES];
        _rightArrow.hidden = !_isShowArrow;
        
        [self setNeedsLayout];
    }
}

@end


@interface EditSafeTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *valueLbl;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, assign) BOOL isShowArrow;

@end

@implementation EditSafeTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditSafeTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    //    if ([dict integerValueForKey:@"type"]==EditProfileTypeAvatar) {
    //        rowHeight = 40.f;
    //    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    return [self buildCellDict:type title:title value:value isShowArrow:YES];
}
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[EditSafeTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (title) [dict setObject:title forKey:@"title"];
    if (value) [dict setObject:value forKey:[self cellDictKeyForValue]];
    [dict setObject:[NSNumber numberWithBool:isShowArrow] forKey:[self cellDictShowArrow]];
    return dict;
}
+ (NSString*)cellDictKeyForValue {
    return @"value";
}
+ (NSString*)cellDictShowArrow {
    return @"showArrow";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        [self.contentView addSubview:_titleLbl];
        
        
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _valueLbl.font = [UIFont systemFontOfSize:13.f];
        _valueLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _valueLbl.backgroundColor = [UIColor clearColor];
        _valueLbl.textAlignment = NSTextAlignmentRight;
        _valueLbl.numberOfLines = 2;
        [self.contentView addSubview:_valueLbl];
        
        //        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
        //        _rightArrow = [CALayer layer];
        //        _rightArrow.contents = (id)rightArrow.CGImage;
        //        _rightArrow.frame = CGRectMake(0, 0, rightArrow.size.width, rightArrow.size.height);
        //        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        _bottomLine.borderWidth = 1.f;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _isShowArrow = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLbl.frame = CGRectNull;
    _valueLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width - 30, 1);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(25.f, 0, _titleLbl.width, self.contentView.height);
    _titleLbl.textColor = [UIColor colorWithHexString:@"dbdcdc"];
    
    //    CGFloat rightArrowX = self.contentView.width;
    //    if (![_rightArrow isHidden]) {
    //        rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
    //        _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    //    }
    
    //    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, 0);
    //    [_valueLbl sizeToFit];
    //    _valueLbl.frame = CGRectMake(100, 0, rightArrowX-15-100, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        _titleLbl.text = title;
        
        _valueLbl.hidden = NO;
        _valueLbl.text = value;
        
        _isShowArrow = [dict boolValueForKey:@"showArrow" defaultValue:YES];
        //        _rightArrow.hidden = !_isShowArrow;
        
        [self setNeedsLayout];
    }
}

@end


@implementation EditAvatarTableViewCell {
    XMWebImageView *_avatarView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditAvatarTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 60.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value
{
    NSMutableDictionary *dict = [EditProfileTableViewCell buildCellDict:type title:title value:value];
    [dict setObject:NSStringFromClass([EditAvatarTableViewCell class]) forKey:[[super class] dictKeyOfClsName]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 35.f/2;
        _avatarView.userInteractionEnabled = YES;
        _avatarView.clipsToBounds = YES;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat rightArrowX = self.contentView.width-15-super.rightArrow.bounds.size.width;
    _avatarView.frame = CGRectMake(rightArrowX-15-35, (self.contentView.height-35)/2, 35, 35);
    _avatarView.hidden = NO;
    super.valueLbl.hidden = YES;
    
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSString *title = [dict stringValueForKey:@"title"];
        NSString *value = [dict stringValueForKey:@"value"];
        super.titleLbl.text = title;
        
        [_avatarView setImageWithURL:value placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"]  XMWebImageScaleType:XMWebImageScale160x160];
        
        [self setNeedsLayout];
    }
}


@end

@implementation EditSummaryTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditSummaryTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    NSMutableDictionary *dict = [EditProfileTableViewCell buildCellDict:type title:title value:value];
    [dict setObject:NSStringFromClass([EditSummaryTableViewCell class]) forKey:[[super class] dictKeyOfClsName]];
    return dict;
}

@end


@implementation EditWecatIDTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditWecatIDTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 44.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
{
    NSMutableDictionary *dict = [EditProfileTableViewCell buildCellDict:type title:title value:value];
    [dict setObject:NSStringFromClass([EditWecatIDTableViewCell class]) forKey:[[super class] dictKeyOfClsName]];
    return dict;
}

@end

@implementation EditGalleryTableViewCell {
    
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([EditGalleryTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 60.f;
    UserDetailInfo *userDetailInfo = [dict objectForKey:[[self class]cellDictKeyForUserDetailInfo]];
    if ([userDetailInfo isKindOfClass:[UserDetailInfo class]]) {
        rowHeight += [PictureItemsEditView heightForOrientationPortrait:[userDetailInfo.gallary count] maxItemsCount:9];
    } else {
        rowHeight += [PictureItemsEditView heightForOrientationPortrait:0 maxItemsCount:9];
    }
    rowHeight += 15.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                       userDetailInfo:(UserDetailInfo*)userDetailInfo
{
    NSMutableDictionary *dict = [EditProfileTableViewCell buildCellDict:type title:title value:value];
    [dict setObject:NSStringFromClass([EditGalleryTableViewCell class]) forKey:[[super class] dictKeyOfClsName]];
    if (userDetailInfo) [dict setObject:userDetailInfo forKey:[self cellDictKeyForUserDetailInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForUserDetailInfo {
    return @"userDetailInfo";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        super.valueLbl.textColor = [UIColor colorWithHexString:@"d0d0d0"];
        
        _editView = [[PictureItemsEditView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [PictureItemsEditView heightForOrientationPortrait:0 maxItemsCount:9]) isShowMainPicTip:NO];
        
        _editView.backgroundColor = [UIColor clearColor];
        _editView.maxItemsCount = 9;
        [self addSubview:_editView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    super.rightArrow.hidden = YES;
    _editView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    super.bottomLine.frame = CGRectMake(0, self.contentView.height-1, self.contentView.width, 1);
    
    CGFloat titleHeight = 60.f;
    
    [super.titleLbl sizeToFit];
    super.titleLbl.frame = CGRectMake(25.f, 0, super.titleLbl.width, titleHeight);
    
    super.valueLbl.frame = CGRectMake(100, 0, self.contentView.width-15-100, 0);
    [super.valueLbl sizeToFit];
    super.valueLbl.frame = CGRectMake(100, 0, self.contentView.width-15-100, titleHeight);
    
    _editView.frame = CGRectMake(0, 60, kScreenWidth, _editView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    [super updateCellWithDict:dict];
    super.rightArrow.hidden = YES;
    
    UserDetailInfo *userDetailInfo = [dict objectForKey:[[self class]cellDictKeyForUserDetailInfo]];
    if ([userDetailInfo isKindOfClass:[UserDetailInfo class]]) {
        _editView.hidden = NO;
        _editView.frame = CGRectMake(0, 60, kScreenWidth, [PictureItemsEditView heightForOrientationPortrait:[userDetailInfo.gallary count] maxItemsCount:9]);
        _editView.viewController = self.viewController;
        _editView.picItemsArray = userDetailInfo.gallary;
    }
}

@end


@interface EditUserNameViewController () <UITextFieldDelegate>
@property(nonatomic,weak) UIInsetTextField *textField;
@end

@implementation EditUserNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    self.isEditUserName == YES?[super setupTopBarTitle:@"用户名"]:[super setupTopBarTitle:@"微信ID"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [self.topBarRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat marginTop = 15.f+topBarHeight;
    
    CALayer *topLine = [CALayer layer];
    topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    topLine.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    [self.view.layer addSublayer:topLine];
    
    marginTop += 1;
    
    UIInsetTextField *textField = [[UIInsetTextField alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 50) rectInsetDX:20 rectInsetDY:0];
    _textField = textField;
    textField.placeholder = self.isEditUserName == YES?@"设置昵称":@"输入微信ID";
    if (self.isEditUserName) {
        textField.text = [Session sharedInstance].currentUser.userName;
    }else{
        textField.text = [Session sharedInstance].currentUser.weixinId;
    }
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:17.f];
    textField.textColor = [UIColor colorWithHexString:@"181818"];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.tag = 200;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField];
    
    marginTop += textField.height;
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    bottomLine.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    [self.view.layer addSublayer:bottomLine];
    
    marginTop += 8;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.font = [UIFont systemFontOfSize:12.f];
    lbl.textColor = [UIColor redColor];
    lbl.text = @"用户名只能修改一次";
    lbl.hidden = self.isEditUserName == YES?NO:YES;
    [lbl sizeToFit];
    lbl.frame = CGRectMake(15, marginTop, self.view.width-30, lbl.height);
    [self.view addSubview:lbl];
    
    marginTop += lbl.height;
    
    [textField becomeFirstResponder];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    UITextField *textFiled = (UITextField*)[self.view viewWithTag:200];
    NSString *userName = [textFiled.text trim];
    if ([userName length]==0) {
        if (self.isEditUserName) {
            [super showHUD:@"请输入昵称" hideAfterDelay:0.8f forView:self.view];
        }else{
            [super showHUD:@"请输入微信ID" hideAfterDelay:0.8f forView:self.view];
        }
        return;
    }
    
    [self.view endEditing:YES];
    
    [self dismiss];
    if (![userName isEqualToString:[Session sharedInstance].currentUser.userName]) {
        if (_handleDidEditUserName) {
            _handleDidEditUserName(self,userName);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self handleTopBarRightButtonClicked:nil];
    return NO;
}

@end


@implementation EditGenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"性别"];
    [super setupTopBarBackButton];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    UIImage *checkedImage = [UIImage imageNamed:@"checked_big"];
    
    CGFloat marginTop = 15.f+topBarHeight;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    [self.view.layer addSublayer:line];
    
    marginTop += 1;
    
    CommandButton *maleBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, marginTop, self.view.bounds.size.width, 50)];
    [maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    maleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    maleBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    maleBtn.backgroundColor = [UIColor whiteColor];
    maleBtn.tag = 100;
    [maleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [maleBtn setImage:checkedImage forState:UIControlStateSelected];
    [maleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.view.width-20-checkedImage.size.width, 0, 0)];
    [self.view addSubview:maleBtn];
    
    UIImageView *checked1 = [[UIImageView alloc] initWithImage:checkedImage];
    checked1.frame = CGRectMake(self.view.width-20-checkedImage.size.width, (maleBtn.height-checkedImage.size.height)/2, checkedImage.size.width, checkedImage.size.height);
    checked1.tag = 10;
    checked1.hidden = YES;
    [maleBtn addSubview:checked1];
    
    marginTop += maleBtn.height;
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    [self.view.layer addSublayer:line];
    
    marginTop += line.bounds.size.height;
    
    CommandButton *femaleBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, marginTop, self.view.bounds.size.width, 50)];
    [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    [femaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    femaleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    femaleBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    femaleBtn.backgroundColor = [UIColor whiteColor];
    femaleBtn.tag = 200;
    femaleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [femaleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.view addSubview:femaleBtn];
    
    UIImageView *checked2 = [[UIImageView alloc] initWithImage:checkedImage];
    checked2.frame = CGRectMake(self.view.width-20-checkedImage.size.width, (femaleBtn.height-checkedImage.size.height)/2, checkedImage.size.width, checkedImage.size.height);
    checked2.tag = 10;
    checked2.hidden = YES;
    [femaleBtn addSubview:checked2];
    
    
    marginTop += femaleBtn.height;
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    [self.view.layer addSublayer:line];
    
    
    [self updateBtnsByGender:[Session sharedInstance].currentUser.gender];
    
    WEAKSELF;
    maleBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf updateBtnsByGender:1];
        [weakSelf dismiss];
        if (weakSelf.handleDidEditGender && [Session sharedInstance].currentUser.gender != 1) {
            weakSelf.handleDidEditGender(weakSelf,1);
        }
    };
    femaleBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf updateBtnsByGender:2];
        [weakSelf dismiss];
        if (weakSelf.handleDidEditGender && [Session sharedInstance].currentUser.gender!=2) {
            weakSelf.handleDidEditGender(weakSelf,2);
        }
    };
}

- (void)updateBtnsByGender:(NSInteger)gender
{
    WEAKSELF;
    UIButton *maleBtn = (UIButton*)[weakSelf.view viewWithTag:100];
    UIButton *femaleBtn = (UIButton*)[weakSelf.view viewWithTag:200];
    if (gender==1) {
        [maleBtn viewWithTag:10].hidden = NO;
        [femaleBtn viewWithTag:10].hidden = YES;
    } else if (gender==2) {
        [maleBtn viewWithTag:10].hidden = YES;
        [femaleBtn viewWithTag:10].hidden = NO;
    } else {
        [maleBtn viewWithTag:10].hidden = YES;
        [femaleBtn viewWithTag:10].hidden = YES;
    }
}

@end


@interface EditSummaryViewController ()<HPGrowingTextViewDelegate>

@end
@implementation EditSummaryViewController {
    HPGrowingTextView *_textView;
    UILabel *_numLbl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@""];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [self.topBarRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:scrollView];
    
    CGFloat marginTop = 0;
    marginTop += 15;
    
    _numLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, self.view.width-30, 0)];
    _numLbl.text = @"0/200";
    _numLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
    _numLbl.textAlignment = NSTextAlignmentRight;
    _numLbl.font = [UIFont systemFontOfSize:12.f];
    [_numLbl sizeToFit];
    _numLbl.frame = CGRectMake(15, marginTop, self.view.width-30, _numLbl.height);
    [scrollView addSubview:_numLbl];
    
    marginTop += _numLbl.height;
    marginTop += 5;
    
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 115)];
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _textView.returnKeyType = UIReturnKeyDefault; //just as an example
    _textView.font = [UIFont systemFontOfSize:15.f];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.isScrollable = NO;
    _textView.enablesReturnKeyAutomatically = NO;
    _textView.animateHeightChange = NO;
    _textView.autoRefreshHeight = NO;
    _textView.frame = CGRectMake(15, marginTop, kScreenWidth-30, 115);
    [scrollView addSubview:_textView];
    
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.placeholder = @"请输入个性签名";
    _textView.text = _summary;
    _textView.delegate = self;
    
    marginTop += _textView.height;
    marginTop += 5;
    
    
    [self bringTopBarToTop];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    [self dismiss];
    if (_handleDidEditSummary) {
        _handleDidEditSummary(self, [NSString disable_emoji:_textView.text]);
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //emoji无效
    if([NSString isContainsEmoji:text]) {
        return NO;
    }
    NSMutableString *newtxt = [NSMutableString stringWithString:growingTextView.text];
    [newtxt replaceCharactersInRange:range withString:text];
    return [newtxt length]<=200;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    _numLbl.text = [NSString stringWithFormat:@"%ld/200",(long)[growingTextView.text length]];
}

@end


@implementation UIBirthdayPicker


@end



@implementation EditUserSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

@end




