//
//  BaseViewController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+Expanded.h"
#import "CoordinatingController.h"

#import "DataSources.h"

#import "AFNetworking.h"

#import "Session.h"

#import "MyNavigationController.h"
#import "Command.h"

@interface BaseViewController () <AuthorizeChangedReceiver>

@property(nonatomic,assign) BOOL isStatusBarHiddenWhenPresented;
@property(nonatomic,assign) BOOL isTabBarHiddenWhenPresented;

@property(nonatomic,assign) BOOL isVisible;

@property(nonatomic,readwrite,weak) UIImageView *topBar;
@property(nonatomic,assign) CGFloat topbarShadowHeight;
@property(nonatomic,readwrite,weak) UIImageView *topBarLogo;
@property(nonatomic,readwrite,weak) UILabel  *topBarTitleLbl;
@property(nonatomic,readwrite,weak) UIButton *topBarBackButton;
@property(nonatomic,readwrite,weak) UIButton *topBarRightButton;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //navigation bar
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    // Do any additional setup after loading the view.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//                self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    _hidesStatusBarWhenPresented = NO;
    _hidesTabBarWhenPresented = YES;
    
    _topbarShadowHeight = 0.f;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.topBar = nil;
    self.topBarTitleLbl = nil;
    self.topBarBackButton = nil;
    self.topBarRightButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //status bar
    if ([UIApplication sharedApplication].isStatusBarHidden != self.hidesStatusBarWhenPresented) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:self.hidesStatusBarWhenPresented withAnimation:UIStatusBarAnimationSlide];
    }
    self.isStatusBarHiddenWhenPresented = [UIApplication sharedApplication].isStatusBarHidden;
    
    self.isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([UIApplication sharedApplication].isStatusBarHidden != self.isStatusBarHiddenWhenPresented) {
        [[UIApplication sharedApplication] setStatusBarHidden:self.isStatusBarHiddenWhenPresented withAnimation:UIStatusBarAnimationSlide];
    }
    
    self.isVisible = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (BOOL)isVisible {
    return _isVisible && [CoordinatingController sharedInstance].visibleController==self;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion {
    [super presentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:animated];
}

- (void)dismiss {
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:animated completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:animated];
        }
    } else {
        [self dismissViewControllerAnimated:animated completion:^{
        }];
    }
}

- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay {
    [[CoordinatingController sharedInstance] showHUD:message hideAfterDelay:hideAfterDelay forView:[self HUDForView]];
}

- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay forView:(UIView*)view {
    [[CoordinatingController sharedInstance] showHUD:message hideAfterDelay:hideAfterDelay forView:view];
}

- (void)showProcessingHUD:(NSString*)message {
    [[CoordinatingController sharedInstance] showProcessingHUD:message forView:[self HUDForView]];
}

- (void)showProcessingHUD:(NSString*)message forView:(UIView*)view {
    [[CoordinatingController sharedInstance] showProcessingHUD:message forView:view];
}

- (void)hideHUD {
    [[CoordinatingController sharedInstance] hideHUD];
}

- (UIView*)HUDForView {
    return self.view;
}

- (void)bringTopBarToTop {
    [self.view bringSubviewToFront:self.topBar];
}

- (CGFloat)setupTopBar {
    return [self setupTopBar:self.view];
}

- (CGFloat)setupTopBar:(UIView*)parentView {
    if (!self.topBar) {
        //        if (self.navigationController.navigationBarHidden) {
        
        TapDetectingImageView *topBar = [[TapDetectingImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopBarHeight)];
        self.topBar = topBar;
        self.topBar.backgroundColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTopbar_Backgroud]?[[SkinIconManager manager] getValue:KTopbar_Backgroud]:@"ffffff"];  //修改topbar背景颜色 之前色值@"f1f1f1"
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.height, topBar.width, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
        [topBar addSubview:view];
        self.topBarlineView = view;
        self.topBar.userInteractionEnabled = YES;
        
        if ([[SkinIconManager manager] isValidWithPath:29]) {
            UIImage *img = [UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:29]];
            self.topBar.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
        }
        
        [parentView addSubview:self.topBar];
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.height - 0.5, topBar.width, 0.5)];
        //        view.backgroundColor = [UIColor lightGrayColor];
        //        [topBar addSubview:view];
        
        WEAKSELF;
        ((TapDetectingImageView*)_topBar).handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
            [weakSelf handleTopBarViewClicked];
        };
        
        //            return self.topBar.bounds.size.height-self.topbarShadowHeight;
        //        } else {
        //            UIImage *navBarBackgroundImg = [UIImage imageNamed:@"titlebar_bg"];
        //            UINavigationBar *navBar = self.navigationController.navigationBar;
        //            if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        //                [navBar setBackgroundImage:navBarBackgroundImg forBarMetrics:UIBarMetricsDefault];
        //            } else {
        //                UIImageView *imageView = (UIImageView *)[navBar viewWithTag:8088];
        //                if (imageView == nil) {
        //                    imageView = [[UIImageView alloc] initWithFrame:navBar.bounds];
        //                    imageView.image = [navBarBackgroundImg stretchableImageWithLeftCapWidth:navBarBackgroundImg.size.width/2 topCapHeight:0];
        //                    [imageView setTag:8088];
        //                    [navBar insertSubview:imageView atIndex:0];
        //                }
        //            }
        //
        //            return self.topBar.bounds.size.height-self.topbarShadowHeight;
        //        }
    } else {
        self.topBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, kTopBarHeight);
        UIView *topBar = self.topBar;
        [topBar removeFromSuperview];
        [parentView addSubview:topBar];
    }
    
    return self.topBar.bounds.size.height-self.topbarShadowHeight;
}

