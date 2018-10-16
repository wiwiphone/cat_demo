//
//  CoordinatingController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
@class MyNavigationController;

typedef void(^shareChannel)(NSInteger shareData);
typedef void(^getImageAndText)();

@interface CoordinatingController : NSObject

@property(nonatomic,readonly) UINavigationController *rootViewController;
@property(nonatomic,readonly) MainViewController *mainViewController;

+ (CoordinatingController*)sharedInstance;

@property (nonatomic, copy) shareChannel shareChannel;
@property (nonatomic, copy) getImageAndText getImageAndText;
///
- (UIViewController*)visibleController;
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewControllerWithCls:(Class)Cls animated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;

///
- (void)openSideMenu;
- (void)closeSideMenu;
- (void)enableSideMenu:(BOOL)enable;

///
- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay;
- (void)showHUD:(NSString*)message hideAfterDelay:(CGFloat)hideAfterDelay forView:(UIView*)view;
- (void)showProcessingHUD:(NSString*)message;
- (void)showProcessingHUD:(NSString*)message forView:(UIView*)view;
- (void)hideHUD;

///
- (BOOL)checkLoginStateAndPresentLoginController:(UIViewController*)viewController completion:(void (^)(void))completion;
- (BOOL)checkBindingStateAndPresentLoginController:(UIViewController*)viewController bindingAlert:(NSString*)bindingAlert completion:(void (^)(void))completion;

///
-(void)gotoOfferedViewController:(NSString*)goodsId index:(NSInteger)index animated:(BOOL)animated;
-(void)gotoRecoverDetailViewController:(NSString*)goodsId index:(NSInteger)index animated:(BOOL)animated;
- (void)gotoGoodsDetailViewController:(NSString*)goodsId animated:(BOOL)animated;
- (void)gotoGoodsLikesViewController:(NSString*)goodsId animated:(BOOL)animated;
- (void)gotoEditProfileViewController:(BOOL)animated;
- (void)gotoUserHomeViewController:(NSInteger)userId animated:(BOOL)animated;
- (void)gotoUserChatViewController:(NSInteger)userId animated:(BOOL)animated;
- (void)gotoUserLikesViewController:(NSInteger)userId animated:(BOOL)animated;
- (void)gotoFollowingsViewController:(NSInteger)userId animated:(BOOL)animated;
- (void)gotoFollowersViewController:(NSInteger)userId animated:(BOOL)animated;
- (void)gotoHomeRecommendViewControllerAnimated:(BOOL)animated;
//- (void)shareGoods:(NSString*)goodsId;

- (void)shareNetWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url content:(NSString *)content parament:(NSMutableDictionary *)param;

- (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url content:(NSString *)content;
- (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url content:(NSString *)content isTeletext:(BOOL)isYES;

- (void)startCameraControllerEdit:(BOOL)canEdit deletegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate;


+(void)dismissMaskView;
+(void)showMaskView:(void (^)())dismissCallback;

@end



