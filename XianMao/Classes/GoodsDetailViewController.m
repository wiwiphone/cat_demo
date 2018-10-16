//
//  GoodsDetailViewController.m
//  XianMao
//
//  Created by simon cai on 11/8/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsDetailViewController.h"

#import "PullRefreshTableView.h"
#import "C2CGoodsDetailViewController.h"
#import "GoodsGradeexPlainView.h"
#import "GoodsTableViewCell.h"

#import "GoodsDetailBottomTagsCell.h"
#import "SepTableViewCell.h"
#import "GoodsDetailPictureCell.h"
#import "GoodsAttributesCell.h"
#import "CommentTableViewCell.h"
#import "SellerInfoTableViewCell.h"
#import "LikedUsersTableViewCell.h"
#import "GoodsDetailTableViewCell.h"
#import "ImageDescTableViewCell.h"
#import "GoodsDetailStoryCell.h"
#import "ServiceTagCell.h"
#import "DataSources.h"
#import "UIColor+Expanded.h"
#import "NSDictionary+Additions.h"

#import "ShoppingCartViewController.h"

#import "CoordinatingController.h"

#import "TabIndicatorView.h"
#import "ServiceIconCell.h"
#import "GoodsInfo.h"
#import "GoodsDetailInfo.h"
#import "CommentTableViewCell.h"

#import "NetworkAPI.h"
#import "Error.h"

#import "GoodsMemCache.h"

#import "Session.h"

#import "Command.h"

#import "GoodsPhotoBrowser.h"

#import "ShoppingCartItem.h"

#import "ASScroll.h"
#import "MJPhoto.h"
#import "LoginViewController.h"
#import "MJPhotoBrowser.h"

#import "PayViewController.h"

#import "BoughtCollectionViewController.h"
#import "BoughtViewController.h"
#import "GoodsStatusMaskView.h"

#import "ParallaxHeaderView.h"

#import "URLScheme.h"

#import "ActivityInfo.h"

#import "NSString+Addtions.h"

#import "GuideView.h"

#import "GoodsService.h"
#import "RecommendTableViewCell.h"

#import "GoodsCommentsViewController.h"
#import "PagesContainerView.h"

#import "SearchViewController.h"
#import "GoodsService.h"

#import "WebViewController.h"
#import "WCAlertView.h"
#import "MCFireworksView.h"
#import "MCFireworksButton.h"
#import "GoodsDetailSelfEngageCell.h"
#import "GoodsBrandCell.h"

#import "AdviserPage.h"
#import "AddBagView.h"
#import "Masonry.h"
#import "BlackView.h"
#import "GoodsGuarantee.h"
#import "WristwatchRecoveryCell.h"
#import "WristwatchRecoveryDetailCell.h"
#import "WristView.h"

#import "WristInviteView.h"
#import "BuyBackCell.h"
#import "PayViewController.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "InformationViewController.h"
#import "AboutViewController.h"
#import "ExpectedDeliveryCell.h"
#import "GoodsAboutCell.h"
#import "InformationViewController.h"
#import "ADMShoppingCentreViewController.h"
#import "DeliveryExplainCell.h"
#import "GoodsAboutDescCell.h"
#import "WeixinCopyCell.h"
#import "BeuseQuanGoodsCell.h"
#import "GoodsPictureCell.h"
#import "GoodsTotalInfCell.h"
#import "HeaderChooseView.h"
#import "IdleBannerTableViewCell.h"

#define GoodsDetailheaderViewHeight kScreenWidth/375*420

@interface GoodsDetailViewControllerContainer () <PagesContainerViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,retain) UIView *transitionView;
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,assign) NSInteger selectedIndex;

@property(nonatomic,weak) UIButton *goodsNumLbl;
@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, weak) UIButton *backBtn;

@end

@implementation GoodsDetailViewControllerContainer


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topbarShadowHeight = 2.f;
    
    
    //    PagesContainerView *pagesContainerView = [[PagesContainerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    //
    //    _pagesContainerView = pagesContainerView;
    //    _pagesContainerView.backgroundColor = [UIColor whiteColor];
    //    UIImage *img = [UIImage imageNamed:@"titlebar_bg"];
    //    _pagesContainerView.topBarHeight = kTopBarHeight;
    //    _pagesContainerView.topBarShadowHeight = topbarShadowHeight;
    //    _pagesContainerView.topBar.contentMarginTop = kTopBarContentMarginTop;
    //    _pagesContainerView.topBar.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    //    _pagesContainerView.pageIndicatorView.hidden = NO;
    //    _pagesContainerView.topBarBackgroundColor = [UIColor clearColor];
    //    _pagesContainerView.pageIndicatorColor = [UIColor colorWithHexString:@"e2bb66"];
    //    _pagesContainerView.pageIndicatorViewSize = CGSizeMake(38, 2);
    //    _pagesContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    _pagesContainerView.delegate = self;
    //    _pagesContainerView.contentMarginTop = -(kTopBarHeight-topbarShadowHeight);
    //    [self.view addSubview:_pagesContainerView];
    //
    ////    _pagesContainerView.topBar.scrollView.userInteractionEnabled = NO;
    ////    _pagesContainerView.topBar.hidden = YES;
    //
    //    _pagesContainerView.topBar.scrollView.userInteractionEnabled = YES;
    //    _pagesContainerView.topBar.alpha = 0.f;
    //    _pagesContainerView.pageIndicatorView.alpha =0.f;
    ////    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTopBar:)];
    ////    [_pagesContainerView.topBar.scrollView addGestureRecognizer:tapGesture];
    ////    [_pagesContainerView.topBar addGestureRecognizer:tapGesture];
    //
    GoodsDetailViewController *detailViewController = [[GoodsDetailViewController alloc] init];
    detailViewController.goodsId = self.goodsId;
    detailViewController.controllerContainer = self;
    detailViewController.title = @"商品";
    
    
    C2CGoodsDetailViewController *c2cController = [[C2CGoodsDetailViewController alloc] init];
    c2cController.goodsId = self.goodsId;
    
    
    //    GoodsCommentsViewController *commentsViewController = [[GoodsCommentsViewController alloc] init];
    //    commentsViewController.goodsId = self.goodsId;
    //    commentsViewController.title = @"评论";
    //
    //    self.pagesContainerView.viewControllers =  @[detailViewController, commentsViewController];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [[MyNavigationController alloc] initWithRootViewController:detailViewController],
                            [[MyNavigationController alloc] initWithRootViewController:c2cController],
                            nil];
    
    self.transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.transitionView.backgroundColor = [UIColor whiteColor];
    self.transitionView.autoresizesSubviews = YES;
    [self.view addSubview:self.transitionView];
    
    
    //    [self setupTopBar];
    
    //    CGFloat topBarHeight = 0;
    
    //    self.topBar.alpha = 0.f;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 25, 25)];
    backBtn.layer.cornerRadius = 16.f;
    backBtn.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [backBtn addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"Back_Promrt_MF"] forState:UIControlStateNormal];
    backBtn.tag = 1000;
    [self.view addSubview:backBtn];
    _backBtn = backBtn;
    
    TapDetectingView *backBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, backBtn.top-(62-backBtn.height)/2, 62, 62)];
    backBgView.backgroundColor = [UIColor clearColor];
    backBgView.tag = 1001;
    [self.view addSubview:backBgView];
    
    WEAKSELF;
    backBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [weakSelf handleTopBarBackButtonClicked:nil];
    };
    
    //    CGFloat width = kScreenWidth*32/320;
    
    //    UIButton *shoppingCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-12-32, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 32, 32)];
    //    shoppingCartBtn.layer.cornerRadius = 16.f;
    //    shoppingCartBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    //    [shoppingCartBtn addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [shoppingCartBtn setImage:[UIImage imageNamed:@"shopping_cart"] forState:UIControlStateNormal];
    //    [self.view addSubview:shoppingCartBtn];
    //    shoppingCartBtn.tag = 101;
    
    //    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    //    [self.view addSubview:goodsNumLbl];
    //    _goodsNumLbl = goodsNumLbl;
    
    //    TapDetectingView *shoppingCartBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(self.view.width-57, shoppingCartBtn.top-(57-backBtn.height)/2, 57, 57)];
    //    shoppingCartBgView.backgroundColor = [UIColor clearColor];
    //    shoppingCartBgView.tag = 102;
    //    [self.view addSubview:shoppingCartBgView];
    //    shoppingCartBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
    //        [weakSelf handleTopBarRightButtonClicked:nil];
    //    };
    
    
    //    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-12-32-15-32, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 32, 32)];
    //    shareBtn.layer.masksToBounds = YES;
    //    shareBtn.layer.cornerRadius = 16.f;
    //    shareBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    //    [shareBtn setImage:[UIImage imageNamed:@"goods_detail_share"] forState:UIControlStateNormal];
    //    [self.view addSubview:shareBtn];
    //    shareBtn.tag = 110;
    
    //    TapDetectingView *shareBtnBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(self.view.width-12-32-18-32-10, shareBtn.top-(57-shareBtn.height)/2, 57, 57)];
    //    shareBtnBgView.backgroundColor = [UIColor clearColor];
    //    shareBtnBgView.tag = 111;
    //    [self.view addSubview:shareBtnBgView];
    //    shareBtnBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
    //        [weakSelf shareGoods];
    //    };
    //
    //
    //    //    ParallaxHeaderView *parallaxHeaderView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [GoodsDetailHeaderView heightForOrientationPortrait:nil])];
    //    //    GoodsDetailHeaderView *headerView = [[GoodsDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [GoodsDetailHeaderView heightForOrientationPortrait:nil])];
    //    //    parallaxHeaderView.headerView = headerView;
    //    //    headerView.backgroundColor = [UIColor whiteColor];
    //    //    self.tableView.tableHeaderView = parallaxHeaderView;
    //
    //    UIImageView *bottomView = [self buildBottomView];
    //    bottomView.frame = CGRectMake(0, self.view.bounds.size.height-kBottomBarHeight, self.view.bounds.size.width, bottomView.height);
    //    [self.view addSubview:bottomView];
    //    _bottomView = bottomView;
    //
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    //
    //
    //    if (!self.detailInfo) {
    //        [self showLoadingView];
    //        if ([self.goodsId length]>0) {
    //            [self reloadData];
    //        } else {
    //            [self loadEndWithNoContent:@"该商品已不存在"];
    //        }
    //    } else {
    //        WEAKSELF;
    //        [weakSelf updateHeaderViewWithGoodsDetail:self.detailInfo];
    //        [weakSelf updateBottomViewWithGoodsInfo:self.detailInfo.goodsInfo];
    //        [weakSelf updateTableView];
    //    }
    //
    //
    //    //    if ([self.goodsId length]>0) {
    //    //        [[NetworkAPI sharedInstance] statForGoods:self.goodsId completion:nil failure:nil];
    //    //    }
    //
    //    [self bringTopBarToTop];
    
    //    _pagesContainerView.scrollView.bounces = NO;
    //    [_pagesContainerView.scrollView setScrollEnabled:NO];
    
    _selectedIndex = -1;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getGoodsDetail:self.goodsId completion:^(GoodsDetailInfo *goodsInfo) {
        [weakSelf hideLoadingView];
        if ([goodsInfo.goodsInfo.seller isB2CGoods] ||
            [goodsInfo.goodsInfo.seller isMeowGoods]) {
            [self displayViewControllerAtIndex:0 animated:NO];
            return ;
        }else if([goodsInfo.goodsInfo.seller isC2CGoods]){
            [self displayViewControllerAtIndex:1 animated:NO];
            return;
        } else {
            [self displayViewControllerAtIndex:1 animated:NO];
        }
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
    //    [self displayViewControllerAtIndex:1 animated:NO];
    self.goodsNumLbl.hidden = YES;
}

//- (CGFloat)setupTopBar {
//    CGFloat height = [super setupTopBar];
//
//    WEAKSELF;
//    if (![self.topBar viewWithTag:10222]) {
//        NSArray *tabBtnTitles = [NSArray arrayWithObjects:@"商品",@"评论", nil];
//        GoodsDetailTopBarIndicatorView *tabBar = [[GoodsDetailTopBarIndicatorView alloc] initWithFrame:CGRectMake(110, kTopBarContentMarginTop, kScreenWidth-220, self.topBarHeight-kTopBarContentMarginTop)tabBtnTitles:tabBtnTitles];
//        //    _tabBar = tabBar;
//        tabBar.tag = 10222;
//        [self.topBar addSubview:tabBar];
//        [tabBar setTabAtIndex:0 animated:NO];
//        tabBar.didSelectAtIndex = ^(NSInteger index) {
//
//        };
//        tabBar.beforeSelectAtIndex = ^(NSInteger index) {
//            [weakSelf displayViewControllerAtIndex:index animated:YES];
//        };
//    }
//
//    return height;
//}

//- (void)setViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated {
//    GoodsDetailTopBarIndicatorView *tabBar = (GoodsDetailTopBarIndicatorView*)[super.topBar viewWithTag:10222];;
//    tabBar.tag = 10222;
//    [tabBar setTabAtIndex:1 animated:animated];
//    _selectedIndex = index;
//}

#pragma mark - Private methods
- (void)displayViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    
    if (_selectedIndex != index)
    {
        if (animated) {
            CGRect targetBeginRect = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
            if (index<_selectedIndex) {
                targetBeginRect = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
            }
            CGRect currentEndRect = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
            if (index<_selectedIndex) {
                currentEndRect = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
            }
            
            UIViewController *currentViewController = [_viewControllers objectAtIndex:_selectedIndex];
            
            UIViewController *targetViewController = [_viewControllers objectAtIndex:index];
            targetViewController.view.hidden = NO;
            
            if ([targetViewController.view isDescendantOfView:_transitionView]) {
                targetViewController.view.frame = targetBeginRect;
                [_transitionView bringSubviewToFront:targetViewController.view];
            } else {
                //
                targetViewController.view.frame = targetBeginRect;
                targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [_transitionView addSubview:targetViewController.view];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                targetViewController.view.frame = _transitionView.bounds;
                currentViewController.view.frame = currentEndRect;
            } completion:^(BOOL finished) {
                targetViewController.view.frame = _transitionView.bounds;
                currentViewController.view.frame = currentEndRect;
                [currentViewController.view removeFromSuperview];
                _selectedIndex = index;
            }];
        } else
        {
            UIViewController *targetViewController = [_viewControllers objectAtIndex:index];
            targetViewController.view.hidden = NO;
            targetViewController.view.frame = _transitionView.bounds;
            
            NSArray *subviews = [_transitionView subviews];
            for (UIView *view in subviews) {
                [view removeFromSuperview];
            }
            
            if ([targetViewController.view isDescendantOfView:_transitionView])
            {
                [_transitionView bringSubviewToFront:targetViewController.view];
            }
            else
            {
                //
                targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [_transitionView addSubview:targetViewController.view];
            }
            _selectedIndex = 0;
        }
    }
}

- (void)bringTopBarToTop
{
    [super bringTopBarToTop];
    
    UIView *backBtn = [self.view viewWithTag:1000];
    UIView *backBgView = [self.view viewWithTag:1001];
    UIView *shoppingCartBtn = [self.view viewWithTag:101];
    UIView *shoppingCartBgView = [self.view viewWithTag:102];
    UIView *shareBtn = [self.view viewWithTag:110];
    UIView *shareBtnBgView = [self.view viewWithTag:111];
    [self.view bringSubviewToFront:backBtn];
    [self.view bringSubviewToFront:backBgView];
    [self.view bringSubviewToFront:shoppingCartBtn];
    [self.view bringSubviewToFront:shoppingCartBgView];
    [self.view bringSubviewToFront:shareBtn];
    [self.view bringSubviewToFront:shareBtnBgView];
    [self.view bringSubviewToFront:self.goodsNumLbl];
}

- (UIButton*)buildGoodsNumLbl
{
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    [goodsNumLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    goodsNumLbl.enabled = NO;
    goodsNumLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    goodsNumLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
    return goodsNumLbl;
}

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    if (goodsNum > 0) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            CGFloat goodsNumLblWidth = size.width+8;
            CGFloat goodsNumLblHeight = 13.f;
            UIView *shoppingCartBtn = [self.view viewWithTag:101];
            self.goodsNumLbl.frame = CGRectMake(shoppingCartBtn.right-4, kTopBarContentMarginTop+6, goodsNumLblWidth, goodsNumLblHeight);
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            CGFloat goodsNumLblWidth = size.width+8;
            CGFloat goodsNumLblHeight = 13.f;
            UIView *shoppingCartBtn = [self.view viewWithTag:101];
            self.goodsNumLbl.frame = CGRectMake(shoppingCartBtn.right-4, kTopBarContentMarginTop+6, goodsNumLblWidth, goodsNumLblHeight);
            _goodsNumLbl.hidden = NO;
        }
        
    } else {
        [_goodsNumLbl setTitle:@"" forState:UIControlStateDisabled];
        _goodsNumLbl.hidden = YES;
    }
}

- (void)shareGoods
{
    WEAKSELF;
    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
    if (goodsInfo) {
        NSString *_shareImageUrl = goodsInfo.mainPicUrl;
        if ([_shareImageUrl mag_isEmpty] && goodsInfo.gallaryItems && [goodsInfo.gallaryItems count] >0) {
            _shareImageUrl = ((GoodsGallaryItem *)[goodsInfo.gallaryItems objectAtIndex:0]).picUrl;
        }
        
        UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                               [SDWebImageManager lw_cacheKeyForURL:
                                [NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale480x480]]]];
        
        
        if (shareImage == nil) {
            shareImage = [weakSelf getImageFromURL:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale200x200]];
        }
        
        [[CoordinatingController sharedInstance] shareWithTitle:@"来自爱丁猫的分享"
                                                          image:shareImage
                                                            url:kURLGoodsDetailFormat(goodsInfo.goodsId)
                                                        content:goodsInfo.goodsName];
        
        [MobClick event:@"click_share_from_detail"];
        
        weakSelf.request = [[NetworkAPI sharedInstance] shareGoodsWith:weakSelf.goodsId completion:^(int shareNum) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
                if (goodsInfo) {
                    goodsInfo.stat.shareNum = shareNum;
                }
                MBGlobalSendGoodsInfoChangedNotification(0,weakSelf.goodsId);
            });
            _$hideHUD();
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    if (isLoggedIn) {
        [MobClick event:@"click_shopping_chart_from_detail"];
        
        if ([self.navigationController.viewControllers count]>1) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
            if ([viewController isKindOfClass:[ShoppingCartViewController class]]) {
                [self dismiss];
                return;
            }
        }
        ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }
}

