//
//  AppDelegate.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "AppDelegate.h"
#import <localauthentication/localauthentication.h>

#import "MyNavigationController.h"
#import "CoordinatingController.h"
#import "MainViewController.h"
#import "NetworkManager.h"
#import "PayManager.h"
#import "Session.h"
#import "EMSession.h"
#import "UMSocial.h"
#import "URLScheme.h"
#import "PayManager.h"

#import "SDImageCache.h"
#import "NSData+AES.h"
#import "NSString+AES.h"
#import "NetworkAPI.h"
#import "AESCrypt.h"
#import "ClientVersionService.h"

#import "SDImageCache.h"

#import "RNCachingURLProtocol.h"
#import "LaunchPageView.h"

#import "NSString+Validation.h"

#import "WCAlertView.h"

#import "ChatViewController.h"
#import "AboutViewController.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+EaseMob.h"
#import "AppDelegate+UMeng.h"
#import "MsgCountManager.h"

#import "FenQiLePayViewController.h"

#import "ForumPostDetailViewController.h"
#import "ForumPublishViewController.h"
#import "ForumPostListViewController.h"

#import "GoodsDetailViewController.h"
#import "GoodsCommentsViewController.h"

#import "RemindOpenNotifiViewController.h"

#import "PublishGoodsViewController.h"
#import "RechargeViewController.H"


#import "ForumOneSelfController.h"
#import "ForumPostCatHouseCell.h"
#import "ForumCatHouseDetailController.h"
#import "ForumPoatCatHouseControllerTwo.h"
#import "LoginViewController.h"

#import "OfferedViewController.h"
#import "PartialView.h"
#import "PayViewController.h"
#import "BoughtViewController.h"
#import "BoughtCollectionViewController.h"

#import "NewPageController.h"
#import "PublishViewController.h"

#import "C2CGoodsDetailViewController.h"
#import "LaunchNewPageView.h"
#import "FMDeviceManager.h"

#import "SkinIconManager.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate () <WXApiDelegate, EMChatManagerDelegate>
{
    UIImageView *_splashView;
    BOOL _isPushNotificationKey;
    NSDictionary *_apsInfo;
}
@property(strong,nonatomic) ClientVersionService *versionService;
@property(nonatomic,strong) UIView *myBgViewAlpha;
@property(nonatomic,strong) HTTPRequest *requestEMob;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    WEAKSELF;
    //可以适配ios10, 先注释掉
    //    if (NSClassFromString(@"UNUserNotificationCenter")) {
    //        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    //    }
    
    
    //判断皮肤文件
    [[SkinIconManager manager] loadSkinIcon];
    
    //        添加push方式，支持程序死了以后跳转push页面。。。
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if (apsInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *redirectUri = [userInfo stringValueForKey:@"redirect_uri"];
            [URLScheme locateWithRedirectUri:redirectUri andIsShare:YES];
        });
    }