- (CGFloat)topBarHeight {
    return self.topBar.bounds.size.height-self.topbarShadowHeight;
}

- (void)setupTopBarLogo:(UIImage*)logoImg
{
    if (!self.topBarLogo)
    {
        CGFloat X = (CGRectGetWidth(self.topBar.bounds)-logoImg.size.width)/2;
        CGFloat Y = kTopBarContentMarginTop+(CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-logoImg.size.height)/2-self.topbarShadowHeight;
        UIImageView *topBarLogo = [[UIImageView alloc] initWithImage:logoImg];
        self.topBarLogo = topBarLogo;
        self.topBarLogo.frame = CGRectMake(X, Y, logoImg.size.width, logoImg.size.height);
        self.topBarLogo.userInteractionEnabled = YES;
        [self.topBar addSubview:self.topBarLogo];
    } else {
        
        CGFloat X = (CGRectGetWidth(self.topBar.bounds)-logoImg.size.width)/2;
        CGFloat Y = kTopBarContentMarginTop+(CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-logoImg.size.height)/2-self.topbarShadowHeight;
        UIImageView *topBarLogo = self.topBarLogo;
        self.topBarLogo.frame = CGRectMake(X, Y, logoImg.size.width, logoImg.size.height);
        [topBarLogo removeFromSuperview];
        [self.topBar addSubview:topBarLogo];
    }
}

- (void)setupTopBarTitle:(NSString*)title
{
    if (!self.topBarTitleLbl) {
        UILabel *topBarTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(55, kTopBarContentMarginTop, _topBar.bounds.size.width-110, _topBar.bounds.size.height-kTopBarContentMarginTop)];
        self.topBarTitleLbl = topBarTitleLbl;
        self.topBarTitleLbl.backgroundColor = [UIColor clearColor];
        self.topBarTitleLbl.textAlignment = NSTextAlignmentCenter;
        self.topBarTitleLbl.userInteractionEnabled = YES;
        self.topBarTitleLbl.font = [UIFont systemFontOfSize:16.f];
        self.topBarTitleLbl.textColor = [UIColor colorWithHexString:[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KTopbar_TitleColor]]?[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KTopbar_TitleColor]]:@"181818"];
        [self.topBar addSubview:self.topBarTitleLbl];
    }
    self.topBarTitleLbl.text = title;
}

- (void)setupTopBarBackButton
{
    [self setupTopBarBackButton:[UIImage imageNamed:@"Back_Promrt_MF"] imgPressed:nil];
    //self.topBarBackButton.backgroundColor = [UIColor redColor];
}

- (void)setupTopBarBackButton:(UIImage*)imgNormal imgPressed:(UIImage*)imgPressed {
    if (!self.topBarBackButton) {
        CGFloat height = CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-self.topbarShadowHeight;
        CGFloat width = height;
        CGFloat X = 15-(imgNormal!=nil?(width-imgNormal.size.width)/2:0);
        UIButton *topBarBackButton = [[UIButton alloc] initWithFrame:CGRectMake(X, kTopBarContentMarginTop, width, height)];
        self.topBarBackButton = topBarBackButton;
        self.topBarBackButton.backgroundColor = [UIColor clearColor];
        [self.topBarBackButton addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarBackButton setImage:imgNormal forState:UIControlStateNormal];
        [self.topBarBackButton setImage:imgPressed forState:UIControlStateHighlighted];
        
        [self.topBar addSubview:self.topBarBackButton];
    }
    else {
        CGFloat height = CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-self.topbarShadowHeight;
        CGFloat width = height;
        CGFloat X = 15-(imgNormal!=nil?(width-imgNormal.size.width)/2:0);
        UIButton *topBarBackButton = self.topBarBackButton;
        topBarBackButton.frame = CGRectMake(X, kTopBarContentMarginTop, width, height);
        [topBarBackButton removeFromSuperview];
        [self.topBar addSubview:topBarBackButton];
    }
}