- (void)scrollViewDidScrollFromGoodsDetail:(UIScrollView *)scrollView {
    //    [_tableView scrollViewDidScroll:scrollView];
    
    //    if (scrollView == _tableView
    //        && [self.tableView.tableHeaderView isKindOfClass:[ParallaxHeaderView class]])
    //    {
    //        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
    //        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    //    }
    //
    UIView *backBtn = [self.view viewWithTag:1000];
    UIView *shoppingCartBtn = [self.view viewWithTag:101];
    UIView *shareBtn = [self.view viewWithTag:110];
    
    CGFloat currentPosition = scrollView.contentOffset.y;
    if (currentPosition<=20) {
        //        self.topBar.alpha = 0.f;
        //        _pagesContainerView.topBar.alpha = 0.f;
        //        _pagesContainerView.pageIndicatorView.alpha = 0.f;
        
        UIColor *bgColor = [UIColor clearColor];[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        backBtn.backgroundColor = bgColor;
        
        shoppingCartBtn.backgroundColor = bgColor;
        shareBtn.backgroundColor = bgColor;
    } else {
        if (currentPosition>=200.f) {
            //            self.topBar.alpha = 1.f;
            //            _pagesContainerView.topBar.alpha = 1.f;
            //            _pagesContainerView.pageIndicatorView.alpha = 1.f;
            
            UIColor *bgColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            backBtn.backgroundColor = bgColor;
            shoppingCartBtn.backgroundColor = bgColor;
            shareBtn.backgroundColor = bgColor;
        } else {
            //            self.topBar.alpha = currentPosition/200.f;
            //            _pagesContainerView.topBar.alpha = currentPosition/200.f;
            //            _pagesContainerView.pageIndicatorView.alpha =currentPosition/200.f;
            
            UIColor *bgColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f*(1.f-currentPosition/200.f)];
            backBtn.backgroundColor = bgColor;
            shoppingCartBtn.backgroundColor = bgColor;
            shareBtn.backgroundColor = bgColor;
        }
    }
    
    if (scrollView.contentOffset.y >= kScreenWidth) {
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 1;
            
        }];
        [_backBtn setImage:[UIImage imageNamed:@"Back_Promrt_MF"] forState:UIControlStateNormal];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 0;
        }];
        [_backBtn setImage:[UIImage imageNamed:@"Back_Promrt_MF"] forState:UIControlStateNormal];
    }
    
    //    [_backBtn setImage:[UIImage imageNamed:@"backBtnTwo-MF"] forState:UIControlStateNormal];
    
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}

- (void)$$handleShoppingCartSyncFinishedNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi addedItem:(ShoppingCartItem*)item
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi removedGoodsIds:(NSArray*)goodsIds
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

@end


#import "ForumAttachView.h"
#import "ForumInputToolBar.h"
#import "TagsExplanView.h"
#import "PicSuccess.h"
#import "SYFireworksView.h"
#import "SYFireworksButton.h"
#import "ParabolaTool.h"
#import "QuanGoodsView.h"
#import "GoodsGradeHUDView.h"
#define kBottomBarHeight 56.f

@interface GoodsDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,GoodsDetailHeaderTabViewDelegate,GoodsInfoChangedReceiver,AuthorizeChangedReceiver,ForumInputToolBarDelegate,DXChatBarMoreViewDelegate,UIGestureRecognizerDelegate,SearchViewControllerDelegate, GoodsCommentTitleCellDelegata, WristwatchRecoveryCellDelegate, WristViewDelegate,ParabolaToolDelegate>

@property(nonatomic,weak) UIImageView *bottomView;
@property(nonatomic,weak)   UIButton *addCartBtn;
@property(nonatomic,weak)   UIButton *buyBtn;
@property(nonatomic, strong) TagsExplanView *tagsExplainView;
@property(nonatomic,assign) CGFloat lastContentOffsetY;
@property (nonatomic, strong) BlackView *bgView;
@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;

@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, strong) GoodsGradeexPlainView * goodsGradeexPlainView;
@property(nonatomic,weak) UIButton *goodsNumLbl;

@property(nonatomic,strong) GoodsDetailInfo *detailInfo;
@property(nonatomic,strong) GoodsPhotoBrowser *photoBrowser;

@property(nonatomic,weak) UIView *likeBtnView;

@property(nonatomic,strong) PayViewController *payViewController;

@property(nonatomic,strong) NSMutableArray *goodsRecommendList;

@property(nonatomic,strong) NSMutableArray *commentsList;

@property(nonatomic,weak) ForumInputToolBar *toolBar;
@property(nonatomic,weak) ForumAttachContainerView *attachContainerView;

@property(nonatomic,assign) NSInteger reply_user_id;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) SYFireworksButton *shoppingCartBtn;
@property (nonatomic, weak) UIButton *moreBtn;
@property (nonatomic, weak) UIButton *backBtn1;
@property (nonatomic, weak) MCFireworksButton *sopportBtn;
@property (nonatomic, weak) MCFireworksButton *sopportBtn1;
@property (nonatomic, weak) VerticalCommandButton *sopportBtn2;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) UIView *likeView;
@property (nonatomic, strong) VerticalCommandButton *chatBtn;

@property (nonatomic, strong) AddBagView *addBagView;
@property (nonatomic, strong) BlackView *blackView;

@property (nonatomic, strong) BlackView *blackViewWrist;
@property (nonatomic, strong) WristView *wristView;
@property (nonatomic, copy) NSString *wristContentText;

@property (nonatomic, strong) BlackView *inviteBlackView;
@property (nonatomic, strong) WristInviteView *wristInviteView;
@property (nonatomic, strong) PicSuccess *PicTextSuccessView;
@property (nonatomic, strong) CommandButton *disPicSuccessView;
@property (nonatomic, strong) UIImageView * animationImage;
@property (nonatomic, strong) UIImageView * redView;
@property (nonatomic, assign) NSInteger canPay;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, assign) NSInteger isOpen;

@property (nonatomic, strong) AdviserPage *adviserPage;

@property (nonatomic, strong) QuanGoodsView *quanView;
@property (nonatomic, strong) BlackView *quanBgView;
@property (nonatomic, strong) NSArray *quanList;

@property (nonatomic, strong) NSMutableArray *gallaryItems;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) ASScroll *scrollImageView;

@property (nonatomic, assign) CGFloat picOffSet;
@property (nonatomic, assign) CGFloat paraOffSet;
@property (nonatomic, assign) CGFloat guardOffSet;
@property (nonatomic, assign) CGFloat hiddeOffSet;

@property (nonatomic, strong) HeaderChooseView *headerChooseView;
@end

@implementation GoodsDetailViewController {
    CGFloat _lastContentOffsetY;
}

-(HeaderChooseView *)headerChooseView{
    if (!_headerChooseView) {
        _headerChooseView = [[HeaderChooseView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 52)];
        _headerChooseView.backgroundColor = [UIColor whiteColor];
        _headerChooseView.hidden = YES;
    }
    return _headerChooseView;
}

-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}

- (GoodsGradeexPlainView *)goodsGradeexPlainView{
    if (!_goodsGradeexPlainView) {
        _goodsGradeexPlainView = [[GoodsGradeexPlainView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 435)];
    }
    return _goodsGradeexPlainView;
}

-(NSMutableArray *)gallaryItems{
    if (!_gallaryItems) {
        _gallaryItems = [[NSMutableArray alloc] init];
    }
    return _gallaryItems;
}

-(NSArray *)quanList{
    if (!_quanList) {
        _quanList = [[NSArray alloc] init];
    }
    return _quanList;
}

-(BlackView *)quanBgView{
    if (!_quanBgView) {
        _quanBgView = [[BlackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _quanBgView;
}

-(QuanGoodsView *)quanView{
    if (!_quanView) {
        _quanView = [[QuanGoodsView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 300)];
    }
    return _quanView;
}

-(PicSuccess *)PicTextSuccessView{
    if (!_PicTextSuccessView) {
        _PicTextSuccessView = [[PicSuccess alloc] initWithFrame:CGRectZero];
        _PicTextSuccessView.backgroundColor = [UIColor whiteColor];
        _PicTextSuccessView.layer.masksToBounds = YES;
        _PicTextSuccessView.layer.cornerRadius = 5;
    }
    return _PicTextSuccessView;
}

-(CommandButton *)disPicSuccessView{
    if (!_disPicSuccessView) {
        _disPicSuccessView = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_disPicSuccessView setImage:[UIImage imageNamed:@"Goods_Fenxiao_Dismiss"] forState:UIControlStateNormal];
        [_disPicSuccessView sizeToFit];
    }
    return _disPicSuccessView;
}


-(TagsExplanView *)tagsExplainView{
    if (!_tagsExplainView) {
        _tagsExplainView = [[TagsExplanView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 310)];
        _tagsExplainView.backgroundColor = [UIColor whiteColor];
    }
    return _tagsExplainView;
}

-(BlackView *)bgView{
    if (!_bgView) {
        _bgView = [[BlackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgView;
}

-(BlackView *)inviteBlackView{
    if (!_inviteBlackView) {
        _inviteBlackView = [[BlackView alloc] initWithFrame:self.view.bounds];
    }
    return _inviteBlackView;
}

-(WristInviteView *)wristInviteView{
    if (!_wristInviteView) {
        _wristInviteView = [[WristInviteView alloc] initWithFrame:CGRectZero];
        _wristInviteView.backgroundColor = [UIColor whiteColor];
        _wristInviteView.wristDissDelegate = self;
        _wristInviteView.layer.masksToBounds = YES;
        _wristInviteView.layer.cornerRadius = 5;
    }
    return _wristInviteView;
}

-(WristView *)wristView{
    if (!_wristView) {
        _wristView = [[WristView alloc] initWithFrame:CGRectZero];
        _wristView.backgroundColor = [UIColor whiteColor];
        _wristView.wristDissDelegate = self;
    }
    return _wristView;
}

-(BlackView *)blackViewWrist{
    if (!_blackViewWrist) {
        _blackViewWrist = [[BlackView alloc] initWithFrame:self.view.bounds];
    }
    return _blackViewWrist;
}

-(BlackView *)blackView{
    if (!_blackView) {
        _blackView = [[BlackView alloc] initWithFrame:CGRectZero];
    }
    return _blackView;
}

-(AddBagView *)addBagView{
    if (!_addBagView) {
        _addBagView = [[AddBagView alloc] initWithFrame:CGRectZero];
        _addBagView.layer.masksToBounds = YES;
        _addBagView.layer.cornerRadius = 5;
    }
    return _addBagView;
}

- (UIImageView *)redView
{
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 -20, kScreenWidth/2-20, 40, 40)];
        _redView.image = [UIImage imageNamed:@"overseas"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}

- (void)dealloc
{
    self.bottomView = nil;
    self.tableView = nil;
    self.dataSources = nil;
    self.quanView = nil;
    self.quanBgView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelecteIndex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelctCellIndex" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelecteIndex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelctCellIndex" object:nil];
}

- (void)viewDidLoad
{
    WEAKSELF;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    CGFloat topBarHeight = [super setupTopBar];
    //    [super setupTopBarTitle:@"详情"];
    //    [self setupTopBar];
    CGFloat topBarHeight = 0;
    self.isOpen = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshenTableView) name:@"goodsAboutCellNotification" object:nil];
    topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"商品详情"];
    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:self.goodsId];
    
    [ParabolaTool sharedTool].delegate = self;
    self.wristContentText = @"1.原价回收商品支持48小时无理由退货，在不影响第二次销售的情况下，原附件齐全，并无任何损坏，方可退货。\n\n"
    "2.至确认收货起90天后至1年内，可申请原价回购，爱丁猫收取售价5% 的服务费。\n\n\n\n\n\n\n";
    //    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    //    topView.backgroundColor = [UIColor orangeColor];
    //    [self.view addSubview:topView];
    
    //    CommandButton *shareBtn = [[CommandButton alloc] initWithFrame:CGRectMake(super.topBar.width-10-30, kTopBarContentMarginTop, 30, super.topBarHeight-kTopBarContentMarginTop)];
    //    [shareBtn setImage:[UIImage imageNamed:@"share_btn_topbar"] forState:UIControlStateNormal];
    //    [super.topBar addSubview:shareBtn];
    //    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
    //
    //    CommandButton *shoppingCartBtn = [[CommandButton alloc] initWithFrame:CGRectMake(shareBtn.left-30-2, kTopBarContentMarginTop, 30, super.topBarHeight-kTopBarContentMarginTop)];
    //    [shoppingCartBtn setImage:[UIImage imageNamed:@"shopping_cart"] forState:UIControlStateNormal];
    //    [super.topBar addSubview:shoppingCartBtn];
    //    shoppingCartBtn.tag = 101;
    //
    //
    //    CGRect frame = super.topBarTitleLbl.frame;
    //    frame.origin.x = frame.origin.x+(super.topBarTitleLbl.right-shoppingCartBtn.left+2);
    //    frame.size.width = frame.size.width-2*(super.topBarTitleLbl.right-shoppingCartBtn.left+2);
    //    super.topBarTitleLbl.frame = frame;
    //
    //
    //    self.goodsNumLbl.frame = CGRectNull;
    //    [self.topBar addSubview:self.goodsNumLbl];
    //
    //
    //    shareBtn.handleClickBlock = ^(CommandButton *sender) {
    //
    //    };
    //    shoppingCartBtn.handleClickBlock = ^(CommandButton *sender) {
    //        BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    //        if (isLoggedIn) {
    //            [MobClick event:@"click_shopping_chart_from_detail"];
    //            ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
    //            [super pushViewController:viewController animated:YES];
    //        }
    //    };
    
    
    //    [self.topBar setBackgroundColor:[UIColor orangeColor]];
    self.topBar.alpha = 1;
    
    if ([[Session sharedInstance] isLoggedIn]) {
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"repurchase" path:@"get_permission_value" parameters:nil completionBlock:^(NSDictionary *data) {
            NSInteger canpay = [data integerValueForKey:@"get_permission_value"];
            weakSelf.canPay = canpay;
        } failure:^(XMError *error) {
            
        } queue:nil]];
    }
    
    
    // self.picDatas = [NSMutableArray arrayWithArray:@[[NSNull null],[NSNull null],[NSNull null]]];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight-kBottomBarHeight+2.f)];
    self.tableView = tableView;
    self.tableView.enableRefreshing = NO;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.enableLoadingMore = NO;
    [self.view addSubview:tableView];
    
    [self.view addSubview:self.headerChooseView];
    
    self.headerChooseView.headerScrollTableInfIndexP = ^(NSInteger index){
        if (index == 1) {
            CGPoint offset = CGPointMake(0, weakSelf.picOffSet);
            [weakSelf.tableView setContentOffset:offset animated:YES];
        } else if (index == 2) {
            CGPoint offset = CGPointMake(0, weakSelf.paraOffSet);
            [weakSelf.tableView setContentOffset:offset animated:YES];
        } else if (index == 3){
            CGPoint offset = CGPointMake(0, weakSelf.guardOffSet);
            [weakSelf.tableView setContentOffset:offset animated:YES];
        }
    };
    
    UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(17, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 25, 25)];
    backBtn1.layer.cornerRadius = 16.f;
    backBtn1.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [backBtn1 addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 setImage:[UIImage imageNamed:@"Back_Promrt_MF"] forState:UIControlStateNormal];
    backBtn1.tag = 1000;
    //    [self.view addSubview:backBtn1];
    [backBtn1 sizeToFit];
    self.backBtn1 = backBtn1;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 25, 25)];
    backBtn.layer.cornerRadius = 16.f;
    backBtn.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [backBtn addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"Back_Promrt_MF"] forState:UIControlStateNormal];
    backBtn.tag = 1000;
    //    [self.view addSubview:backBtn];
    [backBtn sizeToFit];
    self.backBtn = backBtn;
    
    TapDetectingView *backBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, backBtn.top-(62-backBtn.height)/2, 62, 62)];
    backBgView.backgroundColor = [UIColor clearColor];
    backBgView.tag = 1001;
    [self.view addSubview:backBgView];
    
    backBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [weakSelf handleTopBarBackButtonClicked:nil];
    };
    
    //    CGFloat width = kScreenWidth*32/320;
    
    UIButton * moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-15-20, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2 + 2, 20, 20)];
    moreBtn.layer.cornerRadius = 16.f;
    moreBtn.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [moreBtn addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];//shoppingCartBtn
    [moreBtn setImage:[UIImage imageNamed:@"more_wjh"] forState:UIControlStateNormal];
    [self.view addSubview:moreBtn];
    self.moreBtn = moreBtn;
    moreBtn.tag = 101;
    
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    [self.view addSubview:goodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    
    
    _titles = @[@"消息",@"首页",@"我要反馈",@"分享"];
    _images=@[@"pop_messgae",@"pop_home",@"pop_feedback",@"pop_share"];
    TapDetectingView *moreBtnBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(self.view.width-57, moreBtn.top-(57-backBtn.height)/2, 57, 57)];
    moreBtnBgView.backgroundColor = [UIColor clearColor];
    moreBtnBgView.tag = 102;
    [self.view addSubview:moreBtnBgView];
    moreBtnBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        
        [self createPopMenuView];
    };
    
    
    SYFireworksButton *shoppingCartBtn = [[SYFireworksButton alloc] initWithFrame:CGRectMake(moreBtnBgView.frame.origin.x-15, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 25, 25)];
    //    shareBtn.layer.masksToBounds = YES;
    //    shareBtn.layer.cornerRadius = 16.f;
    //    shoppingCartBtn.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    shoppingCartBtn.particleScale = 0.05;
    shoppingCartBtn.particleScaleRange = 0.02;
    [shoppingCartBtn setImage:[UIImage imageNamed:@"Mine_New_ShoppingBad_White_MF"] forState:UIControlStateNormal];
    [self.view addSubview:shoppingCartBtn];
    self.shoppingCartBtn = shoppingCartBtn;
    shoppingCartBtn.tag = 110;
    
    TapDetectingView *shareBtnBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(self.view.width-12-32-18-32, shoppingCartBtn.top-(57-shoppingCartBtn.height)/2, 47, 57)];
    shareBtnBgView.backgroundColor = [UIColor clearColor];
    shareBtnBgView.tag = 111;
    [self.view addSubview:shareBtnBgView];
    shareBtnBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [weakSelf handleTopBarRightButtonClicked:nil];
    };
    
    //    MCFireworksButton *sopportBtn = [[MCFireworksButton alloc] initWithFrame:CGRectMake(shareBtn.frame.origin.x-23-20, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2 - 2, 30, 30)];
    //    [sopportBtn setImage:[UIImage imageNamed:@"New_Like_MF"] forState:UIControlStateNormal];
    //    [sopportBtn setImage:[UIImage imageNamed:@"New_Like_S"] forState:UIControlStateSelected];
    //    sopportBtn.particleImage = [UIImage imageNamed:@"Sparkle"];
    //    sopportBtn.particleScale = 0.05;
    //    sopportBtn.particleScaleRange = 0.02;
    //    [self.view addSubview:sopportBtn];
    //    self.sopportBtn = sopportBtn;
    //    sopportBtn.tag = 112;
    //    [sopportBtn addTarget:self action:@selector(clickSopportBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //    ParallaxHeaderView *parallaxHeaderView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [GoodsDetailHeaderView heightForOrientationPortrait:nil])];
    //    GoodsDetailHeaderView *headerView = [[GoodsDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [GoodsDetailHeaderView heightForOrientationPortrait:nil])];
    //    parallaxHeaderView.headerView = headerView;
    //    headerView.backgroundColor = [UIColor whiteColor];
    //    self.tableView.tableHeaderView = parallaxHeaderView;
    
    UIImageView *bottomView = [self buildBottomView];  //底部的View
    bottomView.frame = CGRectMake(0, self.view.bounds.size.height-kBottomBarHeight, self.view.bounds.size.width, bottomView.height);
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
    
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    
    
    if (!self.detailInfo) {
        [self showLoadingView];
        if ([self.goodsId length]>0) {
            [self reloadData];
        } else {
            [self loadEndWithNoContent:@"该商品已不存在"];
        }
    } else {
        WEAKSELF;
        [weakSelf updateHeaderViewWithGoodsDetail:self.detailInfo];
        [weakSelf updateBottomViewWithGoodsInfo:self.detailInfo.goodsInfo];
        [weakSelf updateTableView];
    }
    
    
    ForumInputToolBar *toolBar = [[ForumInputToolBar alloc] initWithFrame:CGRectMake(0, self.view.height-[ForumInputToolBar defaultHeight], self.view.width, [ForumInputToolBar defaultHeight]) withInputTextView:nil];
    _toolBar = toolBar;
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _toolBar.delegate = self;
    _toolBar.hiddenWhenNoEditing = YES;
    if ([_toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        DXChatBarMoreView *moreView = (DXChatBarMoreView*)(_toolBar.moreView);
        moreView.delegate = self;
    }
    _toolBar.inputTextView.placeHolder = @"评论";
    _toolBar.hiddenWhenNoEditing = YES;
    _toolBar.hidden = YES;
    [self.view addSubview:toolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.toolBar.moreView setDelegate:self];
    }
    
    ForumAttachContainerView *attachContainerView = [[ForumAttachContainerView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
    [self.toolBar addSubview:attachContainerView];
    attachContainerView.hidden = YES;
    _attachContainerView = attachContainerView;
    _toolBar.attachContainerView = attachContainerView;
    
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismissKeyboard:)];
    singleTapGR.delegate = self;
    [self.view addGestureRecognizer:singleTapGR];
    
    //    if ([self.goodsId length]>0) {
    //        [[NetworkAPI sharedInstance] statForGoods:self.goodsId completion:nil failure:nil];
    //    }
    
    _reply_user_id = 0;
    
    //    self.shareBtn.hidden = YES;
    //    self.shoppingCartBtn.hidden = YES;
    //    self.backBtn.hidden = YES;
    //    self.goodsNumLbl.hidden = YES;
    self.sopportBtn.hidden = YES;
    //    self.backBtn1.hidden = NO;
    
    
    [self bringTopBarToTop];
    
    [self.view addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.addBagView];
    [self.addBagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(kScreenWidth-100));
        make.height.equalTo(@(kScreenWidth-(kScreenWidth/320*210)));
    }];
    self.addBagView.hidden = YES;
    self.blackView.hidden = YES;
    
    self.addBagView.pushShopBag = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.addBagView.alpha = 0;
            weakSelf.blackView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.addBagView removeFromSuperview];
            [weakSelf.blackView removeFromSuperview];
        }];
        ShoppingCartViewController *shopViewController = [[ShoppingCartViewController alloc] init];
        [weakSelf pushViewController:shopViewController animated:YES];
    };
    
    self.blackView.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.PicTextSuccessView.alpha = 0;
            weakSelf.disPicSuccessView.alpha = 0;
            weakSelf.addBagView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.addBagView removeFromSuperview];
            [weakSelf.PicTextSuccessView removeFromSuperview];
            [weakSelf.disPicSuccessView removeFromSuperview];
        }];
    };
    
    self.blackViewWrist.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.wristView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.wristView removeFromSuperview];
        }];
    };
    
    self.inviteBlackView.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.wristInviteView.alpha = 0;
        } completion:^(BOOL finished) {
            //            [weakSelf.wristInviteView removeFromSuperview];
        }];
    };
    //    UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 150, kScreenWidth - 64, 100, 100)];
    //    likeView.backgroundColor = [UIColor redColor];
    //    [self.tableView addSubview:likeView];
    //    [self.view bringSubviewToFront:likeView];
    
    [self.view addSubview:self.PicTextSuccessView];
    [self.view addSubview:weakSelf.disPicSuccessView];
    self.PicTextSuccessView.alpha = 0;
    self.disPicSuccessView.alpha = 0;
    [weakSelf.PicTextSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.equalTo(@150);
    }];
    
    [weakSelf.disPicSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.PicTextSuccessView.mas_top);
        make.right.equalTo(weakSelf.PicTextSuccessView.mas_right).offset(-10);
    }];
    weakSelf.disPicSuccessView.handleClickBlock = ^(CommandButton *sender){
        weakSelf.blackView.alpha = 0;
        weakSelf.PicTextSuccessView.alpha = 0;
        weakSelf.disPicSuccessView.alpha = 0;
    };
    
    weakSelf.PicTextSuccessView.disPicView = ^(){
        weakSelf.blackView.alpha = 0;
        weakSelf.PicTextSuccessView.alpha = 0;
        weakSelf.disPicSuccessView.alpha = 0;
    };
    
    if ([Session sharedInstance].isLoggedIn) {
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"bonus" path:@"list_by_goods_in_detail" parameters:@{@"goods_sn":self.goodsId} completionBlock:^(NSDictionary *data) {
            if (data) {
                NSArray *quanList = data[@"list"];
                weakSelf.quanList = quanList;
                
                [[CoordinatingController sharedInstance].visibleController.view addSubview:self.quanBgView];
                weakSelf.quanBgView.alpha = 0;
                [[CoordinatingController sharedInstance].visibleController.view addSubview:self.quanView];
                [weakSelf.quanView setQuanList:self.quanList];
                
                weakSelf.quanBgView.dissMissBlackView = ^(){
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.quanBgView.alpha = 0;
                        weakSelf.quanView.frame = CGRectMake(0, kScreenHeight, kScreenHeight, 300);
                    }];
                };
                
                [weakSelf.tableView reloadData];
            }
        } failure:^(XMError *error) {
            
        } queue:nil]];
    }
    
}

