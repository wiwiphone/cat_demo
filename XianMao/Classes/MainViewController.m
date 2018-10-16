//
//  MainViewController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

//指纹支付框架
#import <localauthentication/localauthentication.h>

#import "MainViewController.h"
#import "TabBarView.h"

#import "CoordinatingController.h"
#import "AssessViewController.h"
#import "MyNavigationController.h"
#import "FeedsViewController.h"
#import "RecommendViewController.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "ConsignViewController.h"
#import "SaleViewController.h"
#import "PublishGoodsViewController.h"
#import "MessageViewController.h"
#import "NewMessageViewController.h"
#import "MineViewController.h"
#import "MineNewViewController.h"
#import "IssueViewController.h"
#import "InsureViewController.h"

#import "BlackView.h"
#import "ReleaseButton.h"
#import "ReleaseCoverButton.h"

#import "LoginViewController.h"

#import "Command.h"

#import "WCAlertView.h"
#import "UIColor+Expanded.h"
#import "DataSources.h"
#import "Session.h"
#import "NetworkAPI.h"

#import "UserAddressViewController.h"

#import "MsgCountManager.h"

#import "SDImageCache.h"
#import "EMSession.h"
#import "Masonry.h"
#import "CategoryService.h"
#import "Cate.h"
#import "BrandInfo.h"
#import "RecoveryGoodsPublish.h"

#import "RemindOpenNotifiViewController.h"
#import "GuideView.h"
#import "ForumPoatCatHouseControllerTwo.h"

#import "VisualEffectView.h"
#import "RecoverGoodsController.h"
#import "SprangView.h"

#import "DiscoveryViewController.h"
#import "IdleViewController.h"

#import "PublishViewController.h"
#import "InformationViewController.h"
#import "PublishChooseView.h"
#import "WebViewController.h"

#import "SuccessGoodsView.h"
#import "SharedItem.h"
#import "SkinVo.h"
#import "RXRotateButtonOverlayView.h"
#import "ConsignmentViewController.h"

#define kBottomTabBarTagToSell 2
#define kBottomTabBarBeforeSelectActionKey @"kMainViewTabBarBeforeSelectActionKey"

@interface MainViewController () <TabBarViewDelegate, AuthorizeChangedReceiver,MsgCountChangedReceiver, PublishSelectViewControllerDelegate, SprangViewDelegate, RXRotateButtonOverlayViewDelegate>

@property(nonatomic,retain) UIView *transitionView;
@property(nonatomic,retain) TabBarView *tabBarView;
@property (nonatomic, strong) TapDetectingImageView * assessImageView;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,retain) NSArray *tabButtonDicts;

@property (nonatomic, strong) ReleaseButton *releaseNofm;
@property (nonatomic, strong) ReleaseCoverButton *releaseRecover;
@property (nonatomic, weak) BlackView *backView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *titleStr1;
@property (nonatomic, assign) NSInteger cate_id;

@property (nonatomic, strong) NSArray *cateList;
@property (nonatomic, strong) NSArray *brandList;
@property(nonatomic,strong) Cate *selectedCate;
@property(nonatomic,strong) BrandInfo *selectedBrandInfo;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) PublishChooseView * publishChooseView;
@property(nonatomic,weak) BaseViewController *viewController;
@property (nonatomic, strong) VisualEffectView *visualView;

@property (nonatomic, strong) SprangView *sprangView;
@property (nonatomic, strong) VerticalCommandButton *centerBtn;
@property (nonatomic, strong) BlackView * blackView;

@property (nonatomic, strong) SuccessGoodsView *successGoodsView;
@property (nonatomic, strong) BlackView *successBgView;
@property (nonatomic, strong) CommandButton *disSuccessBtn;
@property (nonatomic, strong) RXRotateButtonOverlayView* overlayView;
@end

@implementation MainViewController

-(CommandButton *)disSuccessBtn{
    if (!_disSuccessBtn) {
        _disSuccessBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-60-30, 110-72, 27, 72)];
        [_disSuccessBtn setImage:[UIImage imageNamed:@"Dis_SuccessPublish"] forState:UIControlStateNormal];
        [_disSuccessBtn sizeToFit];
    }
    return _disSuccessBtn;
}

