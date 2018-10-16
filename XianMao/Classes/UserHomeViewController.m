//
//  UserHomeViewController.m
//  XianMao
//
//  Created by simon cai on 11/10/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UserHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PullRefreshTableView.h"
#import "GoodsDetailViewController.h"
#import "GoodsTableViewCell.h"
#import "GoodsGalleryGridCell.h"
#import "UserHomeTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "OwnHomeHeaderView.h"
#import "BlankTableViewCell.h"
#import "SepTableViewCell.h"

#import "DataSources.h"

#import "MineViewController.h"

#import "EditProfileViewController.h"
#import "FollowsViewController.h"
#import "CoordinatingController.h"
#import "ForumOneSelfController.h"

#import "DataListLogic.h"
#import "GoodsInfo.h"
#import "UserDetailInfo.h"

#import "Session.h"
#import "NetworkAPI.h"

#import "UIImage+Resize.h"
#import "ActionSheet.h"
#import "AssetPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AreaViewController.h"

#import "AppDirs.h"

#import "GoodsMemCache.h"
#import "UIActionSheet+Blocks.h"

#import "SearchFilterInfo.h"
#import "SearchViewController.h"

#import "NSString+URLEncoding.h"
#import "JSONKit.h"

#import "CoordinatingController.h"
#import "URLScheme.h"
#import "MineGoodsShelfCell.h"
#import "UserHomeGoodsShelfCateCell.h"
#import "UserHomeSegCell.h"
#import "UserHomeAlSaleCell.h"
#import "UserHomeAlSelaCataCell.h"
#import "RecoverCollectionViewController.h"
#import "SoldCollectionViewController.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "AboutViewController.h"
#import "ShoppingCartViewController.h"
#import "VisualEffectView.h"
#import "IdleTableViewCell.h"
#import "ADMShoppingCentreViewController.h"

@interface UserHomeViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,GoodsInfoChangedReceiver,UserInfoChangedReceiver,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserHomeHeaderViewDelegate,UserHomeDetailViewDelegate,EditProfileViewControllerDelegate>

@property(nonatomic,weak)   UserHomeHeaderView *headerView;
@property(nonatomic,retain) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) NSMutableArray *goodsArrayList;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,strong) DataListLogic *dataListLogicSearch;

@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,strong) UserDetailInfo *userDetailInfo;

@property(nonatomic,strong) HTTPRequest *requestForFront;
@property(nonatomic,strong) ADMActionSheet *actionSheet;

@property(nonatomic,assign) BOOL isFirstLoad;

@property(nonatomic,strong) UserHomeDetailView *detailView;
@property (nonatomic, strong) OwnHomeHeaderView * ownHeaderView;
@property(nonatomic,strong) NSMutableArray *filterInfoArray;

@end