- (void)freshenTableView
{
    if (self.isOpen == 1) {
        self.isOpen = 0;
    } else {
        self.isOpen = 1;
    }
    [self updateTableView];
    [self.tableView reloadData];
}

- (void)createPopMenuView
{
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = _images[i];
        info.title = _titles[i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:kScreenWidth/375*150 item:obj action:^(NSInteger index) {
        //@[@"消息",@"首页",@"我要反馈",@"分享"];
        switch (index) {
            case 0:
            {
                [[CoordinatingController sharedInstance] popToRootViewControllerAnimated:YES];
                [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:3];
            }
                break;
            case 1:
            {
                [[CoordinatingController sharedInstance] gotoHomeRecommendViewControllerAnimated:YES];
            }
                break;
            case 2:
            {
                FeedbackViewController * feedBack = [[FeedbackViewController alloc] init];
                [[CoordinatingController sharedInstance] pushViewController:feedBack animated:YES];
                break;
            }
            case 3:
                [self shareGoods];
                break;
                
            default:
                break;
        }
    }];
}



-(void)showExplain{
    WEAKSELF;
    [self.view addSubview:self.blackViewWrist];
    [self.view addSubview:self.wristView];
    self.wristView.alpha = 0;
    self.blackViewWrist.alpha = 0;
    
    CGSize size = [self.wristContentText sizeWithFont:[UIFont systemFontOfSize:15.f]
                                    constrainedToSize:CGSizeMake(kScreenWidth-58*2-16*2,MAXFLOAT)
                                        lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.wristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(kScreenWidth-58*2));
        make.height.equalTo(@(size.height + 50));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.blackViewWrist.alpha = 0.7;
        weakSelf.wristView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}



-(void)wristDissBtn{
    WEAKSELF;
    [UIView animateWithDuration:0.25 animations:^{
        if (weakSelf.wristView) {
            weakSelf.wristView.alpha = 0;
        }
        
        if (weakSelf.wristInviteView) {
            weakSelf.wristInviteView.alpha = 0;
        }
        
        if (weakSelf.blackViewWrist) {
            weakSelf.blackViewWrist.alpha = 0;
        }
        
        if (weakSelf.inviteBlackView) {
            weakSelf.inviteBlackView.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        if (weakSelf.wristView) {
            [weakSelf.wristView removeFromSuperview];
        }
        
        if (weakSelf.wristInviteView) {
            [weakSelf.wristInviteView removeFromSuperview];
        }
        
        if (weakSelf.blackViewWrist) {
            [weakSelf.blackViewWrist removeFromSuperview];
        }
        
        if (weakSelf.inviteBlackView) {
            [weakSelf.inviteBlackView removeFromSuperview];
        }
    }];
}

-(void)clickSopportBtn{
    
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    
    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:self.goodsId];
    if (goodsInfo) {
        [MobClick event:@"click_want_from_detail"];
        if (goodsInfo.isLiked) {
            //            self.sopportBtn.selected = NO;
            //            self.sopportBtn1.selected = NO;
            self.sopportBtn2.selected = NO;
            [GoodsSingletonCommand unlikeGoods:goodsInfo.goodsId];
            //            [self.sopportBtn popInsideWithDuration:0.4];
            //            [self.sopportBtn1 popInsideWithDuration:0.4];
        } else {
            //            self.sopportBtn.selected = YES;
            //            self.sopportBtn1.selected = YES;
            self.sopportBtn2.selected = YES;
            [GoodsSingletonCommand likeGoods:goodsInfo.goodsId];
            
            //            [self.sopportBtn popOutsideWithDuration:0.5];
            //            [self.sopportBtn animate];
            //
            //            [self.sopportBtn1 popOutsideWithDuration:0.5];
            //            [self.sopportBtn1 animate];
            
        }
    }
}

-(void)replyTitleCell:(UITextField *)textField{
    //    [self.toolBar resignFirstResponder];
    //    [self.toolBar  beginEditing];
    
    if (self.controllerContainer) {
        GoodsCommentsViewController *commentsViewController = [[GoodsCommentsViewController alloc] init];
        commentsViewController.goodsId = self.goodsId;
        commentsViewController.title = @"评论";
        [self pushViewController:commentsViewController animated:YES];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.attachContainerView.bounds fromView:self.attachContainerView];
    if (CGRectContainsPoint(rect, point) && ![self.attachContainerView isHidden]) {
        return NO;
    }
    if ([self.view findFirstResponder] || [self.toolBar isInEditing] || ![self.attachContainerView isHidden]) {
        if (![[gestureRecognizer.view superview] isKindOfClass:[ForumAttachmentView class]])
            return YES;
    }
    return NO;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

- (CGFloat)setupTopBar {
    CGFloat height = [super setupTopBar];
    
    if (![self.topBar viewWithTag:10222]) {
        NSArray *tabBtnTitles = [NSArray arrayWithObjects:@"", nil];
        GoodsDetailTopBarIndicatorView *tabBar = [[GoodsDetailTopBarIndicatorView alloc] initWithFrame:CGRectMake(110, kTopBarContentMarginTop, kScreenWidth-220, self.topBarHeight-kTopBarContentMarginTop)tabBtnTitles:tabBtnTitles];
        //    _tabBar = tabBar;
        tabBar.indicatorView.hidden = YES;
        tabBar.tag = 10222;
        [self.topBar addSubview:tabBar];
        [tabBar setTabAtIndex:0 animated:NO];
        tabBar.didSelectAtIndex = ^(NSInteger index) {
            
        };
    }
    
    return height;
    return 0;
}

- (CGFloat)setupTopBarDup {
    CGFloat height = [super setupTopBar];
    
    if (![self.topBar viewWithTag:10222]) {
        NSArray *tabBtnTitles = [NSArray arrayWithObjects:@"", nil];
        GoodsDetailTopBarIndicatorView *tabBar = [[GoodsDetailTopBarIndicatorView alloc] initWithFrame:CGRectMake(110, kTopBarContentMarginTop, kScreenWidth-220, self.topBarHeight-kTopBarContentMarginTop)tabBtnTitles:tabBtnTitles];
        UIView *view = [[UIView alloc] initWithFrame:self.topBar.bounds];
        view.backgroundColor = [UIColor colorWithHexString:@"dcdddd"];
        [self.topBar addSubview:view];
        //    _tabBar = tabBar;
        tabBar.indicatorView.hidden = YES;
        tabBar.tag = 10222;
        [self.topBar addSubview:tabBar];
        [tabBar setTabAtIndex:0 animated:NO];
        tabBar.didSelectAtIndex = ^(NSInteger index) {
            
        };
    }
    
    return height;
    return 0;
}

- (void)shareGoods
{
    WEAKSELF;
    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
    if (goodsInfo) {
        NSString *_shareImageUrl = goodsInfo.mainPicUrl;
        if ([_shareImageUrl mag_isEmpty] && goodsInfo.gallaryItems && [goodsInfo.gallaryItems count] >0) {
            _shareImageUrl = ((GoodsGallaryItem *)[goodsInfo.gallaryItems objectAtIndex:0]).picUrl;
        }
        
        UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                               [SDWebImageManager lw_cacheKeyForURL:
                                [NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale480x480]]]];
        
        
        if (shareImage == nil) {
            
            
            shareImage = [weakSelf getImageFromURL:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale200x200]];
        }
        
        //        [[CoordinatingController sharedInstance] shareWithTitle:@"来自爱丁猫的分享"
        //                                                          image:shareImage
        //                                                            url:kURLGoodsDetailFormat(goodsInfo.goodsId)
        //                                                        content:goodsInfo.goodsName];
        //增加获取图文
        [[CoordinatingController sharedInstance] shareWithTitle:[NSString stringWithFormat:@"%@",goodsInfo.goodsName]
                                                          image:shareImage
                                                            url:kURLGoodsDetailFormat(goodsInfo.goodsId)
                                                        content:goodsInfo.summary
                                                     isTeletext:YES];
        
        [MobClick event:@"click_share_from_detail"];
        
        weakSelf.request = [[NetworkAPI sharedInstance] shareGoodsWith:weakSelf.goodsId completion:^(int shareNum) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
                if (goodsInfo) {
                    goodsInfo.stat.shareNum = shareNum;
                }
                MBGlobalSendGoodsInfoChangedNotification(0,weakSelf.goodsId);
            });
            _$hideHUD();
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }
    
    
    //获取图文
    [CoordinatingController sharedInstance].getImageAndText = ^(){
        
        for (int i = 0; i < weakSelf.detailInfo.gallaryItems.count; i++) {
            GoodsGallaryItem * gallary = weakSelf.detailInfo.gallaryItems[i];
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:gallary.picUrl]]];
            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        NSString * shareText = [NSString stringWithFormat:@"%@,%.2f,%@,%@",weakSelf.goodsInfo.goodsName,weakSelf.goodsInfo.shopPrice,weakSelf.goodsInfo.summary,kURLGoodsDetailFormat(goodsInfo.goodsId)];
        UIPasteboard * pastebpard = [UIPasteboard generalPasteboard];
        pastebpard.string = shareText;
    };
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        //        [[CoordinatingController sharedInstance] showHUD:@"获取图文成功" hideAfterDelay:0.8];
        self.blackView.hidden = NO;
        self.PicTextSuccessView.alpha = 1;
        self.blackView.alpha = 0.7;
        self.disPicSuccessView.alpha = 1;
    }else{
        [[CoordinatingController sharedInstance] showHUD:@"获取图文失败" hideAfterDelay:0.8];
    }
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)bringTopBarToTop
{
    [super bringTopBarToTop];
    
    UIView *backBtn = [self.view viewWithTag:1000];
    UIView *backBgView = [self.view viewWithTag:1001];
    UIView *shoppingCartBtn = [self.view viewWithTag:101];
    UIView *shoppingCartBgView = [self.view viewWithTag:102];
    UIView *shareBtn = [self.view viewWithTag:110];
    UIView *shareBtnBgView = [self.view viewWithTag:111];
    UIView *sopportBtn = [self.view viewWithTag:112];
    //    UIView *bgView = [self.tableView viewWithTag:1121];
    //    UIView *sopportBtn1 = [bgView viewWithTag:1120];
    [self.view bringSubviewToFront:sopportBtn];
    [self.view bringSubviewToFront:backBtn];
    [self.view bringSubviewToFront:backBgView];
    [self.view bringSubviewToFront:shoppingCartBtn];
    [self.view bringSubviewToFront:shoppingCartBgView];
    [self.view bringSubviewToFront:shareBtn];
    [self.view bringSubviewToFront:shareBtnBgView];
    [self.view bringSubviewToFront:self.goodsNumLbl];
    //    [self.view bringSubviewToFront:bgView];
    //    [bgView bringSubviewToFront:sopportBtn1];
}