#if DEBUG
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#endif
    
    [application setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    [self systemInit];
    
    //     初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self reLoginToEaseMob];
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    // 初始化友盟SDK
    [self umengApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [CoordinatingController sharedInstance].rootViewController;
    [self.window makeKeyAndVisible];
    
    //调试H5页面代码, 上线时不需要
    //    [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
    
    [self checkVersion];
    [self registerRemoteNotification];
    
    
    // 加上这句话 防止聊天点击图片崩溃   不加 会崩溃
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    // Override point for customization after application launch.
    
    
    
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // 准备SDK初始化参数
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    // SDK具有防调试功能，当使用xcode运行时，请取消此行注释，开启调试模式
    // 否则使用xcode运行会闪退，(但直接在设备上点APP图标可以正常运行)
    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
    // 指定对接同盾的测试环境，正式上线时，请删除或者注释掉此行代码，切换到同盾生产环境
    [options setValue:@"sandbox" forKey:@"product"]; // TODO  env
    // 指定合作方标识
    [options setValue:@"aidingmao" forKey:@"partner"];
    // 使用上述参数进行SDK初始化
    manager->initWithOptions(options);
    
    
    //    [self startupSplashView];
    [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:0];
    
    //    [LaunchNewPageView showNewLaunchPageView];
    [LaunchPageView showLaunchView];
    if ([self isFirstStart]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NewPageController *newPageController = [[NewPageController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:newPageController animated:NO];
        });
        //        self.window.rootViewController = newPageController;
    }
    
    //添加不使用IQKeyboardManager的类
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ChatViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[FeedbackViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumPublishViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumPostDetailViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumPostListViewController class]];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumPostDetailViewController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumPostListViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[GoodsDetailViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[GoodsCommentsViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[GoodsDetailViewControllerContainer class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[PublishGoodsViewController class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PublishGoodsViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RechargeViewController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RechargeViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumCatHouseDetailController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumCatHouseDetailController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumPoatCatHouseControllerTwo class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumPoatCatHouseControllerTwo class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumOneSelfController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumOneSelfController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumPostListViewControllerTwo class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumPostListViewControllerTwo class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ForumPostCatHouseCell class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[ForumPostCatHouseCell class]];
    //ForumPostCatHouseCell
    
    //ForumPoatCatHouseControllerTwo
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[OfferedViewController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[OfferedViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[PublishViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[C2CGoodsDetailViewController class]];
    
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[PartialView class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PartialView class]];
    //
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[PayViewController class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PayViewController class]];
    
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[BoughtViewController class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[BoughtViewController class]];
    
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[BoughtCollectionViewController class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[BoughtCollectionViewController class]];
    
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[PublishGoodsContentView class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PublishGoodsContentView class]];
    
    //    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RegisterViewController class]];
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RegisterViewController class]];
    
#pragma mark -------------------获取设备版本号，等在执行任务-----------------------------
#pragma mark -------------------获取设备版本号，等在执行任务-----------------------------
#pragma mark -------------------获取设备版本号，等在执行任务-----------------------------
#pragma mark -------------------获取设备版本号，等在执行任务-----------------------------
#pragma mark -------------------获取设备版本号，等在执行任务-----------------------------
#pragma mark -------------------获取设备版本号，等在执行任务-----------------------------
    //获取设备版本号
    NSString *iPhoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"-------------------------------------------------------------------------------iphoneVersion%@", iPhoneVersion);
    
    //    获取用户是否开启推送消息功能
    //    NSInteger type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    //    NSLog(@"--------------------------------------------------------------------------------------------------------%lu", type);
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    //指纹
//  [self lockFunction];
    
    //铜盾
    if ([[Session sharedInstance] isLoggedIn]) {
        NSDictionary *params = @{@"blackBox":[[Session sharedInstance] getFMDeviceBlackBox], @"phone":[Session sharedInstance].currentUser.phoneNumber};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"td_sent_equipment" parameters:params completionBlock:^(NSDictionary *data) {
            
        } failure:^(XMError *error) {
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
    }
    
    
    //iOS用户点击聊天推送消息进入应用后,转到对应的ViewController
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [[CoordinatingController sharedInstance].mainViewController dismiss:YES];
        [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:3];
    }
    
    return YES;
}

-(void)didReceiveMessages:(NSArray *)aMessages{
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatController" object:aMessages];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"\n ===> 程序进入前台 !");
    //    [self lockFunction];
}