@implementation UserHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WEAKSELF;
    [weakSelf showLoadingView];     //storeType 1个人 2商家
    _request = [[NetworkAPI sharedInstance] getUserDetail:self.userId completion:^(UserDetailInfo *userDetailInfo) {
        [weakSelf hideLoadingView];
        
        //        weakSelf.viewControllers = [NSArray arrayWithObjects:
        //                                [[MyNavigationController alloc] initWithRootViewController:detailViewController],
        //                                [[MyNavigationController alloc] initWithRootViewController:c2cController],
        //                                nil];
        if (userDetailInfo.userInfo.userId == [Session sharedInstance].currentUserId) {
            [weakSelf setNomalUser];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            return ;
        }
        
        if (userDetailInfo.userInfo.storeType == 1) {
            [weakSelf setNomalUser];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            ADMShoppingCentreViewController *shoppingCenterController = [[ADMShoppingCentreViewController alloc] init];
            shoppingCenterController.userId = self.userId;
            [shoppingCenterController updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
            //            [[CoordinatingController sharedInstance].visibleController.navigationController setViewControllers:@[shoppingCenterController]];
            [weakSelf addChildViewController:shoppingCenterController];
            [self.view addSubview:shoppingCenterController.view];
        }
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
}

-(void)setNomalUser{
    //    CGFloat topBarHeight = [super setupTopBar];
    //    [super setupTopBarTitle:@""];
    //    [super setupTopBarRightButton:[UIImage imageNamed:@"edit_profile.png"] imgPressed:nil];
    //    [super setupTopBarBackButton];

    
    CGFloat topBarHeight = 0.f;
    [super setupTopBar];
    self.topBar.backgroundColor = [UIColor clearColor];
    self.topBarlineView.hidden = YES;
    self.topBarRightButton.backgroundColor  = [UIColor clearColor];
    [super setupTopBarBackButton:[UIImage imageNamed:@"back_button-white"] imgPressed:[UIImage imageNamed:@"back_button-white"]];
    [super setupTopBarRightButton:[UIImage imageNamed:@"three_point"] imgPressed:[UIImage imageNamed:@"three_point"]];
    [super setupTopBarRightTwoButton:[UIImage imageNamed:@"shopping_bag_white_new"] imgPressed:[UIImage imageNamed:@"shopping_bag_white_new"]];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    self.goodsArrayList = [NSMutableArray arrayWithCapacity:60];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    self.tableView.autoTriggerLoadMore = YES;
    self.tableView.enableLoadingMore = NO;
    self.tableView.enableRefreshing = NO;
    [self.view addSubview:self.tableView];
    
    
    //    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2+5, 20, 20)];
    //    backBtn.layer.cornerRadius = 16.f;
    ////    backBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
    //    [backBtn addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [backBtn setImage:[UIImage imageNamed:@"back-MF"] forState:UIControlStateNormal];
    //    [self.view addSubview:backBtn];
    //    backBtn.tag = 1100;
    //
    //    TapDetectingView *backBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, backBtn.top-(62-backBtn.height)/2, 62, 62)];
    //    backBgView.backgroundColor = [UIColor clearColor];
    //    backBgView.tag = 1111;
    //    [self.view addSubview:backBgView];
    //    WEAKSELF;
    //    backBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
    //        [weakSelf handleTopBarBackButtonClicked:nil];
    //    };
    
    
    //    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-15-64, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 64, 32)];
    //    followBtn.layer.cornerRadius = 16.f;
    //    followBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
    //    [followBtn addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    //    [followBtn setTitleColor:[UIColor colorWithHexString:@"FFE8B0"] forState:UIControlStateNormal];
    //    followBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    //    [self.view addSubview:followBtn];
    //    followBtn.hidden = YES;
    //    followBtn.tag = 1101;
    
    //    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-3-50, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-65)/2+5, 50, 50)];
    //    shareBtn.layer.cornerRadius = 16.f;
    ////    shareBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
    //    [shareBtn addTarget:self action:@selector(handleShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [shareBtn setImage:[UIImage imageNamed:@"Share_TopBar_New_MF"] forState:UIControlStateNormal];
    //    [self.view addSubview:shareBtn];
    //    shareBtn.hidden = YES;
    //    shareBtn.tag = 1102;
    
    
    //    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtn.left-3-38, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2 - 2, 25, 25)];
    //    editBtn.layer.cornerRadius = 16.f;
    ////    editBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
    //    [editBtn addTarget:self action:@selector(handleEditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [editBtn setImage:[UIImage imageNamed:@"MineText"] forState:UIControlStateNormal];
    //    [self.view addSubview:editBtn];
    //    editBtn.hidden = YES;
    //    editBtn.tag = 1103;
    
    
    //    CGFloat marginLeft = backBtn.right+10;
    //    _searchBarView = [[UIView alloc] initWithFrame:CGRectMake(marginLeft, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-24)/2, self.view.width-marginLeft-marginLeft, 24)];
    //    _searchBarView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.85];
    //    _searchBarView.layer.masksToBounds = YES;
    //    _searchBarView.layer.cornerRadius = 12.f;
    //    [self.view addSubview:_searchBarView];
    
    [self updateTitleBar];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    [self updateTitleBar];
    
    [self showLoadingView];
    
    if (self.userId>0) {
        self.isFirstLoad = YES;
        [self initDataListLogic];
        [self reloadUserData];
    } else {
        [self loadEndWithNoContent:@"改用户不存在"];
    }
}

- (void)bringTopBarToTop {
    [self.view bringSubviewToFront:[self.view viewWithTag:1111]];
    [self.view bringSubviewToFront:[self.view viewWithTag:1100]];
    //    [self.view bringSubviewToFront:[self.view viewWithTag:1101]];
    [self.view bringSubviewToFront:[self.view viewWithTag:1102]];
    [self.view bringSubviewToFront:[self.view viewWithTag:1103]];
    
}

- (void)updateFollowButtonStatus:(BOOL)isFollowing {
    //    WEAKSELF;
    //    UIButton *followBtn = (UIButton*)[weakSelf.view viewWithTag:1101];
    //    if (isFollowing) {
    //        [followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    //        [followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    //        [followBtn setImage:nil forState:UIControlStateNormal];
    //        followBtn.selected = YES;
    //        followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //        followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    } else {
    //        [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    //        [followBtn setTitle:@"关注" forState:UIControlStateSelected];
    //        [followBtn setImage:[UIImage imageNamed:@"follow_icon"] forState:UIControlStateNormal];
    //        followBtn.selected = NO;
    //        followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5f);
    //        followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 1.5f, 0, 0);
    //    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView = nil;
    self.dataSources = nil;
}

- (void)initDataListLogic
{
    WEAKSELF;
    
    weakSelf.tableView.enableRefreshing = NO;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"get_user_goods" pageSize:12];
    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:self.userId]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        //        if (weakSelf.tableView.enableRefreshing) {
        //            weakSelf.tableView.pullTableIsRefreshing = YES;
        //        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        
        if ([weakSelf.dataSources count] == 0) {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:1];
            [newList addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:nil isLoading:YES]];
            [weakSelf.dataSources removeAllObjects];
            [weakSelf setDataSources:newList];
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        
        weakSelf.tableView.enableLoadingMore = YES;
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        if ([weakSelf.dataSources count]>0) {
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
            if (ClsTableViewCell == [BlankTableViewCell class]) {
                [weakSelf.dataSources removeObjectAtIndex:0];
            }
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        
        //        _request = [[NetworkAPI sharedInstance] getUserDetail:self.userId completion:^(UserDetailInfo *userDetailInfo) {
        //            [LoadingView hideLoadingView:weakSelf.view];

        if ([Session sharedInstance].currentUserId == weakSelf.userId) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:[UserHomeSegCell buildCellDict]];
            [arr addObject:[MineGoodsShelfCell buildCellDict]];
            [arr addObject:[UserHomeGoodsShelfCateCell buildCellDict]];
            [arr addObject:[UserHomeSegCell buildCellDict]];
            [arr addObject:[UserHomeAlSaleCell buildCellDict]];
            [arr addObject:[UserHomeAlSelaCataCell buildCellDict]];
            [arr addObject:[UserHomeSegCell buildCellDict]];
            weakSelf.dataSources = arr;
        }
        
        //            if ([weakSelf.filterInfoArray count]>0) {
        //
        //                [weakSelf.dataSources addObject:[buildCellDict:weakSelf.filterInfoArray]];
        //                [weakSelf.dataSources addObject:[UserHomeGoodsTotalNumCell buildCellDict:weakSelf.userDetailInfo.userInfo.goodsNum]];
        //            }
        
        for (int i = 0; i < addedItems.count; i++) {
            [weakSelf.dataSources addObject:[IdleTableViewCell buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
            [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
        
        //            for (NSInteger i=0;i<[addedItems count];i+=2) {
        //                NSMutableArray *array = [[NSMutableArray alloc] init];
        //                [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
        //                if (i+1>=[addedItems count]) {
        //                    [weakSelf.goodsArrayList addObject:array];
        //                    break;
        //                }
        //                [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
        //                [weakSelf.goodsArrayList addObject:array];
        //            }
        //
        //            for (NSInteger i=0;i<[weakSelf.goodsArrayList count];i++) {
        //                if ([weakSelf.dataSources count]>0) {
        //                    //                [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        //                }
        //                NSArray *array = [weakSelf.goodsArrayList objectAtIndex:i];
        //                [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
        //                [weakSelf.dataSources addObject:[SepTwoTableViewCell buildCellDict]];
        //            }
        //[weakSelf.dataSources insertObject:[SepTableViewCell buildCellDict] atIndex:0];
        if (loadFinished) {
            //            [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        [weakSelf.tableView reloadData];
        //        } failure:^(XMError *error) {
        //
        //        }];
        
        //        RecommendGoodsInfo *goodsInfo = [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:0]];
        //        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        //        for (int i=0;i<[addedItems count];i++) {
        //            if (i>0) {
        //                [newList addObject:[SepTableViewCell buildCellDict]];
        //            }
        //            BOOL isDataChanged = NO;
        //            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
        //            [newList addObject:[GoodsGalleryGridCell buildCellDict:goodsInfo]];
        //        }
        //        weakSelf.dataSources = newList;
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        
        if ([weakSelf.dataSources count]>0) {
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
            if (ClsTableViewCell == [BlankTableViewCell class]) {
                [weakSelf.dataSources removeObjectAtIndex:0];
            }
        }
        
        weakSelf.tableView.enableLoadingMore = YES;
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        BOOL ignoreCount = 0;
        if ([addedItems count]>0) {
            NSMutableArray *array = nil;
            if ([weakSelf.goodsArrayList count]>0) {
                array = [weakSelf.goodsArrayList objectAtIndex:[weakSelf.goodsArrayList count]-1];
            }
            if (array && [array count]==1) {
                [array addObject: [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:0]]];
                ignoreCount = 1;
            }
        }
        
        for (int i = 0; i < addedItems.count; i++) {
            [weakSelf.dataSources addObject:[IdleTableViewCell buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
            [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
        //        NSMutableArray *addedGoodsArrayList = [[NSMutableArray alloc] init];
        //        for (NSInteger i=0;i<[addedItems count]-ignoreCount;i+=2) {
        //            NSMutableArray *array = [[NSMutableArray alloc] init];
        //            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
        //            if (i+1>=[addedItems count]-ignoreCount) {
        //                //                [weakSelf.goodsArrayList addObject:array];
        //                [addedGoodsArrayList addObject:array];
        //                break;
        //            }
        //            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
        //            //[weakSelf.goodsArrayList addObject:array];
        //            [addedGoodsArrayList addObject:array];
        //        }
        //
        //        [weakSelf.goodsArrayList addObjectsFromArray:addedGoodsArrayList];
        //
        //        for (NSInteger i=0;i<[addedGoodsArrayList count];i++) {
        //            NSArray *array = [addedGoodsArrayList objectAtIndex:i];
        //            if ([weakSelf.dataSources count]>0) {
        //                [weakSelf.dataSources addObject:[SepTwoTableViewCell buildCellDict]];
        //            }
        //            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
        //        }
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SepTwoTableViewCell buildCellDict]];
        }
        
        //        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        //        for (int i=0;i<[addedItems count];i++) {
        //            if (i>0) {
        //                [newList addObject:[SepTableViewCell buildCellDict]];
        //            }
        //
        //            BOOL isDataChanged = NO;
        //            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
        //            [newList addObject:[GoodsGalleryGridCell buildCellDict:goodsInfo]];
        //        }
        //        if ([newList count]>0) {
        //            //NSInteger count = [weakSelf.dataSources count];
        //            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
        //            if ([dataSources count]>0) {
        //                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
        //            }
        //            [dataSources addObjectsFromArray:newList];
        //            weakSelf.dataSources = dataSources;
        //        }
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        
        if ([weakSelf.dataSources count]>0) {
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
            if (ClsTableViewCell == [BlankTableViewCell class]) {
                [weakSelf.dataSources removeObjectAtIndex:0];
            }
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
        weakSelf.tableView.enableRefreshing = NO;//YES;

        if ([Session sharedInstance].currentUserId != weakSelf.userId) {
            [weakSelf.dataSources removeAllObjects];
            [weakSelf.dataSources addObject:[UserHomeSegCell buildCellDict]];
            [weakSelf.dataSources addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:@"暂无商品"]];
        }
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
}

- (void)reloadUserData
{
    WEAKSELF;
    [weakSelf.dataSources addObject:[UserHomeSegCell buildCellDict]];
    if ([Session sharedInstance].currentUserId == weakSelf.userId) {
        [weakSelf.dataSources addObject:[MineGoodsShelfCell buildCellDict]];
        [weakSelf.dataSources addObject:[UserHomeGoodsShelfCateCell buildCellDict]];
        [weakSelf.dataSources addObject:[UserHomeSegCell buildCellDict]];
        [weakSelf.dataSources addObject:[UserHomeAlSaleCell buildCellDict]];
        [weakSelf.dataSources addObject:[UserHomeAlSelaCataCell buildCellDict]];
        [weakSelf.dataSources addObject:[UserHomeSegCell buildCellDict]];
    }
    
    _request = [[NetworkAPI sharedInstance] getUserDetail:self.userId completion:^(UserDetailInfo *userDetailInfo) {
        [LoadingView hideLoadingView:weakSelf.view];
        weakSelf.userDetailInfo = userDetailInfo;
        UserHomeHeaderView *headerView = [[UserHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:userDetailInfo.userInfo])];
        OwnHomeHeaderView * ownHeaderView = [[OwnHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [OwnHomeHeaderView heightForOrientationPortrait:userDetailInfo.userInfo])];
        if ([Session sharedInstance].currentUserId == weakSelf.userId) {
            weakSelf.tableView.tableHeaderView = ownHeaderView;
            [ownHeaderView updateWithUserInfo:userDetailInfo];
        }else{
            weakSelf.tableView.tableHeaderView = headerView;
            [headerView updateWithUserInfo:userDetailInfo];
        }
        
        weakSelf.headerView = headerView;
        weakSelf.ownHeaderView = ownHeaderView;
        weakSelf.headerView.myDelegate = weakSelf;
        
        if (userDetailInfo.userInfo.userId == [Session sharedInstance].currentUserId) {
            [[Session sharedInstance] setUserInfo:userDetailInfo.userInfo];
        } else {
            [weakSelf updateFollowButtonStatus:weakSelf.userDetailInfo.userInfo.isfollowing];
        }
        
        [weakSelf loadGoodsFilter];
        
    } failure:^(XMError *error) {
        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf) {
                    [weakSelf reloadUserData];
                }
            });
        };
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
        
        [weakSelf bringTopBarToTop];
    }];
}