-(BlackView *)successBgView{
    if (!_successBgView) {
        _successBgView = [[BlackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _successBgView;
}

- (TapDetectingImageView *)assessImageView{
    if (!_assessImageView) {
        _assessImageView = [[TapDetectingImageView alloc] init];
        _assessImageView.image = [UIImage imageNamed:@"assessIcon"];
    }
    return _assessImageView;
}

-(SuccessGoodsView *)successGoodsView{
    if (!_successGoodsView) {
        _successGoodsView = [[SuccessGoodsView alloc] initWithFrame:CGRectMake(60, 110, kScreenWidth-120, kScreenWidth/320*440)];
        _successGoodsView.backgroundColor = [UIColor whiteColor];
    }
    return _successGoodsView;
}

-(BlackView *)blackView
{
    if (!_blackView) {
        _blackView = [[BlackView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
        _blackView.alpha = 1;
        _blackView.hidden  = YES;
    }
    return _blackView;
}

-(PublishChooseView *)publishChooseView
{
    if (!_publishChooseView) {
        _publishChooseView = [[PublishChooseView alloc] initWithFrame:CGRectMake(15, kScreenHeight-50-15-150, kScreenWidth-30, 150)];
        _publishChooseView.alpha = 0;
        _publishChooseView.hidden = YES;
        _publishChooseView.userInteractionEnabled = YES;
    }
    return _publishChooseView;
}

-(VerticalCommandButton *)centerBtn
{
    if (!_centerBtn) {
        _centerBtn = [[VerticalCommandButton alloc] init];
        [_centerBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_centerBtn setImage:[UIImage imageNamed:@"centerBtn"] forState:UIControlStateNormal];
        [_centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        _centerBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _centerBtn.layer.masksToBounds = YES;
        _centerBtn.layer.cornerRadius = 20;
        _centerBtn.imageTextSepHeight = 3;
        _centerBtn.contentMarginTop = 10;
    }
    return _centerBtn;
}

-(SprangView *)sprangView{
    if (!_sprangView) {
        _sprangView = [[SprangView alloc] initWithFrame:CGRectZero];
        _sprangView.backgroundColor = [UIColor clearColor];
        _sprangView.sprangDelegate = self;
    }
    return _sprangView;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backButton setImage:[UIImage imageNamed:@"Publish_click"] forState:UIControlStateNormal];//Publish_click
//        _backButton.backgroundColor = [UIColor whiteColor];
        _backButton.layer.masksToBounds = YES;
        _backButton.layer.cornerRadius = 43/2;
        [_backButton sizeToFit];
    }
    return _backButton;
}

-(ReleaseButton *)releaseNofm{
    if (!_releaseNofm) {
        _releaseNofm = [[ReleaseButton alloc] initWithFrame:CGRectZero];
//        [_releaseNofm setImage:[UIImage imageNamed:@"releaseNofm_MF"] forState:UIControlStateNormal];
        [_releaseNofm setBackgroundImage:[UIImage imageNamed:@"releaseNofm_MF"] forState:UIControlStateNormal];
    }
    return _releaseNofm;
}

-(ReleaseCoverButton *)releaseRecover{
    if (!_releaseRecover) {
        _releaseRecover = [[ReleaseCoverButton alloc] initWithFrame:CGRectZero];
//        [_releaseRecover setImage:[UIImage imageNamed:@"releaseRecover_MF"] forState:UIControlStateNormal];
        [_releaseRecover setBackgroundImage:[UIImage imageNamed:@"releaseRecover_MF"] forState:UIControlStateNormal];
        
    }
    return _releaseRecover;
}

- (NSString *)dataFilePath:(NSString *)fileName
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingFormat:@"%@/", fileName];
    return path;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _hidesTabBarWithAnimated = NO;
    _selectedIndex = -1;
    
    self.transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-kBottomTabBarHeight)];
    self.transitionView.backgroundColor = [UIColor whiteColor];
    self.transitionView.autoresizesSubviews = YES;
    [self.view addSubview:self.transitionView];
    
    
    ///////////////////////////////////////////////////////
    /////                                            //////
    /////                                            //////
    /////                                            //////
    /////                                            //////
    /////           添加根部Controller                //////
    /////                                            //////
    /////                                            //////
    /////                                            //////
    /////                                            //////
    /////                                            //////
    ///////////////////////////////////////////////////////
    WEAKSELF;
#pragma mark -------------------Controller
    NSDictionary * skinDict = [[Session sharedInstance] loadSkinIconData];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    self.viewControllers = [NSArray arrayWithObjects:
                            [[MyNavigationController alloc] initWithRootViewController:[[HomeRecommendViewController alloc] init]],
                            [[MyNavigationController alloc] initWithRootViewController:[[IdleViewController alloc] init]],
                            [[MyNavigationController alloc] initWithRootViewController:[[PublishGoodsViewController alloc] init]],
                            [[MyNavigationController alloc] initWithRootViewController:[[InformationViewController alloc] init]],
                            [[MyNavigationController alloc] initWithRootViewController:[[MineNewViewController alloc] init]],
                            nil];
    
    
    if ([[SkinIconManager manager] isValidWithPath:KTabbar3_S]) {
        [self.backButton setImage:[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar3_S]] forState:UIControlStateNormal];
    }
    
    UIFont  *textFont = [UIFont systemFontOfSize:9.f];
    UIColor *textColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTabbar_TextColor_N]?[[SkinIconManager manager] getValue:KTabbar_TextColor_N]:@"1a1a1a"];//修改底部颜色2016.5.7 Feng  [UIColor colorWithHexString:@"383735"]; //修改颜色1a1a1a 2016.11.21
    UIColor *textSelectedColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTabbar_TextColor_S]?[[SkinIconManager manager] getValue:KTabbar_TextColor_S]:@"f9384c"];//修改底部颜色2016.5.7 Feng  [UIColor colorWithHexString:@"b48132"]; //修改颜色1a1a1a 2016.11.21

    NSMutableDictionary *homeTabBtnDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar1_Text]?[[SkinIconManager manager] getValue:KTabbar1_Text]:@"商城", kTabBarButtonText,
                                            textFont,kTabBarButtonTextFont,
                                            textColor,kTabBarButtonTextColor,
                                            textSelectedColor,kTabBarButtonSelectedTextColor,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar1_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar1_N]]:[UIImage imageNamed:@"Tabbar_Main_N_New"],kTabBarButtonImage,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar1_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar1_S]]:[UIImage imageNamed:@"Tabbar_Main_New"],kTabBarButtonSelectedImage,
                                            [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                            [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                            nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_homepage"];
        [[CoordinatingController sharedInstance] enableSideMenu:YES];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        
    }];
    
    NSMutableDictionary *exploreTabBtnDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar2_Text]?[[SkinIconManager manager] getValue:KTabbar2_Text]:@"个人闲置", kTabBarButtonText,
                                               textFont,kTabBarButtonTextFont,
                                               textColor,kTabBarButtonTextColor,
                                               textSelectedColor,kTabBarButtonSelectedTextColor,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar2_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar2_N]]:[UIImage imageNamed:@"Tabbar_Discover_N_New_MF"],kTabBarButtonImage,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar2_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar2_S]]:[UIImage imageNamed:@"Tabbar_Discover_New_MF"],kTabBarButtonSelectedImage,
                                               [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                               [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                               nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_dicovery"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        
    }];
    //@"卖东西", kTabBarButtonText,
    NSMutableDictionary *saleTabBtnDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar3_Text]?[[SkinIconManager manager] getValue:KTabbar3_Text]:@"", kTabBarButtonText,
                                            textFont,kTabBarButtonTextFont,
                                            textColor,kTabBarButtonTextColor,
                                            textSelectedColor,kTabBarButtonSelectedTextColor,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar3_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar3_N]]:[UIImage imageNamed:@"Publish_Tabbar_Cebter"],kTabBarButtonImage,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar3_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar3_S]]:[UIImage imageNamed:@"Publish_Tabbar_Cebter"],kTabBarButtonSelectedImage,
                                            [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                            [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                            nil] fillActionWithParameters:^(id parameters){
        [MobClick event:@"click_sell_tab"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        
        //        [self displayViewControllerAtIndex:[parameters integerValue]];
        //        _selectedIndex = [parameters integerValue];
        //        ConsignViewController *viewController = [[ConsignViewController alloc] init];
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        //        [super presentViewController:navController animated:YES completion:^{
        //        }];
        
        //        PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        //        [super presentViewController:navController animated:YES completion:^{
        //        }];
        //        viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
        //          [super showHUD:@"发布成功" hideAfterDelay:1.2f];
        //        };
        //
        if (self.centerBtn.hidden == YES) {
            self.centerBtn.hidden = NO;
            self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2-25, kScreenHeight-45, 50, 40);
            } completion:^(BOOL finished) {
                
            }];
        }
        if (_selectedIndex == [parameters integerValue]) {
            UINavigationController *navConroller = (UINavigationController*)([_viewControllers objectAtIndex:_selectedIndex]);
            if ([navConroller viewControllers].count>0) {
                SaleViewController *saleConroller = [navConroller.viewControllers objectAtIndex:0];
                if ([saleConroller isKindOfClass:[SaleViewController class]]) {
                    [saleConroller showPublishGoodsView];
                }
            }
        }
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
    }];
    NSMutableDictionary *messageTabBtnDict = [[[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar4_Text]?[[SkinIconManager manager] getValue:KTabbar4_Text]:@"消息", kTabBarButtonText,
                                               textFont,kTabBarButtonTextFont,
                                               textColor,kTabBarButtonTextColor,
                                               textSelectedColor,kTabBarButtonSelectedTextColor,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar4_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar4_N]]:[UIImage imageNamed:@"Tabbar_Message_N_New_MF"],kTabBarButtonImage,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar4_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar4_S]]:[UIImage imageNamed:@"Tabbar_Message_New_MF"],kTabBarButtonSelectedImage,
                                               [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                               [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                               nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_message"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        if ([[Session sharedInstance] isLoggedIn]) {
            
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            //            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            viewController.title = @"登录";
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
        }
    }] fillActionAndReturn:^id{
        if ([[Session sharedInstance] isLoggedIn]) {
            return [NSNumber numberWithBool:YES];
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            //            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
            return [NSNumber numberWithBool:NO];
        }
    } withKey:kBottomTabBarBeforeSelectActionKey];
    
    NSMutableDictionary *mineTabBtnDict = [[[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar5_Text]?[[SkinIconManager manager] getValue:KTabbar5_Text]:@"我的", kTabBarButtonText,
                                             textFont,kTabBarButtonTextFont,
                                             textColor,kTabBarButtonTextColor,
                                             textSelectedColor,kTabBarButtonSelectedTextColor,
                                             [[SkinIconManager manager] isValidWithPath:KTabbar5_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar5_N]]:[UIImage imageNamed:@"Tabbar_Mine_N_New_MF"],kTabBarButtonImage,
                                             [[SkinIconManager manager] isValidWithPath:KTabbar5_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar5_S]]:[UIImage imageNamed:@"Tabbar_Mine_New_MF"],kTabBarButtonSelectedImage,
                                             [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                             [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                             nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_mine"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        if ([[Session sharedInstance] isLoggedIn]) {
            
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            //            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            viewController.title = @"登录";
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
        }
    }] fillActionAndReturn:^id{
        if ([[Session sharedInstance] isLoggedIn]) {
            return [NSNumber numberWithBool:YES];
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            //            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
            return [NSNumber numberWithBool:NO];
        }
    } withKey:kBottomTabBarBeforeSelectActionKey];
    
    self.tabButtonDicts = [NSArray arrayWithObjects: homeTabBtnDict, exploreTabBtnDict, saleTabBtnDict, messageTabBtnDict, mineTabBtnDict, nil];
    
    
    self.tabBarView = [[TabBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-kBottomTabBarHeight, self.view.bounds.size.width, kBottomTabBarHeight) buttonDicts:self.tabButtonDicts];
    
    self.tabBarView.backgroundColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTabbar_Backgroud]?[[SkinIconManager manager] getValue:KTabbar_Backgroud]:@"ffffff"];  //修改tabbar 2016.4.16 Feng  //修改颜色 2016.7.7 Feng
    
    if ([[SkinIconManager manager] isValidWithPath:KTabbar_BackgroudImg]) {
        UIImage *imgBg = [UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar_BackgroudImg]];
        self.tabBarView.image = imgBg;
        [self.tabBarView setImage:[imgBg stretchableImageWithLeftCapWidth:imgBg.size.width/2 topCapHeight:imgBg.size.height/2]];
    }
    self.tabBarView.delegate = self;
    
    [self.view addSubview:self.tabBarView];
    //[self setSelectedAtIndex:0];ski
    
    self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-25, 0, 0);
    self.centerBtn.hidden = YES;
    //    [self.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.centerBtn];
    [self.view addSubview:self.blackView];
    [self.view addSubview:self.publishChooseView];
   
    
    self.publishChooseView.handlePublishNewGoods = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.blackView.alpha = 0;
            weakSelf.publishChooseView.alpha = 0;
            weakSelf.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
        } completion:^(BOOL finished) {
            weakSelf.centerBtn.hidden = YES;
            PublishViewController *publishController = [[PublishViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishController];
            publishController.isFromDraft = NO;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
    };
    
    self.publishChooseView.handleSaveDraft = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.blackView.alpha = 0;
            weakSelf.publishChooseView.alpha = 0;
            weakSelf.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
        } completion:^(BOOL finished) {
            weakSelf.centerBtn.hidden = YES;
            PublishViewController *publishController = [[PublishViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishController];
            publishController.isFromDraft  = YES;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
    };
    self.blackView.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.blackView.alpha = 0;
            weakSelf.publishChooseView.alpha = 0;
            weakSelf.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
        } completion:^(BOOL finished) {
            weakSelf.centerBtn.hidden = YES;
        }];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissResales) name:@"dissMissResales" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"reloadView" object:nil];
    // [self registerNotifications];
    //    [self showHUD:[NSString stringWithFormat:@"%d",([MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount)]
    //                              hideAfterDelay:7.0
    //                                     forView:self.view];
    //    if ([[Session sharedInstance] isLoggedIn]) {
    //        [self restMsgButtonCount:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
    //    }
    
    [self.releaseNofm addTarget:self action:@selector(releaseNofmBuy) forControlEvents:UIControlEventTouchUpInside];
    [self.releaseRecover addTarget:self action:@selector(releaseRecoverBuy) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(dissMissSubviews) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self.view addSubview:[self genView]];
}

