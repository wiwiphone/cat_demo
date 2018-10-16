//
//  BaseViewController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+DismissKeyboard.h"
#import "MBDefaultViewController.h"
#import "LoadingView.h"
#import "MyNavigationController.h"

#define kTopBarContentMarginTop (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?statusBarHeight():0.f)
#define kTopBarHeight (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?(kTopBarContentMarginTop+45.f):45.f)

@interface BaseViewController : MBDefaultViewController

@property(nonatomic,assign) BOOL hidesStatusBarWhenPresented;
@property(nonatomic,assign) BOOL hidesTabBarWhenPresented;

@property(nonatomic,readonly) BOOL isVisible;

///
@property(nonatomic,readonly) CGFloat topbarShadowHeight;
@property(nonatomic,readonly,weak) UIImageView *topBar;
@property(nonatomic,readonly,weak) UIImageView *topBarLogo;
@property(nonatomic,readonly,weak) UILabel  *topBarTitleLbl;
@property(nonatomic,readonly,weak) UIButton *topBarBackButton;
@property(nonatomic,readonly,weak) UIButton *topBarRightButton;
@property (nonatomic, weak) UIButton *topBarRightTwoButton;
@property (nonatomic, strong) UIView *topBarlineView;

- (void)bringTopBarToTop;
- (CGFloat)setupTopBar;
- (CGFloat)setupTopBar:(UIView*)parentView;
- (CGFloat)topBarHeight;
- (void)setupTopBarLogo:(UIImage*)logoImg;
- (void)setupTopBarTitle:(NSString*)title;
- (void)setupTopBarBackButton;
- (void)setupTopBarBackButton:(UIImage*)imgNormal imgPressed:(UIImage*)imgPressed;
- (void)setupTopBarRightButton;
- (void)setupTopBarRightButton:(UIImage*)imgNormal imgPressed:(UIImage*)imgPressed;
- (void)setupTopBarRightTwoButton;
- (void)setupTopBarRightTwoButton:(UIImage*)imgNormal imgPressed:(UIImage*)imgPressed;
- (void)handleTopBarRightTwoButtonClicked:(UIButton*)sender;
- (void)handleTopBarBackButtonClicked:(UIButton*)sender;
- (void)handleTopBarRightButtonClicked:(UIButton*)sender;
- (void)handleTopBarViewClicked;

///
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;
- (void)handleSwipBackGuesture;

///
- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay;
- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay forView:(UIView*)view;
- (void)showProcessingHUD:(NSString*)message;
- (void)showProcessingHUD:(NSString*)message forView:(UIView*)view;
- (void)hideHUD;
- (UIView*)HUDForView;


///
- (LoadingView*)showRemindLoginView;
- (LoadingView*)showLoadingView;
- (LoadingView*)showLoadingViewNotTopBar;
- (void)hideLoadingView;
- (void)hideLoadingView:(CGFloat)hideAfterDelay;
- (LoadingView*)loadEndWithNoContent;
- (LoadingView*)loadEndWithNoContentWithRetryButton;
- (LoadingView*)loadEndWithNoContentWithRetryButton:(NSString*)title;
- (LoadingView*)loadEndWithNoContentWithRetryButtonNotTopBar:(NSString*)title;
- (LoadingView*)loadEndWithNoContentWithRetryButtonHaveView:(NSString*)title andView:(CGFloat )viewHeigth;
- (LoadingView*)loadEndWithNoContentAndImage:(NSString*)title imageName:(NSString *)imageName;
- (LoadingView*)loadEndWithError;
- (LoadingView*)loadEndWithNoContent:(NSString*)title;
- (LoadingView*)loadEndWithError:(NSString*)title;
- (LoadingView*)loadEndWithErrorNotTopBar;
- (LoadingView*)loadEndWithErrorNotTopBar:(NSString*)title;
- (void)hideNoContentView;


///
- (void)setupReachabilityChangedObserver;
- (void)handleReachabilityChanged:(id)notificationObject;

@end


extern UIInterfaceOrientation interfaceOrientation(void);
extern CGRect screenBounds(void);
extern CGFloat statusBarHeight(void);



@interface BaseViewControllerHandleMemoryWarning : BaseViewController

@end