///search/goods_filter
- (void)loadGoodsFilter
{
    WEAKSELF;
    NSDictionary *parameters = @{@"seller_id":[NSNumber numberWithInteger:self.userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"goods_filter" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSArray *list = [data arrayValueForKey:@"list"];
        NSMutableArray *filterInfoArray = [NSMutableArray arrayWithCapacity:list.count];
        if ([list isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in list) {
                SearchFilterInfo *filerInfo = [SearchFilterInfo createWithDict:dict];
                if ([filerInfo isCompatible]) {
                    [filterInfoArray addObject:filerInfo];
                }
            }
        }
        
        weakSelf.filterInfoArray = filterInfoArray;
        
        [weakSelf.dataListLogic reloadDataListByForce];
        
    } failure:^(XMError *error) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        
    } queue:nil]];
}

+ (NSDictionary*)createQueryParam:(NSString*)queryKey queryValue:(NSString*)queryValue {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (queryKey) [dict setObject:queryKey forKey:@"qk"];
    if (queryValue) [dict setObject:queryValue forKey:@"qv"];
    return dict;
}

- (void)doSearch
{
    WEAKSELF;
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    //    NSMutableString *params = [[NSMutableString alloc] initWithString:@""];
    NSArray *filterInfos = weakSelf.filterInfoArray;
    for (SearchFilterInfo *filterInfo in filterInfos) {
        if ([filterInfo isKindOfClass:[SearchFilterInfo class]]) {
            if (filterInfo.type == 2) {
                if (filterInfo.queryKey && [filterInfo.queryKey length]>0) {
                    for (SearchFilterItem *filterItem in filterInfo.items) {
                        if ([filterItem isKindOfClass:[SearchFilterItem class]] && filterItem.isYesSelected && filterItem.queryValue && [filterItem.queryValue length]>0) {
                            [paramsArray addObject:[[weakSelf class] createQueryParam:filterInfo.queryKey queryValue:filterItem.queryValue]];
                        }
                    }
                }
            }
        }
    }
    
    NSString *params = [[paramsArray JSONString] URLEncodedString];
    
    [weakSelf showProcessingHUD:nil];
    
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"list" pageSize:16 fetchSize:32];
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.parameters = @{@"keywords":@"",
                                  @"params":params?params:@"",
                                  @"seller_id":[NSNumber numberWithInteger:self.userId]};
    
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        //        if (weakSelf.tableView.enableRefreshing) {
        //            weakSelf.tableView.pullTableIsRefreshing = YES;
        //        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.enableLoadingMore = YES;
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        if ([weakSelf.dataSources count]>0) {
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
            if (ClsTableViewCell == [BlankTableViewCell class]) {
                [weakSelf.dataSources removeObjectAtIndex:0];
            }
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        
        if ([Session sharedInstance].currentUserId == weakSelf.userId) {
            [weakSelf.dataSources addObject:[MineGoodsShelfCell buildCellDict]];
            [weakSelf.dataSources addObject:[UserHomeGoodsShelfCateCell buildCellDict]];
            [weakSelf.dataSources addObject:[UserHomeSegCell buildCellDict]];
            [weakSelf.dataSources addObject:[UserHomeAlSaleCell buildCellDict]];
            [weakSelf.dataSources addObject:[UserHomeAlSelaCataCell buildCellDict]];
            [weakSelf.dataSources addObject:[UserHomeSegCell buildCellDict]];
        }
        
        //        [weakSelf.dataSources addObject:[UserHomeSearchFilterCell buildCellDict:weakSelf.filterInfoArray]];
        //        [weakSelf.dataSources addObject:[UserHomeGoodsTotalNumCell buildCellDict:weakSelf.userDetailInfo.userInfo.goodsNum]];
        
        for (int i = 0; i < addedItems.count; i++) {
            [weakSelf.dataSources addObject:[IdleTableViewCell buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
            [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
        //        for (NSInteger i=0;i<[addedItems count];i+=2) {
        //            NSMutableArray *array = [[NSMutableArray alloc] init];
        //            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
        //            if (i+1>=[addedItems count]) {
        //                [weakSelf.goodsArrayList addObject:array];
        //                break;
        //            }
        //            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
        //            [weakSelf.goodsArrayList addObject:array];
        //        }
        //
        //        for (NSInteger i=0;i<[weakSelf.goodsArrayList count];i++) {
        ////            if ([weakSelf.dataSources count]>0) {
        ////                [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        ////            }
        //            NSArray *array = [weakSelf.goodsArrayList objectAtIndex:i];
        //            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
        //            [weakSelf.dataSources addObject:[SepUserHomeViewCell buildCellDict]];
        //        }
        //[weakSelf.dataSources insertObject:[SepTableViewCell buildCellDict] atIndex:0];
        if (loadFinished) {
            //            [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
        //        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        //        for (int i=0;i<[addedItems count];i++) {
        //            if (i>0) {
        //                [newList addObject:[SepTableViewCell buildCellDict]];
        //            }
        //
        //            BOOL isDataChanged = NO;
        //            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
        //            [newList addObject:[GoodsGalleryGridCell buildCellDict:goodsInfo]];
        //        }
        //        weakSelf.dataSources = newList;
        
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.enableLoadingMore = YES;
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        BOOL ignoreCount = 0;
        if ([addedItems count]>0) {
            NSMutableArray *array = nil;
            if ([weakSelf.goodsArrayList count]>0) {
                array = [weakSelf.goodsArrayList objectAtIndex:[weakSelf.goodsArrayList count]-1];
            }
            if (array && [array count]==1) {
                [array addObject: [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:0]]];
                ignoreCount = 1;
            }
        }
        
        for (int i = 0; i < addedItems.count; i++) {
            [weakSelf.dataSources addObject:[IdleTableViewCell buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
            [weakSelf.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
        //        NSMutableArray *addedGoodsArrayList = [[NSMutableArray alloc] init];
        //        for (NSInteger i=0;i<[addedItems count]-ignoreCount;i+=2) {
        //            NSMutableArray *array = [[NSMutableArray alloc] init];
        //            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
        //            if (i+1>=[addedItems count]-ignoreCount) {
        //                //                [weakSelf.goodsArrayList addObject:array];
        //                [addedGoodsArrayList addObject:array];
        //                break;
        //            }
        //            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
        //            //[weakSelf.goodsArrayList addObject:array];
        //            [addedGoodsArrayList addObject:array];
        //        }
        //
        //        [weakSelf.goodsArrayList addObjectsFromArray:addedGoodsArrayList];
        //
        //        for (NSInteger i=0;i<[addedGoodsArrayList count];i++) {
        //            NSArray *array = [addedGoodsArrayList objectAtIndex:i];
        //            if ([weakSelf.dataSources count]>0) {
        //                [weakSelf.dataSources addObject:[SepUserHomeViewCell buildCellDict]];
        //            }
        //            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
        //        }
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SepUserHomeViewCell buildCellDict]];
        }
        
        //        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        //        for (int i=0;i<[addedItems count];i++) {
        //            if (i>0) {
        //                [newList addObject:[SepTableViewCell buildCellDict]];
        //            }
        //
        //            BOOL isDataChanged = NO;
        //            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
        //            [newList addObject:[GoodsGalleryGridCell buildCellDict:goodsInfo]];
        //        }
        //        if ([newList count]>0) {
        //            //NSInteger count = [weakSelf.dataSources count];
        //            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
        //            if ([dataSources count]>0) {
        //                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
        //            }
        //            [dataSources addObjectsFromArray:newList];
        //            weakSelf.dataSources = dataSources;
        //        }
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:1];
        //        [newList addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:@"暂无商品"]];
        //        [weakSelf.dataSources removeAllObjects];
        //        [weakSelf setDataSources:newList];
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
}

- (void)toggleDetailView:(UserHomeHeaderView *)headerView isShow:(BOOL)isShow
{
    if (isShow) {
        CGPoint pt = [self.view convertPoint:CGPointMake(0, self.headerView.height) fromView:self.headerView];
        //self.headerView.height-“头像距离上面的距离”－50
        CGFloat height = self.headerView.height-(39.f+kTopBarContentMarginTop)-50; //头部露出的高度，
        if (pt.y-height>0) {
            CGFloat heightMoveToTop = pt.y-height;//上移的高度
            self.tableView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height+heightMoveToTop);
            [self.detailView removeFromSuperview];
            //            self.detailView = [[UserHomeDetailView alloc] initWithFrame:CGRectMake(0, pt.y, kScreenWidth, kScreenHeight-height)];
            self.detailView = [[UserHomeDetailView alloc] initWithFrame:CGRectMake(0, pt.y, kScreenWidth, kScreenHeight)];
            self.detailView.delegate = self;
            [self.detailView updateWithUserInfo:self.userDetailInfo];
            [self.view addSubview:self.detailView];
            
            //            CGRect endFrame = CGRectMake(0, self.tableView.top-heightMoveToTop, self.tableView.width, self.tableView.height);
            //add code
            CGRect endFrame = CGRectMake(0, self.tableView.top-heightMoveToTop, self.tableView.width, self.tableView.height);
            CGRect endFrameDetailView = self.detailView.frame;
            endFrameDetailView.origin.y = endFrameDetailView.origin.y-heightMoveToTop;
            
            [UIView animateWithDuration:0.25f animations:^{
                self.tableView.frame = endFrame;
                
                //add code
                //                self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + heightMoveToTop);
                self.detailView.frame = endFrameDetailView;
            } completion:^(BOOL finished) {
                self.tableView.frame = endFrame;
                self.detailView.frame = endFrameDetailView;
            }];
            
        } else {
            //            CGFloat heightMoveToBottom = -(pt.y-height);//下移的高度
            //            self.tableView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height+heightMoveToBottom);
            [self.detailView removeFromSuperview];
            self.detailView = [[UserHomeDetailView alloc] initWithFrame:CGRectMake(0, pt.y, kScreenWidth, kScreenHeight-pt.y)];
            self.detailView.delegate = self;
            [self.detailView updateWithUserInfo:self.userDetailInfo];
            [self.view addSubview:self.detailView];
            
            
            //            CGRect endFrame = CGRectMake(0, self.tableView.top+heightMoveToBottom, self.tableView.width, self.tableView.height);
            //            CGRect endFrameDetailView = self.detailView.frame;
            //            endFrameDetailView.origin.y = endFrameDetailView.origin.y+heightMoveToBottom;
            //
            //            [UIView animateWithDuration:0.25f animations:^{
            //                self.tableView.frame = endFrame;
            //                self.detailView.frame = endFrameDetailView;
            //            } completion:^(BOOL finished) {
            //                self.tableView.frame = endFrame;
            //                self.detailView.frame = endFrameDetailView;
            //            }];
        }
        //        [self.detailView removeFromSuperview];
        //        pt = [self.view convertPoint:CGPointMake(0, self.headerView.height) fromView:self.headerView];
        //        self.detailView = [[UserHomeDetailView alloc] initWithFrame:CGRectMake(0, pt.y, kScreenWidth, kScreenHeight-pt.y)];
        //        self.detailView.delegate = self;
        //        [self.detailView updateWithUserInfo:self.userDetailInfo];
        //        [self.view addSubview:self.detailView];
    } else {
        CGFloat topBarHeight = 0.f;
        CGRect endFrame = CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight);
        [UIView animateWithDuration:0.25f animations:^{
            self.tableView.frame = endFrame;
        } completion:^(BOOL finished) {
            self.tableView.frame = endFrame;
        }];
        
        [self.detailView removeFromSuperview];
        self.detailView = nil;
    }
}

- (void)tappedHideDetailView:(UserHomeDetailView *)detailView {
    [self.headerView notifyHideDetailView];
}

- (void)updateTitleBar
{
    //    if ([Session sharedInstance].isLoggedIn) {
    //
    //    }
    //    if ([Session sharedInstance].isLoggedIn && self.userId == [Session sharedInstance].currentUserId) {
    //        [super setupTopBarTitle:[Session sharedInstance].currentUser.userName];
    //        self.topBarRightButton.hidden = NO;
    //    } else {
    //        self.topBarRightButton.hidden = YES;
    //    }
    //
    if ([Session sharedInstance].isLoggedIn && [Session sharedInstance].currentUserId==self.userId) {
        //        [self.view viewWithTag:1101].hidden = YES;
        [self.view viewWithTag:1103].hidden = NO;
    } else {
        //        [self.view viewWithTag:1101].hidden = NO;
        [self.view viewWithTag:1103].hidden = YES;
    }
    
    [self.view viewWithTag:1102].hidden = NO;
}

- (void)shareUserImpl:(UIImage*)image {
    if (!image) {
        image = [UIImage imageNamed:@"AppIcon_120"];
    }
    [[CoordinatingController sharedInstance] shareWithTitle:@"来自爱丁猫的分享"
                                                      image:image
                                                        url:kURLUserHome(self.userDetailInfo.userInfo.userId)
                                                    content:[NSString stringWithFormat:@"%@",self.userDetailInfo.userInfo.userName]];
}

- (void)handleShareButtonClicked{
    
    WEAKSELF;
    if ([self.userDetailInfo.userInfo.avatarUrl length]>0) {
        
        NSURL *shareImageUrl =  [NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:self.userDetailInfo.userInfo.avatarUrl isWebP:NO scaleType:XMWebImageScale160x160]];
        
        UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                               [SDWebImageManager lw_cacheKeyForURL:
                                shareImageUrl]];
        if (shareImage == nil) {
            
            [weakSelf showProcessingHUD:nil];
            [[SDWebImageManager sharedManager] downloadImageWithURL:shareImageUrl
                                                            options:SDWebImageLowPriority
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                               [weakSelf hideHUD];
                                                               [weakSelf shareUserImpl:image];
                                                           }];
        } else {
            [weakSelf shareUserImpl:shareImage];
        }
    } else {
        [weakSelf shareUserImpl:nil];
    }
}