-(void)reloadView{
    NSDictionary * skinDict = [[Session sharedInstance] loadSkinIconData];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([[SkinIconManager manager] isValidWithPath:KTabbar3_S]) {
        [self.backButton setImage:[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar3_S]] forState:UIControlStateNormal];
    }
    
    UIFont  *textFont = [UIFont systemFontOfSize:9.f];
    UIColor *textColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTabbar_TextColor_N]?[[SkinIconManager manager] getValue:KTabbar_TextColor_N]:@"1a1a1a"];//修改底部颜色2016.5.7 Feng  [UIColor colorWithHexString:@"383735"]; //修改颜色1a1a1a 2016.11.21
    UIColor *textSelectedColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTabbar_TextColor_S]?[[SkinIconManager manager] getValue:KTabbar_TextColor_S]:@"f9384c"];//修改底部颜色2016.5.7 Feng  [UIColor colorWithHexString:@"b48132"]; //修改颜色1a1a1a 2016.11.21
    
    NSMutableDictionary *homeTabBtnDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar1_Text]?[[SkinIconManager manager] getValue:KTabbar1_Text]:@"商城", kTabBarButtonText,
                                            textFont,kTabBarButtonTextFont,
                                            textColor,kTabBarButtonTextColor,
                                            textSelectedColor,kTabBarButtonSelectedTextColor,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar1_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar1_N]]:[UIImage imageNamed:@"Tabbar_Main_N_New"],kTabBarButtonImage,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar1_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar1_S]]:[UIImage imageNamed:@"Tabbar_Main_New"],kTabBarButtonSelectedImage,
                                            [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                            [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                            nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_homepage"];
        [[CoordinatingController sharedInstance] enableSideMenu:YES];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        
    }];
    
    NSMutableDictionary *exploreTabBtnDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar2_Text]?[[SkinIconManager manager] getValue:KTabbar2_Text]:@"个人闲置", kTabBarButtonText,
                                               textFont,kTabBarButtonTextFont,
                                               textColor,kTabBarButtonTextColor,
                                               textSelectedColor,kTabBarButtonSelectedTextColor,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar2_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar2_N]]:[UIImage imageNamed:@"Tabbar_Discover_N_New_MF"],kTabBarButtonImage,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar2_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar2_S]]:[UIImage imageNamed:@"Tabbar_Discover_New_MF"],kTabBarButtonSelectedImage,
                                               [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                               [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                               nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_dicovery"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        
    }];
    //@"卖东西", kTabBarButtonText,
    NSMutableDictionary *saleTabBtnDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar3_Text]?[[SkinIconManager manager] getValue:KTabbar3_Text]:@"", kTabBarButtonText,
                                            textFont,kTabBarButtonTextFont,
                                            textColor,kTabBarButtonTextColor,
                                            textSelectedColor,kTabBarButtonSelectedTextColor,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar3_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar3_N]]:[UIImage imageNamed:@"Publish_Tabbar_Cebter"],kTabBarButtonImage,
                                            [[SkinIconManager manager] isValidWithPath:KTabbar3_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar3_S]]:[UIImage imageNamed:@"Publish_Tabbar_Cebter"],kTabBarButtonSelectedImage,
                                            [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                            [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                            nil] fillActionWithParameters:^(id parameters){
        [MobClick event:@"click_sell_tab"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        
        //        [self displayViewControllerAtIndex:[parameters integerValue]];
        //        _selectedIndex = [parameters integerValue];
        //        ConsignViewController *viewController = [[ConsignViewController alloc] init];
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        //        [super presentViewController:navController animated:YES completion:^{
        //        }];
        
        //        PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        //        [super presentViewController:navController animated:YES completion:^{
        //        }];
        //        viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
        //          [super showHUD:@"发布成功" hideAfterDelay:1.2f];
        //        };
        //
        if (self.centerBtn.hidden == YES) {
            self.centerBtn.hidden = NO;
            self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2-25, kScreenHeight-45, 50, 40);
            } completion:^(BOOL finished) {
                
            }];
        }
        if (_selectedIndex == [parameters integerValue]) {
            UINavigationController *navConroller = (UINavigationController*)([_viewControllers objectAtIndex:_selectedIndex]);
            if ([navConroller viewControllers].count>0) {
                SaleViewController *saleConroller = [navConroller.viewControllers objectAtIndex:0];
                if ([saleConroller isKindOfClass:[SaleViewController class]]) {
                    [saleConroller showPublishGoodsView];
                }
            }
        }
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
    }];
    NSMutableDictionary *messageTabBtnDict = [[[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar4_Text]?[[SkinIconManager manager] getValue:KTabbar4_Text]:@"消息", kTabBarButtonText,
                                               textFont,kTabBarButtonTextFont,
                                               textColor,kTabBarButtonTextColor,
                                               textSelectedColor,kTabBarButtonSelectedTextColor,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar4_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar4_N]]:[UIImage imageNamed:@"Tabbar_Message_N_New_MF"],kTabBarButtonImage,
                                               [[SkinIconManager manager] isValidWithPath:KTabbar4_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar4_S]]:[UIImage imageNamed:@"Tabbar_Message_New_MF"],kTabBarButtonSelectedImage,
                                               [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                               [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                               nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_message"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        if ([[Session sharedInstance] isLoggedIn]) {
            
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            //            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            viewController.title = @"登录";
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
        }
    }] fillActionAndReturn:^id{
        if ([[Session sharedInstance] isLoggedIn]) {
            return [NSNumber numberWithBool:YES];
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            //            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
            return [NSNumber numberWithBool:NO];
        }
    } withKey:kBottomTabBarBeforeSelectActionKey];
    
    NSMutableDictionary *mineTabBtnDict = [[[NSMutableDictionary dictionaryWithObjectsAndKeys:[[SkinIconManager manager] getValue:KTabbar5_Text]?[[SkinIconManager manager] getValue:KTabbar5_Text]:@"我的", kTabBarButtonText,
                                             textFont,kTabBarButtonTextFont,
                                             textColor,kTabBarButtonTextColor,
                                             textSelectedColor,kTabBarButtonSelectedTextColor,
                                             [[SkinIconManager manager] isValidWithPath:KTabbar5_N]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar5_N]]:[UIImage imageNamed:@"Tabbar_Mine_N_New_MF"],kTabBarButtonImage,
                                             [[SkinIconManager manager] isValidWithPath:KTabbar5_S]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar5_S]]:[UIImage imageNamed:@"Tabbar_Mine_New_MF"],kTabBarButtonSelectedImage,
                                             [NSNumber numberWithBool:YES],KTabBarIsCheckableBtn,
                                             [NSNumber numberWithInteger:8],KTabBarButtonIconPaddingTop,
                                             nil] fillActionWithParameters:^(id parameters) {
        [MobClick event:@"click_mine"];
        [[CoordinatingController sharedInstance] enableSideMenu:NO];
        [self displayViewControllerAtIndex:[parameters integerValue]];
        _selectedIndex = [parameters integerValue];
        
        if (self.centerBtn.hidden == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                self.centerBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-45+20, 0, 0);
                self.blackView.alpha = 0;
                self.publishChooseView.alpha = 0;
            } completion:^(BOOL finished) {
                self.centerBtn.hidden = YES;
            }];
        }
        if ([[Session sharedInstance] isLoggedIn]) {
            
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            viewController.title = @"登录";
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
        }
    }] fillActionAndReturn:^id{
        if ([[Session sharedInstance] isLoggedIn]) {
            return [NSNumber numberWithBool:YES];
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [super presentViewController:navController animated:YES completion:^{
            }];
            return [NSNumber numberWithBool:NO];
        }
    } withKey:kBottomTabBarBeforeSelectActionKey];
    
    self.tabButtonDicts = [NSArray arrayWithObjects: homeTabBtnDict, exploreTabBtnDict, saleTabBtnDict, messageTabBtnDict, mineTabBtnDict, nil];
    [self.tabBarView setButtonDicts:self.tabButtonDicts];
    
    self.tabBarView.backgroundColor = [UIColor colorWithHexString:[[SkinIconManager manager] getValue:KTabbar_Backgroud]?[[SkinIconManager manager] getValue:KTabbar_Backgroud]:@"ffffff"];  //修改tabbar 2016.4.16 Feng  //修改颜色 2016.7.7 Feng
    if ([[SkinIconManager manager] isValidWithPath:KTabbar_BackgroudImg]) {
        UIImage *imgBg = [UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTabbar_BackgroudImg]];
        self.tabBarView.image = imgBg;
        [self.tabBarView setImage:[imgBg stretchableImageWithLeftCapWidth:imgBg.size.width/2 topCapHeight:imgBg.size.height/2]];
    }
    [self.tabBarView selectTabAtIndex:0];
}

