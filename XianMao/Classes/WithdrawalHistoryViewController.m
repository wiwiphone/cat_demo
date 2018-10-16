//
//  WithdrawalHistoryViewController.m
//  XianMao
//
//  Created by darren on 15/1/27.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "WithdrawalHistoryViewController.h"

#import "PullRefreshTableView.h"

#import "DataSources.h"

#import "CoordinatingController.h"

#import "DataListLogic.h"
#import "Wallet.h"

#import "Session.h"
#import "NetworkAPI.h"

#import "UserHomeViewController.h"
#import "WithdrawalHistoryTableViewCell.h"


@interface WithdrawalHistoryViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic,retain) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation WithdrawalHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"账单"];
    [super setupTopBarBackButton];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight) style:UITableViewStylePlain];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    [self.tableView registerClass:[WithdrawalHistoryTableViewCell class] forCellReuseIdentifier:@"WithdrawalHistoryTableViewCell"];
    [self.tableView registerClass:[AccountLogTableViewCell class] forCellReuseIdentifier:@"AccountLogTableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
//    [self updateTitleBar];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self initDataListLogic];
    });
    
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


//- (void)initDataListLogic
//{
//    WEAKSELF;
//    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"user" path:@"get_withdraw_record" pageSize:20];
//    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
//    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
//    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
//        if ([weakSelf.dataSources count]>0) {
//            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
//        }
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//    };
//    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
//        [weakSelf hideLoadingView];
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//        weakSelf.tableView.autoTriggerLoadMore = YES;
//        
//        if (needReloadList) {
//            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//            for (int i=0;i<[addedItems count];i++) {
//                NSDictionary *dict = [addedItems objectAtIndex:i];
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    [newList addObject:[WithdrawalHistoryTableViewCell buildCellDict:[WithdrawalInfo createWithDict:dict]]];
//                }
//            }
//            weakSelf.dataSources = newList;
//            [weakSelf.tableView reloadData];
//        } else {
//            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[addedItems count]];
//            
//            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//            for (int i=0;i<[addedItems count];i++) {
//                NSDictionary *dict = [addedItems objectAtIndex:i];
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    [dataSources insertObject:[WithdrawalHistoryTableViewCell buildCellDict:[WithdrawalInfo createWithDict:dict]] atIndex:i];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [indexPaths addObject:indexPath];
//                }
//            }
//            if ([indexPaths count]>0) {
//                weakSelf.dataSources = dataSources;
//                [weakSelf.tableView beginUpdates];
//                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                [weakSelf.tableView endUpdates];
//            }
//        }
//    };
//    
//    
//    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = YES;
//    };
//    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
//        [weakSelf hideLoadingView];
//        
//        NSInteger count = [weakSelf.dataSources count];
//        
//        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[addedItems count]];
//        NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//        for (int i=0;i<[addedItems count];i++) {
//            NSDictionary *dict = [addedItems objectAtIndex:i];
//            if ([dict isKindOfClass:[NSDictionary class]]) {
//                [dataSources insertObject:[WithdrawalHistoryTableViewCell buildCellDict: [WithdrawalInfo createWithDict:dict]] atIndex:i];
//                NSInteger index = count+i;
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//                [indexPaths addObject:indexPath];
//            }
//        }
//        if ([indexPaths count]>0) {
//            weakSelf.dataSources = dataSources;
//            [weakSelf.tableView beginUpdates];
//            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView endUpdates];
//        }
//        
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//        weakSelf.tableView.autoTriggerLoadMore = YES;
//    };
//    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
//        [weakSelf hideLoadingView];
//        if ([weakSelf.dataSources count]==0) {
//            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
//                [weakSelf.dataListLogic reloadDataListByForce];
//            };
//        }
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.autoTriggerLoadMore = NO;
//        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//    };
//    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        
//        [weakSelf loadEndWithNoContent];
//    };
//    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
//        
//    };
//    [_dataListLogic firstLoadFromCache];
//    
//    [weakSelf showLoadingView];
//}

- (void)initDataListLogic
{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"user" path:@"get_account_record" pageSize:20];
    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
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
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [newList addObject:[AccountLogTableViewCell buildCellDict:[[AccountLogVo alloc] initWithJSONDictionary:dict] cellIndex:i]];
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
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
        
        NSInteger count = [weakSelf.dataSources count];
        NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [dataSources addObject:[AccountLogTableViewCell buildCellDict: [[AccountLogVo alloc] initWithJSONDictionary:dict] cellIndex:count+i]];
            }
        }
        weakSelf.dataSources = dataSources;
        [weakSelf.tableView reloadData];
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
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end

//AccountLogTableViewCell

//user/get_account_record[GET]分页createtime{user_id} 获取账单历史 {  []AccountLogVo(createtime(l), type(i), amount_cent(i), title (s), subtitle(s), icon_url(s))  }    subtitle为null不显示     @白骁 @卢云



