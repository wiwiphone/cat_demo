//
//  ExploreViewController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ExploreViewController.h"
#import "MyWebView.h"
#import "URLScheme.h"
#import "NetworkManager.h"
#import "LocalURLCache.h"

#import "PullRefreshTableView.h"

#import "SVPullToRefresh.h"
#import "Session.h"
#import "LoginViewController.h"
#import "WebViewJavascriptBridge.h"

#import "QrCodeScanViewController.h"
#import "NSString+Addtions.h"

#import "SearchViewController.h"

#import "DataListViewController.h"


#import "PullRefreshTableView.h"
#import "PagesContainerView.h"
#import "NSString+URLEncoding.h"

#import "TopBarRightCancelButton.h"

//@interface ExploreViewController () <UIScrollViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchBarViewDelegate,RecommendViewControllerDelegate,PagesContainerViewDelegate>
//
//@property(nonatomic,weak) SearchBarView *searchBarView;
//@property(nonatomic,weak) TopBarRightCancelButton *myTopBarRightButton;
//
//@property(nonatomic,weak) UIView *tabBar;
//@property(nonatomic,strong) NSArray *viewControllers;
//@property(nonatomic,weak) PagesContainerView *pagesContainerView;
////@property(nonatomic,weak) UIView *transitionView;
////@property(nonatomic,assign) NSInteger selectAtIndex;
//
//@property(nonatomic,weak) MyWebView *webView;
//
//@end
//
//@interface ExploreTabButton : CommandButton
//@end
//@implementation ExploreTabButton
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (![self isSelected])
//        [super touchesBegan:touches withEvent:event];
//}
//@end
//
//@implementation ExploreViewController {
//    CGFloat _lastContentOffsetY;
//}
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        _isShowBackBtn = NO;
//        _tabIndex = 0;
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    CGFloat topBarHeight = [super setupTopBar];
////    [super setupTopBarTitle:@"发现"];
//
//
//    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15-15, 29)];
//    _searchBarView = searchBarView;
//    _searchBarView.placeholder = @"搜索";
//    _searchBarView.delegate = self;
//    _searchBarView.searchBarDelegate = self;
////    _searchBarView.layer.borderWidth = 0.5;
////    _searchBarView.layer.borderColor = [UIColor colorWithHexString:@"e3e3e3"].CGColor;
////    _searchBarView.layer.masksToBounds = YES;
//
////    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
////    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//
//    TopBarRightCancelButton *myTopBarRightButton = [[TopBarRightCancelButton alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
//    _myTopBarRightButton = myTopBarRightButton;
//    _myTopBarRightButton.backgroundColor = [UIColor clearColor];
//    _myTopBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
//    _myTopBarRightButton.titleLabel.font = [UIFont systemFontOfSize:13.5f];
//    [_myTopBarRightButton addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_myTopBarRightButton setTitleColor:[UIColor colorWithHexString:@"E2BB66"] forState:UIControlStateNormal];
////    [_myTopBarRightButton setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
//    [self.topBar addSubview:self.myTopBarRightButton];
//
//    [_searchBarView enableCancelButton:NO];
//    [self.topBar addSubview:_searchBarView];
//    
//    _searchBarView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.85];
//
////    [self.topBar addSubview:view];
//
//    //CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15, 29)
//    //CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-46.f-15, 29)
////    _myTopBarRightButton.hidden = YES;
//    [_myTopBarRightButton removeFromSuperview];
//    [self.topBar addSubview:_myTopBarRightButton];
//    _searchBarView.frame = CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15, 29);
//    _myTopBarRightButton.frame = CGRectMake(super.topBar.width-15-46, _searchBarView.top, 46, _searchBarView.height);
//
////    view.frame = CGRectMake(super.topBar.width-15-46, _searchBarView.top, 46, _searchBarView.height);
//    
//    if (_isShowBackBtn) {
//        [super setupTopBarBackButton];
//        _searchBarView.frame = CGRectMake(super.topBarBackButton.right, _searchBarView.top, _searchBarView.right-super.topBarBackButton.right, _searchBarView.height);
//    }
//
//    CGFloat marginTop = topBarHeight;
//    marginTop += 10;
//    
////    UIView *transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
////    transitionView.backgroundColor = [UIColor clearColor];
////    transitionView.autoresizesSubviews = YES;
////    transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
////    [self.view addSubview:transitionView];
////    _transitionView = transitionView;
//    
//    CGFloat topbarShadowHeight = 2.f;
//    
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
//    _pagesContainerView.pageIndicatorViewSize = CGSizeMake(40, 2);
//    _pagesContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _pagesContainerView.delegate = self;
//    _pagesContainerView.contentMarginTop = -(kTopBarHeight-topbarShadowHeight);
//    [self.view addSubview:_pagesContainerView];
//    
//    self.pagesContainerView.topBar.hidden = YES;
//    self.pagesContainerView.pageIndicatorView.hidden = YES;
//    
//    [self loadData];
//    
//    
//    
////    if (self.pagesContainerView.selectedIndex != _curSelectedAtIndex) {
////        [self.pagesContainerView setSelectedIndex:_curSelectedAtIndex animated:NO];
////    }
//    
////    _selectAtIndex = 0;
//    
////    CommandButton *btn = (CommandButton*)[self.tabBar viewWithTag:(_selectAtIndex+1)*10];
////    btn.selected = YES;
////    [self displayBAtIndex:_selectAtIndex];
//    
//    [self.view bringSubviewToFront:self.tabBar];
//    
//    [self bringTopBarToTop];
//
//    [super setupReachabilityChangedObserver];
//}
//
//- (void)loadData
//{
//    WEAKSELF;
//    
//    ///discover/list【GET】 发现页接口
////    返回 "data": {
////        "list": [
////                 "aidingmao://datalist/?module=recommend&path=list&params=&title=%e5%93%81%e7%89%8c",
////                 "aidingmao://datalist/?module=recommend&path=list&params=&title=%e7%b1%bb%e7%9b%ae",
////                 "aidingmao://datalist/?module=recommend&path=list&params=&title=%e4%b8%93%e9%a2%98"
////                 ]
////    }
//    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
//    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
//    
//
//    if ([weakSelf.viewControllers count]>0) {
//        //...
//        CGFloat marginTop = weakSelf.topBarHeight;
//        marginTop += 10;
//        
//        NSArray *viewControllers = weakSelf.viewControllers;
//        if ([viewControllers count]>1) {
//            UIView *tabBar = [weakSelf buildTabBarView:viewControllers];
//            CGRect frame = tabBar.frame;
//            frame.origin.y = marginTop;
//            tabBar.frame = frame;
//            [weakSelf.view addSubview:tabBar];
//            weakSelf.tabBar = tabBar;
//            
//            marginTop += weakSelf.tabBar.height;
//            marginTop += 10;
//        }
//        
//        CGFloat tableViewContentMarginTop = 0.f;
//        if (weakSelf.tabBar && weakSelf.tabBar.height >0) {
//            tableViewContentMarginTop = kTopBarHeight-2+weakSelf.tabBar.height+20;
//        } else {
//            tableViewContentMarginTop = kTopBarHeight-2;
//        }
//        
//        for (DataListViewController *viewControler in viewControllers) {
//            viewControler.tableViewContentMarginTop = tableViewContentMarginTop;
//        }
//        weakSelf.pagesContainerView.viewControllers = viewControllers;
//        if (weakSelf.tabIndex>=0&&weakSelf.tabIndex< weakSelf.pagesContainerView.viewControllers.count) {
//            weakSelf.pagesContainerView.selectedIndex = weakSelf.tabIndex;
//        }
//    } else {
//        [weakSelf showLoadingView];
//
//        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"discover" path:@"list" parameters:parameters completionBlock:^(NSDictionary *data) {
//            [weakSelf hideLoadingView];
//            
//            NSArray *array = [data arrayValueForKey:@"list"];
//            if ([array isKindOfClass:[NSArray class]] && [array count]>0) {
//                CGFloat marginTop = weakSelf.topBarHeight;
//                marginTop += 10;
//                
//                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//                for (NSString *redirectUri in array) {
//                    if ([redirectUri isKindOfClass:[NSString class]] && [redirectUri length]>0) {
//                        NSURL *url = [NSURL URLWithString:[[redirectUri URLDecodedString] URLEncodedString]];
//                        NSString *query = url.query;
//                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//                        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
//                            NSArray *elts = [param componentsSeparatedByString:@"="];
//                            if([elts count] < 2) continue;
//                            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
//                        }
//                        
//                        NSString *module = [[params valueForKey:@"module"] URLDecodedString];
//                        NSString *path = [[params valueForKey:@"path"] URLDecodedString];
//                        NSString *title = [[params valueForKey:@"title"] URLDecodedString];
//                        NSString *params_string = [params valueForKey:@"params"];
//                        BOOL is_separate = [[[params stringValueForKey:@"is_separate"] trim] isEqualToString:@"1"]?YES:NO;
//                        
//                        if ([module length]>0 && [path length]>0) {
//                            DataListViewController *viewControler = [[DataListViewController alloc] init];
//                            viewControler.module = module;
//                            viewControler.path = path;
//                            viewControler.isShowTitleBar = NO;
//                            viewControler.delegate = self;
//                            viewControler.title = title;
//                            viewControler.params = params_string;
//                            viewControler.isNeedShowSeperator = is_separate;
//                            [viewControllers addObject:viewControler];
//                        }
//                    }
//                }
//                //
//                weakSelf.viewControllers = viewControllers;
//                
//                if ([viewControllers count]>0) {
//                    if ([viewControllers count]>1) {
//                        UIView *tabBar = [weakSelf buildTabBarView:viewControllers];
//                        CGRect frame = tabBar.frame;
//                        frame.origin.y = marginTop;
//                        tabBar.frame = frame;
//                        [weakSelf.view addSubview:tabBar];
//                        weakSelf.tabBar = tabBar;
//                        
//                        marginTop += weakSelf.tabBar.height;
//                        marginTop += 10;
//                    }
//                    
//                    CGFloat tableViewContentMarginTop = 0.f;
//                    if (weakSelf.tabBar && weakSelf.tabBar.height >0) {
//                        tableViewContentMarginTop = kTopBarHeight-2+weakSelf.tabBar.height+20;
//                    } else {
//                        tableViewContentMarginTop = kTopBarHeight-2;
//                    }
//                    
//                    for (DataListViewController *viewControler in viewControllers) {
//                        viewControler.tableViewContentMarginTop = tableViewContentMarginTop;
//                    }
//                    weakSelf.pagesContainerView.viewControllers = viewControllers;
//                    if (weakSelf.tabIndex>=0&&weakSelf.tabIndex< weakSelf.pagesContainerView.viewControllers.count) {
//                        weakSelf.pagesContainerView.selectedIndex = weakSelf.tabIndex;
//                    }
//                }
//            }
//            
//            if ([weakSelf.pagesContainerView.viewControllers count] == 0) {
//                [weakSelf loadWebContent];
//            }
//        } failure:^(XMError *error) {
//            [weakSelf  loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf loadData];
//                });
//            };
//        } queue:nil]];
//    }
//}
//
//- (UIView*)buildTabBarView:(NSArray*)viewControllers {
//    NSInteger tabCount = [viewControllers count];
//    if (tabCount>3) tabCount = 3;
//    
//    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth*30/320.f)];
//    CGFloat width = (kScreenWidth-30)/tabCount;
//    CGFloat height = tabBar.height;
//    CGFloat marginLeft = 15.f;
//    
//    NSInteger index = 1;
//    
//    UIImage *leftBg = [UIImage imageNamed:@"tab_left_a"];
//    UIImage *leftBgSelected = [UIImage imageNamed:@"tab_left_on_a"];
//    CommandButton *btnLeft = [[ExploreTabButton alloc] initWithFrame:CGRectMake(marginLeft, 0, width, height)];
//    [btnLeft setBackgroundImage:[leftBg stretchableImageWithLeftCapWidth:leftBg.size.width/2 topCapHeight:leftBg.size.height/2] forState:UIControlStateNormal];
//    [btnLeft setBackgroundImage:[leftBgSelected stretchableImageWithLeftCapWidth:leftBgSelected.size.width/2 topCapHeight:leftBgSelected.size.height/2] forState:UIControlStateSelected];
//    [btnLeft setTitle:((UIViewController*)[viewControllers objectAtIndex:index-1]).title forState:UIControlStateNormal];
//    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [btnLeft setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
//    btnLeft.titleLabel.font = [UIFont systemFontOfSize:13.f];
//    btnLeft.backgroundColor = [UIColor clearColor];
//    btnLeft.tag = 10*index;
//    [tabBar addSubview:btnLeft];
//    
//    marginLeft += btnLeft.width;
//    
//    CommandButton *btnMiddle = nil;
//    if (tabCount>2) {
//        index+=1;
//        
//        UIImage *middleBgOn = [UIImage imageNamed:@"tab_middle_on_a"];
//        UIImage *middleBg = [UIImage imageNamed:@"tab_middle_a"];
//        btnMiddle = [[ExploreTabButton alloc] initWithFrame:CGRectMake(marginLeft, 0, width, height)];
//        [btnMiddle setTitle:((UIViewController*)[viewControllers objectAtIndex:index-1]).title forState:UIControlStateNormal];
//        [btnMiddle setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [btnMiddle setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
//        btnMiddle.titleLabel.font = [UIFont systemFontOfSize:13.f];
//        [btnMiddle setBackgroundImage:[middleBg stretchableImageWithLeftCapWidth:middleBg.size.width/2
//                                                                      topCapHeight:middleBg.size.height/2] forState:UIControlStateNormal];
//        [btnMiddle setBackgroundImage:[middleBgOn stretchableImageWithLeftCapWidth:middleBgOn.size.width/2
//                                                                    topCapHeight:middleBgOn.size.height/2] forState:UIControlStateSelected];
//        btnMiddle.layer.masksToBounds = YES;
//        btnMiddle.layer.borderWidth = 0.5f;
//        btnMiddle.layer.borderColor = [UIColor colorWithHexString:@"282828"].CGColor;
//        btnMiddle.tag = 10*index;
//        [tabBar addSubview:btnMiddle];
//        
//        marginLeft += btnMiddle.width;
//    }
//    
//    index+=1;
//    
//    UIImage *rightBg = [UIImage imageNamed:@"tab_right_a"];
//    UIImage *rightBgSelected = [UIImage imageNamed:@"tab_right_on_a"];
//    CommandButton *btnRight = [[ExploreTabButton alloc] initWithFrame:CGRectMake(marginLeft, 0, width, height)];
//    [btnRight setBackgroundImage:[rightBg stretchableImageWithLeftCapWidth:rightBg.size.width/2 topCapHeight:rightBg.size.height/2] forState:UIControlStateNormal];
//    [btnRight setBackgroundImage:[rightBgSelected stretchableImageWithLeftCapWidth:rightBgSelected.size.width/2 topCapHeight:rightBgSelected.size.height/2] forState:UIControlStateSelected];
//    [btnRight setTitle:((UIViewController*)[viewControllers objectAtIndex:index-1]).title forState:UIControlStateNormal];
//    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [btnRight setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
//    btnRight.titleLabel.font = [UIFont systemFontOfSize:13.f];
//    btnRight.backgroundColor = [UIColor clearColor];
//    btnRight.tag = 10*index;
//    [tabBar addSubview:btnRight];
//    
//    WEAKSELF;
//    btnLeft.handleClickBlock = ^(CommandButton *sender) {
//        [weakSelf handleTabBarClicked:sender];
//    };
//    btnMiddle.handleClickBlock = ^(CommandButton *sender) {
//        [weakSelf handleTabBarClicked:sender];
//    };
//    btnRight.handleClickBlock = ^(CommandButton *sender) {
//        [weakSelf handleTabBarClicked:sender];
//    };
//    
//    return tabBar;
//}
//
//- (void)handleTabBarClicked:(CommandButton*)sender
//{
//    if (![sender isSelected]) {
//        sender.selected = YES;
//        
//        for (CommandButton*btn in [self.tabBar subviews]) {
//            if (btn != sender) {
//                btn.selected = NO;
//            }
//        }
//    }
//    [self displayBAtIndex:sender.tag/10-1];
//}
//
//- (void)pageTopBarItemClickedAtIndex:(NSInteger)index
//{
//    
//}
//
//- (void)pageBeforeSelectAtIndex:(NSInteger)index
//{
//    
//}
//
//- (void)pageDidSelectAtIndex:(NSInteger)index
//{
//    for (CommandButton*btn in [self.tabBar subviews]) {
//        if (btn.tag != (index+1)*10) {
//            btn.selected = NO;
//        }
//    }
//    CommandButton *btn = (CommandButton*)[self.tabBar viewWithTag:(index+1)*10];
//    btn.selected = YES;
//}
//
//- (void)displayBAtIndex:(NSInteger)index
//{
//    [_pagesContainerView setSelectedIndex:index animated:YES];
//    
////    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
////    targetViewController.view.hidden = NO;
////    targetViewController.view.frame = _transitionView.bounds;//
////
////    //    [targetViewController willMoveToParentViewController:self];
////    //    targetViewController.view.frame = CGRectMake(0, marginTop, kScreenWidth, self.view.height-marginTop);
////    //    [self.view addSubview:targetViewController.view];
////    //    [targetViewController didMoveToParentViewController:targetViewController];
////    
////    NSArray *subviews = [self.transitionView subviews];
////    for (UIView *view in subviews) {
////        [view removeFromSuperview];
////    }
////    
////    if ([targetViewController.view isDescendantOfView:self.view])
////    {
////        [self.transitionView bringSubviewToFront:targetViewController.view];
////    }
////    else
////    {
////        targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
////        [self.transitionView addSubview:targetViewController.view];
////        if (self.tabBar && self.tabBar.height >0) {
////            ((DataListViewController*)targetViewController).tableView.contentMarginTop = kTopBarHeight-2+self.tabBar.height+20;
////        } else {
////            ((DataListViewController*)targetViewController).tableView.contentMarginTop = kTopBarHeight-2;
////        }
////    }
////    
////    _selectAtIndex = index;
//}
//
//- (void)recommendTableViewScrollViewDidScroll:(UIScrollView *)scrollView viewController:(RecommendViewController*)viewController
//{
////    if ([self.viewControllers objectAtIndex:_selectAtIndex]==viewController) {
////        CGFloat currentPosition = scrollView.contentOffset.y;
////        CGFloat contentMarginTop = 0;
////        if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
////            contentMarginTop = ((PullRefreshTableView*)scrollView).contentMarginTop;
////        }
////        
////        if (currentPosition<=-contentMarginTop) {
////            self.tabBar.alpha = 1.f;
////        } else {
////            currentPosition = currentPosition+contentMarginTop;
////            CGFloat lastContentOffsetY = _lastContentOffsetY+contentMarginTop;
////            
////            if (currentPosition < lastContentOffsetY) {
////                //下拉
////                CGFloat alpha = (lastContentOffsetY-currentPosition)/100.f+self.tabBar.alpha;
////                if (alpha>1)alpha= 1.;
////                self.tabBar.alpha = alpha;
////            } else {
////                //上
////                CGFloat alpha = (lastContentOffsetY-currentPosition)/320.f+self.tabBar.alpha;
////                if (alpha<0.)alpha= 0.;
////                self.tabBar.alpha = alpha;
////            }
////        }
////        _lastContentOffsetY = scrollView.contentOffset.y;
////    }
//}
//
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//
////    if ([self.navigationController.view superview]==nil) {
////        [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
////        [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
////        [_webView loadHTMLString:@"" baseURL:nil];
////        [_webView stopLoading];
////        _webView.delegate = nil;
////        [_webView removeFromSuperview];
////        _webView = nil;
////
////        [_searchBarView removeFromSuperview];
////        _searchBarView = nil;
////
////        [super hideLoadingView];
////
////        self.view = nil;
////    }
//}
//- (void)dealloc
//{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    if (_webView) {
//        [_webView loadHTMLString:@"" baseURL:nil];
//        [_webView stopLoading];
//        [_webView setDelegate:nil];
//        [_webView removeFromSuperview];
//        _webView = nil;
//    }
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Dispose of any resources that can be recreated.
//
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
//        if (self.isViewLoaded && !self.view.window) {
//
//            if (_webView) {
//                [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
//                [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
//                [_webView loadHTMLString:@"" baseURL:nil];
//                [_webView stopLoading];
//                _webView.delegate = nil;
//                [_webView removeFromSuperview];
//                _webView = nil;
//                
//                [[NSURLCache sharedURLCache] removeAllCachedResponses];
//                
//                [_searchBarView removeFromSuperview];
//                _searchBarView = nil;
//            }
//        
//            [super hideLoadingView];
//
//            self.view = nil;
//        }
//    }
//
//    [super didReceiveMemoryWarning];
//}
//
//- (void)loadWebContent
//{
//    WEAKSELF;
//    if (!_webView) {
//        MyWebView *webView = [[MyWebView alloc] initWithFrame:CGRectZero];
//
//        _webView = webView;
//        _webView.useCached = YES;
//
//        CGFloat topBarHeight = self.topBarHeight;
//        _webView.frame = CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight);
//        _webView.backgroundColor = [UIColor whiteColor];
//        _webView.scrollView.delegate = self;
//        [weakSelf.webView removeFromSuperview];
//        [weakSelf.view addSubview:weakSelf.webView];
//        _webView.delegate = _webView;
//    }
//    {
//        NSString *exploreURL = [NSString stringWithFormat:@"%@?%ld",kURLExplore,lround(floor([[NSDate date] timeIntervalSince1970]))];
//
//        [_webView.scrollView addPullToRefreshWithActionHandler:^{
//            [weakSelf.webView firstLoadURLString:exploreURL];
//        }];
//
//        [weakSelf showLoadingView];
//
//        _webView.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView
//                                                    webViewDelegate:_webView
//                                                            handler:^(id data, WVJBResponseCallback responseCallback) {}];
//
//        WEAKSELF
//
//        [_webView.bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//            weakSelf.webView.responseCallback = responseCallback;
//            if ([Session sharedInstance].isLoggedIn) {
//                NSDictionary *userInfo = @{@"avatar":[Session sharedInstance].currentUser.avatarUrl,
//                                           @"token":[Session sharedInstance].token,
//                                           @"user_name":[Session sharedInstance].currentUser.userName,
//                                           @"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
//                if (weakSelf.webView.responseCallback) {
//                    weakSelf.webView.responseCallback(userInfo);
//                }
//
//            } else {
//                LoginViewController *loginVC = [[LoginViewController alloc] init];
//                [[CoordinatingController sharedInstance] presentViewController:loginVC animated:YES completion:^{
//
//                }];
//            }
//
//        }];
//
//
//        _webView.webViewDidStartLoadBlock = ^(MyWebView *webView) {
//
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//
//        };
//        _webView.webViewDidFinishLoadBlock = ^(MyWebView *webView) {
//
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//
//            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            [weakSelf.webView.scrollView.pullToRefreshView stopAnimating];
//            [weakSelf hideLoadingView];
//
//            if (![NetworkManager sharedInstance].isReachable) {
//                [webView stopLoading];
//                [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//                    [weakSelf.webView firstLoadURLString:exploreURL];
//                };
//                [weakSelf showHUD:@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
//            }
//        };
//
//        _webView.webViewShouldStartLoadWithRequestBlock = ^(MyWebView *webView, NSURLRequest *request,UIWebViewNavigationType navigationType) {
//            if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//                [URLScheme locateWithHtml5Url:request.URL.absoluteString andIsShare:YES];
//                return NO;
//            }
//            return YES;
//        };
//        _webView.webViewDidFailWithErrorBlock = ^(MyWebView *webView,NSError *error) {
//
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//
//            [weakSelf.webView.scrollView.pullToRefreshView stopAnimating];
//            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//                if (!weakSelf.webView.isLoading) {
//                    [weakSelf.webView firstLoadURLString:kURLExplore];
//                }
//            };
//
//            [weakSelf showHUD:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
//        };
//        if (!weakSelf.webView.isLoading) {
//            [weakSelf.webView firstLoadURLString:kURLExplore];
//        }
//    }
//}
//
//#pragma mark - UISearchBarDelegate
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar becomeFirstResponder];
//    //    _searchHistoryView.hidden = NO;
//
//    _myTopBarRightButton.hidden = NO;
//    _myTopBarRightButton.isInEditing = YES;
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    _myTopBarRightButton.isInEditing = NO;
//
//    _myTopBarRightButton.hidden = YES;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    //    _searchHistoryView.hidden = YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSString *keywords = [searchBar.text trim];
//    searchBar.text = nil;
//    [searchBar resignFirstResponder];
//    if ([keywords length]>0 && [searchBar isKindOfClass:[SearchBarView class]]) {
//        SearchViewController *viewController = [[SearchViewController alloc] init];
//        viewController.searchKeywords = keywords;
//        viewController.searchType = ((SearchBarView*)searchBar).currentSearchType;
//        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//    }
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//
//}
//
//@end
//