//JSPatch测试
//- (UIView *)genView
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
////    view.hidden = YES;
//    return view;
//}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self diss];
//}

-(void)pushPublishNofm{
    [self sendBuy];
    [self.overlayView dismiss];
}

-(void)pushPublishRecovery{
    [self releaseNofmBuy];
    [self.overlayView dismiss];
}

-(void)pushPublishDraft{
    WEAKSELF;
    
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkBindingStateAndPresentLoginController:self bindingAlert:@"请绑定手机号，当您错过买家的消息时，我们将会给您手机短信通知。" completion:^{ }];
    if (isLoggedIn) {
        PublishViewController *viewController = [[PublishViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        viewController.isFromDraft = YES;
        [self presentViewController:nav animated:YES completion:^{
            nil;
        }];
        
        viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
            
            [weakSelf.view addSubview:weakSelf.successBgView];
            [weakSelf.view addSubview:weakSelf.successGoodsView];
            [weakSelf.view addSubview:weakSelf.disSuccessBtn];
            
            [weakSelf.successGoodsView getGoodsEditInfo:goodsEditableInfo];
            weakSelf.successBgView.alpha = 0;
            weakSelf.successGoodsView.alpha = 0;
            weakSelf.disSuccessBtn.alpha = 0;
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.successBgView.alpha = 0.7;
                weakSelf.successGoodsView.alpha = 1;
                weakSelf.disSuccessBtn.alpha = 1;
            }];
            
            weakSelf.successBgView.dissMissBlackView = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.successGoodsView.alpha = 0;
                    weakSelf.disSuccessBtn.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.successGoodsView removeFromSuperview];
                    [weakSelf.disSuccessBtn removeFromSuperview];
                    weakSelf.successGoodsView = nil;
                    weakSelf.disSuccessBtn = nil;
                }];
            };
            
            weakSelf.successGoodsView.disSuccessGoodsView = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.successGoodsView.alpha = 0;
                    weakSelf.successBgView.alpha = 0;
                    weakSelf.disSuccessBtn.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.successGoodsView removeFromSuperview];
                    [weakSelf.successBgView removeFromSuperview];
                    [weakSelf.disSuccessBtn removeFromSuperview];
                    weakSelf.successBgView = nil;
                    weakSelf.successGoodsView = nil;
                    weakSelf.disSuccessBtn = nil;
                }];
            };
            
            weakSelf.disSuccessBtn.handleClickBlock = ^(CommandButton *sender){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.successGoodsView.alpha = 0;
                    weakSelf.successBgView.alpha = 0;
                    weakSelf.disSuccessBtn.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.successGoodsView removeFromSuperview];
                    [weakSelf.successBgView removeFromSuperview];
                    [weakSelf.disSuccessBtn removeFromSuperview];
                    weakSelf.successBgView = nil;
                    weakSelf.successGoodsView = nil;
                    weakSelf.disSuccessBtn = nil;
                }];
            };
            
        };
        
    }
    [self diss];
    [self.overlayView dismiss];
}

-(void)sendBuy{
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.url = SENDPUBLISH;
    [self pushViewController:viewController animated:YES];
    [self diss];
}