-(void)lockFunction{
    //指纹
    UIView *lockView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    lockView.backgroundColor = [UIColor whiteColor];
    CommandButton *loginButton = [[CommandButton alloc] initWithFrame:CGRectZero];
    loginButton.backgroundColor = [UIColor colorWithHexString:@"f4433e"];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5;
    [lockView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lockView.mas_centerX);
        make.bottom.equalTo(lockView.mas_bottom).offset(-100);
        make.width.equalTo(@100);
    }];
    
    void(^lock)() = ^(){
        [[CoordinatingController sharedInstance].rootViewController.view addSubview:lockView];
        LAContext *context = [[LAContext alloc] init];
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
            NSLog(@"支持");
            // 输入指纹，异步
            // 提示：指纹识别只是判断当前用户是否是手机的主人！程序原本的逻辑不会受到任何的干扰！
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登录" reply:^(BOOL success, NSError *error) {
                NSLog(@"%d %@", success, error);
                
                if (success) {
                    // 登录成功
                    // TODO
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 animations:^{
                            lockView.alpha = 0;
                        } completion:^(BOOL finished) {
                            [lockView removeFromSuperview];
                        }];
                    });
                    
                } else {
                    return ;
                }
            }];
            
            NSLog(@"come here");
        } else {
            NSLog(@"不支持");
        }
    };
    
    loginButton.handleClickBlock = ^(CommandButton *sender){
        lock();
    };
    lock();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    SDImageCache *imgCache = [[SDImageCache alloc] init];
    [imgCache clearMemory];
    imgCache = nil;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

//版本更新检测
- (void)checkVersion
{
    WEAKSELF;
    if (!_versionService) {
        _versionService = [[ClientVersionService alloc] init];
    }
    [_versionService checkVersionWithCompletionHandler:^{
        weakSelf.versionService = nil;
    }];
}

// 新版本首次启动,显示指引页
- (BOOL)isFirstStart
{
    
    NSString *firstStart =  [[NSUserDefaults standardUserDefaults] objectForKey:@"firstStart"];
    
    if (firstStart == nil || [firstStart isEqualToString:@""] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firstStart"];
        
        return YES;
    }
    return NO;
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", deviceToken);
    [UMessage registerDeviceToken:deviceToken];
    //    [UMessage addAlias:@"adm_000000" type:@"ADM" response:^(id responseObject, NSError *error) {
    //        NSLog(@"%@",responseObject);
    //    }];
    
    //    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    [[Session sharedInstance] syncAliasPushIdToUMessage];
}