//@interface ExploreViewController () <UIScrollViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchBarViewDelegate>
//
//@property(nonatomic,weak) MyWebView *webView;
//@property(nonatomic,weak) SearchBarView *searchBarView;
//@property(nonatomic,weak) TopBarRightButton *myTopBarRightButton;
//
//@end
//
//@implementation ExploreViewController {
//    
//}
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    CGFloat topBarHeight = [super setupTopBar];
////    [super setupTopBarTitle:@"发现"];
//    
//    
//    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15-15, 29)];
//    _searchBarView = searchBarView;
//    _searchBarView.placeholder = @"请输入关键词";
//    _searchBarView.delegate = self;
//    _searchBarView.searchBarDelegate = self;
//    _searchBarView.isShowClearButton = NO;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
//    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    
//    TopBarRightButton *myTopBarRightButton = [[TopBarRightButton alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
//    _myTopBarRightButton = myTopBarRightButton;
//    _myTopBarRightButton.backgroundColor = [UIColor clearColor];
//    _myTopBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
//    _myTopBarRightButton.titleLabel.font = [UIFont systemFontOfSize:13.5f];
//    [_myTopBarRightButton addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_myTopBarRightButton setTitleColor:[UIColor colorWithHexString:@"E2BB66"] forState:UIControlStateNormal];
//    [_myTopBarRightButton setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
//    [self.topBar addSubview:self.myTopBarRightButton];
//    
//    [_searchBarView enableCancelButton:NO];
//    [self.topBar addSubview:_searchBarView];
//    
//    [self.topBar addSubview:view];
//    
//    //CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15, 29)
//    //CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-46.f-15, 29)
//    _myTopBarRightButton.hidden = YES;
//    [_myTopBarRightButton removeFromSuperview];
//    [self.topBar addSubview:_myTopBarRightButton];
//    _searchBarView.frame = CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15, 29);
//    _myTopBarRightButton.frame = CGRectMake(super.topBar.width-15-46, _searchBarView.top, 46, _searchBarView.height);
//    
//    view.frame = CGRectMake(super.topBar.width-15-46, _searchBarView.top, 46, _searchBarView.height);
//    
//    
//    // new for memory cleaning
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    // new for memory cleanup
//    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
//    
////    WEAKSELF;
//    
//    
////    self.webView.scrollView.pullToRefreshView.backgroundColor = [UIColor colorWithHexString:@"392426"];
//    self.webView.scrollView.pullToRefreshView.textColor = [UIColor colorWithHexString:@"AAAAAA"];//E5C98B
////    @property (nonatomic, strong) UIColor *arrowColor;
////    @property (nonatomic, strong) UIColor *textColor;
//    
////    self.backgroundColor = [UIColor colorWithHexString:@"392426"];
//
//    [self loadWebContent];
//    
//    [super setupReachabilityChangedObserver];
//}
//
//
//#pragma mark - UISearchBarDelegate
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar becomeFirstResponder];
//    //    _searchHistoryView.hidden = NO;
//    
//    _myTopBarRightButton.hidden = NO;
//    _myTopBarRightButton.isInEditing = YES;
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    _myTopBarRightButton.isInEditing = NO;
//    
//    _myTopBarRightButton.hidden = YES;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    //    _searchHistoryView.hidden = YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSString *keywords = [searchBar.text trim];
//    searchBar.text = nil;
//    [searchBar resignFirstResponder];
//    if ([keywords length]>0 && [searchBar isKindOfClass:[SearchBarView class]]) {
//        SearchViewController *viewController = [[SearchViewController alloc] init];
//        viewController.searchKeywords = keywords;
//        viewController.searchType = ((SearchBarView*)searchBar).currentSearchType;
//        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//    }
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    
////    if ([self.navigationController.view superview]==nil) {
////        [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
////        [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
////        [_webView loadHTMLString:@"" baseURL:nil];
////        [_webView stopLoading];
////        _webView.delegate = nil;
////        [_webView removeFromSuperview];
////        _webView = nil;
////        
////        [_searchBarView removeFromSuperview];
////        _searchBarView = nil;
////        
////        [super hideLoadingView];
////        
////        self.view = nil;
////    }
//}
//- (void)dealloc
//{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [_webView loadHTMLString:@"" baseURL:nil];
//    [_webView stopLoading];
//    [_webView setDelegate:nil];
//    [_webView removeFromSuperview];
//    _webView = nil;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Dispose of any resources that can be recreated.
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
//        if (self.isViewLoaded && !self.view.window) {
//            
//            [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
//            [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
//            [_webView loadHTMLString:@"" baseURL:nil];
//            [_webView stopLoading];
//            _webView.delegate = nil;
//            [_webView removeFromSuperview];
//            _webView = nil;
//            
//            [[NSURLCache sharedURLCache] removeAllCachedResponses];
//            
//            [_searchBarView removeFromSuperview];
//            _searchBarView = nil;
//            
//            [super hideLoadingView];
//            
//            self.view = nil;
//        }
//    }
//    
//    [super didReceiveMemoryWarning];
//}
//
//- (void)handleReachabilityChanged:(id)notificationObject {
//    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
////    if ([[NetworkManager sharedInstance] isReachable]) {
////        [self.webView reload];
////    } else {
////        [self.webView cancel];
////    }
//}
//
//- (void)loadWebContent
//{
//    WEAKSELF;
//    if (!_webView) {
//        MyWebView *webView = [[MyWebView alloc] initWithFrame:CGRectZero];
//        
//        _webView = webView;
//        _webView.useCached = YES;
//        
//        CGFloat topBarHeight = self.topBarHeight;
//        _webView.frame = CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight);
//        _webView.backgroundColor = [UIColor whiteColor];
//        _webView.scrollView.delegate = self;
//        [weakSelf.webView removeFromSuperview];
//        [weakSelf.view addSubview:weakSelf.webView];
//        _webView.delegate = _webView;
//    }
//    {
//        NSString *exploreURL = [NSString stringWithFormat:@"%@?%ld",kURLExplore,lround(floor([[NSDate date] timeIntervalSince1970]))];
//        
//        [_webView.scrollView addPullToRefreshWithActionHandler:^{
//            [weakSelf.webView firstLoadURLString:exploreURL];
//        }];
//        
//        [weakSelf showLoadingView];
//        
//        _webView.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView
//                                                    webViewDelegate:_webView
//                                                            handler:^(id data, WVJBResponseCallback responseCallback) {}];
//        
//        WEAKSELF
//        
//        [_webView.bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//            weakSelf.webView.responseCallback = responseCallback;
//            if ([Session sharedInstance].isLoggedIn) {
//                NSDictionary *userInfo = @{@"avatar":[Session sharedInstance].currentUser.avatarUrl,
//                                           @"token":[Session sharedInstance].token,
//                                           @"user_name":[Session sharedInstance].currentUser.userName,
//                                           @"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
//                if (weakSelf.webView.responseCallback) {
//                    weakSelf.webView.responseCallback(userInfo);
//                }
//                
//            } else {
//                LoginViewController *loginVC = [[LoginViewController alloc] init];
//                [[CoordinatingController sharedInstance] presentViewController:loginVC animated:YES completion:^{
//                    
//                }];
//            }
//            
//        }];
//
//        
//        _webView.webViewDidStartLoadBlock = ^(MyWebView *webView) {
//            
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//            
//        };
//        _webView.webViewDidFinishLoadBlock = ^(MyWebView *webView) {
//            
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            
//            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [weakSelf.webView.scrollView.pullToRefreshView stopAnimating];
//            [weakSelf hideLoadingView];
//            
//            if (![NetworkManager sharedInstance].isReachable) {
//                [webView stopLoading];
//                [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//                    [weakSelf.webView firstLoadURLString:exploreURL];
//                };
//                [weakSelf showHUD:@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
//            }
//        };
//        
//        _webView.webViewShouldStartLoadWithRequestBlock = ^(MyWebView *webView, NSURLRequest *request,UIWebViewNavigationType navigationType) {
//            if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//                [URLScheme locateWithHtml5Url:request.URL.absoluteString andIsShare:YES];
//                return NO;
//            }
//            return YES;
//        };
//        _webView.webViewDidFailWithErrorBlock = ^(MyWebView *webView,NSError *error) {
//            
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            
//            [weakSelf.webView.scrollView.pullToRefreshView stopAnimating];
//            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//                if (!weakSelf.webView.isLoading) {
//                    [weakSelf.webView firstLoadURLString:kURLExplore];
//                }
//            };
//            
//            [weakSelf showHUD:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
//        };
//        if (!weakSelf.webView.isLoading) {
//            [weakSelf.webView firstLoadURLString:kURLExplore];
//        }
//    }
//}
//
//@end