-(void)releaseRecoverBuy{
    
    [self diss];
    [ClientReportObject clientReportObjectWithViewCode:TabBarViewCode regionCode:PublishRecoveryRegionCode referPageCode:PublishRecoveryViewCode andData:nil];
    WEAKSELF;
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    
    self.cateList = nil;
    self.brandList = nil;
    
    IssueViewController *issueController = [[IssueViewController alloc] init];
    issueController.titleText = @"回收";
    issueController.releaseIndex = YES;
    [self pushViewController:issueController animated:YES];
    
//修改求回收需求   修改跳转业务
//#if DEBUG
//    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
//    typeof(viewController) __weak weakViewController = viewController;
//    //        viewController.delegate = weakSelf;
//    //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
//    //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
//    viewController.title = @"选择类别";
//    viewController.delegate = self;
//    viewController.selectableItemArray = nil;
//    if ([self.cateList count]>0) {
//        NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:self.cateList.count];
//        for (Cate *cate in self.cateList) {
//            if ([cate isKindOfClass:[Cate class]]) {
//                if ([cate.children count]>0) {
//                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
//                    NSLog(@"%@", selectableItemArray);
//                } else {
//                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:cate==self.selectedCate attatchedItem:cate]];
//                    
//                    weakViewController.isSupportSearch = YES;
//                }
//            }
//        }
//        weakViewController.selectableItemArray = selectableItemArray;
//    } else {
//        viewController.callbackBlockAfterWiewDidLoad = ^{
//            [weakViewController showProcessingHUD:nil];
//            [CategoryService getCateList:^(NSDictionary *data) {
//                [weakViewController hideHUD];
//                NSArray *cateListDicts = [data arrayValueForKey:@"list"];
//                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
//                NSMutableArray *cateList = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
//                for (NSDictionary *dict in cateListDicts) {
//                    if ([dict isKindOfClass:[NSDictionary class]]) {
//                        Cate *cate = [Cate createWithDict:dict];
//                        //一级
//                        [cateList addObject:cate];
//                        if ([cate.children count]>0) {
//                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
//                        } else {
//                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:NO attatchedItem:cate]];
//                            weakViewController.isSupportSearch = YES;
//                        }
//                    }
//                }
//                self.cateList = cateList;
//                weakViewController.selectableItemArray = selectableItemArray;
//                [weakViewController reloadData];
//            } failure:^(XMError *error) {
//                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
//            }];
//        };
//    }
//    [self.navigationController pushViewController:viewController animated:YES];
//
//#else
//    //判断用户时候发布过求回收商品，如果发布过直接跳转到报价页面
//    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getGoodsPublish:^(NSDictionary *data) {
//        
//        RecoveryGoodsPublish *goodsPublish = [[RecoveryGoodsPublish alloc] initWithJSONDictionary:data];
//        if (goodsPublish.status == 1) {
//            
//            [WCAlertView showAlertWithTitle:@"提示" message:goodsPublish.desc customizationBlock:^(WCAlertView *alertView) {
//                
//            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                if (buttonIndex == 0) {
//                    InsureViewController *insureViewController = [[InsureViewController alloc] init];
//                    insureViewController.goodsID = goodsPublish.goods_id;
//                    insureViewController.index = 1;
//                    //            insureViewController.userid = [Session sharedInstance].currentUserId;
//                    [weakSelf pushViewController:insureViewController animated:YES];
//                }
//            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//        } else if (goodsPublish.status == 0) {
//            PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
//            typeof(viewController) __weak weakViewController = viewController;
//            //        viewController.delegate = weakSelf;
//            //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
//            //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
//            viewController.title = @"选择类别";
//            viewController.delegate = self;
//            viewController.selectableItemArray = nil;
//            if ([self.cateList count]>0) {
//                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:self.cateList.count];
//                for (Cate *cate in self.cateList) {
//                    if ([cate isKindOfClass:[Cate class]]) {
//                        if ([cate.children count]>0) {
//                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
//                            NSLog(@"%@", selectableItemArray);
//                        } else {
//                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:cate==self.selectedCate attatchedItem:cate]];
//                            
//                            weakViewController.isSupportSearch = YES;
//                        }
//                    }
//                }
//                weakViewController.selectableItemArray = selectableItemArray;
//            } else {
//                viewController.callbackBlockAfterWiewDidLoad = ^{
//                    [weakViewController showProcessingHUD:nil];
//                    [CategoryService getCateList:^(NSDictionary *data) {
//                        [weakViewController hideHUD];
//                        NSArray *cateListDicts = [data arrayValueForKey:@"list"];
//                        NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
//                        NSMutableArray *cateList = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
//                        for (NSDictionary *dict in cateListDicts) {
//                            if ([dict isKindOfClass:[NSDictionary class]]) {
//                                Cate *cate = [Cate createWithDict:dict];
//                                //一级
//                                [cateList addObject:cate];
//                                if ([cate.children count]>0) {
//                                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
//                                } else {
//                                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:NO attatchedItem:cate]];
//                                    weakViewController.isSupportSearch = YES;
//                                }
//                            }
//                        }
//                        self.cateList = cateList;
//                        weakViewController.selectableItemArray = selectableItemArray;
//                        [weakViewController reloadData];
//                    } failure:^(XMError *error) {
//                        [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
//                    }];
//                };
//            }
//            [self.navigationController pushViewController:viewController animated:YES];
//        }
//        
//    } failure:^(XMError *error) {
//        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//    }]];
//#endif
}


//求回收跳转方法

- (void)publishDidSelect:(PublishSelectViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem
{

//remove防止退出时出现数组数据错乱
    if (self.brandList) {
        
        BrandInfo *brand = (BrandInfo *)selectableItem.attachedItem;
        
        self.titleStr1 = selectableItem.title;
        NSString *str = [NSString stringWithFormat:@"%@-%@", self.titleStr, self.titleStr1];
        IssueViewController *issueController = [[IssueViewController alloc] init];
        issueController.titleText = str;
        issueController.cate_id = self.cate_id;
        issueController.brand_id = brand.brandId;
        issueController.cateName = self.titleStr;
        issueController.brandName = self.titleStr1;
        issueController.releaseIndex = YES;
        [self pushViewController:issueController animated:YES];
        self.brandList = nil;
        [viewController removeFromParentViewController];
        return;
    }
    
    if ([((Cate*)selectableItem.attachedItem).children count]==0) {

        Cate *cate = (Cate *)selectableItem.attachedItem;
        self.selectedCate = cate;
        [self publishSelectBrand:self.brandList];
        self.selectedCate = nil;
        self.titleStr = cate.name;
        self.cate_id = cate.cateId;
        [viewController removeFromParentViewController];
        NSLog(@"%@", cate.name);
    }
    else {
        
        [self pulishSelectCate:((Cate*)selectableItem.attachedItem).children andTitle:selectableItem.title];
        [viewController removeFromParentViewController];
    }
}

- (void)publishSelectBrand:(NSArray*)brandList
{
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    viewController.title = @"选择品牌";
    viewController.delegate = self;
    viewController.isGroupedWithName = YES;
    viewController.isSupportSearch = YES;
    
    //add code
    viewController.isShowHeader = YES;
    
    if ([brandList count]>0) {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:brandList.count];
            for (BrandInfo *brandInfo in brandList) {
                NSString *name = @"";
                if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
                    name = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
                } else if ([brandInfo.brandEnName length]>0) {
                    name = brandInfo.brandEnName;
                } else if (brandInfo.brandName) {
                    name = brandInfo.brandName;
                }
                if ([name length]>0) {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:self.selectedBrandInfo==brandInfo attatchedItem:brandInfo]];
                }
            }
            weakViewController.selectableItemArray = selectableItemArray;
            [weakViewController reloadData];
        };
    } else {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            [weakViewController showProcessingHUD:nil];
            //_selectedCate?0:
            [BrandService getBrandList:_selectedCate.parentId completion:^(NSArray *fechtedBrandList) {
                [weakViewController hideHUD];
                NSLog(@"%ld, %ld", _selectedCate.cateId, _selectedCate.parentId);
                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:fechtedBrandList.count];
                for (BrandInfo *brandInfo in fechtedBrandList) {
                    NSString *name = @"";
                    if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
                        name = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
                    } else if ([brandInfo.brandEnName length]>0) {
                        name = brandInfo.brandEnName;
                    } else if (brandInfo.brandName) {
                        name = brandInfo.brandName;
                    }
                    if ([name length]>0) {
                        [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:self.selectedBrandInfo==brandInfo attatchedItem:brandInfo]];
                    }
                }
                self.brandList = fechtedBrandList;
                weakViewController.selectableItemArray = selectableItemArray;
                [weakViewController reloadData];
            } failure:^(XMError *error) {
                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pulishSelectCate:(NSArray*)cateList andTitle:(NSString *)title
{
    WEAKSELF;
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    //        viewController.delegate = weakSelf;
    //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
    //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
    viewController.title = title;
    viewController.delegate = weakSelf;
    viewController.selectableItemArray = nil;
    if ([cateList count]>0) {
        NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateList.count];
        for (Cate *cate in cateList) {
            if ([cate isKindOfClass:[Cate class]]) {
                if ([cate.children count]>0) {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
                    NSLog(@"%@", selectableItemArray);
                } else {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:cate==weakSelf.selectedCate attatchedItem:cate]];
                    
                    weakViewController.isSupportSearch = YES;
                }
            }
        }
        weakViewController.selectableItemArray = selectableItemArray;
    }
    else {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            [weakViewController showProcessingHUD:nil];
            [CategoryService getCateList:^(NSDictionary *data) {
                [weakViewController hideHUD];
                NSArray *cateListDicts = [data arrayValueForKey:@"list"];
                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
                NSMutableArray *cateList = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
                for (NSDictionary *dict in cateListDicts) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        Cate *cate = [Cate createWithDict:dict];
                        //一级
                        [cateList addObject:cate];
                        if ([cate.children count]>0) {
                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
                        } else {
                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:NO attatchedItem:cate]];
                            weakViewController.isSupportSearch = YES;
                        }
                    }
                }
                weakSelf.cateList = cateList;
                weakViewController.selectableItemArray = selectableItemArray;
                [weakViewController reloadData];
            } failure:^(XMError *error) {
                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    [self.navigationController pushViewController:viewController animated:YES];
}