- (void)handleEditButtonClicked:(UIButton*)sender {
    EditProfileViewController *viewController = [[EditProfileViewController alloc] init];
    viewController.userDetailInfo = self.userDetailInfo;
    viewController.delegate = self;
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

-(void)handleCatButtonClicked:(UIButton *)sender{
    ForumOneSelfController *oneSelfController = [[ForumOneSelfController alloc] init];
    [self pushViewController:oneSelfController animated:YES];
}

- (void)editProfileGalleryChanged:(EditProfileViewController*)viewController gallery:(NSArray*)gallary
{
    WEAKSELF;
    NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
    for (PictureItem *item in gallary) {
        if ([item isKindOfClass:[PictureItem class]]) {
            if (item.picId == kPictureItemLocalPicId) {
                [uploadFiles addObject:item.picUrl];
            }
        }
    }
    
    if ([uploadFiles count]>0) {
        [weakSelf showProcessingHUD:nil];
        [[NetworkAPI sharedInstance] updaloadPics:uploadFiles completion:^(NSArray *picUrlArray) {
            NSInteger index = 0;
            for (PictureItem *tempItem in gallary) {
                if (tempItem.picId == kPictureItemLocalPicId) {
                    tempItem.picId = 0;
                    if (index<[picUrlArray count]) {
                        tempItem.picUrl = [picUrlArray objectAtIndex:index];
                    }
                    index+=1;
                }
            }
            [weakSelf upddateGallery:gallary];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [self upddateGallery:gallary];
    }
}

- (void)upddateGallery:(NSArray*)gallary
{
    WEAKSELF;
    [[NetworkAPI sharedInstance] setGallery:gallary completion:^{
        [weakSelf hideHUD];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}


- (void)handleTopBarRightButtonClicked:(UIButton*)sender {
    //    if (!sender.isSelected) {
    //        [UserSingletonCommand followUser:self.userId];
    //    } else {
    //        [UserSingletonCommand unfollowUser:self.userId];
    //    }
    
    NSArray * title = @[@"消息",@"首页",@"我要反馈",@"分享"];
    NSArray * image =@[@"pop_messgae",@"pop_home",@"pop_feedback",@"pop_share"];
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < title.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = image[i];
        info.title = title[i];
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
                [self handleShareButtonClicked];
                break;
                
            default:
                break;
        }
    }];
    
}

-(void)handleTopBarRightTwoButtonClicked:(UIButton *)sender
{
    ShoppingCartViewController * shoppingCart = [[ShoppingCartViewController alloc] init];
    [self pushViewController:shoppingCart animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.headerView notifyHideDetailView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    self.tableView.pullTableIsRefreshing = YES;
    [self reloadUserData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
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
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[UserHomeSearchFilterCell class]]) {
        ((UserHomeSearchFilterCell*)tableViewCell).handleSearchFilterButtonActionBlock = ^(SearchFilterInfo *filterInfo) {
            if (filterInfo) {
                [weakSelf doSearch];
            } else {
                SearchViewController *viewController = [[SearchViewController alloc] init];
                viewController.sellerId = weakSelf.userId;
                viewController.isForSelected = NO;
                [weakSelf pushViewController:viewController animated:YES];
            }
        };
    }
    
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
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if (ClsTableViewCell == [MineGoodsShelfCell class]) {
        RecoverCollectionViewController *viewController = [[RecoverCollectionViewController alloc] init];
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    } else if (ClsTableViewCell == [UserHomeAlSaleCell class]) {
        SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }else if (ClsTableViewCell == [IdleTableViewCell class]){
        GoodsInfo *goodsIno = [dict objectForKey:[IdleTableViewCell cellDictKeyForGoodsInfo]];
        if (goodsIno && [goodsIno isKindOfClass:[GoodsInfo class]]) {
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsIno.goodsId animated:YES];
        }
    }
    //    NSDictionary *dict = _curSelectedTabIndex==0?[self.dataSourcesStoreInfo objectAtIndex:[indexPath row]]:[self.dataSources objectAtIndex:[indexPath row]];;
    //    GoodsInfo *goodsIno = [dict objectForKey:[GoodsGalleryGridCell cellDictKeyForGoodsInfo]];
    //    if (goodsIno && [goodsIno isKindOfClass:[GoodsInfo class]]) {
    //        [MobClick event:@"click_item_from_personal_page_goods"];
    //        [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsIno.goodsId animated:YES];
    //    }
}

///
- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    [self updateTitleBar];
    
    if (self.userId == [Session sharedInstance].currentUserId) {
        [self.ownHeaderView updateWithUserInfo:self.userDetailInfo];
    }
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self updateTitleBar];
    
    if (self.userId == [Session sharedInstance].currentUserId) {
        [self.ownHeaderView updateWithUserInfo:self.userDetailInfo];
    }
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    [self updateTitleBar];
    
    if (self.userId == [Session sharedInstance].currentUserId) {
        [self.ownHeaderView updateWithUserInfo:self.userDetailInfo];
    }
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    [self updateTitleBar];
    
    if (self.userId == [Session sharedInstance].currentUserId) {
        [self.ownHeaderView updateWithUserInfo:self.userDetailInfo];
    }
}