@interface ExploreViewController () <UIScrollViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchBarViewDelegate,RecommendViewControllerDelegate,PagesContainerViewDelegate>

@property(nonatomic,weak) SearchBarView *searchBarView;
@property(nonatomic,weak) TopBarRightCancelButton *myTopBarRightButton;

@property(nonatomic,weak) ExploreLeftTabView *tabBar;
@property(nonatomic,strong) NSArray *viewControllers;

@property(nonatomic,weak) UIView *transitionView;
@property(nonatomic,assign) NSInteger selectAtIndex;

@end

@implementation ExploreViewController


- (id)init {
    self = [super init];
    if (self) {
        _isShowBackBtn = NO;
        _tabIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    //    [super setupTopBarTitle:@"发现"];
    
    
    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15-15, 29)];
    _searchBarView = searchBarView;
    _searchBarView.placeholder = @"搜索";
    _searchBarView.delegate = self;
    _searchBarView.searchBarDelegate = self;
    //    _searchBarView.layer.borderWidth = 0.5;
    //    _searchBarView.layer.borderColor = [UIColor colorWithHexString:@"e3e3e3"].CGColor;
    //    _searchBarView.layer.masksToBounds = YES;
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
    //    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    TopBarRightCancelButton *myTopBarRightButton = [[TopBarRightCancelButton alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
    _myTopBarRightButton = myTopBarRightButton;
    _myTopBarRightButton.backgroundColor = [UIColor clearColor];
    _myTopBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    _myTopBarRightButton.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    [_myTopBarRightButton addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myTopBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    //    [_myTopBarRightButton setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
    [self.topBar addSubview:self.myTopBarRightButton];
    
    [_searchBarView enableCancelButton:NO];
    [self.topBar addSubview:_searchBarView];
    
    _searchBarView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.85];
    _searchBarView.layer.masksToBounds = YES;
    _searchBarView.layer.cornerRadius = (_searchBarView.height)/2;
    
    //    [self.topBar addSubview:view];
    
    //CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15, 29)
    //CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-46.f-15, 29)
    //    _myTopBarRightButton.hidden = YES;
    [_myTopBarRightButton removeFromSuperview];
    [self.topBar addSubview:_myTopBarRightButton];
    _searchBarView.frame = CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15, 29);
    _myTopBarRightButton.frame = CGRectMake(super.topBar.width-15-46, _searchBarView.top, 46, _searchBarView.height);
    
    if (_isShowBackBtn) {
        [super setupTopBarBackButton];
        _searchBarView.frame = CGRectMake(super.topBarBackButton.right, _searchBarView.top, _searchBarView.right-super.topBarBackButton.right, _searchBarView.height);
    }
    
    UIView *transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:transitionView];
    _transitionView = transitionView;
    
    WEAKSELF;
    _selectAtIndex = -1;
    
    ExploreLeftTabView *tabBar = [[ExploreLeftTabView alloc] initWithFrame:CGRectMake(0, topBarHeight, 62, self.view.height-topBarHeight)];
    tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    _tabBar.handleDidSelectAtIndexBlock = ^(NSInteger index) {
        if (weakSelf.selectAtIndex!=index) {
            
            UIViewController *targetViewController = [weakSelf.viewControllers objectAtIndex:index];
            targetViewController.view.hidden = NO;
            targetViewController.view.frame = weakSelf.transitionView.bounds;//
            
            NSArray *subviews = [weakSelf.transitionView subviews];
            for (UIView *view in subviews) {
                [view removeFromSuperview];
            }
            
            if ([targetViewController.view isDescendantOfView:self.view])
            {
                [weakSelf.transitionView bringSubviewToFront:targetViewController.view];
            }
            else
            {
                targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [weakSelf.transitionView addSubview:targetViewController.view];
                if ([targetViewController isKindOfClass:[DataListViewController class]]) {
                    ((DataListViewController*)targetViewController).tableView.contentMarginTop = kTopBarHeight-2;
                }
                else if ([targetViewController isKindOfClass:[ExploreBrandViewController class]]) {
                    ((ExploreBrandViewController*)targetViewController).tableView.contentMarginTop = kTopBarHeight-2;
                    [ClientReportObject clientReportObjectWithViewCode:CatalogueViewCode regionCode:BrandViewCode referPageCode:BrandViewCode andData:nil];
                }
            }
            weakSelf.selectAtIndex = index;
        }
    };
    
    [self bringTopBarToTop];
    
    [super setupReachabilityChangedObserver];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.

    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        if (self.isViewLoaded && !self.view.window) {
            
            [_searchBarView removeFromSuperview];
            _searchBarView = nil;
            [super hideLoadingView];
            
            self.view = nil;
        }
    }
    [super didReceiveMemoryWarning];
}