- (UIButton*)buildGoodsNumLbl
{
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"fb0006"];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    [goodsNumLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    goodsNumLbl.enabled = NO;
    goodsNumLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    goodsNumLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
    return goodsNumLbl;
}

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"syncRenewData" object:[NSNumber numberWithInteger:goodsNum]];
    
    _goodsNumLbl.hidden = YES;
    
    if (goodsNum > 0  && self.topBar.alpha == 1) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            CGFloat goodsNumLblWidth = size.width+8;
            CGFloat goodsNumLblHeight = 13.f;
            UIView *shoppingCartBtn = [self.view viewWithTag:101];
            self.goodsNumLbl.frame = CGRectMake(self.shoppingCartBtn.right - 7, kTopBarContentMarginTop+3, goodsNumLblWidth, goodsNumLblHeight);
            _goodsNumLbl.alpha = 1;
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            CGFloat goodsNumLblWidth = size.width+8;
            CGFloat goodsNumLblHeight = 13.f;
            UIView *shoppingCartBtn = [self.view viewWithTag:101];
            self.goodsNumLbl.frame = CGRectMake(self.shoppingCartBtn.right - 7, kTopBarContentMarginTop+3, goodsNumLblWidth, goodsNumLblHeight);
            _goodsNumLbl.hidden = NO;
            _goodsNumLbl.alpha = 1;
        }
        
    } else {
        [_goodsNumLbl setTitle:@"0" forState:UIControlStateDisabled];
        _goodsNumLbl.alpha = 0;
        _goodsNumLbl.hidden = YES;
    }
}

- (void)reloadData
{
    WEAKSELF;
    [_request cancel];
    _request = [[NetworkAPI sharedInstance] getGoodsDetail:self.goodsId completion:^(GoodsDetailInfo *detail) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.detailInfo = detail;
        [weakSelf.headerChooseView getGoodsDetailInfo:self.detailInfo];
        [weakSelf.gallaryItems addObjectsFromArray:weakSelf.detailInfo.gallaryItems];
        for (int i = 0; i < weakSelf.gallaryItems.count; i++) {
            PictureItem *item = weakSelf.gallaryItems[i];
            XMWebImageView *imageView = [[XMWebImageView alloc] init];
            [imageView setImageWithURL:item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            [weakSelf.imageViews addObject:imageView];
        }
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
            
            AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
//            [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
            weakSelf.adviserPage = adviserPage;
            
        } failure:^(XMError *error) {
            
        } queue:nil]];
        
        if (detail.goodsInfo != nil) {
            //        //测试
            //        detail.goodsInfo.isLimitActivity = YES;
            //        ActivityBaseInfo *info = [[ActivityBaseInfo alloc] init];
            //        info.remainTime = 109999;
            //        info.isFinished = NO;
            //        detail.goodsInfo.activityBaseInfo = info;
            //        ///=====
            
            //        if (detail.brandInfo && [detail.brandInfo.brandEnName length]>0) {
            //            [weakSelf setupTopBarTitle:detail.brandInfo.brandEnName];
            //        }
            BOOL isDataChanged = NO;
            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:detail.goodsInfo isDataChanged:&isDataChanged];
            self.goodsInfo = goodsInfo;
            if (goodsInfo.isLiked) {
                self.sopportBtn2.selected = YES;
                //                self.sopportBtn1.selected = YES;
            } else {
                self.sopportBtn2.selected = NO;
                //                self.sopportBtn1.selected = NO;
            }
            [weakSelf.dataSources addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
//            detail.goodsInfo = goodsInfo;
            
            
            [weakSelf updateHeaderViewWithGoodsDetail:detail];
            [weakSelf updateBottomViewWithGoodsInfo:detail.goodsInfo];
            [weakSelf updateTableView];
            
            //        NSMutableArray *dataSources = [[NSMutableArray alloc] init];
            //
            //        {
            //            [dataSources addObject:[GoodsDetailBaseInfoCell buildCellDict:detail.goodsInfo]];
            //            [dataSources addObject:[SellerInfoTableViewCell buildCellDict:detail.goodsInfo.seller]];
            //
            //            [dataSources addObject:[LikedUsersTableViewCell buildCellDict:detail.goodsInfo.goodsId totalNum:detail.goodsInfo.stat.likeNum likedUsers:detail.goodsInfo.likedUsers]];
            //            [dataSources addObject:[SepTableViewCell buildCellDict]];
            //
            ////            if ([detail.attrItems count]>0) {
            ////                [detailPicItemCells addObject:[GoodsDetailTitleCell buildCellDict:@"规格参数:"]];
            ////                [detailPicItemCells addObject:[GoodsAttributesCell buildCellDict:detail.attrItems]];
            ////            }
            ////
            ////            if ([detail.detailPicItems count]>0) {
            ////                [detailPicItemCells addObject:[GoodsDetailTitleCell buildCellDict:@"商品详情:"]];
            ////
            ////                for (GoodsDetailPicItem *picItem in detail.detailPicItems) {
            ////                    [detailPicItemCells addObject:[GoodsDetailPictureCell buildCellDict:picItem]];
            ////                }
            ////            }
            ////
            //            [dataSources addObject:[SepTableViewCell buildCellDict]];
            //            [dataSources addObject:[GoodsDetailBottomTagsCell buildCellDict]];
            //        }
            
            //        weakSelf.dataSources = dataSources;
            //
            //        [weakSelf.tableView reloadData];
            
            if (isDataChanged) {
                NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
                [goodsIds addObject:detail.goodsInfo.goodsId];
                MBGlobalSendGoodsInfoListChangedNotification((NSUInteger)weakSelf, goodsIds);
            }
            
            MBGlobalSendGoodsInfoUpdatedNotification(weakSelf.detailInfo.goodsInfo);
            
            [weakSelf setupTopBar];
            //            weakSelf.topBar.alpha = 0;
            [weakSelf bringTopBarToTop];
            [weakSelf hideLoadingView];
            
            
            //            if ([GuideView isNeedShowWaitItGuideView]) {
            //                dispatch_async( dispatch_get_main_queue(), ^{
            //                    if (weakSelf.likeBtnView) {
            //                        CGPoint pt = [weakSelf.view convertPoint:CGPointMake(0, 0) fromView:weakSelf.likeBtnView];
            //                        if (pt.y<weakSelf.bottomView.top+20) {
            //                            [GuideView showWaitItGuideView:weakSelf.likeBtnView];
            //                        }
            //                    }
            //                });
            //            }
            
            [weakSelf loadRecommandGoods];
            [weakSelf loadGoodsCommends];
        } else {
            [weakSelf loadEndWithNoContent:@"商品已被下架"];
        }
    } failure:^(XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        
        if (weakSelf.detailInfo == nil) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf reloadData];
            };
            [weakSelf bringTopBarToTop];
        }
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[[UIApplication sharedApplication] keyWindow]];
    }];
}

- (void)loadRecommandGoods {
    //    recommend_goods
    //    GoodsService RecommendGoodsInfo
    
    WEAKSELF;
    [GoodsService recommend_goods:self.detailInfo.goodsInfo.goodsId completion:^(NSArray *goods_list) {
        
        NSMutableArray *goodsRecommendList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[goods_list count];i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[goods_list objectAtIndex:i]];
            if (i+1>=[goods_list count]) {
                [goodsRecommendList addObject:array];
                break;
            }
            [array addObject:[goods_list objectAtIndex:i+1]];
            [goodsRecommendList addObject:array];
        }
        
        weakSelf.goodsRecommendList = goodsRecommendList;
        
        [weakSelf updateTableView];
    } failure:^(XMError *error) {
        
    }];
}

- (void)loadGoodsCommends {
    WEAKSELF;
    [GoodsService comment_list:self.goodsId size:5 completion:^(NSArray *comments) {
        NSMutableArray *commentsList = [[NSMutableArray alloc] initWithArray:comments];
        weakSelf.commentsList = commentsList;
        [weakSelf updateTableView];
    } failure:^(XMError *error) {
        
    }];
}