///

- (void)$$handleGoodsInfoChanged:(id<MBNotification>)notifi goodsIds:(NSArray*)goodsIds
{
    WEAKSELF;
    if (notifi.key == (NSUInteger)weakSelf) return;
    [weakSelf.tableView reloadData];
}

///
- (void)$$handleUserInfoChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue] && [Session sharedInstance].currentUserId==[userId integerValue]) {
        [self.userDetailInfo.userInfo updateWithUserInfo:[Session sharedInstance].currentUser];
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
    }
}

///

- (void)$$handleFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue] && [Session sharedInstance].currentUserId!=[userId integerValue]) {
        self.userDetailInfo.userInfo.isfollowing = YES;
        self.userDetailInfo.userInfo.fansNum = self.userDetailInfo.userInfo.fansNum+1;
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
        
        [self updateFollowButtonStatus:YES];
    }
}

- (void)$$handleUnFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue] &&  [Session sharedInstance].currentUserId!=[userId integerValue]) {
        self.userDetailInfo.userInfo.isfollowing = NO;
        self.userDetailInfo.userInfo.fansNum = self.userDetailInfo.userInfo.fansNum-1<0?0:self.userDetailInfo.userInfo.fansNum-1;
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
        
        [self updateFollowButtonStatus:NO];
    }
}

