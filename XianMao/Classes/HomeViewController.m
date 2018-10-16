//
//  HomeViewController.m
//  XianMao
//
//  Created by simon cai on 18/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "HomeViewController.h"
#import "PagesContainerView.h"
#import "RecommendViewController.h"
#import "FollowingsViewController.h"
#import "LatestViewController.h"

#import "QrCodeScanViewController.h"
#import "SearchViewController.h"
#import "FeedsViewController.h"

@interface HomeViewController () <UIGestureRecognizerDelegate,PagesContainerViewDelegate,RecommendViewControllerDelegate>
@property(nonatomic,weak) PagesContainerView *pagesContainerView;
@property(nonatomic,strong) NSArray *viewControllers;
@property(nonatomic,assign) NSInteger curSelectedAtIndex;
@end

@implementation HomeViewController {
    CGFloat _lastContentOffsetY;
}

- (id)init {
    self = [super init];
    if (self) {
        RecommendViewController *recommendController = [[RecommendViewController alloc] init];
        recommendController.title = @" 精选 ";
        recommendController.delegate = self;
        
        FollowingsViewController *followingsController = [[FollowingsViewController alloc] init];
        followingsController.title = @" 关注 ";
        followingsController.delegate = self;
        
        FeedsViewController *latestController = [[FeedsViewController alloc] init];
        latestController.title = @" 最新 ";
        latestController.delegate = self;
        
        _viewControllers = @[recommendController, followingsController,latestController];
        
        _curSelectedAtIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    CGFloat topBarHeight = [super setupTopBar];
//    CGFloat topBarHeight = kTopBarHeight;
//    super.topBar.image = nil;
//    [super setupTopBarLogo:[UIImage imageNamed:@"titlebar_logo"]];
//    //[super setupTopBarBackButton:[UIImage imageNamed:@"category_normal.png"] imgPressed:nil];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"search_normal"] imgPressed:nil];
//
//    [super setupTopBarBackButton:[UIImage imageNamed:@"qrcode_scan"] imgPressed:nil];
    
    
    CGFloat topbarShadowHeight = 2.f;
    
    PagesContainerView *pagesContainerView = [[PagesContainerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    _pagesContainerView = pagesContainerView;
    _pagesContainerView.backgroundColor = [UIColor whiteColor];
    UIImage *img = [UIImage imageNamed:@"titlebar_bg"];
    _pagesContainerView.topBarHeight = kTopBarHeight;
    _pagesContainerView.topBarShadowHeight = topbarShadowHeight;
    _pagesContainerView.topBar.contentMarginTop = kTopBarContentMarginTop;
    _pagesContainerView.topBar.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    _pagesContainerView.pageIndicatorView.hidden = NO;
    _pagesContainerView.topBarBackgroundColor = [UIColor clearColor];
    _pagesContainerView.pageIndicatorColor = [UIColor colorWithHexString:@"c2a79d"];
    _pagesContainerView.pageIndicatorViewSize = CGSizeMake(40, 2);
    _pagesContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _pagesContainerView.delegate = self;
    _pagesContainerView.contentMarginTop = -(kTopBarHeight-topbarShadowHeight);
    [self.view addSubview:_pagesContainerView];
    
//    _pagesContainerView.topBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    ;
    _pagesContainerView.topBar.scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTopBar:)];
    [_pagesContainerView.topBar.scrollView addGestureRecognizer:tapGesture];
    [_pagesContainerView.topBar addGestureRecognizer:tapGesture];    
    
    self.pagesContainerView.viewControllers = _viewControllers;
    
    if (self.pagesContainerView.selectedIndex != _curSelectedAtIndex) {
        [self.pagesContainerView setSelectedIndex:_curSelectedAtIndex animated:NO];
    }
    
//    {
//        UIImage *imgNormal = [UIImage imageNamed:@"qrcode_scan"];
//        UIImage *imgPressed = nil;
//        CGFloat height = CGRectGetHeight(self.pagesContainerView.topBar.bounds)-kTopBarContentMarginTop-topbarShadowHeight;
//        CGFloat width = height;
//        CGFloat X = 15-(imgNormal!=nil?(width-imgNormal.size.width)/2:0);
//        UIButton *topBarBackButton = [[UIButton alloc] initWithFrame:CGRectMake(X, kTopBarContentMarginTop, width, height)];
//        topBarBackButton.backgroundColor = [UIColor clearColor];
//        [topBarBackButton addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [topBarBackButton setImage:imgNormal forState:UIControlStateNormal];
//        [topBarBackButton setImage:imgPressed forState:UIControlStateHighlighted];
//        [self.pagesContainerView.topBar addSubview:topBarBackButton];
//    }
//    
//    {
//        UIImage *imgNormal = [UIImage imageNamed:@"search_normal"];
//        UIImage *imgPressed = nil;
//        CGFloat height = CGRectGetHeight(self.pagesContainerView.topBar.bounds)-kTopBarContentMarginTop-topbarShadowHeight;
//        CGFloat width = height;
//        CGFloat X = CGRectGetWidth(self.pagesContainerView.topBar.bounds)-width-(imgNormal!=nil?(15-(width-imgNormal.size.width)/2):15);
//        UIButton *topBarRightButton = [[UIButton alloc] initWithFrame:CGRectMake(X, kTopBarContentMarginTop, width+10, width)];
//        topBarRightButton.backgroundColor = [UIColor clearColor];
//        [topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
//        [topBarRightButton addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [topBarRightButton setImage:imgNormal forState:UIControlStateNormal];
//        [topBarRightButton setImage:imgPressed forState:UIControlStateHighlighted];
//        [self.pagesContainerView.topBar addSubview:topBarRightButton];
//    }
}

- (void)recommendTableViewScrollViewDidScroll:(UIScrollView *)scrollView viewController:(RecommendViewController*)viewController
{
//    if ([_pagesContainerView.viewControllers objectAtIndex:_pagesContainerView.selectedIndex]==viewController) {
//        CGFloat currentPosition = scrollView.contentOffset.y;
//        CGFloat contentMarginTop = 0;
//        if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
//            contentMarginTop = ((PullRefreshTableView*)scrollView).contentMarginTop;
//        }
//        
//        if (currentPosition<=-contentMarginTop) {
//            _pagesContainerView.topBar.alpha = 1.f;
//        } else {
//            currentPosition = currentPosition+contentMarginTop;
//            CGFloat lastContentOffsetY = _lastContentOffsetY+contentMarginTop;
//            
//            if (currentPosition < lastContentOffsetY) {
//                //下拉
//                CGFloat alpha = (lastContentOffsetY-currentPosition)/180.f+_pagesContainerView.topBar.alpha;
//                if (alpha>1)alpha= 1.;
//                _pagesContainerView.topBar.alpha = alpha;
//                _pagesContainerView.pageIndicatorView.alpha = alpha;
//            } else {
//                //上
//                CGFloat alpha = (lastContentOffsetY-currentPosition)/180.f+_pagesContainerView.topBar.alpha;
//                if (alpha<0.6)alpha= 0.6;
//                _pagesContainerView.topBar.alpha = alpha;
//                _pagesContainerView.pageIndicatorView.alpha = alpha;
//            }
//        }
//        _lastContentOffsetY = scrollView.contentOffset.y;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
            _curSelectedAtIndex = _pagesContainerView.selectedIndex;;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.view = nil;
//    _curSelectedAtIndex = _pagesContainerView.selectedIndex;;
}

#pragma mark - qrcode
- (void)handleTopBarBackButtonClicked:(UIButton*)sender
{
    QrCodeScanViewController *serviceWeb = [[QrCodeScanViewController alloc] init];
    [super pushViewController:serviceWeb animated:YES];
}

- (void)handleTopBarRightButtonClicked:(UIButton*)sender
{
    [MobClick event:@"click_search_from_homepage"];
    SearchViewController *viewController = [[SearchViewController alloc] init];
    [super pushViewController:viewController animated:YES];
}


- (void)tappedTopBar:(UIGestureRecognizer*)gesture
{
    NSInteger selectedIndex = _pagesContainerView.selectedIndex;
    [self pageDidSelectAtIndex:selectedIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger selectedIndex = _pagesContainerView.selectedIndex;
    UIViewController *viewController = [_pagesContainerView.viewControllers objectAtIndex:selectedIndex];
    if ([viewController isKindOfClass:[RecommendViewController class]]) {
        [viewController viewWillAppear:YES];
    }
}

- (void)pageTopBarItemClickedAtIndex:(NSInteger)index
{
    NSInteger selectedIndex = _pagesContainerView.selectedIndex;
    if (selectedIndex == index) {
        if (selectedIndex>=0&&selectedIndex<_pagesContainerView.viewControllers.count) {
            UIViewController *viewController = [_pagesContainerView.viewControllers objectAtIndex:selectedIndex];
            if ([viewController isKindOfClass:[RecommendViewController class]]) {
                [((RecommendViewController*)viewController).tableView scrollViewToTop:YES];
            }
        }
    } 
}

- (void)pageBeforeSelectAtIndex:(NSInteger)index
{
    UIViewController *viewController = [_pagesContainerView.viewControllers objectAtIndex:index];
    if ([viewController isKindOfClass:[RecommendViewController class]]) {
        [viewController viewWillAppear:YES];
    }
    
    if (index==0) {
        [MobClick event:@"click_recommand_feeds"];
    } else if (index ==1){
        [MobClick event:@"click_favor_feeds"];
    } else {
        [MobClick event:@"click_just_in_feeds"];
    }
    
}

- (void)pageDidSelectAtIndex:(NSInteger)selectedIndex
{
    
}

@end


