//
//  NoticeViewController.m
//  XianMao
//
//  Created by simon on 1/2/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"

#import "PullRefreshTableView.h"

#import "DataListLogic.h"
#import "Notice.h"

#import "Session.h"
#import "NetworkAPI.h"

#import "CoordinatingController.h"

#import "Session.h"

#import "MsgCountManager.h"
#import "URLScheme.h"

@interface NoticeViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,AuthorizeChangedReceiver>

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;



@end


@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setupTopBar];
    [super setupTopBarBackButton];
    [self setupTopBarTitle:self.titleStr];
    
    CGFloat height = [super topBarHeight];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - height)];
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F5F5F5"];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)dealloc
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.view = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WEAKSELF;
    if (!_dataListLogic) {
        [weakSelf initDataListLogic];
        if ([Session sharedInstance].isLoggedIn) {
            [weakSelf.dataListLogic firstLoadFromCache];
            [weakSelf showLoadingView];
        } else {
            [weakSelf showRemindLoginView].handleRetryBtnClicked = ^(LoadingView *view) {
                [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                }];
            };
        }
    } else {
        if ([Session sharedInstance].isLoggedIn) {
            if ([MsgCountManager sharedInstance].noticeCount>0)
            {
                [weakSelf.dataListLogic reloadDataListByForce];
            }
        } else {
            [weakSelf showRemindLoginView].handleRetryBtnClicked = ^(LoadingView *view) {
                [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                }];
            };
        }
    }
}

- (void)initDataListLogic {
    WEAKSELF;
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
        //调整push消息接口  分类
//    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"notification" path:@"get_notices" pageSize:20 fetchSize:40];
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"notification" path:@"get_type_notices" pageSize:40];
    _dataListLogic.parameters = @{@"msg_type":[NSNumber numberWithInteger:self.noticeType]};
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            [newList addObject:[NoticeTableViewCell buildCellDict:[Notice createWithDict:[addedItems objectAtIndex:i]]]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        
        
//        [[MsgCountManager sharedInstance] clearNoticeCount];
        [[MsgCountManager sharedInstance] clearNotice:weakSelf.notice_count];
        weakSelf.notice_count = 0;
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            [newList addObject:[NoticeTableViewCell buildCellDict:[Notice createWithDict:[addedItems objectAtIndex:i]]]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            if ([Session sharedInstance].isLoggedIn) {
                [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                    [weakSelf.dataListLogic reloadDataListByForce];
                };
            } else {
                [weakSelf showRemindLoginView].handleRetryBtnClicked = ^(LoadingView *view) {
                    [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                    }];
                };
            }
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataListByForce];
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
        [tableViewCell.contentView setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:[self.dataSources objectAtIndex:[indexPath row]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    Notice *notice = [dict objectForKey:[NoticeTableViewCell cellDictKeyForNotice]];
    if (notice && [notice.redirectUri length]>0) {
        
        [Session sharedInstance].viewCode = MessageNavNotifyViewCode;
        
        [URLScheme locateWithRedirectUri:notice.redirectUri andIsShare:YES];
    }
}

- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    [self hideLoadingView];
    [self.dataListLogic reloadDataListByForce];
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self hideLoadingView];
    [self.dataListLogic reloadDataListByForce];
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    WEAKSELF;
    [weakSelf showRemindLoginView].handleRetryBtnClicked = ^(LoadingView *view) {
        [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
        }];
    };
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    WEAKSELF;
    [weakSelf showRemindLoginView].handleRetryBtnClicked = ^(LoadingView *view) {
        [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
        }];
    };
}

@end


@implementation NoticeViewControllerPresented

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.title?self.title:@"消息"];
    [super setupTopBarBackButton];
    
    self.tableView.frame = CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight);
}

@end