- (void)updateTableView
{
    CGFloat offSet = GoodsDetailheaderViewHeight;
    GoodsDetailInfo *detail = self.detailInfo;
    if (detail) {
        NSMutableArray *dataSources = [[NSMutableArray alloc] init];
        offSet += [OrderTabViewCellSmallTwo rowHeightForPortrait];
        [dataSources addObject:[GoodsDetailBaseInfoCell buildCellDict:detail.goodsInfo]];//parada Cell
        offSet += [GoodsDetailBaseInfoCell rowHeightForPortrait:[GoodsDetailBaseInfoCell buildCellDict:detail.goodsInfo]];
        if (self.quanList.count > 0) {
            [dataSources addObject:[BeuseQuanGoodsCell buildCellDict:[NSMutableArray arrayWithArray:self.quanList]]];
            offSet += [BeuseQuanGoodsCell rowHeightForPortrait:[BeuseQuanGoodsCell buildCellDict:[NSMutableArray arrayWithArray:self.quanList]]];
        }
        if (detail.goodsInfo.serviceIcon.count > 0) {
            [dataSources addObject:[ServiceTagCell buildCellDict:detail.goodsInfo]];
            offSet += [ServiceTagCell rowHeightForPortrait:[ServiceTagCell buildCellDict:detail.goodsInfo]];
        }
        
//        detail.goodsInfo.summary = @"案件是的哈空间是单卡坚实的看见爱上当看见俺还是都看见俺还是大家爱看书";
        if ([detail.goodsInfo.summary length] > 0) {
//            [dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
//            offSet += [SepWhiteTableViewCell rowHeightForPortrait];
//            [dataSources addObject:[GoodsDescribeSepCell buildCellDict]];
//            offSet += [GoodsDescribeSepCell rowHeightForPortrait];
            [dataSources addObject:[GoodsDetailStoryCell buildCellDict:detail.goodsInfo]];//这里应该传入GoodsInfo
            offSet += [GoodsDetailStoryCell rowHeightForPortrait:[GoodsDetailStoryCell buildCellDict:detail.goodsInfo]];
        }
        
        //        if (detail.goodsInfo.expected_delivery_type > 0) {
        //            [dataSources addObject:[ExpectedDeliveryCell buildCellDict:detail.goodsInfo]];
        //        }
        //        [dataSources addObject:[DeliveryExplainCell buildCellDict]];
        
        if (detail.goodsInfo.goodsBenefitInfo.count > 0) {
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
            
            NSArray * array = detail.goodsInfo.goodsBenefitInfo;
            GoodsGuarantee * goodsGuarantee = array[0];
            [dataSources addObject:[ServiceIconCell buildCellDict:goodsGuarantee]];
            offSet += [ServiceIconCell rowHeightForPortrait:[ServiceIconCell buildCellDict:goodsGuarantee]];
//            [dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
//        if (detail.goodsInfo.goods_guarantee.count > 0) {
//            [dataSources addObject:[SepSWTableViewCell buildCellDict]];
//            for (int i = 0; i < detail.goodsInfo.goods_guarantee.count; i++) {
//                GoodsGuarantee *goodsGuarantee = detail.goodsInfo.goods_guarantee[i];
//                [dataSources addObject:[DeliveryExplainCell buildGoodsGuaranteeCellDict:goodsGuarantee]];
//                if (i == detail.goodsInfo.goods_guarantee.count - 1) {
//                    
//                } else {
//                    [dataSources addObject:[SepSWTableViewCell1 buildCellDict]];
//                }
//            }
//            [dataSources addObject:[SepSWTableViewCell buildCellDict]];
//        }
        
        if ([detail.goodsInfo.seller.autotrophyGoodsVo.promiseList count] > 0) {
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
            if ([detail.goodsInfo.seller.autotrophyGoodsVo.title length] > 0) {// || (detail.goodsInfo.supportType & GOODSINDEX) == GOODSINDEX
                [dataSources addObject:[GoodsDetailSelfEngageCell buildCellDict:detail]];
                offSet += [GoodsDetailSelfEngageCell rowHeightForPortrait:[GoodsDetailSelfEngageCell buildCellDict:detail]];
            }
            if (detail.goodsInfo.seller.autotrophyGoodsVo.promiseList.count > 0) {
                [dataSources addObject:[GoodsDetailServeTagsCell buildCellDict:detail]];
                offSet += [GoodsDetailServeTagsCell rowHeightForPortrait:[GoodsDetailServeTagsCell buildCellDict:detail]];
            }
        }
        
        //        [dataSources addObject:[GoodsTagsCell buildCellDict:detail.tagList goodsInfo:detail.goodsInfo]];
        if ((detail.goodsInfo.supportType & GOODSINDEX) == GOODSINDEX) {//回购商品
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
            [dataSources addObject:[WristwatchRecoveryCell buildCellDict]];
            offSet += [WristwatchRecoveryCell rowHeightForPortrait:[WristwatchRecoveryCell buildCellDict]];
            for (int i = 0; i < detail.goodsInfo.goodsFittings.count; i++) {
                GoodsFittings *fitting = detail.goodsInfo.goodsFittings[i];
                if (fitting.type == 2) {
                    [dataSources addObject:[WristwatchRecoveryDetailCell buildCellDict:fitting]];
                    offSet += [WristwatchRecoveryDetailCell rowHeightForPortrait:[WristwatchRecoveryDetailCell buildCellDict:fitting]];
                }
            }
            if (detail.goodsInfo.buyBackInfo.length > 0) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                offSet += [SepTableViewCell rowHeightForPortrait];
                [dataSources addObject:[BuyBackCell buildCellTitle:detail.goodsInfo.buyBackInfo]];
                offSet += [BuyBackCell rowHeightForPortrait:[BuyBackCell buildCellTitle:detail.goodsInfo.buyBackInfo]];
            }
        }
        
        [dataSources addObject:[SepTableViewCell buildCellDict]];
        offSet += [SepTableViewCell rowHeightForPortrait];
        [dataSources addObject:[WeixinCopyCell buildCellDict:self.adviserPage]];
        offSet += [WeixinCopyCell rowHeightForPortrait:[WeixinCopyCell buildCellDict:self.adviserPage]];
        [dataSources addObject:[SepTableViewCell buildCellDict]];
        offSet += [SepTableViewCell rowHeightForPortrait];
        if (detail.goodsInfo.seller.adBanner && detail.goodsInfo.seller.adBanner.count > 0) {
            [dataSources addObject:[IdleBannerTableViewCell buildCellDict:detail.goodsInfo.seller.adBanner[0]]];
            offSet += [IdleBannerTableViewCell rowHeightForPortrait:[IdleBannerTableViewCell buildCellDict:detail.goodsInfo.seller.adBanner[0]]];
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
        }
        self.picOffSet = offSet;
        [dataSources addObject:[GoodsTotalInfCell buildCellDict:self.detailInfo]];
        offSet += [GoodsTotalInfCell rowHeightForPortrait];
        if (detail.gallaryItems.count > 0) {
            for (int i = 0; i < detail.gallaryItems.count; i++) {
                [dataSources addObject:[GoodsPictureCell buildCellDict:detail.gallaryItems[i] index:i+1]];
                offSet += [GoodsPictureCell rowHeightForPortrait:[GoodsPictureCell buildCellDict:detail.gallaryItems[i] index:i+1]];
                [dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
                offSet += [SepWhiteTableViewCell1 rowHeightForPortrait];
            }
        }
        
        if ([detail.attrItems count]>0) {
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
            self.paraOffSet = offSet;
            [dataSources addObject:[GoodsDetailTitleCell buildCellDict:@"商品参数" isOpen:1 b2cOrc2c:1]];
            offSet += [GoodsDetailTitleCell rowHeightForPortrait:[GoodsDetailTitleCell buildCellDict:@"商品参数" isOpen:1 b2cOrc2c:1]];
            for (int i = 0; i < detail.attrItems.count; i++) {
                GoodsAttributeItem *item = detail.attrItems[i];
                NSInteger isExpand = 0;
                if ([item.attrName isEqualToString:@"成色"]) {
                    isExpand = 1;
                } else {
                    isExpand = 0;
                }
                [dataSources addObject:[GoodsAboutCell buildCellDict:item.attrName attrValue:item.attrValue isExpand:isExpand]];
                offSet += [GoodsAboutCell rowHeightForPortrait:[GoodsAboutCell buildCellDict:item.attrName attrValue:item.attrValue isExpand:isExpand]];
                if ([item.attrName isEqualToString:@"成色"]) {
                    if (self.isOpen) {
                        [dataSources addObject:[GoodsAboutDescCell buildCellDict:self.goodsInfo.gradeTag.desc]];
                        offSet += [GoodsAboutDescCell rowHeightForPortrait:[GoodsAboutDescCell buildCellDict:self.goodsInfo.gradeTag.desc]];
                    }
                }
            }
            [dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
            offSet += [SepWhiteTableViewCell rowHeightForPortrait];
            [dataSources addObject:[SegTabViewCellSmallMF buildCellDict]];
            
            
            offSet += [SegTabViewCellSmallMF rowHeightForPortrait];
            [dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
            offSet += [SepWhiteTableViewCell1 rowHeightForPortrait];
//            [dataSources addObject:[GoodsDetailStoryCell buildCellDict:detail.goodsInfo]];
//            offSet += [GoodsDetailStoryCell rowHeightForPortrait:[GoodsDetailStoryCell buildCellDict:detail.goodsInfo]];
            [dataSources addObject:[GoodsBrandCell buildCellDict:detail.brandInfo]];
            offSet += [GoodsBrandCell rowHeightForPortrait:[GoodsBrandCell buildCellDict:detail.brandInfo]];
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
        }
        self.guardOffSet = offSet;
//        [dataSources addObject:[GoodsDetailTitleCell buildCellDict:@"交易保障" isOpen:1 b2cOrc2c:1]];
//        offSet += [GoodsDetailTitleCell rowHeightForPortrait:[GoodsDetailTitleCell buildCellDict:@"交易保障" isOpen:1 b2cOrc2c:1]];
        [dataSources addObject:[DealguaranteCell buildCellDict:detail.imageDescGroupItems]];
        offSet += [DealguaranteCell rowHeightForPortrait:[DealguaranteCell buildCellDict:detail.imageDescGroupItems]];
        if ([self.goodsRecommendList count]>0) {
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            offSet += [SepTableViewCell rowHeightForPortrait];
            self.hiddeOffSet = offSet;
            [dataSources addObject:[GoodsRecommendSepCell buildCellDict]];
            for (NSInteger i=0;i<[self.goodsRecommendList count];i++) {
                
                NSArray *array = [self.goodsRecommendList objectAtIndex:i];
                [dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
                
                [dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
            }
        } else {
            [dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
        }
        
        self.dataSources = dataSources;
        [self.tableView reloadData];
    }
}

- (void)updateHeaderViewWithGoodsDetail:(GoodsDetailInfo*)detail
{
    if (!detail){
        detail = self.detailInfo;
    }
    
    //    GoodsDetailHeaderView *headerView = [[GoodsDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];;
    //    [headerView updateWithDetailInfo:detail];
    //    weakSelf.tableView.tableHeaderView = headerView;
    
    if (detail.contactType == 1) {
        [self.chatBtn setImage:[UIImage imageNamed:@"Goods_advise"] forState:UIControlStateNormal];
        [self.chatBtn setTitle:@"联系顾问" forState:UIControlStateNormal];
        self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        self.chatBtn.tag = 1;
    } else {
        [self.chatBtn setImage:[UIImage imageNamed:@"Goods_advise"] forState:UIControlStateNormal];
        [self.chatBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        self.chatBtn.tag = 0;
    }
    
    
    
    [self.sopportBtn2 setImage:[UIImage imageNamed:@"Goods_Like"] forState:UIControlStateNormal];
    [self.sopportBtn2 setImage:[UIImage imageNamed:@"Goods_Like_Selected"] forState:UIControlStateSelected];
    self.sopportBtn2.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.sopportBtn2 setTitle:@"心动" forState:UIControlStateNormal];
    if (detail.goodsInfo.stat.likeNum > 999) {
        [self.sopportBtn2 setTitle:@"999+" forState:UIControlStateSelected];
        [self.sopportBtn2 setTitle:@"999+" forState:UIControlStateNormal];
    }else{
        
        [self.sopportBtn2 setTitle:[NSString stringWithFormat:@"%ld",(long)detail.goodsInfo.stat.likeNum]
                          forState:UIControlStateSelected];
        [self.sopportBtn2 setTitle:[NSString stringWithFormat:@"%ld",(long)detail.goodsInfo.stat.likeNum]
                          forState:UIControlStateNormal];
    }
    
    
    if (!_likeView) {
        ParallaxHeaderView *parallaxHeaderView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(kScreenWidth, GoodsDetailheaderViewHeight)];//[GoodsDetailHeaderView heightForOrientationPortrait:nil]
        GoodsDetailHeaderView *headerView = [[GoodsDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GoodsDetailheaderViewHeight)];//[GoodsDetailHeaderView heightForOrientationPortrait:nil]
        [headerView updateWithDetailInfo:detail];
        parallaxHeaderView.headerView = headerView;
        headerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = parallaxHeaderView;
        WEAKSELF;
        headerView.scrollTable = ^(){
            CGPoint offset = CGPointMake(0, weakSelf.paraOffSet);
            [weakSelf.tableView setContentOffset:offset animated:YES];
        };
        
        UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-40-15, kScreenWidth - 25, 40, 40)];
        likeView.backgroundColor = [UIColor whiteColor];
        likeView.layer.masksToBounds = YES;
        likeView.layer.cornerRadius = 20;
        likeView.tag = 1121;
        likeView.hidden = YES;
        self.likeView = likeView;
        [self.tableView addSubview:likeView];
        MCFireworksButton *sopportBtn1 = [[MCFireworksButton alloc] initWithFrame:CGRectMake(kScreenWidth-40-15, kScreenWidth - 25, likeView.width, likeView.height)];
        [sopportBtn1 setImage:[UIImage imageNamed:@"like_New_New_MF"] forState:UIControlStateNormal];
        [sopportBtn1 setImage:[UIImage imageNamed:@"New_Like_S"] forState:UIControlStateSelected];
        //    sopportBtn1.layer.masksToBounds = YES;
        //    sopportBtn1.layer.cornerRadius = 20;
        sopportBtn1.particleImage = [UIImage imageNamed:@"Sparkle"];
        sopportBtn1.particleScale = 0.05;
        sopportBtn1.particleScaleRange = 0.02;
        //        [self.tableView addSubview:sopportBtn1];
        self.sopportBtn1 = sopportBtn1;
        sopportBtn1.tag = 1120;
        [sopportBtn1 addTarget:self action:@selector(clickSopportBtn) forControlEvents:UIControlEventTouchUpInside];
        if (self.goodsInfo.isLiked) {
            sopportBtn1.selected = YES;
        } else {
            sopportBtn1.selected = NO;
        }
        [self bringTopBarToTop];
    }
}

- (void)updateBottomViewWithGoodsInfo:(GoodsInfo*)goodsInfo
{
    WEAKSELF;
    BOOL isEabled = ![[Session sharedInstance] isExistInShoppingCart:weakSelf.goodsId];
    weakSelf.addCartBtn.enabled = isEabled;
    //    if (isEabled) {
    //        weakSelf.addCartBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];//[UIColor colorWithHexString:@"E6C57D"];
    //    } else {
    //        weakSelf.addCartBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];//[UIColor colorWithHexString:@"F5F5F5"];
    //    }
    
    if ([goodsInfo isLocked] && self.detailInfo.orderLockInfo) {
        if (self.detailInfo.orderLockInfo.buyerId == [Session sharedInstance].currentUserId) {
            [self.buyBtn setTitle:@"继续支付" forState:UIControlStateNormal];
            weakSelf.buyBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];//[UIColor colorWithHexString:@"282828"];
            weakSelf.buyBtn.enabled = YES;
        } else {
            [self.buyBtn setTitle:@"已被抢" forState:UIControlStateNormal];
            [weakSelf.buyBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
            weakSelf.buyBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];//[UIColor colorWithHexString:@"666666"];
            weakSelf.buyBtn.enabled = NO;
        }
    } else {
        [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        weakSelf.buyBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];//[UIColor colorWithHexString:@"282828"];
        weakSelf.buyBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (UIImageView*)buildBottomView {
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kBottomBarHeight)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = [UIColor clearColor];
    UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
    [bottomView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
    
    CGFloat marginLeft = 0.f;
    VerticalCommandButton *chatBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectMake(0, 8.f, bottomView.width/6, bottomView.height-16.f)];
    [chatBtn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    chatBtn.contentAlignmentCenter = YES;
    chatBtn.imageTextSepHeight = 3;
    [chatBtn setImage:[UIImage imageNamed:@"Tabbar_Message_N_New_MF"] forState:UIControlStateNormal];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:8.f];
    self.chatBtn = chatBtn;
    [bottomView addSubview:chatBtn];
    
    marginLeft += chatBtn.width;
    
    VerticalCommandButton * sopportBtn2 = [[VerticalCommandButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.chatBtn.frame), 8, bottomView.width/6, bottomView.height-16.f)];
    [sopportBtn2 setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateSelected];
    [sopportBtn2 setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    sopportBtn2.contentAlignmentCenter = YES;
    sopportBtn2.imageTextSepHeight = 8;
    [sopportBtn2 addTarget:self action:@selector(clickSopportBtn) forControlEvents:UIControlEventTouchUpInside];
    self.sopportBtn2 = sopportBtn2;
    [bottomView addSubview:self.sopportBtn2];
    
    
    CommandButton *buyBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/375*104-10, 8.f, kScreenWidth/375*104, bottomView.height-16.f)];
    buyBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    buyBtn.layer.masksToBounds = YES;
    buyBtn.layer.cornerRadius = 2;
    [bottomView addSubview:buyBtn];
    self.buyBtn = buyBtn;
    
    CommandButton *addCartBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-2*(kScreenWidth/375*104)-(2*10), 8.f, kScreenWidth/375*104, bottomView.height-16.f)];//bottomView.width - bottomView.width/5
    addCartBtn.backgroundColor = [UIColor colorWithHexString:@"000000"];
    addCartBtn.layer.borderColor = [UIColor colorWithHexString:@"000000"].CGColor;
    addCartBtn.layer.borderWidth = 1;
    addCartBtn.layer.masksToBounds = YES;
    addCartBtn.layer.cornerRadius = 2;
    [addCartBtn setTitle:@"加入购物袋" forState:UIControlStateNormal];
    [addCartBtn setTitle:@"已加入购物袋" forState:UIControlStateDisabled];
    [addCartBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [addCartBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateDisabled];
    addCartBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [bottomView addSubview:addCartBtn];
    self.addCartBtn = addCartBtn;
    
    marginLeft += addCartBtn.width;
    
    
    
    //        CALayer *topLine = [CALayer layer];
    //        topLine.backgroundColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    //        topLine.frame = CGRectMake(0, 0, bottomView.width, 1);
    //        [bottomView.layer addSublayer:topLine];
    
    //    CALayer *sepLine = [CALayer layer];
    //    sepLine.backgroundColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    //    sepLine.frame = CGRectMake(chatBtn.right-0.5, 10.f, 0.5, bottomView.height-20.f);
    //    [bottomView.layer addSublayer:sepLine];
    
    //    CALayer *sepLine1 = [CALayer layer];
    //    sepLine1.backgroundColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    //    sepLine1.frame = CGRectMake(buyBtn.left-0.5, 10.f, 0.5, bottomView.height-20.f);
    //    [bottomView.layer addSublayer:sepLine1];
    
    WEAKSELF;
    addCartBtn.handleClickBlock = ^(CommandButton *sender) {
        if ([weakSelf.detailInfo.goodsInfo isOnSale])
        {
            if ([[Session sharedInstance] isLoggedIn]) {
                
                if (weakSelf.canPay == 0 && weakSelf.goodsInfo.supportType == 1) {
                    
                    [weakSelf.view addSubview:self.inviteBlackView];
                    [weakSelf.view addSubview:self.wristInviteView];
                    weakSelf.inviteBlackView.alpha = 0;
                    weakSelf.wristInviteView.alpha = 0;
                    [self.wristInviteView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.view.mas_centerX);
                        make.centerY.equalTo(self.view.mas_centerY);
                        //                make.width.equalTo(@(kScreenWidth-58*2));
                        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/375*40);
                        make.right.equalTo(self.view.mas_right).offset(-(kScreenWidth/375*40));
                        make.height.equalTo(@(kScreenWidth/375*152));
                    }];
                    
                    self.wristInviteView.inviteDiss = ^(){
                        [UIView animateWithDuration:0.25 animations:^{
                            weakSelf.wristInviteView.alpha = 0;
                            weakSelf.inviteBlackView.alpha = 0;
                        } completion:^(BOOL finished) {
                            //                    [weakSelf.wristInviteView removeFromSuperview];
                            //                    [weakSelf.inviteBlackView removeFromSuperview];
                        }];
                    };
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.inviteBlackView.alpha = 0.7;
                        weakSelf.wristInviteView.alpha = 1;
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                    return ;
                }
                
                [weakSelf showProcessingHUD:nil];
                weakSelf.request = [[NetworkAPI sharedInstance] addToShoppingCart:weakSelf.goodsId completion:^(NSInteger totalNum,ShoppingCartItem* addedItem) {
                    
                    [weakSelf hideHUD];
                    
                    [[Session sharedInstance] setShoppingCartGoods:totalNum addedItem:addedItem];
                    
                    //                    [WCAlertView showAlertWithTitle:@"恭喜您" message:@"加入购物袋成功" customizationBlock:^(WCAlertView *alertView) {
                    //
                    ////                        alertView.buttonTextColor = [UIColor colorWithHexString:@"c2a79d"];
                    ////                        alertView.style = WCAlertViewStyleCustomizationBlock;
                    //                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    //                        if (buttonIndex == 0) {
                    //
                    //                        } else {
                    //                            //这里执行代码
                    //                            ShoppingCartViewController *shopViewController = [[ShoppingCartViewController alloc] init];
                    //                            [self pushViewController:shopViewController animated:YES];
                    //                        }
                    //                    } cancelButtonTitle:@"继续逛" otherButtonTitles:@"去付款", nil];
                    
                    //加入购物袋立即购买
                    //                    weakSelf.blackView.alpha = 0;
                    //                    weakSelf.addBagView.alpha = 0;
                    //                    weakSelf.blackView.hidden = NO;
                    //                    weakSelf.addBagView.hidden = NO;
                    //                    [UIView animateWithDuration:0.25 animations:^{
                    //                        weakSelf.blackView.alpha = 0.7;
                    //                        weakSelf.addBagView.alpha = 1;
                    //                    }];
                    
                    _animationImage = [[UIImageView alloc] init];
                    _animationImage.image = [UIImage imageNamed:@"shoppingAnimation"];
                    [self.view addSubview:self.animationImage];
                    [self.animationImage mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(self.view);
                    }];
                    
                    
                    self.animationImage.hidden = NO;
                    CGRect parentRectA = CGRectMake(kScreenWidth/2, kScreenHeight/2, 20, 20);
                    CGRect parentRectB = [self.view convertRect:self.shoppingCartBtn.frame toView:self.view];
                    UIBezierPath *path= [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(parentRectA.origin.x, parentRectA.origin.y)];
                    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+25,  parentRectB.origin.y+25) controlPoint:CGPointMake(parentRectA.origin.x + 100, parentRectA.origin.y + 100)];
                    [[ParabolaTool sharedTool] throwObject:self.animationImage  path:path isRotation:YES endScale:0.3];
                    
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
                
            } else {
                LoginViewController *viewController = [[LoginViewController alloc] init];
                //                CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
                viewController.title = @"登录";
                UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
                [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
                    
                }];
            }
        } else {
            [weakSelf showHUD:[NSString stringWithFormat:@"商品%@",[weakSelf.detailInfo.goodsInfo statusDescription]] hideAfterDelay:0.8f];
        }
        
        [MobClick event:@"click_add_to_chart_from_detail"];
    };
    
    buyBtn.handleClickBlock = ^(CommandButton *sender) {
        
        if (weakSelf.canPay == 0 && weakSelf.goodsInfo.supportType == 1) {
            
            [weakSelf.view addSubview:self.inviteBlackView];
            [weakSelf.view addSubview:self.wristInviteView];
            weakSelf.inviteBlackView.alpha = 0;
            weakSelf.wristInviteView.alpha = 0;
            [self.wristInviteView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.centerY.equalTo(self.view.mas_centerY);
                //                make.width.equalTo(@(kScreenWidth-58*2));
                make.left.equalTo(self.view.mas_left).offset(kScreenWidth/375*40);
                make.right.equalTo(self.view.mas_right).offset(-(kScreenWidth/375*40));
                make.height.equalTo(@(kScreenWidth/375*152));
            }];
            
            self.wristInviteView.inviteDiss = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.wristInviteView.alpha = 0;
                    weakSelf.inviteBlackView.alpha = 0;
                } completion:^(BOOL finished) {
                    //                    [weakSelf.wristInviteView removeFromSuperview];
                    //                    [weakSelf.inviteBlackView removeFromSuperview];
                }];
            };
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.inviteBlackView.alpha = 0.7;
                weakSelf.wristInviteView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
            return ;
        }
        
        if ([weakSelf.detailInfo.goodsInfo isOnSale])  {
            if ([[Session sharedInstance] isLoggedIn]) {
                NSMutableArray *items = [[NSMutableArray alloc] init];
                [items addObject:[ShoppingCartItem createWithGoodsInfo:weakSelf.detailInfo.goodsInfo]];
                
                weakSelf.payViewController = [[PayViewController alloc] init];
                weakSelf.payViewController.items = items;
                weakSelf.payViewController.goodsInfo = weakSelf.detailInfo.goodsInfo;
                weakSelf.payViewController.handlePayDidFnishBlock = ^(BaseViewController*payViewController, NSInteger index) {
                    [weakSelf.payViewController dismiss:NO];
                    weakSelf.payViewController.handlePayDidFnishBlock = nil;
                    weakSelf.payViewController = nil;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIViewController *currentVC = [CoordinatingController sharedInstance].visibleController;
                        if (![currentVC isKindOfClass:[BoughtCollectionViewController class]]) {
                            PayViewController *payController = (PayViewController *)payViewController;
                            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
                            viewController.goonWithPayController = 1;
                            [ClientReportObject clientReportObjectWithViewCode:GoodsDetailReferPageCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:@{@"goodsId":weakSelf.goodsId}];
                            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                        }
                    });
                    
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                        UIViewController *currentVC = [CoordinatingController sharedInstance].visibleController;
                    //                        if (![currentVC isKindOfClass:[BoughtViewController class]]) {
                    //                            BoughtViewController *viewController = [[BoughtViewController alloc] init];
                    //                            [weakSelf pushViewController:viewController animated:YES];
                    //                        }
                    //                    });
                };
                [ClientReportObject clientReportObjectWithViewCode:GoodsDetailReferPageCode regionCode:MineSureOrderViewCode referPageCode:MineSureOrderViewCode andData:@{@"goodsId":weakSelf.goodsId}];
                [weakSelf pushViewController:weakSelf.payViewController animated:YES];
            }
            else {
                LoginViewController *viewController = [[LoginViewController alloc] init];
                //                CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
                viewController.title = @"登录";
                UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
                [ClientReportObject clientReportObjectWithViewCode:GoodsDetailReferPageCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
                [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
                    
                }];
            }
        } else {
            
            if ([weakSelf.detailInfo.goodsInfo isLocked] && weakSelf.detailInfo.orderLockInfo) {
                if (weakSelf.detailInfo.orderLockInfo.buyerId == [Session sharedInstance].currentUserId) {
                    
                    if ([weakSelf.navigationController.viewControllers count]>1) {
                        UIViewController *viewController = [weakSelf.navigationController.viewControllers objectAtIndex:[weakSelf.navigationController.viewControllers count]-2];
                        if ([viewController isKindOfClass:[BoughtCollectionViewController class]]) {
                            [weakSelf dismiss];
                            return;
                        }
                    }
                    BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
                    [ClientReportObject clientReportObjectWithViewCode:GoodsDetailReferPageCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:@{@"goodsId":weakSelf.goodsId}];
                    [weakSelf pushViewController:viewController animated:YES];
                    
                } else {
                    [weakSelf showHUD:[NSString stringWithFormat:@"商品%@",@"已被抢"] hideAfterDelay:0.8f];
                }
            } else {
                [weakSelf showHUD:[NSString stringWithFormat:@"商品%@",[weakSelf.detailInfo.goodsInfo statusDescription]] hideAfterDelay:0.8f];
            }
        }
        
        [MobClick event:@"click_buynow"];
    };
    chatBtn.handleClickBlock = ^(CommandButton *sender) {
        
        if (sender.tag == 1) {
            NSInteger userId = [Session sharedInstance].currentUserId;
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"bind_adviser" parameters:@{@"user_id":[NSNumber numberWithInteger:userId]} completionBlock:^(NSDictionary *data) {
                
                AdviserPage *adviser = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                [UserSingletonCommand chatWithUserHasWXNum:adviser.userId msg:[NSString stringWithFormat:@"%@", adviser.greetings] adviser:adviser nadGoodsId:weakSelf.detailInfo.goodsInfo.goodsId];
                
            } failure:^(XMError *error) {
                [self showHUD:[error errorMsg] hideAfterDelay:0.8];
            } queue:nil]];
            
        } else {
            [UserSingletonCommand chatBalance:weakSelf.detailInfo.goodsInfo.goodsId];
        }
        
        [MobClick event:@"click_chat_from_detail"];
    };
    return bottomView;
}