///discover/classification[GET] 获取分类列表 {list[]{aidingmao协议取数据} }  接口用这个， 数据明天让前段加功能后配

- (void)loadData {
    
    WEAKSELF;
    if ([weakSelf.viewControllers count]>0) {
        
        NSMutableArray *btnsArray = [[NSMutableArray alloc] init];
        for (BaseViewController *viewController in weakSelf.viewControllers) {
            [btnsArray addObject:viewController.title?viewController.title:@""];
        }
        [weakSelf.tabBar updateWithBtnTitles:btnsArray];
        
        if (weakSelf.selectAtIndex>=0 && weakSelf.selectAtIndex<[weakSelf.viewControllers count]) {
            [weakSelf.tabBar setSelectAtIndex:weakSelf.selectAtIndex];
        } else {
            [weakSelf.tabBar setSelectAtIndex:0];
        }
        
    } else {
        [weakSelf showLoadingView];
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"discover" path:@"classification" parameters:parameters completionBlock:^(NSDictionary *data) {
            [weakSelf hideLoadingView];
            
            NSArray *array = [data arrayValueForKey:@"list"];
            if ([array isKindOfClass:[NSArray class]] && [array count]>0) {
                CGFloat marginTop = weakSelf.topBarHeight;
                marginTop += 10;
                
                NSMutableArray *btnsArray = [[NSMutableArray alloc] init];
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                for (NSString *redirectUri in array) {
                    if ([redirectUri isKindOfClass:[NSString class]] && [redirectUri length]>0) {
                        NSURL *url = [NSURL URLWithString:[[redirectUri URLDecodedString] URLEncodedString]];
                        NSString *query = url.query;
                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                            NSArray *elts = [param componentsSeparatedByString:@"="];
                            if([elts count] < 2) continue;
                            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
                        }
                        
                        NSString *module = [[params valueForKey:@"module"] URLDecodedString];
                        NSString *path = [[params valueForKey:@"path"] URLDecodedString];
                        NSString *title = [[params valueForKey:@"title"] URLDecodedString];
                        NSString *params_string = [params valueForKey:@"params"];
                        BOOL is_separate = [[[params stringValueForKey:@"is_separate"] trim] isEqualToString:@"1"]?YES:NO;
                        
                        if ([module length]>0 && [path length]>0) {
                            //brand/get_list
                            if ([module isEqualToString:@"brand"] && [path isEqualToString:@"get_list"]) {
                                ExploreBrandViewController *viewControler = [[ExploreBrandViewController alloc] init];
                                viewControler.isShowTitleBar = NO;
                                viewControler.title = title;
                                viewControler.params = params_string;
                                viewControler.tableViewContentMarginTop = kTopBarHeight-2;
                                viewControler.numOfColumns = 3;
                                [viewControllers addObject:viewControler];
                            } else {
                                DataListViewController *viewControler = [[DataListViewController alloc] init];
                                viewControler.module = module;
                                viewControler.path = path;
                                viewControler.isShowTitleBar = NO;
                                viewControler.delegate = self;
                                viewControler.title = title;
                                viewControler.params = params_string;
                                viewControler.isNeedShowSeperator = is_separate;
                                viewControler.tableViewContentMarginTop = kTopBarHeight-2;
                                [viewControllers addObject:viewControler];
                            }
                            
                            [btnsArray addObject:title?title:@""];
                        }
                    }
                }
                //
                weakSelf.viewControllers = viewControllers;
                [weakSelf.tabBar updateWithBtnTitles:btnsArray];
                if (weakSelf.tabIndex>=0 && weakSelf.tabIndex<[weakSelf.viewControllers count]) {
                    [weakSelf.tabBar setSelectAtIndex:weakSelf.tabIndex];
                } else {
                    [weakSelf.tabBar setSelectAtIndex:0];
                }
            }
        } failure:^(XMError *error) {
            [weakSelf  loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf loadData];
                });
            };
        } queue:nil]];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    //    _searchHistoryView.hidden = NO;
    
    _myTopBarRightButton.hidden = NO;
    _myTopBarRightButton.isInEditing = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _myTopBarRightButton.isInEditing = NO;
    
    _myTopBarRightButton.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //    _searchHistoryView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keywords = [searchBar.text trim];
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    if ([keywords length]>0 && [searchBar isKindOfClass:[SearchBarView class]]) {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.searchKeywords = keywords;
        viewController.searchType = ((SearchBarView*)searchBar).currentSearchType;
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

@end

#import "BrandInfo.h"
#import "BaseTableViewCell.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface ExploreBrandViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic, strong) NSMutableDictionary *sections;

@end

@implementation ExploreBrandViewController

- (id)init {
    self = [super init];
    if (self){
        _numOfColumns = 4;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = 0;
    if (self.isShowTitleBar) {
        [super setupTopBar];
        [super setupTopBarTitle:self.title?self.title:@"品牌"];
        [super setupTopBarBackButton];
    }
    
    self.sections = [[NSMutableDictionary alloc] init];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    self.tableView.pullDelegate = self;
    self.tableView.enableRefreshing = NO;
    self.tableView.enableLoadingMore = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentMarginTop = kTopBarHeight-2;
    self.tableView.sectionIndexColor = [UIColor colorWithHexString:@"666666"];//

    if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor)]) {
        [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    }
    [self bringTopBarToTop];
    
    [self loadData];
}