///
- (void)$$handleAvatarChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue]) {
        [self.userDetailInfo.userInfo updateWithUserInfo:[Session sharedInstance].currentUser];
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
    }
}

- (void)$$handleUserFrontChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue]) {
        [self.userDetailInfo.userInfo updateWithUserInfo:[Session sharedInstance].currentUser];
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
    }
}

- (void)$$handleUserProfileChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue]) {
        [self.userDetailInfo.userInfo updateWithUserInfo:[Session sharedInstance].currentUser];
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
    }
}

- (void)$$handleUserNameChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    if (self.userId == [userId integerValue]) {
        [self.userDetailInfo.userInfo updateWithUserInfo:[Session sharedInstance].currentUser];
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [UserHomeHeaderView heightForOrientationPortrait:self.userDetailInfo.userInfo]);
        [self.headerView updateWithUserInfo:self.userDetailInfo];
    }
}

-(void)pushCatHouseController{
    ForumOneSelfController *oneSelfController = [[ForumOneSelfController alloc] init];
    oneSelfController.user_id = self.userId;
    [self pushViewController:oneSelfController animated:YES];
}

- (void)headerViewModifyFront:(UserHomeHeaderView*)headerView {
    
    if ([Session sharedInstance].currentUserId==self.userId) {
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
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WEAKSELF;
    UIImage *image= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
    if (image) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *newImage = [image resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationMedium];
            [AppDirs cleanupTempDir];
            NSString *filePath = [AppDirs saveImage:newImage dir:[AppDirs tempDir] fileName:@"avatar" fileExtention:@"jpg"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showProcessingHUD:nil];
                _requestForFront = [[NetworkAPI sharedInstance] setFrontImage:filePath completion:^(NSString *frontUrl) {
                    [weakSelf hideHUD];
                    [[Session sharedInstance] setUserFront:frontUrl];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                }];
            });
        });
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



@end


@interface UserDetailButton : CommandButton
@end
@implementation UserDetailButton
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}
@end

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "WebViewController.h"

#import "UIImageView+LBBlurredImage.h"
#import "TagsPopView.h"
#import "ConfirmBackView.h"
#import "SignatureView.h"

@interface UserHomeHeaderView()