- (void)animationDidFinish
{
    [self.animationImage removeFromSuperview];
    [self.shoppingCartBtn popOutsideWithDuration:0.5];
    [self.shoppingCartBtn animate];
}


- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    if (isLoggedIn) {
        [MobClick event:@"click_shopping_chart_from_detail"];
        
        if ([self.navigationController.viewControllers count]>1) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
            if ([viewController isKindOfClass:[ShoppingCartViewController class]]) {
                [self dismiss];
                return;
            }
        }
        ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }
}



- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)tabView:(GoodsDetailHeaderTabView*)view displayTabAtIndex:(NSInteger)index
{
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
    
    /**
     类似淘宝详情页的tableHeaderView视觉滑动差得效果
     
     if (scrollView == _tableView
     && [self.tableView.tableHeaderView isKindOfClass:[ParallaxHeaderView class]])
     {
     // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
     [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
     }
     */
    
    UIView *backBtn = [self.view viewWithTag:1000];
    UIView *shoppingCartBtn = [self.view viewWithTag:101];
    UIView *shareBtn = [self.view viewWithTag:110];
    
    CGFloat currentPosition = scrollView.contentOffset.y;
    if (currentPosition<=20) {
        //        self.topBar.alpha = 0.f;
        UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        backBtn.backgroundColor = bgColor;
        shoppingCartBtn.backgroundColor = bgColor;
        shareBtn.backgroundColor = bgColor;
    } else {
        if (currentPosition>=200.f) {
            //            self.topBar.alpha = 1.f;
            UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            backBtn.backgroundColor = bgColor;
            shoppingCartBtn.backgroundColor = bgColor;
            shareBtn.backgroundColor = bgColor;
        } else {
            //            self.topBar.alpha = currentPosition/200.f;
            
            UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f*(1.f-currentPosition/200.f)];
            backBtn.backgroundColor = bgColor;
            shoppingCartBtn.backgroundColor = bgColor;
            shareBtn.backgroundColor = bgColor;
        }
    }
    
    
    
    //    NSLog(@"%.2f", scrollView.contentOffset.y);
    
    //    if (kScreenHeight == 667) {
    if (scrollView.contentOffset.y >= kScreenWidth - 64) {
        //            [UIView animateWithDuration:0.25 animations:^{
        //                self.topBar.alpha = 1;
        //
        //            }];
        [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
        //            self.shareBtn.hidden = NO;
        //            self.shoppingCartBtn.hidden = NO;
        //            self.backBtn.hidden = NO;
        //            self.goodsNumLbl.hidden = NO;
        self.sopportBtn.hidden = NO;
        self.sopportBtn1.hidden = YES;
        //            [_backBtn1 setImage:[UIImage imageNamed:@"backBtnTwo-MF"] forState:UIControlStateNormal];
    } else {
        //            [UIView animateWithDuration:0.25 animations:^{
        //                self.topBar.alpha = 0;
        //            }];
        //            self.shareBtn.hidden = YES;
        //            self.shoppingCartBtn.hidden = YES;
        //            self.backBtn.hidden = YES;
        //            self.goodsNumLbl.hidden = YES;
        self.sopportBtn.hidden = YES;
        self.sopportBtn1.hidden = NO;
        //            [_backBtn1 setImage:[UIImage imageNamed:@"backBtn-MF"] forState:UIControlStateNormal];
    }
    
    if (self.controllerContainer) {
        [self.controllerContainer scrollViewDidScrollFromGoodsDetail:scrollView];
    }
    
    if (scrollView.contentOffset.y >= self.picOffSet && scrollView.contentOffset.y < self.hiddeOffSet) {
        self.headerChooseView.hidden = NO;
    } else {
        self.headerChooseView.hidden = YES;
    }
    
    if (scrollView.contentOffset.y >= self.picOffSet && scrollView.contentOffset.y < self.paraOffSet-10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelecteIndex" object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelctCellIndex" object:@(1)];
    } else if (scrollView.contentOffset.y >= self.paraOffSet-10 && scrollView.contentOffset.y < self.guardOffSet-10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelecteIndex" object:@(2)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelctCellIndex" object:@(2)];
    } else if (scrollView.contentOffset.y >= self.guardOffSet-10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelecteIndex" object:@(3)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelctCellIndex" object:@(3)];
    }
    
    //    - (void)scrollViewDidScrollFromGoodsDetail:(UIScrollView *)scrollView
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"%.2f", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y < kScreenWidth / 2 - 10) {
//        [self.tableView scrollViewToTop:YES];
//    } else if (scrollView.contentOffset.y > kScreenWidth / 2 - 10 && scrollView.contentOffset.y < kScreenWidth + 10) {
//        CGPoint offset = CGPointMake(0, kScreenWidth);
//        [self.tableView setContentOffset:offset animated:YES];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
//    NSLog(@"%.2f", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y < kScreenWidth / 2 - 10) {
//        [self.tableView scrollViewToTop:YES];
//    } else if (scrollView.contentOffset.y > kScreenWidth / 2 - 10 && scrollView.contentOffset.y < kScreenWidth + 10) {
//        CGPoint offset = CGPointMake(0, kScreenWidth);
//        [self.tableView setContentOffset:offset animated:YES];
//    }
}



- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    _tableView.pullTableIsRefreshing = YES;
    [self reloadData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources?[self.dataSources count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([tableViewCell isKindOfClass:[GoodsDetailBaseInfoCell class]]) {
            UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
            [tableViewCell addGestureRecognizer:longPressGesture];
        } else if ([tableViewCell isKindOfClass:[GoodsDetailStoryCell class]]) {
            UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(summerCellLongPress:)];
            [tableViewCell addGestureRecognizer:longPressGesture];
        }
    }
    [tableViewCell updateCellWithDict:dict];
    
    if ([tableViewCell isKindOfClass:[GoodsDetailServeTagsCell class]]) {
        ((GoodsDetailServeTagsCell *)tableViewCell).handleMoreBtnClicked = ^(){
            
            [weakSelf.view addSubview:weakSelf.bgView];
            [weakSelf.view addSubview:weakSelf.tagsExplainView];
            [weakSelf.tagsExplainView getTagsArr:weakSelf.detailInfo.goodsInfo.seller.autotrophyGoodsVo.promiseList];
            weakSelf.bgView.alpha = 0;
            weakSelf.bgView.dissMissBlackView = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.tagsExplainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 310);
                    weakSelf.bgView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.tagsExplainView removeFromSuperview];
                    [weakSelf.bgView removeFromSuperview];
                }];
            };
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.bgView.alpha = 0.7;
                weakSelf.tagsExplainView.frame = CGRectMake(0, kScreenHeight-310, kScreenWidth, 310);
            }];
        };
    }
    
    if ([tableViewCell isKindOfClass:[GoodsDetailBaseInfoCell class]]) {
        GoodsDetailBaseInfoCell *baseInfoCell = (GoodsDetailBaseInfoCell*)tableViewCell;
        _likeBtnView = baseInfoCell.likeBtnView;
        baseInfoCell.handlegradeTagBlock =^(GoodsGradeTag * gradeTagVo){
           GoodsGradeHUDView * goodGradeHUDView = [GoodsGradeHUDView show];
            [goodGradeHUDView getGradeTag:gradeTagVo];
        };
    }
    else if ([tableViewCell isKindOfClass:[GoodsMoreCommentsCell class]]) {
        ((GoodsMoreCommentsCell*)tableViewCell).handleMoreCommentsBlock = ^() {
            //            GoodsDetailTopBarIndicatorView *tabBar = (GoodsDetailTopBarIndicatorView*)[super.topBar viewWithTag:10222];;
            //            tabBar.tag = 10222;
            //            [tabBar setTabAtIndex:1 animated:YES];
            //            if (weakSelf.controllerContainer) {
            //                [weakSelf.controllerContainer.pagesContainerView setSelectedIndex:1 animated:YES];
            //            }
            if (weakSelf.controllerContainer) {
                //                [weakSelf.controllerContainer setViewControllerAtIndex:1 animated:YES];
                GoodsCommentsViewController *commentsViewController = [[GoodsCommentsViewController alloc] init];
                commentsViewController.goodsId = self.goodsId;
                commentsViewController.title = @"评论";
                [weakSelf pushViewController:commentsViewController animated:YES];
            }
        };
    }
    else if ([tableViewCell isKindOfClass:[GoodsCommentTitleCell class]]) {
        //        ((GoodsCommentTitleCell*)tableViewCell).handleAddCommentsBlock = ^() {
        //            [weakSelf.toolBar  beginEditing];
        //        };
        ((GoodsCommentTitleCell*)tableViewCell).delegateTextField = self;
        
    }
    else if ([tableViewCell isKindOfClass:[CommentTableViewCell class]]) {
        ((CommentTableViewCell*)tableViewCell).handleDelCommentBlock = ^(CommentVo *comment) {
            [weakSelf showProcessingHUD:nil];
            [GoodsService comment_delete:comment.comment_id completion:^{
                [weakSelf hideHUD];
                SEL selector = @selector($$handleGoodsCommentDeleted:commentId:);
                MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:comment.comment_id]);
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    else if ([tableViewCell isKindOfClass:[GoodsDetailAppoveTagsCell class]]) {
        ((GoodsDetailAppoveTagsCell*)tableViewCell).handleMoreBtnClicked = ^() {
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.title = @"";
            viewController.url = @"http://activity.aidingmao.com/help/service";
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
    }
    
    else if ([tableViewCell isKindOfClass:[GoodsNoCommentsCell class]]) {
        ((GoodsNoCommentsCell*)tableViewCell).handleAddCommentsBlock = ^() {
            [weakSelf.toolBar  beginEditing];
        };
    }
    
    else if ([tableViewCell isKindOfClass:[SegTabViewTitleCell class]]) {
        SegTabViewTitleCell *baseInfoCell = (SegTabViewTitleCell*)tableViewCell;
        baseInfoCell.handleShareCommentsBlock = ^(){
            [weakSelf shareGoods];
        };
        
        baseInfoCell.handleShopCommentsBlock = ^(CommandButton *sender){
            [weakSelf handleTopBarRightButtonClicked:sender];
        };
        
        baseInfoCell.handleSupportCommentsBlock = ^(GoodsInfo *goodsInfo){
            //            if (goodsInfo.isLiked == 1) {
            //                weakSelf.sopportBtn.selected = YES;
            //            } else {
            //                weakSelf.sopportBtn.selected = NO;
            //            }
            [weakSelf clickSopportBtn];
        };
    }
    
    else if ([tableViewCell isKindOfClass:[WristwatchRecoveryCell class]]) {
        WristwatchRecoveryCell *wristwatchCell = (WristwatchRecoveryCell *)tableViewCell;
        wristwatchCell.wristDelegate = self;
    }
    
    //    else if ([tableViewCell isKindOfClass:[GoodsCommentTitleCell class]]) {
    //        GoodsCommentTitleCell *titleCell = (GoodsCommentTitleCell *)tableViewCell;
    //        [titleCell updateCellWithDetailDict: weakSelf.detailInfo];
    //    }
    
    else if ([tableViewCell isKindOfClass:[BuyBackCell class]]) {
        BuyBackCell * buyBackCell = (BuyBackCell *)tableViewCell;
        buyBackCell.rtLabelSelect = ^(NSURL * url){
            
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = [url absoluteString];
            viewController.title = @"原价回购标准";
            [self pushViewController:viewController animated:YES];
        };
    }else if ([tableViewCell isKindOfClass:[DeliveryExplainCell class]]){
        DeliveryExplainCell * deliver =(DeliveryExplainCell *)tableViewCell;
        deliver.handleWashBlock = ^(NSString * url){
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = url;
            [self pushViewController:viewController animated:YES];
        };
    } else if ([tableViewCell isKindOfClass:[GoodsPictureCell class]]) {
        GoodsPictureCell *pictureCell = (GoodsPictureCell *)tableViewCell;
        pictureCell.showPicDetail = ^(XMWebImageView *imageView){
            [weakSelf didClickViewPage:imageView imageViewArray:weakSelf.imageViews];
        };
    } else if ([tableViewCell isKindOfClass:[GoodsTotalInfCell class]]) {
        GoodsTotalInfCell *cell = (GoodsTotalInfCell *)tableViewCell;
        cell.scrollTableInfIndexP = ^(NSInteger index){
            if (index == 1) {
                CGPoint offset = CGPointMake(0, weakSelf.picOffSet);
                [weakSelf.tableView setContentOffset:offset animated:YES];
            } else if (index == 2) {
                CGPoint offset = CGPointMake(0, weakSelf.paraOffSet);
                [weakSelf.tableView setContentOffset:offset animated:YES];
            } else if (index == 3){
                CGPoint offset = CGPointMake(0, weakSelf.guardOffSet);
                [weakSelf.tableView setContentOffset:offset animated:YES];
            }
        };
    } else if ([tableViewCell isKindOfClass:[GoodsAboutCell class]]){
        GoodsAboutCell * cell = (GoodsAboutCell *)tableViewCell;
        cell.handleDoubtImageViewBlock =^(){
            
            [weakSelf.view addSubview:weakSelf.bgView];
            [weakSelf.view addSubview:weakSelf.goodsGradeexPlainView];
            [weakSelf.goodsGradeexPlainView getGoodsGradeDataSources:self.goodsInfo.gradeVoList.gradeItemList title:self.goodsInfo.gradeVoList.title];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.bgView.alpha = 0.7;
                _goodsGradeexPlainView.frame = CGRectMake(0, kScreenHeight-435, kScreenWidth, 435);
            }];
            weakSelf.bgView.dissMissBlackView = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.bgView.alpha = 0;
                    _goodsGradeexPlainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 435);
                } completion:^(BOOL finished) {
                    [weakSelf.bgView removeFromSuperview];
                    [weakSelf.goodsGradeexPlainView removeFromSuperview];
                }];
            };
        };
    }

    return tableViewCell;
}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [_scrollImageView setCurrentPage:index];
}