- (void)loadData {
    WEAKSELF;
    if ([weakSelf.sections count]==0) {
        [weakSelf showLoadingView];
        
        NSDictionary *params = @{@"params":[self.params length]>0?self.params:@""};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"brand" path:@"get_list" parameters:params completionBlock:^(NSDictionary *data) {
            [weakSelf hideLoadingView];
            weakSelf.tableView.pullTableIsRefreshing = NO;
            NSMutableDictionary *sections = [[NSMutableDictionary alloc] init];
            NSArray *dictArray = [data arrayValueForKey:@"list"];
            if ([dictArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in dictArray) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        BrandInfo *brandInfo = [BrandInfo createWithDict:dict];
                        if ([brandInfo brandName].trim.length>0 && [brandInfo iconUrl].trim.length>0) {
                            NSString *firstLetter = [brandInfo getFirstNameEn];
                            BOOL found = NO;
                            for (NSString *str in [sections allKeys]) {
                                if ([str isEqualToString:[firstLetter uppercaseString]]) {
                                    found = YES;
                                    NSMutableArray *brandsList = (NSMutableArray*)[sections objectForKey:[firstLetter uppercaseString]];
                                    [brandsList addObject:brandInfo];
                                    break;
                                }
                            }
                            if (!found) {
                                NSMutableArray *brandsList = [[NSMutableArray alloc] init];
                                [brandsList addObject:brandInfo];
                                [sections setValue:brandsList forKey:[firstLetter uppercaseString]];
                            }
                        }
                    }
                }
            }
            // Sort each section array
            for (NSString* key in [sections allKeys]) {
                [[sections objectForKey:key] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"brandEnName" ascending:YES]]];
            }
            