-(void)releaseNofmBuy{
//    //临时作为求回收商品入口
//    RecoverGoodsController *recoverGoodsController = [[RecoverGoodsController alloc] init];
//    [self pushViewController:recoverGoodsController animated:YES];
//    
//    if (true) {
//        return;
//    }
    [ClientReportObject clientReportObjectWithViewCode:TabBarViewCode regionCode:PublishNormalRegionCode referPageCode:PublishNormalViewCode andData:nil];
    WEAKSELF;
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkBindingStateAndPresentLoginController:self bindingAlert:@"请绑定手机号，当您错过买家的消息时，我们将会给您手机短信通知。" completion:^{ }];
    if (isLoggedIn) {
        
//         GoodsEditableInfo *editableInfo = [[Session sharedInstance] loadPublishGoodsFromDraft];
//        if (editableInfo) {
//            self.centerBtn.hidden = NO;
//            self.blackView.hidden = NO;
//            self.publishChooseView.hidden = NO;
//            [UIView animateWithDuration:0.25 animations:^{
//                self.centerBtn.frame = CGRectMake(kScreenWidth/2-25, kScreenHeight-50, 50, 50);
//                self.blackView.alpha = 0.5;
//                self.publishChooseView.alpha = 1;
//            }];
//        }else{
            PublishViewController *publishController = [[PublishViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishController];
            [self presentViewController:nav animated:YES completion:nil];
            
            publishController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
                
                [weakSelf.view addSubview:weakSelf.successBgView];
                [weakSelf.view addSubview:weakSelf.successGoodsView];
                [weakSelf.view addSubview:weakSelf.disSuccessBtn];
                
                [weakSelf.successGoodsView getGoodsEditInfo:goodsEditableInfo];
                weakSelf.successBgView.alpha = 0;
                weakSelf.successGoodsView.alpha = 0;
                weakSelf.disSuccessBtn.alpha = 0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.successBgView.alpha = 0.7;
                    weakSelf.successGoodsView.alpha = 1;
                    weakSelf.disSuccessBtn.alpha = 1;
                }];
                
                weakSelf.successBgView.dissMissBlackView = ^(){
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.successGoodsView.alpha = 0;
                        weakSelf.disSuccessBtn.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakSelf.successGoodsView removeFromSuperview];
                        [weakSelf.disSuccessBtn removeFromSuperview];
                        weakSelf.successGoodsView = nil;
                        weakSelf.disSuccessBtn = nil;
                    }];
                };
                
                weakSelf.successGoodsView.disSuccessGoodsView = ^(){
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.successGoodsView.alpha = 0;
                        weakSelf.successBgView.alpha = 0;
                        weakSelf.disSuccessBtn.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakSelf.successGoodsView removeFromSuperview];
                        [weakSelf.successBgView removeFromSuperview];
                        [weakSelf.disSuccessBtn removeFromSuperview];
                        weakSelf.successBgView = nil;
                        weakSelf.successGoodsView = nil;
                        weakSelf.disSuccessBtn = nil;
                    }];
                };
                
                weakSelf.disSuccessBtn.handleClickBlock = ^(CommandButton *sender){
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.successGoodsView.alpha = 0;
                        weakSelf.successBgView.alpha = 0;
                        weakSelf.disSuccessBtn.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakSelf.successGoodsView removeFromSuperview];
                        [weakSelf.successBgView removeFromSuperview];
                        [weakSelf.disSuccessBtn removeFromSuperview];
                        weakSelf.successBgView = nil;
                        weakSelf.successGoodsView = nil;
                        weakSelf.disSuccessBtn = nil;
                    }];
                };
                
            };
//        }

    }
    
    [MobClick event:@"click_sell_button"];
    
    [self diss];
}

-(void)dissMissSubviews{
    
    [self diss];
}

-(void)dissMissResales{
    
//    [self.backButton removeFromSuperview];
    
    [UIView animateWithDuration:0.5 animations:^{
        _backButton.transform = CGAffineTransformIdentity;
        _backButton.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        
        self.backButton.hidden = YES;
    }];
    
//    if (kScreenWidth == 320) {
//        self.releaseNofm.frame = CGRectMake(kScreenWidth / 6 - 17, kScreenHeight - 150, 116, 80);
//        self.releaseRecover.frame = CGRectMake(kScreenWidth - (kScreenWidth / 6) * 3 + 7, kScreenHeight - 150, 116, 80);
//    } else if (kScreenWidth == 375) {
//        self.releaseNofm.frame = CGRectMake(kScreenWidth / 6 - 27.5, kScreenHeight - 179, 143.5, 95);
//        self.releaseRecover.frame = CGRectMake(kScreenWidth - (kScreenWidth / 6) * 3 + 7, kScreenHeight - 179, 143.5, 95);
//    } else {
//        self.releaseNofm.frame = CGRectMake(kScreenWidth / 6 - 17.5, kScreenHeight - 179, 143.5, 95);
//        self.releaseRecover.frame = CGRectMake(kScreenWidth - (kScreenWidth / 6) * 3 + 7, kScreenHeight - 179, 143.5, 95);
//    }
    
    self.sprangView.frame = CGRectMake(15, kScreenHeight - self.tabBarView.height - 118 + 5-10, kScreenWidth-30, 118);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.sprangView.frame = CGRectMake(15, kScreenHeight - 118 - self.tabBarView.height - 50 - 15, kScreenWidth-30, 10);
        self.sprangView.alpha = 0;
        self.assessImageView.alpha = 0;
        self.backButton.userInteractionEnabled = NO;
        
//        if (kScreenWidth == 320) {
//            self.releaseNofm.frame = CGRectMake(kScreenWidth / 6 - 17, kScreenHeight, 116, 80);
//            self.releaseRecover.frame = CGRectMake(kScreenWidth - (kScreenWidth / 6) * 3 + 7, kScreenHeight, 116, 80);
//        } else if (kScreenWidth == 375) {
//            self.releaseNofm.frame = CGRectMake(kScreenWidth / 6 - 27.5, kScreenHeight, 143.5, 95);
//            self.releaseRecover.frame = CGRectMake(kScreenWidth - (kScreenWidth / 6) * 3 + 7, kScreenHeight, 143.5, 95);
//        } else {
//                self.releaseNofm.frame = CGRectMake(kScreenWidth / 6 - 17.5, kScreenHeight, 143.5, 95);
//                self.releaseRecover.frame = CGRectMake(kScreenWidth - (kScreenWidth / 6) * 3 + 7, kScreenHeight, 143.5, 95);
//        }
        
    } completion:^(BOOL finished) {
//        if (self.releaseNofm.frame.origin.y == kScreenHeight) {
//            self.backButton.hidden = YES;
//        }
        self.backButton.userInteractionEnabled = YES;
        [self.sprangView removeFromSuperview];
        [self.assessImageView removeFromSuperview];
        self.sprangView = nil;
        [self.backView removeFromSuperview];
        self.backView = nil;
    }];
    
    
    
}

-(void)diss{
//    if (SYSTEMCURRENTV < 8.0) { //修改毛玻璃效果
        if (self.backView) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.backView.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [self.backView removeFromSuperview];
                self.backView = nil;
                
            }];
            
            [self dissMissResales];
            return;
        }