- (void)didClickViewPage:(UIImageView *)imageView imageViewArray:(NSArray*)imageViewArray
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.gallaryItems count]];
    //    for (NSInteger i=0;i< [self.gallaryItems count];i++) {
    //
    //        GoodsGallaryItem *item = (GoodsGallaryItem*)[self.gallaryItems objectAtIndex:i];
    //        MJPhoto *photo = [[MJPhoto alloc] init];
    //        NSString *QNDownloadUrl = nil;
    //        //        if (item.width>0&&item.height>0) {
    //        //            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2.5, item.width/kScreenWidth*item.height*2.5)];
    //        //        } else {
    //        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale750x750];
    //        //        }
    //
    //        //        QNDownloadUrl = item.picUrl;
    //
    //        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
    //        if (i<imageViewArray.count) {
    //            photo.srcImageView = [imageViewArray objectAtIndex:i];
    //        } else {
    //            photo.srcImageView = imageView; // 来源于哪个UIImageView
    //        }
    //        [photos addObject:photo];
    //    }
    
    for (GoodsGallaryItem *item in self.gallaryItems) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        NSString *QNDownloadUrl = nil;
        if (item.width>0&&item.height>0) {
            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2.5, item.width/kScreenWidth*item.height*2.5)];
        } else {
            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale640x640];
        }
        
        QNDownloadUrl = item.picUrl;
        
        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    if ([photos count]>0) {
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.isHaveGoodsDetailBtn = 1;
        browser.currentPhotoIndex = imageView.tag-1; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }
}

-(void)summerCellLongPress:(UIGestureRecognizer *)recognizer{
    if (self.detailInfo.goodsInfo.summary) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.detailInfo.goodsInfo.summary;;
        
        [self showHUD:@"商品描述已复制" hideAfterDelay:0.8f];
    }
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.detailInfo.goodsInfo.goodsName) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.detailInfo.goodsInfo.goodsName;;
            
            [self showHUD:@"商品标题已复制" hideAfterDelay:0.8f];
        }
        
        //        GoodsDetailBaseInfoCell *cell = (GoodsDetailBaseInfoCell *)recognizer.view;
        //        [cell becomeFirstResponder];
        //
        //        CGRect frame = cell.frame;
        //        frame.origin.y += 20;
        //
        //        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制商品标题" action:@selector(handleCopyCell:)];
        //        UIMenuController *menu = [UIMenuController sharedMenuController];
        //        [menu setMenuItems:[NSArray arrayWithObjects:itCopy, nil]];
        //        [menu setTargetRect:frame inView:_tableView];
        //        [menu setMenuVisible:YES animated:YES];
    }
}
- (void)handleCopyCell:(id)sender{//复制cell
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.detailInfo.goodsInfo.goodsName;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    
    if (ClsTableViewCell == [GoodsAboutCell class]) {
        
    }
    
    if (ClsTableViewCell == [GoodsDetailPictureCell class]) {
        WEAKSELF;
        
        GoodsDetailPicItem *clickedPicItem = (GoodsDetailPicItem*)[dict objectForKey:[GoodsDetailPictureCell cellDictKeyForGoodsPicture]];
        if ([clickedPicItem isKindOfClass:[GoodsDetailPicItem class]] && [clickedPicItem.picUrl length]>0)
        {
            NSInteger currentPhotoIndex = 0;
            NSInteger photoCount = 0;
            
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[weakSelf.detailInfo detailPicItems].count];
            
            for (NSInteger i=0;i<[weakSelf.detailInfo detailPicItems].count;i++) {
                
                GoodsDetailPicItem *detailPicItem = [[weakSelf.detailInfo detailPicItems] objectAtIndex:i];
                
                if ([detailPicItem.picUrl length]>0
                    && detailPicItem.width>0
                    && detailPicItem.height>0) {
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    
                    
                    CGFloat height = kScreenWidth/detailPicItem.width*detailPicItem.height;
                    
                    NSString *QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:detailPicItem.picUrl
                                                                            isWebP:NO
                                                                              size:CGSizeMake(kScreenWidth*2,kScreenWidth*height/320*2)] ;
                    photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
                    photo.srcImageView = ((GoodsDetailPictureCell *)[tableView cellForRowAtIndexPath:indexPath]).picView;
                    [photos addObject:photo];
                    
                    if ([detailPicItem.picUrl isEqualToString:clickedPicItem.picUrl]) {
                        currentPhotoIndex = photoCount;
                    }
                    
                    photoCount++;
                }
            }
            
            if ([photos count]>0)
            {
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.photos = photos; // 设置所有的图片
                browser.currentPhotoIndex = currentPhotoIndex; // 弹出相册时显示的第一张图片是？
                [browser show];
            }
        }
    }
    else if (ClsTableViewCell == [ImageDescGroupTitleTableViewCell class]) {
        ImageDescGroup *imageDescGroup = [dict objectForKey:[ImageDescGroupTitleTableViewCell cellDictKeyForImageDescGroup]];
        if ([imageDescGroup isKindOfClass:[ImageDescGroup class]]) {
            if (imageDescGroup.isExpandable) {
                imageDescGroup.isExpanded = !imageDescGroup.isExpanded;
                WEAKSELF;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf updateTableView];
                });
            }
        }
    }
    else if (ClsTableViewCell == [ImageDescTableViewCell class]) {
        ImageDescDO *imageDescDO = [dict objectForKey:[ImageDescTableViewCell cellDictKeyForImageDescDO]];
        if ([imageDescDO isKindOfClass:[ImageDescDO class]]) {
            if ([imageDescDO.redirectUri length]>0) {
                [URLScheme locateWithRedirectUri:imageDescDO.redirectUri  andIsShare:YES];
            }
        }
    }
    else if (ClsTableViewCell == [GoodsAttributesButtonCell class]) {
        [GoodsAttributesPopupView showInView:self.view detailInfo:self.detailInfo];
    }
    else if (ClsTableViewCell == [CommentTableViewCell class]) {
        CommentVo *comment = (CommentVo*)[dict objectForKey:[CommentTableViewCell cellKeyForComment]];
        if (comment.user_id == [Session sharedInstance].currentUserId) {
            self.reply_user_id = 0;
            self.toolBar.inputTextView.placeHolder = @"评论";
            [self.toolBar beginEditing];
        } else {
            self.reply_user_id = comment.user_id;
            self.toolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复 %@", comment.username];
            [self.toolBar beginEditing];
        }
    }  else if (ClsTableViewCell == [GoodsDetailSelfEngageCell class]) {
        GoodsDetailInfo *detailInfo = dict[@"detailInfo"];
        if (detailInfo.goodsInfo.seller.autotrophyGoodsVo.redirectUrl.length > 0) {
            [URLScheme locateWithRedirectUriImpl:detailInfo.goodsInfo.seller.autotrophyGoodsVo.redirectUrl andIsShare:YES];
        } else {
            ADMShoppingCentreViewController *AMDShoppingCenter = [[ADMShoppingCentreViewController alloc] init];
            AMDShoppingCenter.userId = detailInfo.goodsInfo.seller.userId;
            [self pushViewController:AMDShoppingCenter animated:YES];
        }
    } else if (ClsTableViewCell == [WeixinCopyCell class]) {
        
        
        if (self.adviserPage.weixinId.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.adviserPage.weixinId];
            [self showHUD:@"微信已复制" hideAfterDelay:0.8];
        } else {
            [self showHUD:@"此顾问暂无微信号" hideAfterDelay:0.8];
        }
        
    } else if (ClsTableViewCell == [BeuseQuanGoodsCell class]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.quanBgView.alpha = 0.7;
            self.quanView.frame = CGRectMake(0, kScreenHeight-143-(2 * 72), kScreenWidth, 143+(2 * 72));
        }];
        
    }
}

- (void)$$handleGoodsInfoChanged:(id<MBNotification>)notifi goodsIds:(NSArray*)goodsIds
{
    WEAKSELF;
    if (notifi.key == (NSUInteger)weakSelf) return;
    
    for (NSString *goodsId in goodsIds) {
        if ([goodsId isEqualToString:weakSelf.goodsId]) {
            [weakSelf updateBottomViewWithGoodsInfo:[[GoodsMemCache sharedInstance] dataForKey:goodsId]];
            [weakSelf updateHeaderViewWithGoodsDetail:nil];
            [weakSelf updateTableView];
            break;
        }
    }
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    //    [self updateGoodsNumLbl:0];
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    //    [self updateGoodsNumLbl:0];
}

- (void)$$handleShoppingCartSyncFinishedNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    WEAKSELF;
    BOOL isEabled = ![[Session sharedInstance] isExistInShoppingCart:weakSelf.goodsId];
    
    weakSelf.addCartBtn.enabled = isEabled;
    //    if (isEabled) {
    //        weakSelf.addCartBtn.backgroundColor = [UIColor colorWithHexString:@"150c0f"];//898989//[UIColor colorWithHexString:@"b2873e"];
    //    } else {
    //        weakSelf.addCartBtn.backgroundColor = [UIColor colorWithHexString:@"150c0f"];//[UIColor colorWithHexString:@"999999"];
    //    }
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi addedItem:(ShoppingCartItem*)item
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi removedGoodsIds:(NSArray*)goodsIds
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

- (void)$$handleGoodsStatusUpdated:(id<MBNotification>)notifi goodStatusArray:(NSArray*)goodStatusArray
{
    for (GoodsStatusDO *statusDO in goodStatusArray) {
        if ([self.detailInfo.goodsInfo.goodsId isEqualToString:statusDO.goodsId]) {
            [self.detailInfo.goodsInfo updateWithStatusInfo:statusDO];
            if (statusDO.status==GOODS_STATUS_LOCKED) {
                if (!self.detailInfo.orderLockInfo) {
                    OrderLockInfo *info = [[OrderLockInfo alloc] init];
                    info.remainTime = statusDO.orderLockInfo&&statusDO.orderLockInfo.remainTime>0?statusDO.orderLockInfo.remainTime:20*60;
                    info.buyerId = [Session sharedInstance].currentUserId;
                    info.orderId = nil;
                    self.detailInfo.orderLockInfo = info;
                }
            }
            [self updateHeaderViewWithGoodsDetail:self.detailInfo];
            [self updateBottomViewWithGoodsInfo:self.detailInfo.goodsInfo];
            break;
        }
    }
}

- (void)$$handleFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if ([userId integerValue]==self.detailInfo.goodsInfo.seller.userId) {
        self.detailInfo.goodsInfo.seller.isfollowing = YES;
        [self.tableView reloadData];
    }
}

- (void)$$handleUnFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if ([userId integerValue]==self.detailInfo.goodsInfo.seller.userId) {
        self.detailInfo.goodsInfo.seller.isfollowing = NO;
        [self.tableView reloadData];
    }
}




#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    
}

- (void)didSendFaceWithText:(NSString *)text
{
    WEAKSELF;
    if ([weakSelf.toolBar.inputTextView isFirstResponder]) {
        [weakSelf.view endEditing:YES];
        [weakSelf.toolBar endEditing:YES];
    }
    
    NSString *content = [self.toolBar.inputTextView.text trim];
    if ([content length]>0|| [weakSelf.attachContainerView.attachments count]>0) {
        [weakSelf showProcessingHUD:nil];
        
        [GoodsService comment_publish:weakSelf.goodsId
                        reply_user_id:weakSelf.reply_user_id
                              content:content
                          attachments:weakSelf.attachContainerView.attachments completion:^(CommentVo *commentVo)
         {
             [weakSelf showHUD:@"评论成功" hideAfterDelay:0.8f];
             
             [weakSelf.attachContainerView clear];
             
             GoodsCommentVoWrapper *obj = [[GoodsCommentVoWrapper alloc] init];
             obj.goodsId = weakSelf.goodsId;
             obj.comment = commentVo;
             SEL selector = @selector($$handleGoodsCommentAdd:comment:);
             MBGlobalSendNotificationForSELWithBody(selector, obj);
             
             weakSelf.reply_user_id = 0;
             
             weakSelf.toolBar.inputTextView.placeHolder = @"评论";
             weakSelf.toolBar.inputTextView.text = @"";
             [weakSelf.toolBar textViewDidChange:weakSelf.toolBar.inputTextView];
             
             [weakSelf.view endEditing:YES];
             [weakSelf.toolBar endEditing:YES];
             
         } failure:^(XMError *error) {
             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
         }];
    }
}

- (void)$$handleGoodsCommentAdd:(id<MBNotification>)notifi comment:(GoodsCommentVoWrapper*)commentWrapper
{
    WEAKSELF;
    if ([commentWrapper.goodsId isEqualToString:self.goodsId]) {
        if (!weakSelf.commentsList) {
            weakSelf.commentsList  = [[NSMutableArray alloc] init];
        }
        [weakSelf.commentsList insertObject:commentWrapper.comment atIndex:0];
        [weakSelf updateTableView];
    }
}

- (void)$$handleGoodsCommentDeleted:(id<MBNotification>)notifi commentId:(NSNumber*)commentId
{
    for (NSInteger i=0;i<[self.commentsList count];i++) {
        CommentVo *comment = [self.commentsList objectAtIndex:i];
        if (comment.comment_id == [commentId integerValue]) {
            [self.commentsList removeObjectAtIndex:i];
            [self updateTableView];
            break;
        }
    }
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    
}

- (void)moreViewGoodsAction:(DXChatBarMoreView *)moreView
{
    //    [self.view endEditing:YES];
    //    [self.toolBar endEditing:YES];
    
    if ([Session sharedInstance].currentUser.type==1) {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.delegate = self;
        viewController.isForSelected = YES;
        [self pushViewController:viewController animated:YES];
    } else {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.delegate = self;
        viewController.isForSelected = YES;
        viewController.sellerId = [Session sharedInstance].currentUserId;
        [self pushViewController:viewController animated:YES];
    }
}

- (void)searchViewGoodsSelected:(SearchViewController*)viewController recommendGoods:(RecommendGoodsInfo*)recommendGoodsInfo
{
    ForumAttachItemGoodsVO *attachGoodsVO = [[ForumAttachItemGoodsVO alloc] init];
    attachGoodsVO.goods_id = recommendGoodsInfo.goodsId;
    attachGoodsVO.goods_name = recommendGoodsInfo.goodsName;
    
    ForumAttachmentVO *attachmentVO = [[ForumAttachmentVO alloc] init];
    attachmentVO.type = ForumAttachTypeGoods;
    attachmentVO.item = attachGoodsVO;
    
    [_attachContainerView attachItem:attachmentVO];
    
    [viewController dismiss];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    
}

@end

@interface GoodsDetailHeaderTabView ()

@property(nonatomic,strong) UIButton *detailBtn;
@property(nonatomic,strong) UIButton *attrBtn;
@property(nonatomic,strong) UIButton *commntBtn;
@property(nonatomic,strong) CALayer *bottomLine;

@property(nonatomic,strong) TabIndicatorView *indicatorView;
@end

@implementation GoodsDetailHeaderTabView

+ (CGFloat)heightForOrientationPortrait {
    return 45.f;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.detailBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [self.detailBtn setTitleColor:[DataSources globalBlackColor] forState:UIControlStateNormal];
        self.detailBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        self.detailBtn.tag = 0;
        [self.detailBtn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.detailBtn];
        
        self.attrBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.attrBtn setTitle:@"参数" forState:UIControlStateNormal];
        [self.attrBtn setTitleColor:[DataSources globalBlackColor] forState:UIControlStateNormal];
        self.attrBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        self.attrBtn.tag = 1;
        [self.attrBtn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.attrBtn];
        
        //        self.commntBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        //        [self.commntBtn setTitle:@"评论" forState:UIControlStateNormal];
        //        [self.commntBtn setTitleColor:[DataSources globalBlackColor] forState:UIControlStateNormal];
        //        self.commntBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        //        self.commntBtn.tag = 2;
        //        [self.commntBtn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:self.commntBtn];
        
        self.bottomLine = [CALayer layer];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"].CGColor;
        [self.layer addSublayer:self.bottomLine];
        
        self.indicatorView = [[TabIndicatorView alloc] initWithFrame:CGRectNull tabCount:2];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)layoutSubviews
{
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width/2;
    
    CGFloat marginLeft = 0.f;
    self.detailBtn.frame = CGRectMake(marginLeft, 0, width, height);
    marginLeft += width;
    self.attrBtn.frame = CGRectMake(marginLeft, 0, width, height);
    marginLeft += width;
    //    self.commntBtn.frame = CGRectMake(marginLeft, 0, width, height);
    //    marginLeft += width;
    
    self.indicatorView.frame = CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2);
    
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
}

- (void)switchTab:(UIButton*)sender
{
    if (sender.tag == 0) {
        [MobClick event:@"click_introduction_from_detail"];
    } else {
        [MobClick event:@"click_parameters_from_detail"];
    }
    
    [self setCurTabIndex:sender.tag];
}

- (void)setCurTabIndex:(NSInteger)index
{
    if ([_indicatorView curTabIndex]!=index) {
        [_indicatorView setCurTabIndex:index];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:displayTabAtIndex:)]) {
            [self.delegate tabView:self displayTabAtIndex:index];
        }
    }
}

- (NSInteger)curTabIndex {
    return [_indicatorView curTabIndex];
}

@end


@interface GoodsDetailHeaderView () <ASScrollViewDelegate,GoodsStatusMaskViewDelegate,MJPhotoBrowserDelegate>

@property (nonatomic, strong) ASScroll *scrollImageView;
@property (nonatomic, strong)NSArray *gallaryItems;
@property(nonatomic,strong) CommandButton *shareBtn;
@property(nonatomic,strong) TapDetectingView *shareBtnBgView;

@property(nonatomic,copy) NSString *goodsId;

@property (nonatomic, strong) GoodsStatusMaskView *statusView;
@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,strong) HTTPRequest *queryStatusRequest;

@property (nonatomic, strong) UIImageView *wristwatchImageView;

@property (nonatomic, strong) GoodsInfo *goodsInfo;
@end

@implementation GoodsDetailHeaderView {
    
}

-(UIImageView *)wristwatchImageView{
    if (!_wristwatchImageView) {
        _wristwatchImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _wristwatchImageView.image = [UIImage imageNamed:@"Wrist_Mark"];
        [_wristwatchImageView sizeToFit];
    }
    return _wristwatchImageView;
}

