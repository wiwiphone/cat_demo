//
//  FollowsViewController.m
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "FollowsViewController.h"
#import "CoordinatingController.h"
#import "PullRefreshTableView.h"

#import "FollowsTableViewCell.h"

#import "DataListLogic.h"
#import "Error.h"
#import "NetworkManager.h"

#import "DataSources.h"

#import "User.h"
#import "Session.h"
#import "FollowsHeadView.h"

#import "NSString+URLEncoding.h"
@interface FollowsViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,FollowsTableViewCellDelegate,UserFollowChangedReceiver>

@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property (nonatomic,strong) NSMutableArray * resultDataSource;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property (nonatomic,strong) FollowsHeadView * headView;

@end

@implementation FollowsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(FollowsHeadView *)headView
{
    if (!_headView) {
        _headView = [[FollowsHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        
    }
    return _headView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.isFans?@"粉丝":@"关注"];
    [super setupTopBarBackButton];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    self.resultDataSource = [NSMutableArray arrayWithCapacity:60];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [DataSources globalWhiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    self.tableView.enableRefreshing = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self.headView getPlaceholderString:self.isFans];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    [self initDataListLogic];
    [self searchFunsOrFollows];
    
    
}

-(void)searchFunsOrFollows{
    
    WEAKSELF;
    _headView.SearchFunsOrFollows = ^(NSString * title){
        
        
//        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//        NSString *filePath = [path stringByAppendingPathComponent:@"follows.data"];
//        weakSelf.dataSources = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//        [weakSelf.resultDataSource removeAllObjects];
//        if (title.length > 0) {
//            
//            for (int i = 0; i < self.dataSources.count; i++) {
//                User *userInfo = [[weakSelf.dataSources objectAtIndex:i] objectForKey:[FollowsTableViewCell cellKeyForFollowsUser]];
//                if ([userInfo.userName rangeOfString:title].location != NSNotFound) {
//                    [weakSelf.resultDataSource addObject:userInfo];
//                }
//            }
//            
//            [weakSelf.dataSources removeAllObjects];
//            for (int i = 0; i < weakSelf.resultDataSource.count; i++) {
//                User *userInfo = [weakSelf.resultDataSource objectAtIndex:i];
//                [weakSelf.dataSources addObject:[FollowsTableViewCell buildCellDict:userInfo]];
//            }
//            
//            if (self.dataSources.count > 0) {
//                [weakSelf.tableView reloadData];
//            }else{
//                [weakSelf showHUD:@"查询无结果" hideAfterDelay:0.8];
//            }
//        }
        //搜索修改为网络搜索
        [weakSelf doSearch:title];
    };
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)doSearch:(NSString *)title
{
    [self.dataSources removeAllObjects];
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"follow" path:self.isFans?@"get_followers_by_name":@"get_followings_by_name" pageSize:20];
//    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:self.userId],@"login_user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId]};
    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], @"name":[title URLEncodedString]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        if (addedItems.count == 0) {
            [weakSelf showHUD:@"查询无结果" hideAfterDelay:0.8];
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        if (needReloadList) {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
            [weakSelf.dataSources removeAllObjects];
            for (int i=0;i<[addedItems count];i++) {
                User *userInfo = [User createWithDict:[addedItems objectAtIndex:i]];
                [newList insertObject:[FollowsTableViewCell buildCellDict:userInfo] atIndex:i];
            }
            
            [weakSelf setDataSources:newList];
            [weakSelf.tableView reloadData];
            
            NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [path stringByAppendingPathComponent:@"follows.data"];
            [NSKeyedArchiver archiveRootObject:weakSelf.dataSources toFile:filePath];
            
        } else {
            NSMutableArray *newList = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[addedItems count]];
            for (int i=0;i<[addedItems count];i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
                User *userInfo = [User createWithDict:[addedItems objectAtIndex:i]];
                [newList insertObject:[FollowsTableViewCell buildCellDict:userInfo] atIndex:i];
            }
            [weakSelf setDataSources:newList];
            //            [weakSelf.tableView beginUpdates];
            //            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            //            [weakSelf.tableView endUpdates];
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[addedItems count]];
        NSInteger count = [weakSelf.dataSources count];
        for (int i=0;i<[addedItems count];i++) {
            NSInteger itemIndex = count+i;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
            [indexPaths addObject:indexPath];
            User *userInfo = [User createWithDict:[addedItems objectAtIndex:i]];
            [weakSelf.dataSources addObject:[FollowsTableViewCell buildCellDict:userInfo]];
        }
        //        if ([indexPaths count]>0) {
        //            [weakSelf.tableView beginUpdates];
        //            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        //            [weakSelf.tableView endUpdates];
        //        }
        
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
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
        [weakSelf loadEndWithNoContent];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}

- (void)initDataListLogic
{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"follow" path:self.isFans?@"get_followers":@"get_followings" pageSize:20];
    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:self.userId],@"login_user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        if (needReloadList) {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
            [weakSelf.dataSources removeAllObjects];
            for (int i=0;i<[addedItems count];i++) {
                User *userInfo = [User createWithDict:[addedItems objectAtIndex:i]];
                [newList insertObject:[FollowsTableViewCell buildCellDict:userInfo] atIndex:i];
            }
            
            [weakSelf setDataSources:newList];
            [weakSelf.tableView reloadData];
            
        } else {
            NSMutableArray *newList = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[addedItems count]];
            for (int i=0;i<[addedItems count];i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
                User *userInfo = [User createWithDict:[addedItems objectAtIndex:i]];
                [newList insertObject:[FollowsTableViewCell buildCellDict:userInfo] atIndex:i];
            }
            [weakSelf setDataSources:newList];
//            [weakSelf.tableView beginUpdates];
//            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView endUpdates];
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[addedItems count]];
        NSInteger count = [weakSelf.dataSources count];
        for (int i=0;i<[addedItems count];i++) {
            NSInteger itemIndex = count+i;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
            [indexPaths addObject:indexPath];
            User *userInfo = [User createWithDict:[addedItems objectAtIndex:i]];
            [weakSelf.dataSources addObject:[FollowsTableViewCell buildCellDict:userInfo]];
        }
//        if ([indexPaths count]>0) {
//            [weakSelf.tableView beginUpdates];
//            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView endUpdates];
//        }
        
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
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
        [weakSelf loadEndWithNoContent];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];

    [weakSelf showLoadingView];
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataList];
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
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    tableViewCell.delegate = self;
    
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
    User *userInfo = (User*)[dict objectForKey:[FollowsTableViewCell cellKeyForFollowsUser]];
    if ([userInfo isKindOfClass:[User class]]) {
        [[CoordinatingController sharedInstance] gotoUserHomeViewController:userInfo.userId animated:YES];
    }
}

- (void)$$handleFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            User *user = (User*)[dict objectForKey:[FollowsTableViewCell cellKeyForFollowsUser]];
            if (user.userId == [userId integerValue]) {
                user.isfollowing = YES;
                break;
            }
        }
    }
    [self.tableView reloadData];
}

- (void)$$handleUnFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            User *user = (User*)[dict objectForKey:[FollowsTableViewCell cellKeyForFollowsUser]];
            if (user.userId == [userId integerValue]) {
                user.isfollowing = NO;
                break;
            }
        }
    }
    [self.tableView reloadData];
}

@end