//E2BB66

- (void)setupTopBarRightButton {
    [self setupTopBarRightButton:nil imgPressed:nil];
    self.topBarRightButton.backgroundColor = [UIColor redColor];
    
    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    self.topBarRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.topBarRightButton.titleLabel.font  =[UIFont systemFontOfSize:14.f];
}

- (void)setupTopBarRightButton:(UIImage*)imgNormal imgPressed:(UIImage*)imgPressed
{
    if (!self.topBarRightButton) {
        CGFloat height = CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-self.topbarShadowHeight;
        CGFloat width = height;
        CGFloat X = CGRectGetWidth(self.topBar.bounds)-width-(imgNormal!=nil?(15-(width-imgNormal.size.width)/2):15);
        UIButton *topBarRightButton = [[UIButton alloc] initWithFrame:CGRectMake(X, kTopBarContentMarginTop, width+10, width)];
        self.topBarRightButton = topBarRightButton;
        self.topBarRightButton.backgroundColor = [UIColor clearColor];
        [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        [self.topBarRightButton addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarRightButton setImage:imgNormal forState:UIControlStateNormal];
        [self.topBarRightButton setImage:imgPressed forState:UIControlStateHighlighted];
        [self.topBar addSubview:self.topBarRightButton];
    } else {
        CGFloat height = CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-self.topbarShadowHeight;
        CGFloat width = height;
        CGFloat X = CGRectGetWidth(self.topBar.bounds)-width-(imgNormal!=nil?(15-(width-imgNormal.size.width)/2):15);
        UIButton *topBarRightButton = self.topBarRightButton;
        topBarRightButton.frame = CGRectMake(X, kTopBarContentMarginTop, width+10, width);
        [topBarRightButton removeFromSuperview];
        [self.topBar addSubview:topBarRightButton];
    }
}

- (void)setupTopBarRightTwoButton {
    [self setupTopBarRightTwoButton:nil imgPressed:nil];
    self.topBarRightTwoButton.backgroundColor = [UIColor blueColor];
    
    [self.topBarRightTwoButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    self.topBarRightTwoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.topBarRightTwoButton.titleLabel.font  =[UIFont systemFontOfSize:14.f];
}

- (void)setupTopBarRightTwoButton:(UIImage*)imgNormal imgPressed:(UIImage*)imgPressed
{
    if (!self.topBarRightTwoButton) {
        CGFloat height = CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-self.topbarShadowHeight;
        CGFloat width = height;
        CGFloat X = CGRectGetWidth(self.topBar.bounds)-width-self.topBarRightButton.width+10-(imgNormal!=nil?(15-(width-imgNormal.size.width)/2):15);
        UIButton *topBarRightTwoButton = [[UIButton alloc] initWithFrame:CGRectMake(X, kTopBarContentMarginTop, width+10, width)];
        self.topBarRightTwoButton = topBarRightTwoButton;
        self.topBarRightTwoButton.backgroundColor = [UIColor clearColor];
        [self.topBarRightTwoButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        [self.topBarRightTwoButton addTarget:self action:@selector(handleTopBarRightTwoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarRightTwoButton setImage:imgNormal forState:UIControlStateNormal];
        [self.topBarRightTwoButton setImage:imgPressed forState:UIControlStateHighlighted];
        [self.topBar addSubview:self.topBarRightTwoButton];
    } else {
        CGFloat height = CGRectGetHeight(self.topBar.bounds)-kTopBarContentMarginTop-self.topbarShadowHeight;
        CGFloat width = height;
        CGFloat X = CGRectGetWidth(self.topBar.bounds)-width-self.topBarRightButton.width+10-(imgNormal!=nil?(15-(width-imgNormal.size.width)/2):15);
        UIButton *topBarRightTwoButton = self.topBarRightTwoButton;
        topBarRightTwoButton.frame = CGRectMake(X, kTopBarContentMarginTop, width+10, width);
        [topBarRightTwoButton removeFromSuperview];
        [self.topBar addSubview:topBarRightTwoButton];
    }
}

- (void)handleTopBarBackButtonClicked:(UIButton*)sender {
    [self.view endEditing:YES];
    [self dismiss];
}

- (void)handleSwipBackGuesture {
    
}

- (void)handleTopBarRightTwoButtonClicked:(UIButton*)sender {
    [self.view endEditing:YES];
}

- (void)handleTopBarRightButtonClicked:(UIButton*)sender {
    [self.view endEditing:YES];
}

- (void)handleTopBarViewClicked {
    
}

- (LoadingView*)showRemindLoginView {
    LoadingView *view = [LoadingView showRemindLoginView:self.view];
    view.frame = CGRectMake(0, self.topBarHeight, self.view.width, self.view.height-self.topBarHeight);
    view.backgroundColor = [UIColor whiteColor];
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self.view];
    view.frame = CGRectMake(0, self.topBarHeight, self.view.width, self.view.height-self.topBarHeight);
    view.backgroundColor = [UIColor whiteColor];
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)showLoadingViewNotTopBar {
    LoadingView *view = [LoadingView showLoadingView:self.view];
    view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    view.backgroundColor = [UIColor whiteColor];
    [self bringTopBarToTop];
    return view;
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self.view];
}

- (void)hideLoadingView:(CGFloat)hideAfterDelay {
    if (hideAfterDelay>0) {
        WEAKSELF;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideAfterDelay * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf hideLoadingView];
        });
    } else {
        [self hideLoadingView];
    }
}