+ (CGFloat)heightForOrientationPortrait:(GoodsDetailInfo*)detailInfo {
    return [GoodsDetailHeaderView calculateHeightAndLayoutSubviews:nil detailInfo:detailInfo];
}

- (void)dealloc
{
    self.statusView = nil;
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollImageView = [[ASScroll alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GoodsDetailheaderViewHeight)];
        self.scrollImageView.delegate = self;
        self.scrollImageView.isHaveRightPage = 1;
        [self addSubview:self.scrollImageView];
        self.scrollImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //         原价回购的角标
        //        [self addSubview:self.wristwatchImageView];
        //        self.wristwatchImageView.frame = CGRectMake(12, 64, self.wristwatchImageView.width, self.wristwatchImageView.height);
        
        //        _shareBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        //        [_shareBtn setImage:[UIImage imageNamed:@"goods_detail_share"] forState:UIControlStateNormal];
        ////        [_shareBtn setTitle:@"0" forState:UIControlStateNormal];
        //        _shareBtn.layer.masksToBounds = YES;
        //        _shareBtn.layer.cornerRadius = 16.f;
        //        _shareBtn.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.75];
        ////        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:9.5f];
        //        [self addSubview:_shareBtn];
        //
        //
        //        WEAKSELF;
        //        _shareBtnBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(self.width-62, _shareBtn.top-(62-_shareBtn.height)/2, 62, 62)];
        //        _shareBtnBgView.backgroundColor = [UIColor clearColor];
        //        _shareBtnBgView.tag = 102;
        //        [self addSubview:_shareBtnBgView];
        //        _shareBtnBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        //            [weakSelf shareGoods];
        //        };
        ////
        //        self.backgroundColor = [UIColor whiteColor];
        //
        //        _shareBtn.handleClickBlock = ^(CommandButton *sender) {
        //            [weakSelf shareGoods];
        //        };
        //        self.backgroundColor = [UIColor orangeColor];
        
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 50, self.width, 50)];
        //        imageView.image = [UIImage imageNamed:@"gradually-MF"];
        ////        imageView.backgroundColor = [UIColor redColor];
        //        [self.scrollImageView addSubview:imageView];
        
    }
    return self;
}


-(void)asscrollViewDidScroll:(UIScrollView *)scrollView ASScrollView:(ASScroll *)aSScrollView{
    
    UIPanGestureRecognizer * pan = scrollView.panGestureRecognizer;
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (aSScrollView.isCanSeeMore) {
            if (self.scrollTable) {
                self.scrollTable();
            }
        }
    }
}

- (void)shareGoods
{
    WEAKSELF;
    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
    
    NSString *_shareImageUrl = goodsInfo.mainPicUrl;
    if ([_shareImageUrl mag_isEmpty] && goodsInfo.gallaryItems && [goodsInfo.gallaryItems count] >0) {
        _shareImageUrl = ((GoodsGallaryItem *)[goodsInfo.gallaryItems objectAtIndex:0]).picUrl;
    }
    
    UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                           [SDWebImageManager lw_cacheKeyForURL:
                            [NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale480x480]]]];
    
    
    if (shareImage == nil) {
        shareImage = [weakSelf getImageFromURL:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale200x200]];
    }
    
    [[CoordinatingController sharedInstance] shareWithTitle:@"来自爱丁猫的分享"
                                                      image:shareImage
                                                        url:kURLGoodsDetailFormat(goodsInfo.goodsId)
                                                    content:goodsInfo.goodsName];
    
    [MobClick event:@"click_share_from_detail"];
    
    weakSelf.request = [[NetworkAPI sharedInstance] shareGoodsWith:weakSelf.goodsId completion:^(int shareNum) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
            if (goodsInfo) {
                goodsInfo.stat.shareNum = shareNum;
            }
            MBGlobalSendGoodsInfoChangedNotification(0,weakSelf.goodsId);
        });
        _$hideHUD();
    } failure:^(XMError *error) {
        _$showHUD([error errorMsg], 0.8f);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self class] calculateHeightAndLayoutSubviews:self detailInfo:nil];
    
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(GoodsDetailHeaderView*)cell detailInfo:(GoodsDetailInfo*)detailInfo
{
    CGFloat marginTop = 0.f;
    if (cell) {
        cell.scrollImageView.frame = CGRectMake(0.f, marginTop, kScreenWidth, kScreenWidth);
        cell.shareBtn.frame = CGRectMake(kScreenWidth-cell.shareBtn.width-15, kScreenWidth-15-cell.shareBtn.height, cell.shareBtn.width, cell.shareBtn.height);
        
        cell.shareBtnBgView.frame = CGRectMake(kScreenWidth-cell.shareBtnBgView.width, cell.shareBtn.top-(62-cell.shareBtn.height)/2, cell.shareBtnBgView.width, cell.shareBtnBgView.height);
    }
    marginTop += kScreenWidth;
    return marginTop;
}

- (CGFloat)updateWithDetailInfo:(GoodsDetailInfo *)detailInfo {
    if (detailInfo) {
        GoodsInfo *goodsInfo = detailInfo.goodsInfo;
        self.goodsInfo = goodsInfo;
        
        if ((goodsInfo.supportType & GOODSINDEX) == GOODSINDEX) {//回购商品
            self.wristwatchImageView.hidden = NO;
        } else {
            self.wristwatchImageView.hidden = YES;
        }
        
        self.goodsId = goodsInfo.goodsId;
        
        NSMutableArray *array = [NSMutableArray array];
        for (GoodsGallaryItem *item in detailInfo.gallaryItems) {
            //            if (item.width>0&&item.height>0) {
            //                [array addObject:[XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2, item.width/kScreenWidth*item.height*2)]];
            //            } else {
            //                [array addObject:[XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale640x640]];
            //            }
            [array addObject:[XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale480x480]];
        }
        [self.scrollImageView setArrOfImages:array];
        
        self.gallaryItems = detailInfo.gallaryItems;
        
        CGFloat height = [[self class] calculateHeightAndLayoutSubviews:self detailInfo:nil];
        self.frame =  CGRectMake(0, 0, kScreenWidth, height);
        
        if (![detailInfo.goodsInfo isOnSale]) {
            if (!_statusView) {
                _statusView = [[GoodsStatusMaskView alloc] initForCircle:100.f];
                _statusView.delegate = self;
                [self addSubview:_statusView];
            }
            _statusView.hidden = NO;
            _statusView.statusString = detailInfo.goodsInfo.statusDescription;
            _statusView.center = self.center;
            if ([detailInfo.goodsInfo isLocked]) {
                _statusView.orerLockInfo = detailInfo.orderLockInfo;
            } else {
                _statusView.orerLockInfo = nil;
            }
        } else {
            _statusView.hidden = YES;
        }
        
        [self setNeedsLayout];
    }
    return 0;
}


#pragma mark - Delegate

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [_scrollImageView setCurrentPage:index];
}

- (void)didClickViewPage:(UIImageView *)imageView imageViewArray:(NSArray*)imageViewArray
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.gallaryItems count]];
    for (NSInteger i=0;i< [self.gallaryItems count];i++) {
        
        GoodsGallaryItem *item = (GoodsGallaryItem*)[self.gallaryItems objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *QNDownloadUrl = nil;
        //        if (item.width>0&&item.height>0) {
        //            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2.5, item.width/kScreenWidth*item.height*2.5)];
        //        } else {
        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale750x750];
        //        }
        
        //        QNDownloadUrl = item.picUrl;
        
        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
        if (i<imageViewArray.count) {
            photo.srcImageView = [imageViewArray objectAtIndex:i];
        } else {
            photo.srcImageView = imageView; // 来源于哪个UIImageView
        }
        [photos addObject:photo];
    }
    
    //    for (GoodsGallaryItem *item in self.gallaryItems) {
    //        MJPhoto *photo = [[MJPhoto alloc] init];
    //
    //        NSString *QNDownloadUrl = nil;
    ////        if (item.width>0&&item.height>0) {
    ////            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2.5, item.width/kScreenWidth*item.height*2.5)];
    ////        } else {
    ////            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale640x640];
    ////        }
    //
    //        QNDownloadUrl = item.picUrl;
    //
    //        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
    //        photo.srcImageView = imageView; // 来源于哪个UIImageView
    //        [photos addObject:photo];
    //    }
    
    if ([photos count]>0) {
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.isHaveGoodsDetailBtn = 1;
        browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }
}


- (void)goodsStatusMaskViewGoodsUnLocked:(GoodsStatusMaskView*)maskView
{
    if ([self.goodsId length]>0) {
        [NSArray arrayWithObjects:self.goodsId, nil];
        
        WEAKSELF;
        self.queryStatusRequest = [[NetworkAPI sharedInstance] queryGoodsStatus:[NSArray arrayWithObjects:self.goodsId, nil] completion:^(NSArray *goodsStatusDictArray) {
            weakSelf.queryStatusRequest = nil;
            
            NSMutableArray *goodsStatusArray = [[NSMutableArray alloc] initWithCapacity:[goodsStatusDictArray count]];
            for (NSDictionary *dict in goodsStatusDictArray) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [goodsStatusArray addObject:[GoodsStatusDO createWithDict:dict]];
                }
            }
            
            MBGlobalSendGoodsStatusUpdatedNotification(goodsStatusArray);
        } failure:^(XMError *error) {
            weakSelf.queryStatusRequest = nil;
        }];
    }
}

@end

//@implementation BottomLadderShapedView
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.opaque = NO;
//        self.color = [UIColor colorWithHexString:@"E2BB66"];
//        self.topLeft = 0;
//        self.bottomRight = 0;
//    }
//    return self;
//}
//
//#pragma mark - Public
//
//- (void)setColor:(UIColor *)color
//{
//    if (![_color isEqual:color]) {
//        _color = color;
//        [self setNeedsDisplay];
//    }
//}
//
//- (void)setTopLeft:(CGFloat)topLeft {
//    if (_topLeft!=topLeft) {
//        _topLeft = topLeft;
//        [self setNeedsDisplay];
//    }
//}
//
//- (void)setBottomRight:(CGFloat)bottomRight {
//    if (_bottomRight!=bottomRight) {
//        _bottomRight = bottomRight;
//        [self setNeedsDisplay];
//    }
//}
//
//#pragma mark - Private
//
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextClearRect(context, rect);
//
//    if (_topLeft>0) {
//        CGContextBeginPath(context);
//        CGContextMoveToPoint   (context, _topLeft, CGRectGetMinY(rect));
//        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
//        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
//        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
//        CGContextClosePath(context);
//    }
//
//    if (_bottomRight>0) {
//        CGContextBeginPath(context);
//        CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
//        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
//        CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-_bottomRight, CGRectGetMaxY(rect));
//        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
//        CGContextClosePath(context);
//    }
//
//    CGContextSetFillColorWithColor(context, self.color.CGColor);
//    CGContextFillPath(context);
//}
//
//@end
//
//


@interface GoodsAttributesPopupView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) UIView *bgView;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,weak) CommandButton *closeBtn;
@property(nonatomic,strong) NSMutableArray *dataSources;
@end

@implementation GoodsAttributesPopupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*3/5)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        _bgView = bgView;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height-48)];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [bgView addSubview:tableView];
        _tableView = tableView;
        
        CommandButton *closeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, bgView.height-48, bgView.width, 48)];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [bgView addSubview:closeBtn];
        _closeBtn = closeBtn;
        
        WEAKSELF;
        closeBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf dismiss];
        };
        
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [weakSelf dismiss];
        };
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

+ (void)showInView:(UIView*)view detailInfo:(GoodsDetailInfo*)detailInfo
{
    GoodsAttributesPopupView *popupView = [[GoodsAttributesPopupView alloc] initWithFrame:view.bounds];
    popupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.f];
    [view addSubview:popupView];
    
    [UIView animateWithDuration:0.3f animations:^{
        popupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    } completion:^(BOOL finished) {
        popupView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    }];
    
    popupView.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, popupView.bgView.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        popupView.bgView.frame = CGRectMake(0, kScreenHeight-popupView.bgView.height, kScreenWidth, popupView.bgView.height);
    } completion:^(BOOL finished) {
        popupView.bgView.frame = CGRectMake(0, kScreenHeight-popupView.bgView.height, kScreenWidth, popupView.bgView.height);
    }];
    
    [popupView updateWithGoodsDetail:detailInfo];
}

- (void)dismiss
{
    WEAKSELF;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.f];
    } completion:^(BOOL finished) {
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.f];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.bgView.height);
    } completion:^(BOOL finished) {
        weakSelf.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.bgView.height);
        [weakSelf removeFromSuperview];
    }];
}

- (void)updateWithGoodsDetail:(GoodsDetailInfo*)detailInfo
{
    NSMutableArray *dataSources = [[NSMutableArray alloc] init];
    [dataSources addObject:[GoodsDetailTitleCell buildCellDict:@"商品参数" isOpen:2 b2cOrc2c:1]];
    [dataSources addObject:[GoodsAttributesCell buildCellDict:detailInfo.attrItems]];
    _dataSources = dataSources;
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources?[self.dataSources count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

@end


@interface GoodsDetailTopBarIndicatorView ()

@end

@implementation GoodsDetailTopBarIndicatorView


- (id)initWithFrame:(CGRect)frame tabBtnTitles:(NSArray*)tabBtnTitles {
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *btnFont = [UIFont systemFontOfSize:14.f];
        UIColor*btnTextColor = [UIColor colorWithHexString:@"181818"];//[UIColor colorWithHexString:@"C7AF7A"];
        CGFloat btnHeight = self.height;
        CGFloat btnWidth = (self.width)/[tabBtnTitles count];
        CGFloat btnX = 0.f;
        for (NSInteger i=0;i<[tabBtnTitles count];i++) {
            CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(btnX, 0, btnWidth, btnHeight)];
            btn.tag = i;
            btn.titleLabel.font = btnFont;
            [btn setTitleColor:btnTextColor forState:UIControlStateNormal];
            [btn setTitle:[tabBtnTitles objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:btn];
            
            WEAKSELF;
            btn.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf setTabAtIndex:sender.tag animated:YES];
            };
            btnX += btnWidth;
        }
        
        CGFloat indicatorWidth = self.width/[tabBtnTitles count];
        CGFloat indicatorX = 10.f;
        indicatorWidth = indicatorWidth-20.f;
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(indicatorX, self.height-2, indicatorWidth, 2)];
        _indicatorView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        _indicatorView.tag = 2000;
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)setTabAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSArray *subViews = [self subviews];
    WEAKSELF;
    if (weakSelf.beforeSelectAtIndex) {
        weakSelf.beforeSelectAtIndex(index);
    }
    if (index < [subViews count]-1 && [subViews count]-1>0) {
        CGFloat indicatorWidth = weakSelf.width/([subViews count]-1);
        CGFloat indicatorX = index*indicatorWidth+10.f;
        CGRect endFrame = CGRectMake(indicatorX, weakSelf.indicatorView.top, weakSelf.indicatorView.width, weakSelf.indicatorView.height);
        
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                weakSelf.indicatorView.frame = endFrame;
            } completion:^(BOOL finished) {
                if (weakSelf.didSelectAtIndex) {
                    weakSelf.didSelectAtIndex(index);
                }
            }];
        } else {
            weakSelf.indicatorView.frame = endFrame;
            if (weakSelf.didSelectAtIndex) {
                weakSelf.didSelectAtIndex(index);
            }
        }
    }
}

@end




//if ([detail.goodsInfo.likedUsers count]>0 && detail.goodsInfo.stat.likeNum >0) {
    //注释 显示商品用户心动人数的cell
    //            [dataSources addObject:[SepTableViewCell buildCellDict]];
    //            [dataSources addObject:[LikedUsersTableViewCell buildCellDict:detail.goodsInfo.goodsId totalNum:detail.goodsInfo.stat.likeNum likedUsers:detail.goodsInfo.likedUsers]];
    //            [dataSources addObject:[SepTableViewCell buildCellDict]];
//}

//        } else {
//注释 B2C用户的留言显示cell
//            if ([self.commentsList count]>0) {
//                [dataSources addObject:[SepTableViewCell buildCellDict]];
//                [dataSources addObject:[GoodsCommentTitleCell buildCellDict:detail]];
//                for (NSInteger index=0;index<[self.commentsList count];index++) {
//                    CommentVo *comment = [self.commentsList objectAtIndex:index];
//                    if (index==0) {
//                        [dataSources addObject:[CommentTableViewCell buildCellDictNoTopLine:comment]];
//                    } else {
//                        [dataSources addObject:[CommentTableViewCell buildCellDict:comment]];
//                    }
//                    if (index>=2) {
//                        break;
//                    }
//                }
//
//                if ([self.commentsList count]>3) {
//                    [dataSources addObject:[GoodsMoreCommentsCell buildCellDict]];
//                }
//            } else {
//                //            [dataSources addObject:[GoodsNoCommentsCell buildCellDict]];
//                [dataSources addObject:[GoodsCommentTitleCell buildCellDict:detail]];
//            }
//        }
//        [dataSources addObject:[GoodsAttributesButtonCell buildCellDict]];
//        [dataSources addObject:[SepTableViewCell buildCellDict]];



//        [dataSources addObject:[SepTableViewCell buildCellDict]];
//        [dataSources addObject:[GoodsDetailTitleCell buildCellDict:@"商品故事"]];
//        [dataSources addObject:[SegTabViewCellSmall buildCellDict]];
//        [dataSources addObject:[GoodsDetailStoryCell buildCellDict:detail.goodsInfo]];//这里应该传入GoodsInfo
//        [dataSources addObject:[SepTableViewCell buildCellDict]];

//        [dataSources addObject:[SepTableViewCell buildCellDict]];