//            NSMutableDictionary *numSections = [[NSMutableDictionary alloc] init];
//            NSMutableDictionary *tmpSections = [[NSMutableDictionary alloc] initWithDictionary:sections];
//            for (NSString* key in [sections allKeys]) {
//                if ([key isNumeric]) {
//                    [numSections setObject:[sections objectForKey:key] forKey:key];
//                }
//            }
//            
//            for (NSString* key in [numSections allKeys]) {
//                [tmpSections removeObjectForKey:key];
//            }
//            
//            for (NSString* key in [numSections allKeys]) {
//                [tmpSections setObject:[numSections objectForKey:key]  forKey:key];
//            }
//            
//            sections = tmpSections;
            
            NSMutableDictionary *sectionsDataSoures = [[NSMutableDictionary alloc] init];
            for (NSString* key in [sections allKeys]) {
                NSMutableArray *brandsList = (NSMutableArray*)[sections objectForKey:key];
                NSMutableArray *dataSources = [[NSMutableArray alloc] init];
                NSMutableArray *groupBrands = nil;
                for (NSInteger i=0;i<[brandsList count];i++) {
                    if (!groupBrands) {
                        groupBrands = [[NSMutableArray alloc] init];
                    }
                    [groupBrands addObject:[brandsList objectAtIndex:i]];
                    if ([groupBrands count]>=weakSelf.numOfColumns) {
                        [dataSources addObject:[ExploreBrandTableViewCell buildCellDict:groupBrands numOfColums:weakSelf.numOfColumns marginLeft:weakSelf.numOfColumns==3?62:0]];
                        groupBrands = nil;
                    }
                }
                if (groupBrands && [groupBrands count]>0) {
                    [dataSources addObject:[ExploreBrandTableViewCell buildCellDict:groupBrands numOfColums:weakSelf.numOfColumns marginLeft:weakSelf.numOfColumns==3?62:0]];
                }
                if (dataSources && [dataSources count]>0) {
                    [sectionsDataSoures setObject:dataSources forKey:key];
                }
            }
            
            weakSelf.sections = sectionsDataSoures;
            
            [weakSelf.tableView reloadData];
        } failure:^(XMError *error) {
            [weakSelf  loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf loadData];
                });
            };
        } queue:nil]];
    } else {
//        weakSelf.tableView.pullTableIsRefreshing = YES;
        [weakSelf.tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [self loadData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]];
    
    CGFloat marginLeft = self.numOfColumns==3?62:0;
    marginLeft += 15;
    
    NSString* title = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section];
    
    //增加UILabel
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 0, self.view.width-marginLeft, sectionView.height)];
    [text setTextColor:[UIColor colorWithHexString:@"333333"]];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setText:title];
    [text setFont:[UIFont boldSystemFontOfSize:12.0]];
    [sectionView addSubview:text];
    return sectionView;  
}  


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString* title = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section];
//    return title;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[self.sections valueForKey:
      [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = nil;
    NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSDictionary *dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


@interface ExploreLeftTabButton : CommandButton

@end

@implementation ExploreLeftTabButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
    } else {
        [self setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    }
}
@end