- (LoadingView*)loadEndWithNoContent {
    return [self loadEndWithNoContent:@"暂无内容"];
}

- (LoadingView*)loadEndWithNoContentWithRetryButton {
    return [self loadEndWithNoContentWithRetryButton:@"暂无内容"];
}



- (LoadingView*)loadEndWithNoContentWithRetryButton:(NSString*)title {
    LoadingView *view = [LoadingView loadEndWithNoContentWithRetryButton:self.view title:title];
    view.frame = CGRectMake(0, self.topBarHeight, self.view.width, self.view.height-self.topBarHeight);
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)loadEndWithNoContentWithRetryButtonNotTopBar:(NSString*)title {
    LoadingView *view = [LoadingView loadEndWithNoContentWithRetryButton:self.view title:title];
    view.frame = CGRectMake(0, 0, self.view.width, self.view.height-self.topBarHeight);
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)loadEndWithNoContentWithRetryButtonHaveView:(NSString*)title andView:(CGFloat )viewHeigth{
    LoadingView *view = [LoadingView loadEndWithNoContentWithRetryButton:self.view title:title];
    view.frame = CGRectMake(0, self.topBarHeight + viewHeigth, self.view.width, self.view.height-self.topBarHeight);
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)loadEndWithError {
    return [self loadEndWithError:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"网络连接失败"];
}

- (LoadingView*)loadEndWithNoContentAndImage:(NSString*)title imageName:(NSString *)imageName{
    LoadingView *view = [LoadingView loadEndWithNoContent:self.view title:title image:[UIImage imageNamed:imageName]];
    view.frame = CGRectMake(0, self.topBarHeight, self.view.width, self.view.height-self.topBarHeight);
    
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)loadEndWithNoContent:(NSString*)title {
    LoadingView *view = [LoadingView loadEndWithNoContent:self.view title:title];
    view.frame = CGRectMake(0, self.topBarHeight, self.view.width, self.view.height-self.topBarHeight);
    
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)loadEndWithError:(NSString*)title {
    LoadingView *view = [LoadingView loadEndWithError:self.view title:title];
    view.frame = CGRectMake(0, self.topBarHeight, self.view.width, self.view.height-self.topBarHeight);
    [self bringTopBarToTop];
    return view;
}

- (LoadingView*)loadEndWithErrorNotTopBar {
    return [self loadEndWithErrorNotTopBar:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"网络连接失败"];
}

- (LoadingView*)loadEndWithErrorNotTopBar:(NSString*)title {
    LoadingView *view = [LoadingView loadEndWithError:self.view title:title];
    view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self bringTopBarToTop];
    return view;
}

- (void)hideNoContentView {
    [LoadingView hideLoadingView:self.view];
}

///
- (void)setupReachabilityChangedObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReachabilityChanged:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

- (void)handleReachabilityChanged:(id)notificationObject {
    
}

///
- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    
}

@end


UIInterfaceOrientation interfaceOrientation(void) {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	return orientation;
}

CGRect screenBounds(void) {
	CGRect bounds = [UIScreen mainScreen].bounds;
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation())) {
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}
	return bounds;
}

CGFloat statusBarHeight(void) {
    if ([[UIApplication sharedApplication] isStatusBarHidden]) return 0.0;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation()))
        return [[UIApplication sharedApplication] statusBarFrame].size.width;
    else
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
}




@implementation BaseViewControllerHandleMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

@end