@property(nonatomic,strong) XMWebImageView *frontView;
@property(nonatomic,retain) XMWebImageView *avatarView;
@property(nonatomic,retain) UILabel *nickNameLbl;
@property (nonatomic, strong) UILabel * funsLbl;
@property (nonatomic, strong) UILabel * saleLbl;
@property (nonatomic, strong) UILabel * funsNumLbl;
@property (nonatomic, strong) UILabel * saleNumLbl;
@property(nonatomic,strong) CommandButton *followingBtn;
@property(nonatomic,strong) CommandButton *chatBtn;
@property (nonatomic, strong) CommandButton *catBtn;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) CALayer *bgLine;
@property(nonatomic,strong) UILabel *summaryLbl;
@property(nonatomic,strong) UserDetailButton *detailBtn;
@property(nonatomic,strong) UserDetailInfo *userDetailInfo;
@property (nonatomic, strong) SignatureView * signatureView;
@property(nonatomic,strong) NSMutableArray *authTypesArr;
@property (nonatomic, strong) UIView * bottomLine;
@property(nonatomic,strong) SellerTagsView *tagsView;
@property (nonatomic, strong) XMWebImageView *moreImageView;//...图片
@property (nonatomic, strong) VisualEffectView * effectView;


@end

@implementation UserHomeHeaderView

+ (CGFloat)heightForOrientationPortrait:(User*)userInfo {
    NSLog(@"%@", [userInfo approveTags]);
    CGFloat height = 0;//[SellerTagsView heightForOrientationPortrait:[userInfo approveTags] showTitle:YES];
    NSString *str = @"这家伙很懒，什么都没有留下～";
    if ([userInfo.summary length]>0) {
        str = userInfo.summary;
    }
    
    NSDictionary *Tdic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil];
    CGRect rect  = [str boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    height += rect.size.height;
    return 280.f+height+40;
}

- (void)dealloc
{
    self.avatarView = nil;
    self.nickNameLbl = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = NO;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.frontView = [[XMWebImageView alloc] initWithFrame:CGRectMake(0, -155, kScreenWidth, 310)];
        self.frontView.image = [UIImage imageNamed:@"userHeaderBg"];
        self.frontView.userInteractionEnabled = YES;
        [self addSubview:self.frontView];

        
        self.avatarView = [[XMWebImageView alloc] initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/375*60-20, 155-(kScreenWidth/375*60)/2, kScreenWidth/375*60, kScreenWidth/375*60)];
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.borderWidth = 1;
        self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.height/2;
        self.avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        self.avatarView.userInteractionEnabled = YES;
        self.avatarView.clipsToBounds = YES;
        [self addSubview:self.avatarView];
        
        self.nickNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.nickNameLbl.font = [UIFont boldSystemFontOfSize:24.f];
        self.nickNameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        self.nickNameLbl.textAlignment = NSTextAlignmentLeft;
        [self.nickNameLbl sizeToFit];
        [self addSubview:self.nickNameLbl];

        
        _followingBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _followingBtn.backgroundColor = [UIColor clearColor];
        _followingBtn.layer.borderWidth = 1.f;
        _followingBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_followingBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        [_followingBtn setTitleColor:[DataSources color99999] forState:UIControlStateNormal];
        [_followingBtn setTitle:@"关注" forState:UIControlStateNormal];
        _followingBtn.hidden = YES;
        [self addSubview:_followingBtn];
        
        
        _chatBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _chatBtn.layer.borderWidth = 1.f;
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_chatBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _chatBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        [_chatBtn setTitle:@"私聊" forState:UIControlStateNormal];
        _chatBtn.hidden = YES;
        [self addSubview:_chatBtn];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self addSubview:self.bottomLine];
        
        
        _funsLbl = [[UILabel alloc] init];
        _funsLbl.textColor = [DataSources color99999];
        _funsLbl.font = [UIFont systemFontOfSize:13];
        _funsLbl.text = @"粉丝";
        [_funsLbl sizeToFit];
        [self addSubview:_funsLbl];
        
        _saleLbl = [[UILabel alloc] init];
        _saleLbl.textColor = [DataSources color99999];
        _saleLbl.font = [UIFont systemFontOfSize:13];
        _saleLbl.text = @"已售出";
        [_saleLbl sizeToFit];
        [self addSubview:_saleLbl];
        
        
        _funsNumLbl = [[UILabel alloc] init];
        _funsNumLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _funsNumLbl.font = [UIFont systemFontOfSize:16];
        [_funsNumLbl sizeToFit];
        [self addSubview:_funsNumLbl];
        
        _saleNumLbl = [[UILabel alloc] init];
        _saleNumLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _saleNumLbl.font = [UIFont systemFontOfSize:16];
        [_saleNumLbl sizeToFit];
        [self addSubview:_saleNumLbl];
        
        
        _signatureView = [[SignatureView alloc] init];
        [self addSubview:_signatureView];
        
        WEAKSELF;
        self.chatBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.userDetailInfo) {
                [UserSingletonCommand chatWithUser:weakSelf.userDetailInfo.userInfo.userId];
            }
        };
        
        self.detailBtn.handleClickBlock = ^(CommandButton *sender) {
            sender.selected = !sender.isSelected;
            if (weakSelf.myDelegate && [weakSelf.myDelegate respondsToSelector:@selector(toggleDetailView:isShow:)]) {
                [weakSelf.myDelegate toggleDetailView:weakSelf isShow:sender.isSelected];
            }
        };
        
        self.followingBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.userDetailInfo) {
                if ([sender isSelected]) {
                    [UserSingletonCommand unfollowUser:weakSelf.userDetailInfo.userInfo.userId];
                } else {
                    [UserSingletonCommand followUser:weakSelf.userDetailInfo.userInfo.userId];
                }
            }
        };
        
        self.frontView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if (weakSelf.myDelegate && [weakSelf.myDelegate respondsToSelector:@selector(headerViewModifyFront:)]) {
                [weakSelf.myDelegate headerViewModifyFront:weakSelf];
            }
        };
        
        self.catBtn.handleClickBlock = ^(CommandButton *sender) {
            if ([weakSelf.myDelegate respondsToSelector:@selector(pushCatHouseController)]) {
                [weakSelf.myDelegate pushCatHouseController];
            }
        };
        
        _avatarView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            // 1.封装图片数据
            User *user = [Session sharedInstance].currentUser;
            if ([user.avatarUrl length]>0) {
                
                MJPhoto *photo = [[MJPhoto alloc] init];
                
                photo.url = [NSURL URLWithString:weakSelf.userDetailInfo.userInfo.avatarUrl]; // 图片路径
                photo.srcImageView = weakSelf.avatarView; // 来源于哪个UIImageView
                
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                [photos addObject:photo];
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.isHaveGoodsDetailBtn = YES;
                browser.photos = photos; // 设置所有的图片
                [browser show];
            }
        };
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frontView.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(24);
        make.right.equalTo(self.avatarView.mas_left).offset(10);
        make.height.mas_equalTo(@25);
    }];
    
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarView.mas_right);
        make.top.equalTo(self.avatarView.mas_bottom).offset(43);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*80, 28));
    }];
    
    [self.followingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(43);
        make.right.equalTo(self.chatBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*80, 28));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.chatBtn.mas_bottom).offset(24);
        make.height.mas_equalTo(@1);
    }];
    
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.funsNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(33);
    }];
    
    [self.saleNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(30);
        make.left.equalTo(self.funsNumLbl.mas_right).offset(50);
    }];
    
    [self.funsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funsNumLbl.mas_bottom).offset(8);
        make.centerX.equalTo(self.funsNumLbl.mas_centerX);
    }];
    
    [self.saleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleNumLbl.mas_bottom).offset(8);
        make.centerX.equalTo(self.saleNumLbl.mas_centerX);
    }];
}