@implementation ExploreLeftTabView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemHeight = self.height/[self.subviews count];
    CGFloat marginTop = 0.f;
    for (UIView *view in self.subviews) {
        view.frame = CGRectMake(0, marginTop, self.width, itemHeight);
        marginTop +=  itemHeight;
    }
}

- (void)updateWithBtnTitles:(NSArray*)btnTitiles {
    WEAKSELF;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i=0;i<[btnTitiles count];i++) {
        NSString *title = [btnTitiles objectAtIndex:i];
        if ([title isKindOfClass:[NSString class]]) {
            ExploreLeftTabButton *btn = [[ExploreLeftTabButton alloc] initWithFrame:CGRectZero];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            btn.selected = NO;
            btn.tag = i;
            [self addSubview:btn];
            btn.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf setSelectAtIndex:sender.tag];
            };
        }
    }
}

- (void)setSelectAtIndex:(NSInteger)index {
    WEAKSELF;
    for (ExploreLeftTabButton *view in self.subviews) {
        if (view.tag==index) {
            view.selected = YES;
        } else {
            view.selected = NO;
        }
    }
    if (weakSelf.handleDidSelectAtIndexBlock) {
        weakSelf.handleDidSelectAtIndexBlock(index);
    }
}

@end


@interface ExploreBrandTableViewCell()
@property(nonatomic,strong) NSArray *brandList;
@end

@implementation ExploreBrandTableViewCell {
    XMWebImageView *_iconView1;
    UILabel *_brandNameLbl1;
    
    XMWebImageView *_iconView2;
    UILabel *_brandNameLbl2;
    
    XMWebImageView *_iconView3;
    UILabel *_brandNameLbl3;
    
    XMWebImageView *_iconView4;
    UILabel *_brandNameLbl4;
    
    CGFloat _marginLeft;
    NSInteger _numOfColums;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ExploreBrandTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 92.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)brandsList numOfColums:(NSInteger)numOfColums marginLeft:(CGFloat)marginLeft {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExploreBrandTableViewCell class]];
    if (brandsList)[dict setObject:brandsList forKey:[self cellKeyForBrandList]];
    [dict setObject:[NSNumber numberWithInteger:numOfColums] forKey:[self cellKeyForNumOfColums]];
    [dict setObject:[NSNumber numberWithFloat:marginLeft] forKey:[self cellKeyForMarginLeft]];
    return dict;
}