//    } else {
//        if (self.visualView) {
//            
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                self.visualView.alpha = 0;
//                
//            } completion:^(BOOL finished) {
//                
//                [self.visualView removeFromSuperview];
//                self.visualView = nil;
//                
//            }];
//            
//            [self dissMissResales];
//            return;
//        }
//    }
    
}

//-(void)setAnimationImages:(NSMutableArray*)arr{
//    
//}

-(void)catapultOptionView{

// 图片动画
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 85, 85)];
//    if (!imageView.isAnimating) {
//        NSMutableArray *arr = [[NSMutableArray alloc] init];
//        for (int i = 0; i < 48; i++) {
//            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"XMLID_%d", i]]];
//        }
//        imageView.animationImages = arr;
//        imageView.animationDuration = 48*0.055;
//        imageView.animationRepeatCount = 1;
//        [imageView setImage:[UIImage imageNamed:@"XMLID_48"]];
//        [imageView startAnimating];
//        [self.view addSubview:imageView];
//        
//        [imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:imageView.animationDuration];
//    }
/*********************************************************************************************************************************************************/
    
    
/*********************************************************************************************************************************************************/
//缓存 第一次启动提示。。。
//    if ([GuideView isNeedShowText]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"kText"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"222`" message:@"11" delegate:self cancelButtonTitle:@"111" otherButtonTitles:nil, nil];
//        [alert show];
//    }

    
/*********************************************************************************************************************************************************/
//指纹
//    WEAKSELF;
//    LAContext *context = [[LAContext alloc] init];
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
//        NSLog(@"支持");
//        // 输入指纹，异步
//        // 提示：指纹识别只是判断当前用户是否是手机的主人！程序原本的逻辑不会受到任何的干扰！
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登录" reply:^(BOOL success, NSError *error) {
//            NSLog(@"%d %@", success, error);
//            
//            if (success) {
//                // 登录成功
//                // TODO
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf clickCatapultOptionView];
//                });
//                
//            } else {
//                return ;
//            }
//        }];
//        
//        NSLog(@"come here");
//    } else {
//        NSLog(@"不支持");
//    }

/*********************************************************************************************************************************************************/
//朋友圈多图
//    WEAKSELF;
//    [self showProcessingHUD:@""];
//    NSArray *array_photo = @[@"http://img.meifajia.com/o1aneipt09eCl5bqQp4ifbQdTHlKIJfq.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneipt2fbZm38Zct4DH92p-ez7-fXt.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneiocd24Y6jK8uQA8-8y-47H6vRe7.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneiocdd94h6ld4kQJh8PcpjGSkORS.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneiocdd94h6ld4kQJh8PcpjGSkORS.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneipt09eCl5bqQp4ifbQdTHlKIJfq.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneioccpacV1LVg2AfG9fbYl8zN1So.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneipt0haf1zwepSkxx9okI0W34t05.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneipt09eCl5bqQp4ifbQdTHlKIJfq.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneipt09eCl5bqQp4ifbQdTHlKIJfq.jpg?imageView2/1/w/360/h/480/q/85",
//                             @"http://img.meifajia.com/o1aneipt09eCl5bqQp4ifbQdTHlKIJfq.jpg?imageView2/1/w/360/h/480/q/85"];
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    for (int i = 0; i <8 && i<array_photo.count; i++) {
//        NSString *URL = array_photo[i];
//        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
//        UIImage *imagerang = [UIImage imageWithData:data];
//        NSString *path_sandox = NSHomeDirectory();
//        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
//        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
//        NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
//        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在调起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
//        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
//        [array addObject:item];
//    }
//    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:array
//                                                                                        applicationActivities:nil];
//    //尽量不显示其他分享的选项内容
//    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
//    
//    if (activityViewController) {
//        [self presentViewController:activityViewController animated:TRUE completion:^{
//            [weakSelf hideHUD];
//        }];
//    }
/*********************************************************************************************************************************************************/
    
    //老的发布样式
    //[self clickCatapultOptionView];
    
    //修改发布模式仿咸鱼
    [self clickRotateButtonOverlayView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.releaseNofm layoutSubviews];
    [self.releaseRecover layoutSubviews];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.tabBarView layoutSubviews];
}


- (void)clickRotateButtonOverlayView{
    RXRotateButtonOverlayView* overlayView = [[RXRotateButtonOverlayView alloc] init];//[[RXRotateButtonOverlayView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    GoodsEditableInfo *editableInfo = [[Session sharedInstance] loadPublishGoodsFromDraft];
    if (editableInfo) {
        [overlayView setTitles:@[@"寄卖",@"自己卖",@"草稿箱"]];
        [overlayView setTitleImages:@[@"new_send_sold_publish",@"new_sold_self_publish",@"new_draft_publish"]];
        [overlayView setSubTitles:@[@"更多曝光、更省心",@"定价自由、更自主",@"上次未发布的"]];
    } else {
        [overlayView setTitles:@[@"寄卖",@"自己卖"]];
        [overlayView setTitleImages:@[@"new_send_sold_publish",@"new_sold_self_publish"]];
        [overlayView setSubTitles:@[@"更多曝光、更省心",@"定价自由、更自主"]];
    }
    
    [overlayView setDelegate:self];
    [overlayView setFrame:self.view.bounds];
    [self.view addSubview:overlayView];
    _overlayView = overlayView;
    [overlayView show];
}


-(void)clickCatapultOptionView{
    
    if (self.backView || self.visualView) {
        [self diss];
    }
    WEAKSELF;
    [self.view addSubview:self.backButton];
    BlackView *view = [[BlackView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.backView = view;
    [self.view addSubview:self.backView];
    [self.view addSubview:self.sprangView];
    [self.view addSubview:self.assessImageView];

    self.assessImageView.frame = CGRectMake((kScreenWidth - _assessImageView.image.size.width)/2, 105, _assessImageView.image.size.width, _assessImageView.image.size.height);
    self.assessImageView.alpha = 0;
    self.assessImageView.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
        AssessViewController * viewController = [[AssessViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
        [weakSelf dissMissResales];
    };
    
    self.sprangView.frame = CGRectMake(15, kScreenHeight - 30 - 15, kScreenWidth-30, 0);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.sprangView.frame = CGRectMake(15, kScreenHeight - self.tabBarView.height - 118 + 5-10, kScreenWidth-30, 118);
        self.sprangView.alpha = 1;
        self.assessImageView.alpha = 1;
        self.backButton.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.backButton.userInteractionEnabled = YES;
    }];
    
    if (kScreenWidth == 414) {
        self.backButton.frame = CGRectMake(kScreenWidth / 2 - 43/2, kScreenHeight - 51, 43, 43);
    } else {
        self.backButton.frame = CGRectMake(kScreenWidth / 2 - 43/2, kScreenHeight - 47, 43, 43);
    }
    [self.view bringSubviewToFront:self.backButton];
    self.backButton.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _backButton.transform = CGAffineTransformIdentity;
        //适配iOS7.0
        if ([[UIDevice currentDevice] systemVersion].doubleValue >= 7.0 && [[UIDevice currentDevice] systemVersion].doubleValue < 8.0) {
            _backButton.transform = CGAffineTransformMakeRotation([[SkinIconManager manager] getTabbarType] ? 0 : M_PI_2);
        } else {
            _backButton.transform = CGAffineTransformMakeRotation([[SkinIconManager manager] getTabbarType] ? 0 : M_PI_2+M_PI_2*0.5);
        }
    }];
}

- (void)didEnterBackgroundNotification:(NSNotification *)notifi
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
}

- (void)didBecomeActiveNotification:(NSNotification *)notifi
{
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf restMsgButtonCount:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc
{
   // [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dissMissResales" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadView" object:nil];
}

//#pragma mark - private
//
//-(void)registerNotifications
//{
//    [self unregisterNotifications];
//    
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
//}
//
//-(void)unregisterNotifications
//{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].callManager removeDelegate:self];
//}

- (void)setSelectedAtIndex:(NSInteger)selectedIndex
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBarView selectTabAtIndex:selectedIndex];
        
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
//            UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
//            if (notificationSettings.types == UIUserNotificationTypeNone) {
//                if (![RemindOpenNotifiViewController hasRemindOpenAdmSysNotifi]) {
//                    RemindOpenNotifiViewController *viewController = [[RemindOpenNotifiViewController alloc] init];
//                    [[CoordinatingController sharedInstance] presentViewController:viewController animated:NO completion:nil];
//                }
//            }
//        } else {
//            UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//            if (type == UIRemoteNotificationTypeNone) {
//                if (![RemindOpenNotifiViewController hasRemindOpenAdmSysNotifi]) {
//                    RemindOpenNotifiViewController *viewController = [[RemindOpenNotifiViewController alloc] init];
//                    [[CoordinatingController sharedInstance] presentViewController:viewController animated:NO completion:nil];
//                }
//            }
//        }
    });
}