- (void)notifyHideDetailView
{
    self.detailBtn.selected = NO;
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(toggleDetailView:isShow:)]) {
        [self.myDelegate toggleDetailView:self isShow:self.detailBtn.isSelected];
    }
}

- (CGFloat)tagsViewHeight {
    return _tagsView?_tagsView.height:0;
}

- (void)updateWithUserInfo:(UserDetailInfo*)userDetailInfo {
    
    WEAKSELF;
    if ([userDetailInfo.userInfo.frontUrl length]>0) {
        
    }
    
    self.userDetailInfo = userDetailInfo;
    self.nickNameLbl.text = userDetailInfo.userInfo.userName;
    [self.signatureView getSignatureText:userDetailInfo.userInfo.summary];
    self.funsNumLbl.text = [NSString stringWithFormat:@"%ld",(long)userDetailInfo.userInfo.fansNum];
    self.saleNumLbl.text = [NSString stringWithFormat:@"%ld",(long)userDetailInfo.userInfo.soldNum];
    [self.avatarView setImageWithURL:userDetailInfo.userInfo.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"] XMWebImageScaleType:XMWebImageScale160x160];
    
    if ([Session sharedInstance].isLoggedIn && [Session sharedInstance].currentUserId==self.userDetailInfo.userInfo.userId) {
        _chatBtn.hidden = YES;
        _followingBtn.hidden = YES;
        _catBtn.hidden = YES;
    } else {
        _chatBtn.hidden = NO;
        _followingBtn.hidden = NO;
        _catBtn.hidden = NO;
    }
    
    self.authTypesArr = [NSMutableArray arrayWithCapacity:0];
    
    if ([userDetailInfo.userInfo.authTypes count] > 0) {
        for (int i = 0; i < [userDetailInfo.userInfo.authTypes count]; i++) {
            if ([userDetailInfo.userInfo.authTypes[i] integerValue] > 0) {
                //                [self.authTypesArr addObject:userDetailInfo.userInfo.authTypes[i]];
                NSInteger j = [userDetailInfo.userInfo.authTypes[i] integerValue];
                NSString *appendStr = [NSString stringWithFormat:@"userTags-%ld", (long)j];
                NSString *nameStr = [NSString stringWithFormat:@""];
                switch (j) {
                    case 1:
                        nameStr = @"实名认证";
                        break;
                    case 2:
                        nameStr = @"诚信卖家";
                        break;
                    case 4:
                        nameStr = @"保证金";
                        break;
                    case 8:
                        nameStr = @"金牌卖家";
                        break;
                    case 16:
                        nameStr = @"回收卖家";
                        break;
                    case 32:
                        nameStr = @"闪电发货";
                        break;
                    default:
                        break;
                }
                UserTagInfo *tag = [UserTagInfo createTagInfo:nameStr icon:[UIImage imageNamed:appendStr]];
                [self.authTypesArr addObject:tag];
            }
        }
    }
    
    
    //点点点图片点击方法
    self.popBgView = [[ConfirmBackView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.popView = [[TagsPopView alloc] initWithFrame:CGRectMake(20, (kScreenHeight - 40 - 10 - weakSelf.authTypesArr.count * 55) / 2, kScreenWidth - 40, 40 + 10 + self.authTypesArr.count * 55) tagsArr:weakSelf.authTypesArr];
    self.popView.delegate = self;
    
    __block ConfirmBackView *weakBgView = self.popBgView;
    __block TagsPopView *weakPopView = self.popView;
    
    _tagsView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        weakBgView.backgroundColor = [UIColor blackColor];
        weakBgView.alpha = 0.5;
        weakBgView.confirmBackDelegate = weakSelf;
        
        [weakSelf.viewController.view addSubview:weakBgView];
        
        
        [weakSelf.viewController.view addSubview:weakPopView];
        NSLog(@"tagsView click");
    };
    
    
    
    _moreImageView.handleSingleTapDetected = ^(XMWebImageView *imageView, UITouch *touch) {
        
        
        weakBgView.backgroundColor = [UIColor blackColor];
        weakBgView.alpha = 0.5;
        weakBgView.confirmBackDelegate = weakSelf;
        
        [weakSelf.viewController.view addSubview:weakBgView];
        
        
        [weakSelf.viewController.view addSubview:weakPopView];
        
    };
    
    self.detailBtn.frame = CGRectMake(kScreenWidth - self.detailBtn.width, self.summaryLbl.top, self.detailBtn.width, self.summaryLbl.height);
    
    
    [self bringSubviewToFront:self.tagsView];
    
    if (userDetailInfo.userInfo.isfollowing) {
        [_followingBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followingBtn setTitleColor:[DataSources color99999] forState:UIControlStateNormal];
        _followingBtn.layer.borderColor = [DataSources color99999].CGColor;
        _followingBtn.selected = YES;
    } else {
        [_followingBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followingBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _followingBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        _followingBtn.selected = NO;
    }
}

- (void)dissmiss {
    [self dissMissConBackView];
}

-(void)dissMissConBackView {
    //    NSLog(@"delegate dismiss");
    [self.popBgView removeFromSuperview];
    [self.popView removeFromSuperview];
}

@end


@implementation UserHomeDetailView {
    UITableView *_tableView;
    NSMutableArray *_dataSources;
}

- (id)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        _dataSources = [[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-68)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(tappedHideDetailView:)]) {
        [_delegate tappedHideDetailView:self];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

- (void)updateWithUserInfo:(UserDetailInfo*)userDetailInfo
{
    [_dataSources removeAllObjects];
    [_dataSources addObject:[UserSummaryTableViewCell buildCellDict:userDetailInfo]];
    [_dataSources addObject:[UserIntroGalleryTableViewCell buildCellDict:userDetailInfo]]; //UserIntroGalleryTableViewCell
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *dict = _curSelectedTabIndex==0?[self.dataSourcesStoreInfo objectAtIndex:[indexPath row]]:[self.dataSources objectAtIndex:[indexPath row]];;
    //    GoodsInfo *goodsIno = [dict objectForKey:[GoodsGalleryGridCell cellDictKeyForGoodsInfo]];
    //    if (goodsIno && [goodsIno isKindOfClass:[GoodsInfo class]]) {
    //        [MobClick event:@"click_item_from_personal_page_goods"];
    //        [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsIno.goodsId animated:YES];
    //    }
}


@end