/**
 当用户点击本地推送通知，会自动打开app，这里有2种情况
 app并没有关闭，一直隐藏在后台
 让app进入前台，并会调用AppDelegate的下面方法（并非重新启动app)
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSDictionary * userInfo = notification.userInfo;
    if (userInfo) {
        if ([[userInfo objectForKey:kNotificationType] isEqual:@(EMMessageType)]) {
            [[CoordinatingController sharedInstance].mainViewController.navigationController popToRootViewControllerAnimated:YES];
            [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:3];
        }
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"%@", error);
#if DEBUG
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
    //                                                    message:error.description
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
    //                                          otherButtonTitles:nil];
    //    [alert show];
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    NSLog(@"%@", userInfo);
    //    if (userInfo) {
    //        NSString *pushUrl = userInfo[@"redirect_url"];
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushJumpLive" object:pushUrl];
    //    }
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        if ([aps isKindOfClass:[NSDictionary class]]) {
            NSString *alert = [aps stringValueForKey:@"alert"];
            if ([alert length]>0) {
                [WCAlertView showAlertWithTitle:@"" message:alert customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (buttonIndex==0) {
                        
                    } else {
                        NSString *redirectUri = [userInfo stringValueForKey:@"redirect_uri"];
                        [URLScheme locateWithRedirectUri:redirectUri andIsShare:YES];
                    }
                } cancelButtonTitle:@"忽略" otherButtonTitles:@"看看", nil];
            }
        }
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([userInfo objectForKey:@"redirect_uri"] != nil) {
                NSString *redirectUri = [userInfo stringValueForKey:@"redirect_uri"];
                [URLScheme locateWithRedirectUri:redirectUri andIsShare:YES];
            }
            //            application.applicationIconBadgeNumber = 0;
        });
    }
    
    [[MsgCountManager sharedInstance] syncMsgCount];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //    url = [NSURL URLWithString:@"aidingmao://fqlpay/?result=1"];
    BOOL handled = [PayManager handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (handled) return YES;
    handled = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    if (handled) return YES;
    handled = [URLScheme locateWithRedirectUriImpl:[url absoluteString] andIsShare:YES];
    if (handled) return YES;
    handled = [FenQiLePayViewController locateWithRedirectUri:[url absoluteString]];
    if (handled) return YES;
    handled = [WXApi handleOpenURL:url delegate:self];
    if (handled) {
        return YES;
    }
    return NO;
}

- (void)systemInit {
    
    
    int cacheSizeMemory = 5*1024*1024; // 4MB
    int cacheSizeDisk = 18*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    sharedCache = nil;
    
    [[Session sharedInstance] initialize];
    systemInitCommands();
    [NetworkManager sharedInstance];
    
    SDImageCache *imgCache = [[SDWebImageManager sharedManager] imageCache];
    imgCache.maxCacheAge = 72*60*60; //在内存缓存保留的最长时间 以秒为单位计算 为了检测 设置为5秒
    //    imgCache.maxCacheSize = 5*1024*1024; //在内存中能够存储图片的最大容量 以比特为单位 这里设为1024 也就是1M
    //imgCache.maxMemoryCost = 2*1024*1024; //保存在存储器中像素的总和
    imgCache = nil;
    
    
    //    SDImageCache *cache = [SDImageCache sharedImageCache];
    // 在内存缓存保留的最长时间 以秒为单位计算 为了检测 设置为5秒
    //    cache.maxCacheAge = 20*60;
    //    //  在内存中能够存储图片的最大容量 以比特为单位 这里设为1024 也就是1M
    //    cache.maxCacheSize = 3*1024;
    //  保存在存储器中像素的总和
    //    cache.maxMemoryCost = 1024;
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
//    // [self backGroundTask:application];
//}
//
//// App将要从后台返回
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"foreground"object:nil];
//    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
//}
//// 申请处理时间
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    [[EaseMob sharedInstance] applicationWillTerminate:application];
//}

// 注册推送
- (void)registerRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    NSLog(@"%@",loginInfo);
}

#define IsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//- (void)startupSplashView
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone)
//    {
//        // Make this interesting.
//        _splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        _splashView.userInteractionEnabled = YES;
////        _splashView.contentMode = UIViewContentModeScaleAspectFill;
//        if (IsIPhone5)
//            _splashView.image = [UIImage imageNamed:@"Default-568h"];
//        else
//            _splashView.image = [UIImage imageNamed:@"Default"];
//        [self.window addSubview:_splashView];
//        [self.window bringSubviewToFront:_splashView];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5f];
//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
//        _splashView.alpha = 0.0;
////        _splashView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width * 0.5, -[UIScreen mainScreen].bounds.size.height * 0.5, [UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height * 2);
//        [UIView commitAnimations];
//    }
//}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    [_splashView removeFromSuperview];
    _splashView = nil;
}

- (void)callScreeningAction {
    
    int myHeight = [[UIScreen mainScreen] bounds].size.height - kBottomTabBarHeight;
    
    _myBgViewAlpha = [[UIView alloc]init];
    _myBgViewAlpha.frame = CGRectMake(0,myHeight, kScreenWidth, myHeight);
    _myBgViewAlpha.backgroundColor = [UIColor blackColor];
    _myBgViewAlpha.alpha = 0.8;
    
    //[self.view addSubview:myBgViewAlpha];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:_myBgViewAlpha];
    
    //    //点击动态效果
    //    [UIView animateWithDuration:0.5 animations:^{
    //
    //    }];
    _myBgViewAlpha.frame = CGRectMake(0, 0, kScreenWidth,myHeight);
    
    UIImage *guideImage = [UIImage imageNamed:@"guide"];
    
    
    UIImageView *guideImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - guideImage.size.width ) / 2.0,
                                                                               kScreenHeight - kBottomTabBarHeight - guideImage.size.height,
                                                                               guideImage.size.width, guideImage.size.height)];
    [guideImageView setImage:guideImage];
    [_myBgViewAlpha addSubview:guideImageView];
    
    
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake( guideImageView.frameX+guideImage.size.width+5,guideImageView.frameY-10,60, 60);
    [myButton setImage:[UIImage imageNamed:@"sale_icon_close"] forState:UIControlStateNormal];
    [myButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 30, 40)];
    [myButton addTarget:self action:@selector(reCallScreeningAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_myBgViewAlpha addSubview:myButton];
}

//去除筛选
- (void)reCallScreeningAction {
    
    [_myBgViewAlpha removeFromSuperview];
}

#pragma mark - WXAPIDelegate
- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        //strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                // strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
                MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
                
                break;
            case WXErrCodeUserCancel:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                selector = @selector($$handlePayResultCancelNotification:orderIds:);
                MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
                break;
            default:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                selector = @selector($$handlePayResultFailureNotification:orderIds:);
                MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
                break;
        }
    }
    
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    //    NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
    
    if ([result isEqualToString:@"success"]) {
        SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
        MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
    } else {
        SEL selector = @selector($$handlePayResultFailureNotification:orderIds:);
        MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
    }
}

- (void)reLoginToEaseMob
{
    WEAKSELF;
    
    if ( [NetworkManager sharedInstance].isReachable && [Session sharedInstance].isLoggedIn
        && (![[EMClient sharedClient] isLoggedIn])//[[EaseMob sharedInstance].chatManager isLoggedIn]
        && !self.requestEMob) {
        
        NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
        self.requestEMob = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
            weakSelf.requestEMob = nil;
            EMAccount *currentUserEMAccount = nil;
            for (NSInteger i=0;i< [accountDicts count]; i++) {
                NSDictionary *dict = [accountDicts objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    EMAccount *emAccount = [EMAccount createWithDict:dict];
                    if (emAccount.userId == [Session sharedInstance].currentUserId) {
                        currentUserEMAccount = emAccount;
                        break;
                    }
                }
            }
            
            if (currentUserEMAccount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Session sharedInstance] setUserEMAccount:currentUserEMAccount];
                    [[EMSession sharedInstance] loginWithUsername:currentUserEMAccount.emUserName password:currentUserEMAccount.emPassword completion:^{
                        
                    } failure:^(XMError *error) {
                        _$showHUD([error errorMsg], 0.8f);
                    }];
                });
            } else {
                _$showHUD(@"注册聊天服务失败，请重新登录", 0.8f);
            }
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
            weakSelf.requestEMob = nil;
        }];
    }
}

@end

//push
//push@aidingmao.com
//p12证书密码：aidingmao520

/*分享
 
 新浪微博：
 App Key：	812984050
 App Secret：	e52dadc26a7c514de0cca54660460693
 
 微信：
 AppID：wx093f3eb21ceb7937
 AppSecret：2ca5a9ff94541ef772d4100da5b2734e
 
 短信
 
 
 腾讯开放平台：
 APP ID:1104300138
 APP KEY:5Tyv3zGvyYi4xiDs
 
 
 */