- (void)setHidesTabBarWithAnimated:(BOOL)hidesTabBar
{
    if (_hidesTabBarWithAnimated != hidesTabBar) {
        _hidesTabBarWithAnimated = hidesTabBar;
        
        if (hidesTabBar) {
            [self hideTabBar:YES];
        } else {
            [self showTabBar:YES];
        }
    }
}

- (void)hideTabBar:(BOOL)animated
{
    if (_tabBarView.frame.origin.y == self.view.frame.size.height+(_tabBarView.realHeight-_tabBarView.bounds.size.height)) {
        return;
    }
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        _tabBarView.frame = CGRectMake(_tabBarView.frame.origin.x, _tabBarView.frame.origin.y+_tabBarView.realHeight, _tabBarView.frame.size.width, _tabBarView.frame.size.height);
        [UIView commitAnimations];
    } else {
        _tabBarView.frame = CGRectMake(_tabBarView.frame.origin.x, _tabBarView.frame.origin.y+_tabBarView.realHeight, _tabBarView.frame.size.width, _tabBarView.frame.size.height);
    }
}

- (void)showTabBar:(BOOL)animated
{
    if (_tabBarView.frame.origin.y == self.view.frame.size.height - _tabBarView.bounds.size.height) {
        return;
    }
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        _tabBarView.frame = CGRectMake(_tabBarView.frame.origin.x, _tabBarView.frame.origin.y-_tabBarView.realHeight, _tabBarView.frame.size.width, _tabBarView.frame.size.height);
        [UIView commitAnimations];
        
    } else {
        _tabBarView.frame = CGRectMake(_tabBarView.frame.origin.x, _tabBarView.frame.origin.y-_tabBarView.realHeight, _tabBarView.frame.size.width, _tabBarView.frame.size.height);
    }
}

#pragma mark - Private methods
- (void)displayViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    
    if ([[_viewControllers objectAtIndex:index] isKindOfClass:[UIViewController class]])
    {
        if (_selectedIndex != index)
        {
            NSLog(@"%ld", (long)index);
            if (index == 0) {
                NSLog(@"11");
                [ClientReportObject clientReportObjectWithViewCode:TabBarViewCode regionCode:HomeRegionCode referPageCode:HomeViewCode andData:nil];
            } else if (index == 1) {
                [ClientReportObject clientReportObjectWithViewCode:TabBarViewCode regionCode:CatHouseRegionCode referPageCode:CatHouseViewCode andData:nil];
            } else if (index == 3) {
                [ClientReportObject clientReportObjectWithViewCode:TabBarViewCode regionCode:MessageRegionCode referPageCode:MessageViewCode andData:nil];
            } else if (index == 4) {
                [ClientReportObject clientReportObjectWithViewCode:TabBarViewCode regionCode:MineRegionCode referPageCode:MineViewCode andData:nil];
            }
            
            UIViewController *targetViewController = [_viewControllers objectAtIndex:index];
            targetViewController.view.hidden = NO;
            targetViewController.view.frame = _transitionView.bounds;
            
            if (_viewControllers && _viewControllers.count) {
                for (UIViewController *viewController in _viewControllers) {
                    [viewController willMoveToParentViewController:nil];
                    [viewController.view removeFromSuperview];
                    [viewController removeFromParentViewController];
                }
            }
            
//            NSArray *subviews = [_transitionView subviews];
//            for (UIView *view in subviews) {
//                [view removeFromSuperview];
//            }
            
            if ([targetViewController.view isDescendantOfView:_transitionView])
            {
                [_transitionView bringSubviewToFront:targetViewController.view];
            }
            else
            {
                //
                targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//                [_transitionView addSubview:targetViewController.view];
                
                [self addChildViewController:targetViewController];
                [_transitionView addSubview:[targetViewController view]];
                [targetViewController didMoveToParentViewController:self];
            }
        }
    }
}

//
#pragma mark -
#pragma mark tabBar delegates
- (BOOL)tabBarView:(TabBarView *)tabBar beforeSelectAtIndex:(NSInteger)index selectedMethod:(TabBarButtonSelectedMethod)selectedMethod
{
    BOOL isContinue = YES;
    if (index >= 0 && index < [self.tabButtonDicts count]) {
        if ([[self.tabButtonDicts objectAtIndex:index] isKindOfClass:[NSMutableDictionary class]]) {
            id ret = [[self.tabButtonDicts objectAtIndex:index] doAction:kBottomTabBarBeforeSelectActionKey];
            if (ret!=nil&&[ret isKindOfClass:[NSNumber class]]) {
                isContinue = [ret boolValue];
            }
        }
    }
    return isContinue;//[isContinue boolValue];
}

- (void)tabBarView:(TabBarView *)tabBar didSelectAtIndex:(NSInteger)index selectedMethod:(TabBarButtonSelectedMethod)selectedMethod
{
    if (self.backView) {
        
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            self.backView.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            
//            [self.backView removeFromSuperview];
//            
//        }];
//        [self dissMissResales];
        [self diss];
    }
    
    if (index >= 0 && index < [self.tabButtonDicts count]) {
        if ([[self.tabButtonDicts objectAtIndex:index] isKindOfClass:[NSMutableDictionary class]]) {
            [[self.tabButtonDicts objectAtIndex:index] doActionWithParameters:[NSNumber numberWithInteger:index]];
        }
    }
}

#pragma mark -

- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    [self setSelectedAtIndex:0];
    [self restMsgButtonCount:0];
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    if ([[CoordinatingController sharedInstance].visibleController isKindOfClass:[MineViewController class]]) {
        
                    LoginViewController *viewController = [[LoginViewController alloc] init];
//        CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];

        UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
        [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
        }];
        [self setSelectedAtIndex:0];
    } else {
        if (![[CoordinatingController sharedInstance].visibleController isKindOfClass:[LoginViewController class]]) {
            LoginViewController *viewController = [[LoginViewController alloc] init];
//            CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
            }];
        }
    }
}

- (UIView*)HUDForView {
    UIView *forView = nil;
    if ([_transitionView subviews].count >0) {
        UIView *view = [[_transitionView subviews] objectAtIndex:[_transitionView subviews].count-1];
        UIViewController *viewController = [[self class] findViewController:view];
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController*)viewController).visibleViewController;
        }
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            forView = ((BaseViewController*)viewController).HUDForView;
        }
    }
    return forView;
}

+ (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

- (UIViewController*)visibleController {
    UIView *view = [[_transitionView subviews] objectAtIndex:[_transitionView subviews].count-1];
    UIViewController *viewController = [[self class] findViewController:view];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = ((UINavigationController*)viewController).visibleViewController;
    }
    return viewController;
}

- (void)$$handleNoticeCountDidFinishNotification:(id<MBNotification>)notifi noticeCount:(NSNumber*)noticeCount
{
    [self restMsgButtonCount:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
}

- (void)$$handleChatMsgCountDidFinishNotification:(id<MBNotification>)notifi chatMsgCount:(NSNumber*)chatMsgCount
{
    [self restMsgButtonCount:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
}

- (void)restMsgButtonCount:(NSInteger)msgCount {
    NSArray *buttonArray = [_tabBarView tabBarButtonArray];
    if ([buttonArray count] > 3) {
        TabBarButton *btn = (TabBarButton*)[buttonArray objectAtIndex:3];
        [btn resetNumOfNotifications:msgCount];
    }
}

@end

//aidingmao://goodsId:
//aidingmao://goodsList?tag:




