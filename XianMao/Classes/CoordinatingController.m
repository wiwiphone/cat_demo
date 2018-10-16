//
//  CoordinatingController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "CoordinatingController.h"
#import "SynthesizeSingleton.h"
#import <AVFoundation/AVFoundation.h>



#import "SideMenuController.h"
#import "MainViewController.h"
#import "CategoryViewController.h"

#import "RecoverDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsLikesViewController.h"
#import "UserHomeViewController.h"
#import "ChatViewController.h"
#import "FollowsViewController.h"
#import "UserLikesViewController.h"
#import "EditProfileViewController.h"
#import "OfferedViewController.h"
#import "GoodsMemCache.h"
#import "GoodsInfo.h"
#import "GoodsService.h"

#import "MBProgressHUD.h"

#import "MyNavigationController.h"
#import "LoginViewController.h"
#import "Session.h"
#import "XMEmptyView.h"
#import "AFNetworking.h"

#import "AppDelegate.h"
#import "URLScheme.h"

#import "UMSocial.h"
#import "NetworkAPI.h"

#import "FeedsViewController.h"
#import "RecommendViewController.h"

#import "LXActivity.h"

#import "UIActionSheet+Blocks.h"
#import "AssetPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "WCAlertView.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>

#import "Command.h"

#import "VisualEffectView.h"
#import "ShareView.h"
#import "BlackView.h"

@interface CoordinatingController () <UMSocialUIDelegate,LXActivityDelegate>

@property(nonatomic,readwrite) UINavigationController *rootViewController;
@property(nonatomic,readwrite) MainViewController *mainViewController;
@property(nonatomic,readwrite) CategoryViewController *categoryViewController;

@property(nonatomic,strong) MBProgressHUD *HUD;

@property(nonatomic,weak) TapDetectingView *popupMaskView;

@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) UIView *cannelView;
@property (nonatomic, strong) UIButton *cannelBtn;
@property (nonatomic, strong) VisualEffectView *effectView;
@property (nonatomic, strong) BlackView *blackView;
@end

@implementation CoordinatingController

SYNTHESIZE_SINGLETON_FOR_CLASS(CoordinatingController, sharedInstance);

-(UIButton *)cannelBtn{
    if (!_cannelBtn) {
        _cannelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cannelBtn setTitleColor:[UIColor colorWithHexString:@"e83828"] forState:UIControlStateNormal];
        _cannelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cannelBtn;
}

-(UIView *)cannelView{
    if (!_cannelView) {
        _cannelView = [[UIView alloc] initWithFrame:CGRectZero];
        _cannelView.backgroundColor = [UIColor colorWithHexString:@"eeeeea"];
    }
    return _cannelView;
}

-(BlackView *)blackView{
    if (!_blackView) {
        _blackView = [[BlackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _blackView;
}

-(VisualEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[VisualEffectView alloc] initWithFrame:[UIScreen mainScreen].bounds style:MFBlurEffectStyleDark];
        _effectView.alpleValue = 0;
    }
    return _effectView;
}

-(ShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectZero];
    }
    return _shareView;
}

-(NSMutableDictionary *)param{
    if (!_param) {
        _param = [[NSMutableDictionary alloc] init];
    }
    return _param;
}

- (void)initialize
{
    self.mainViewController = [[MainViewController alloc] init];
    self.rootViewController = [[MyNavigationController alloc] initWithRootViewController:self.mainViewController];;
    
//    self.mainViewController = [[MainViewController alloc] init];
//    
//    self.categoryViewController = [[CategoryViewController alloc] init];
//    
//    SideMenuController *sideMenuController = [[SideMenuController alloc] initWithMenuViewController:self.categoryViewController
//                                                                              contentViewController:self.mainViewController];
//    sideMenuController.menuViewOverlapWidth = 80.f;
//    sideMenuController.bezelWidth = [[UIScreen mainScreen] bounds].size.width;
//    sideMenuController.contentViewOpacity = 0.2f;
//    //sideMenuController.contentViewScale = 0.96f;
//    sideMenuController.panFromBezel = YES;
//    sideMenuController.panFromNavBar = YES;
//    sideMenuController.animationDuration = 0.3f;
//    sideMenuController.shadowOffset = CGSizeMake(8,0);
//    sideMenuController.shadowOpacity = 0.2;
//    sideMenuController.shadowRadius = 3;
//
//    self.rootViewController = sideMenuController;
}

- (UIViewController*)visibleController {
    if (_rootViewController.visibleViewController == _mainViewController) {
        return [_mainViewController visibleController]; //tab
    }
    return _rootViewController.visibleViewController;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    UIViewController *visibleController = _rootViewController.visibleViewController;
    [visibleController presentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *visibleController = _rootViewController.visibleViewController;
    [visibleController.navigationController pushViewController:viewController animated:animated];
}

-(void)popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController *visibleController = _rootViewController.visibleViewController;
    [visibleController.navigationController popToRootViewControllerAnimated:animated];
}

- (void)pushViewControllerWithCls:(Class)Cls animated:(BOOL)animated
{
    NSObject *obj = [[Cls alloc] init];
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *visibleController = _rootViewController.visibleViewController;
        [visibleController.navigationController pushViewController:(UIViewController*)obj animated:YES];
    }
}

- (void)openSideMenu
{
    if ([self.rootViewController isKindOfClass:[SideMenuController class]]) {
        [((SideMenuController*)(self.rootViewController)) openMenu];
    }
}

- (void)closeSideMenu
{
    if ([self.rootViewController isKindOfClass:[SideMenuController class]]) {
        [((SideMenuController*)(self.rootViewController)) closeMenu];
    }
}

- (void)enableSideMenu:(BOOL)enable
{
    if ([self.rootViewController isKindOfClass:[SideMenuController class]]) {
        if (!enable) {
            ((SideMenuController*)(self.rootViewController)).panFromBezel = NO;
            ((SideMenuController*)(self.rootViewController)).panFromBezel = NO;
        } else {
            ((SideMenuController*)(self.rootViewController)).panFromBezel = YES;
            ((SideMenuController*)(self.rootViewController)).panFromBezel = YES;
        }
    }

    
//    if ([self.rootViewController isKindOfClass:[MMDrawerController class]]) {
//        if (!enable) {
//            if (((MMDrawerController*)(self.rootViewController)).leftDrawerViewController) {
//                [((MMDrawerController*)(self.rootViewController)) closeDrawerAnimated:YES completion:^(BOOL finished) {
//                    [((MMDrawerController*)(self.rootViewController)) setLeftDrawerViewController:nil];
//                }];
//            }
//        } else {
//            if (!((MMDrawerController*)(self.rootViewController)).leftDrawerViewController) {
//                [((MMDrawerController*)(self.rootViewController)) setLeftDrawerViewController:self.slideMenuViewController];
//            }
//        }
//    }
}

- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay {
    [self showHUD:message hideAfterDelay:hideAfterDelay forView:[self HUDForView]];
}

- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay forView:(UIView*)view {
    [_HUD removeFromSuperview];
    [_HUD setRemoveFromSuperViewOnHide:YES];
    [_HUD hide:NO];
    _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _HUD.detailsLabelText = message;
    _HUD.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    _HUD.animationType = MBProgressHUDAnimationFade;
    _HUD.mode = MBProgressHUDModeCustomView;
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:hideAfterDelay];
}

- (void)showProcessingHUD:(NSString*)message {
    [self showProcessingHUD:message forView:[self HUDForView]];
}

- (void)showProcessingHUD:(NSString*)message forView:(UIView*)view {
    [_HUD removeFromSuperview];
    [_HUD setRemoveFromSuperViewOnHide:YES];
    [_HUD hide:NO];
    _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _HUD.detailsLabelText = message;
    _HUD.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    _HUD.animationType = MBProgressHUDAnimationFade;
    [_HUD show:YES];
}

- (void)hideHUD {
    [_HUD removeFromSuperview];
    [_HUD setRemoveFromSuperViewOnHide:YES];
    [_HUD hide:YES];
    _HUD = nil;
}

- (UIView*)HUDForView {
    UIView *forView = nil;
    UIViewController *visibleController = _rootViewController.visibleViewController;
    if ([visibleController isKindOfClass:[BaseViewController class]]) {
        forView = ((BaseViewController*)visibleController).HUDForView;
    }
    if (!forView) {
        forView = [UIApplication sharedApplication].keyWindow;
    }
    return forView;
}


//判断是否登录
- (BOOL)checkLoginStateAndPresentLoginController:(UIViewController*)viewController completion:(void (^)(void))completion {
    if (![Session sharedInstance].isLoggedIn) {
        LoginViewController *presenedViewController = [[LoginViewController alloc] init];
//        CheckPhoneViewController *presenedViewController = [[CheckPhoneViewController alloc] init];
        UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
        
        UIViewController *visibleController = _rootViewController.visibleViewController;
        [visibleController presentViewController:navController animated:YES completion:completion];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkBindingStateAndPresentLoginController:(UIViewController*)viewController bindingAlert:(NSString*)bindingAlert completion:(void (^)(void))completion {
    if (![Session sharedInstance].isLoggedIn) {
        //        LoginViewController *presenedViewController = [[LoginViewController alloc] init];
        LoginViewController *presenedViewController = [[LoginViewController alloc] init];
        UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
        
        UIViewController *visibleController = _rootViewController.visibleViewController;
        [visibleController presentViewController:navController animated:YES completion:completion];
        return NO;
    }
    if (![Session sharedInstance].isBindingPhoneNumber) {
        [WCAlertView showAlertWithTitle:@"温馨提示" message:bindingAlert customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex==0) {
                
            } else {
                
//                GetCaptchaCodeViewController *resetPasswordViewController = [[GetCaptchaCodeViewController alloc] init];
//                resetPasswordViewController.title = @"绑定手机号";
//                resetPasswordViewController.isRetry = YES;
//                resetPasswordViewController.captchaType = 4;
                
                GetCaptchaCodeViewController *presenedViewController = [[GetCaptchaCodeViewController alloc] init];
                presenedViewController.title = @"绑定手机号";
                presenedViewController.isRetry = YES;
                presenedViewController.captchaType = 4;
                presenedViewController.index = 4;
                UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
                UIViewController *visibleController = _rootViewController.visibleViewController;
                [visibleController presentViewController:navController animated:YES completion:completion];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
        return NO;
    }
    return YES;
}

-(void)gotoOfferedViewController:(NSString*)goodsId index:(NSInteger)index animated:(BOOL)animated
{
    OfferedViewController *viewController = [[OfferedViewController alloc] init];
    viewController.goodID = goodsId;
    viewController.index = index;
    [self pushViewController:viewController animated:YES];
}

-(void)gotoRecoverDetailViewController:(NSString*)goodsId index:(NSInteger)index animated:(BOOL)animated
{
    RecoverDetailViewController *viewController = [[RecoverDetailViewController alloc] init];
    viewController.goodsID = goodsId;
    viewController.index = index;
    [self pushViewController:viewController animated:YES];
}

- (void)gotoGoodsDetailViewController:(NSString*)goodsId animated:(BOOL)animated
{
    
    GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
    viewController.goodsId = goodsId;
    [self pushViewController:viewController animated:YES];
}

- (void)gotoGoodsLikesViewController:(NSString*)goodsId animated:(BOOL)animated
{
    GoodsLikesViewController *viewController = [[GoodsLikesViewController alloc] init];
    viewController.goodsId = goodsId;
    [self pushViewController:viewController animated:YES];
}

- (void)gotoEditProfileViewController:(BOOL)animated {
    EditProfileViewController *viewController = [[EditProfileViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)gotoUserHomeViewController:(NSInteger)userId animated:(BOOL)animated {
    
    UIViewController *visibleController = [self visibleController];
    if ([visibleController isKindOfClass:[UserHomeViewController class]]) {
        UserHomeViewController *tmpViewController = (UserHomeViewController*)visibleController;
        if (tmpViewController.userId == userId) {
            return;
        }
    }
    
    UserHomeViewController *viewController = [[UserHomeViewController alloc] init];
    viewController.userId = userId;
    [self pushViewController:viewController animated:YES];
}

- (void)gotoUserChatViewController:(NSInteger)userId animated:(BOOL)animated
{
    ChatViewController *viewController = [[ChatViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)gotoUserLikesViewController:(NSInteger)userId animated:(BOOL)animated
{
    UserLikesViewController *viewController = [[UserLikesViewController alloc] init];
    viewController.userId = userId;
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

- (void)gotoFollowingsViewController:(NSInteger)userId animated:(BOOL)animated
{
    FollowsViewController *viewController = [[FollowsViewController alloc] init];
    viewController.userId = userId;
    viewController.isFans = NO;
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

- (void)gotoFollowersViewController:(NSInteger)userId animated:(BOOL)animated
{
    FollowsViewController *viewController = [[FollowsViewController alloc] init];
    viewController.userId = userId;
    viewController.isFans = YES;
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

- (void)gotoHomeRecommendViewControllerAnimated:(BOOL)animated
{
    [[CoordinatingController sharedInstance] popToRootViewControllerAnimated:animated];
    [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:0];
}

/**
 * 商品详情页 type:1 ref:goods_id
 * 订单详情页 type:2 ref:order_id
 * 个人主页   type:3 ref:user_id
 * H5       type:4 ref:url
 * 邀请      type:5 ref:user_id
 * 帖子分享   type:6 ref:post_id
 * 求回收商品分享 type:7 ref:goods_sn
 *
 * dst WEIXIN:weixin
 *          QQ:qq
 *          QZONE:qzone
 *          Friend:friend
 *          DUANXIN:duanxin
 *          WEIBO:weibo
 *
 *
 *参考：map.put("type", mType);
 *     map.put("ref",mRef);
 *     map.put("dst",mPlatform);
 *
 */
- (void)shareNetWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url content:(NSString *)content parament:(NSMutableDictionary *)param{
    WEAKSELF;
    [weakSelf shareWithTitle:title image:image url:url content:content];
    if (param) {
        self.param = param;
    }
}

- (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url content:(NSString *)content
{
    [self shareWithTitle:title image:image url:url content:content isTeletext:NO];
}


/**
 *  @param isYES   是否图文分享
 */
- (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url content:(NSString *)content isTeletext:(BOOL)isYES
{
    __block UIViewController *visibleController = [self visibleController];
    if ([visibleController isKindOfClass:[FeedsViewController class]]) {
        visibleController = [CoordinatingController sharedInstance].mainViewController;
    }
    else if ([visibleController isKindOfClass:[RecommendViewController class]]
             || [visibleController isKindOfClass:[FollowingsViewController class]]
             || [visibleController isKindOfClass:[FeedsViewController class]]) {
        visibleController = [CoordinatingController sharedInstance].mainViewController;
        
    }
    
    NSMutableArray *shareToSnsNames = [[NSMutableArray alloc] init];
    if ([WXApi isWXAppInstalled]) {
        [shareToSnsNames addObject:UMShareToWechatSession];
        [shareToSnsNames addObject:UMShareToWechatTimeline];
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        [shareToSnsNames addObject:UMShareToQQ];
    }
    if ([WeiboSDK isWeiboAppInstalled]) {
        [shareToSnsNames addObject:UMShareToSina];
    }
    if (isYES) {
        [shareToSnsNames addObject:@"goodsDetail"];
    }
    
    [shareToSnsNames addObject:UMShareToSms];
    
    //    [UMSocialSnsService presentSnsIconSheetView:visibleController
    //                                         appKey:UmengAppkey
    //                                      shareText:content
    //                                     shareImage:image
    //                                shareToSnsNames:shareToSnsNames
    //                                       delegate:self];
    
    if (SYSTEMCURRENTV < 8.0) {
        [visibleController.view addSubview:self.blackView];
    } else {
        [visibleController.view addSubview:self.effectView];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.effectView.alpleValue = 1;
    }];
    
    NSInteger hIndex = 0;
    if ((shareToSnsNames.count)%3 != 0) {
        hIndex = (shareToSnsNames.count)/3 + 1;
    } else {
        hIndex = (shareToSnsNames.count)/3;
    }
    
    [visibleController.view addSubview:self.shareView];
    [shareToSnsNames removeObject:UMShareToSms];
    [self.shareView getShareDatas:shareToSnsNames];
    self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    self.shareView.layer.masksToBounds = YES;
    self.shareView.layer.cornerRadius = 5;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight - (50 + (hIndex * (kScreenWidth-160)/3 + 25)) - 70, kScreenWidth, 50 + (hIndex * (kScreenWidth-160)/3 + 25));
    } completion:^(BOOL finished) {
        
    }];
    
    [visibleController.view addSubview:self.cannelView];
    self.cannelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 1);
    self.cannelView.layer.masksToBounds = YES;
    self.cannelView.layer.cornerRadius = 5;
    
    [self.cannelView addSubview:self.cannelBtn];
    self.cannelBtn.frame = CGRectMake(0, 0, kScreenWidth, 50);
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cannelView.frame = CGRectMake(0, kScreenHeight - 60, kScreenWidth, 50);
    } completion:^(BOOL finished) {
        
    }];
    
    [self.cannelBtn addTarget:self action:@selector(disAnimateView) forControlEvents:UIControlEventTouchUpInside];
    
    WEAKSELF;
    self.blackView.dissMissBlackView = ^(){
        [weakSelf remAnimateBlackView];
    };
    
    self.effectView.touchView = ^(){
        [weakSelf remAnimateEffectView];
    };
    
    self.shareView.shareBegin = ^(NSString *shareName){
        
        [weakSelf disAnimateView];
        if ([shareName isEqualToString:@"ShareCopy"]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = url;
            [weakSelf showHUD:@"复制成功" hideAfterDelay:0.8];
        } else if ([shareName isEqualToString:@"goodsDetail"]){
            
            if (weakSelf.getImageAndText) {
                weakSelf.getImageAndText();
            }
            
        }else{
            
            {
                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:url];
                
                //            NSMutableArray *arr = [NSMutableArray arrayWithArray:shareToSnsNames];
                //            [arr removeObject:@"ShareCopy"];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareName] content:content image:image location:nil urlResource:urlResource presentedController:visibleController completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }
            
            
        }
    };
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        /*设置微博*/
        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url ;
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",content ,url];
    }
    
    if ([WXApi isWXAppInstalled]) {
        /*设置微信好友*/
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
        
        /*设置微信朋友圈*/
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        /*设置QQ*/
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    }
    
    /*设置短信*/
    [UMSocialData defaultData].extConfig.smsData.shareImage = nil;
    [UMSocialData defaultData].extConfig.smsData.shareText = content;
    
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
    [UMSocialConfig setTheme:UMSocialThemeWhite];
}

-(void)remAnimateBlackView{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, 0);
        self.cannelView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth,0);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
        [self.cannelView removeFromSuperview];
        self.cannelView = nil;
        self.shareView = nil;
    }];
}

-(void)remAnimateEffectView{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, 0);
        self.effectView.alpleValue = 0;
        self.cannelView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth,0);
    } completion:^(BOOL finished) {
        [self.effectView removeFromSuperview];
        [self.shareView removeFromSuperview];
        [self.cannelView removeFromSuperview];
        self.cannelView = nil;
        self.shareView = nil;
    }];
}

-(void)disAnimateView{
    if (self.blackView) {
        [self remAnimateBlackView];
    }
    
    if (self.effectView) {
        [self remAnimateEffectView];
    }
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

#pragma mark - UmengSocialDelegate


-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    if(response.responseCode == UMSResponseCodeSuccess)
    {
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        
//        manager POST:<#(NSString *)#> parameters:<#(id)#> success:<#^(NSURLSessionDataTask *task, id responseObject)success#> failure:<#^(NSURLSessionDataTask *task, NSError *error)failure#>
    }
}

//添加埋点
- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
//    * dst WEIXIN:weixin
//    *          QQ:qq
//    *          QZONE:qzone
//    *          Friend:friend
//    *          DUANXIN:duanxin
//    *          WEIBO:weibo
    NSString *str = [[NSString alloc] init];
    
//    1000代表微信,2000代表朋友圈,3000代表微博,4000代表qq 5000代表QQ空间,6000代表短信
    NSInteger shareData = 0;
    if ([platformName isEqual:@"sina"]) {
        platformName = @"weibo";
        shareData = 3000;
    } else if ([platformName isEqual:@"wxsession"]) {
        platformName = @"weixin";
        shareData = 1000;
    } else if ([platformName isEqual:@"sms"]) {
        platformName = @"duanxin";
        shareData = 6000;
    } else if ([platformName isEqual:@"wxtimeline"]) {
        platformName = @"friend";
        shareData = 2000;
    } else if ([platformName isEqual:@"qq"]) {
        shareData = 4000;
    }
    
    if (self.param) {
        [self.param setValue:platformName forKey:@"dst"];
    }
    
    if (self.shareChannel) {
        self.shareChannel(shareData);
    }
    
//    NSLog(@"%@", _param);
    [GoodsService setSharePOST:self.param Completion:^(NSDictionary *dict) {
        
    } failure:^(XMError *error) {
        
    }];
}

#pragma mark - show camera view

- (void)startCameraControllerEdit:(BOOL)canEdit deletegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate
{
    WEAKSELF
    [UIActionSheet showInView:[self visibleController].view
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
                                     imagePicker.delegate = delegate;
                                     imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     
                                     imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                                     imagePicker.allowsEditing = canEdit;
                                     [[weakSelf visibleController] presentViewController:imagePicker animated:YES completion:^{
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
                                         imagePicker.delegate = delegate;
                                         imagePicker.allowsEditing = canEdit;
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

}


+(void)dismissMaskView {
    UIView *view = [CoordinatingController sharedInstance].popupMaskView;
    if (view) {
        [view removeFromSuperview];
        [CoordinatingController sharedInstance].popupMaskView = nil;
//        [UIView animateWithDuration:0.2 animations:^{
//            view.backgroundColor = [UIColor clearColor];
//        } completion:^(BOOL finished) {
//            [view removeFromSuperview];
//            [CoordinatingController sharedInstance].popupMaskView = nil;
//        }];
    }
}

+(void)showMaskView:(void (^)())dismissCallback {
    UIView *topView = [CoordinatingController sharedInstance].visibleController.view;
    TapDetectingView *maskView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [topView addSubview:maskView];
    
    maskView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        if (dismissCallback) {
            dismissCallback();
        }
        [view removeFromSuperview];
        [CoordinatingController sharedInstance].popupMaskView = nil;
    };
    
    [UIView animateWithDuration:0.2 animations:^{
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
    } completion:^(BOOL finished) {
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
    }];
    if ([CoordinatingController sharedInstance].popupMaskView) {
        [[CoordinatingController sharedInstance].popupMaskView removeFromSuperview];
    }
    [CoordinatingController sharedInstance].popupMaskView = maskView;
}

@end