+ (NSString*)cellKeyForBrandList {
    return @"brandsList";
}

+ (NSString*)cellKeyForNumOfColums {
    return @"numOfColums";
}

+ (NSString*)cellKeyForMarginLeft {
    return @"marginLeft";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _iconView1 = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconView1.backgroundColor = [UIColor clearColor];
        _iconView1.tag = 100;
        [self.contentView addSubview:_iconView1];
        _brandNameLbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandNameLbl1.tag = 200;
        _brandNameLbl1.numberOfLines = 2;
        _brandNameLbl1.font = [UIFont systemFontOfSize:11.f];
        [self.contentView addSubview:_brandNameLbl1];
        
        _iconView2 = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconView2.backgroundColor = [UIColor clearColor];
        _iconView2.tag = 101;
        [self.contentView addSubview:_iconView2];
        _brandNameLbl2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandNameLbl2.tag = 201;
        _brandNameLbl2.numberOfLines = 2;
        _brandNameLbl2.font = [UIFont systemFontOfSize:11.f];
        [self.contentView addSubview:_brandNameLbl2];
        
        _iconView3 = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconView3.backgroundColor = [UIColor clearColor];
        _iconView3.tag = 102;
        [self.contentView addSubview:_iconView3];
        _brandNameLbl3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandNameLbl3.tag = 202;
        _brandNameLbl3.numberOfLines = 2;
        _brandNameLbl3.font = [UIFont systemFontOfSize:11.f];
        [self.contentView addSubview:_brandNameLbl3];
        
        _iconView4 = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconView4.backgroundColor = [UIColor clearColor];
        _iconView4.tag = 103;
        [self.contentView addSubview:_iconView4];
        _brandNameLbl4 = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandNameLbl4.tag = 203;
        _brandNameLbl4.numberOfLines = 2;
        _brandNameLbl4.font = [UIFont systemFontOfSize:11.f];
        [self.contentView addSubview:_brandNameLbl4];
        
        UIColor *textColor = [UIColor colorWithHexString:@"999999"];
        _brandNameLbl1.textColor = textColor;
        _brandNameLbl2.textColor = textColor;
        _brandNameLbl3.textColor = textColor;
        _brandNameLbl4.textColor = textColor;
        
        WEAKSELF;
        _iconView1.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if ([weakSelf.brandList count]>0) {
                BrandInfo *brandInfo = [weakSelf.brandList objectAtIndex:0];
                [URLScheme locateWithRedirectUri:brandInfo.redirect_uri andIsShare:YES];
                NSDictionary *data = @{@"url":brandInfo.redirect_uri};
                [weakSelf client:data];
            }
        };
        _iconView2.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if ([weakSelf.brandList count]>1) {
                BrandInfo *brandInfo = [weakSelf.brandList objectAtIndex:1];
                [URLScheme locateWithRedirectUri:brandInfo.redirect_uri andIsShare:YES];
                NSDictionary *data = @{@"url":brandInfo.redirect_uri};
                [weakSelf client:data];
            }
        };
        _iconView3.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if ([weakSelf.brandList count]>2) {
                BrandInfo *brandInfo = [weakSelf.brandList objectAtIndex:2];
                [URLScheme locateWithRedirectUri:brandInfo.redirect_uri andIsShare:YES];
                NSDictionary *data = @{@"url":brandInfo.redirect_uri};
                [weakSelf client:data];
            }
        };
        _iconView4.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if ([weakSelf.brandList count]>3) {
                BrandInfo *brandInfo = [weakSelf.brandList objectAtIndex:3];
                [URLScheme locateWithRedirectUri:brandInfo.redirect_uri andIsShare:YES];
                NSDictionary *data = @{@"url":brandInfo.redirect_uri};
                [weakSelf client:data];
            }
        };
    }
    return self;
}

-(void)client:(NSDictionary *)data{
    [ClientReportObject clientReportObjectWithViewCode:BrandViewCode regionCode:MineDiscountCouponViewCode referPageCode:MineDiscountCouponViewCode andData:data];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _iconView1.hidden = YES;
    _brandNameLbl1.hidden = YES;
    _iconView2.hidden = YES;
    _brandNameLbl2.hidden = YES;
    _iconView3.hidden = YES;
    _brandNameLbl3.hidden = YES;
    _iconView4.hidden = YES;
    _brandNameLbl4.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_numOfColums==0) {
        _numOfColums = 4;
    }
    CGFloat marginLeft = _marginLeft;
    CGFloat width = (self.contentView.width-_marginLeft)/_numOfColums;
    
    _iconView1.frame = CGRectMake(marginLeft+(width-52)/2, (62-52)/2, 52, 52);
    
    [_brandNameLbl1 sizeToFit];
    _brandNameLbl1.frame = CGRectMake(marginLeft+(width-52)/2, _iconView1.bottom+5, 52, _brandNameLbl1.height);
    marginLeft += width;
    
    _iconView2.frame = CGRectMake(marginLeft+(width-52)/2, (62-52)/2, 52, 52);
    
    [_brandNameLbl2 sizeToFit];
    _brandNameLbl2.frame = CGRectMake(marginLeft+(width-52)/2, _iconView2.bottom+5, 52, _brandNameLbl2.height);
    marginLeft += width;
    
    _iconView3.frame = CGRectMake(marginLeft+(width-52)/2, (62-52)/2, 52, 52);
    
    [_brandNameLbl3 sizeToFit];
    _brandNameLbl3.frame = CGRectMake(marginLeft+(width-52)/2, _iconView3.bottom+5, 52, _brandNameLbl3.height);
    marginLeft += width;
    
    _iconView4.frame = CGRectMake(marginLeft+(width-52)/2, (62-52)/2, 52, 52);
    
    [_brandNameLbl4 sizeToFit];
    _brandNameLbl4.frame = CGRectMake(marginLeft+(width-52)/2, _iconView4.bottom+5, 52, _brandNameLbl4.height);
    marginLeft += width;
    
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    _marginLeft = [[dict objectForKey:[[self class] cellKeyForMarginLeft]] floatValue];
    _numOfColums = [[dict objectForKey:[[self class] cellKeyForNumOfColums]] floatValue];
    NSArray *brandList = [dict objectForKey:[[self class] cellKeyForBrandList]];
    _brandList = brandList;
    if ([brandList isKindOfClass:[NSArray class]]) {
        for (NSInteger i=0;i<brandList.count;i++) {
            BrandInfo *brandInfo = [brandList objectAtIndex:i];
            XMWebImageView *imageView = (XMWebImageView*)[self.contentView viewWithTag:100+i];
            [imageView setImageWithURL:brandInfo.iconUrl placeholderImage:nil size:CGSizeMake(52*2, 52*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
            imageView.hidden = NO;
            
            UILabel *labl = (UILabel*)[self.contentView viewWithTag:200+i];
            labl.text = brandInfo.brandName;
            labl.hidden = NO;
            labl.textAlignment = NSTextAlignmentCenter;
        }
    }
    [self setNeedsLayout];
}


@end