//友盟账号：
//registerRemoteNotification

//友盟appkey：
//5486e9e6fd98c55164000243

//微信、QQ空间、微博、豆瓣、短信

//环信：aidingmao/aidingmao520!

//环信客服：baiting@aidingmao.com/Aidingmao520!

//支付宝：caiwu1@aidingmao.com

/*
 
 Apple ID
 An automatically generated ID assigned to your app.
 939116402
 
 qiniu.conf.ACCESS_KEY = ‘_ioX8mMk5AKI62zE9iw2fxF1tuzg87UDI5D6Ldf0’
 qiniu.conf.SECRET_KEY = ‘6MD06XdPEb9Iw-vd8GORZhpTcsiNmStAWOHNLOiI’
 
 //每个应用加一个目录前缀就可以了  app1/img/aaxadsf.png 这样 app2/img/asdfg.png类似
 
 
 apple: wuya@aidingmao.com / Aidingmao520!
 fir: yixuan@aidingmao.com / aidingmao.com
 
 QQ开放平台
 账号：2778397179    密码：aidingmao520!
 
 http://www.pgyer.com/
 yao428650@gmail.com
 aidingmao_521
 
 */


//rong cloud
//avos cloud
//telegram


/*
 
 https://github.com/Ezio0/adm-web/blob/master/design/API(2014-12-2).md
 
 */


//http://blog.sina.com.cn/s/blog_6123f9650102vkxy.html





