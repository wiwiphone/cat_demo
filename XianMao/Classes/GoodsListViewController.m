//
//  GoodsListViewController.m
//  XianMao
//
//  Created by simon cai on 11/12/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsListViewController.h"
#import "CoordinatingController.h"
#import "PullRefreshTableView.h"

#import "OrderTableViewCell.h"
#import "SepTableViewCell.h"

#import "DataListLogic.h"
#import "Error.h"
#import "NetworkManager.h"

#import "DataSources.h"
#import "UIColor+Expanded.h"
#import "NSDictionary+Additions.h"

#import "Session.h"
#import "User.h"

#import "GoodsDetailViewController.h"
#import "GoodsTableViewCell.h"
#import "SepTableViewCell.h"

#import "GoodsMemCache.h"


@interface GoodsListViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,
PullRefreshTableViewDelegate,GoodsInfoChangedReceiver>

@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation GoodsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    /*392426   F5F5F5 */
    
    //self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBar];
    [super setupTopBarTitle:self.title];
    [super setupTopBarBackButton];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.pullDelegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    //    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initDataListLogic];
    });
    
}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)initDataListLogic {
    
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:self.module path:self.path pageSize:5];
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
            for (int i=0;i<[addedItems count];i++) {
                if (i>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                BOOL isDataChanged = NO;
                GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
                [newList addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
            }
            weakSelf.dataSources = newList;
            [weakSelf.tableView reloadData];
        } else {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
            for (int i=0;i<[addedItems count];i++) {
                if (i>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                BOOL isDataChanged = NO;
                GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
                [newList addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
            }
            
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0 && [newList count]>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            
            //            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[newList count]];
            for (int i=0;i<[newList count];i++) {
                //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                //                [indexPaths addObject:indexPath];
                [dataSources insertObject:[newList objectAtIndex:i] atIndex:i];
            }
            
            weakSelf.dataSources = dataSources;
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            
            BOOL isDataChanged = NO;
            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)[GoodsInfo createWithDict:[addedItems objectAtIndex:i]] isDataChanged:&isDataChanged];
            
            [newList addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            
            
            //            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[newList count]];
            //            for (int i=0;i<[newList count];i++) {
            //                NSInteger index = count+i;
            //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            //                [indexPaths addObject:indexPath];
            //            }
            
            weakSelf.dataSources = dataSources;
            //            [weakSelf.tableView beginUpdates];
            //            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            //            [weakSelf.tableView endUpdates];
            [weakSelf.tableView reloadData];
        }
        
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
    
    //    int currentPosition = scrollView.contentOffset.y;
    //    if (currentPosition < 0) return;
    //    if (currentPosition > scrollView.contentSize.height) return;
    //    if (currentPosition - _lastPosition > 100)
    //    {
    //        _lastPosition = currentPosition;
    //        [UIView animateWithDuration:0.2 animations:^{
    //            self.topBar.frame = CGRectMake(0, statusBarHeight() - kTopBarHeight,
    //                                           self.view.frame.size.width, kTopBarHeight);
    //
    //            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //            if (!_statusBarView)
    //            {
    //                _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, statusBarHeight())];
    //                _statusBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar_bg"]];
    //
    //            }
    //            [self.view addSubview:_statusBarView];
    //        }];
    //        self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight(), 0.0, 0.0, 0.0);
    //    }
    //    else if (_lastPosition - currentPosition > 100)
    //    {
    //        _lastPosition = currentPosition;
    //        [UIView animateWithDuration:0.2 animations:^{
    //            [_statusBarView removeFromSuperview];
    //            self.topBar.frame = CGRectMake(0, 0, self.view.frame.size.width,kTopBarHeight);
    //            UIImage *img = [UIImage imageNamed:@"titlebar_bg"];
    //            self.topBar.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    //            self.tableView.frame = CGRectMake(0, kTopBarHeight,
    //                                              self.view.frame.size.width,
    //                                              self.view.frame.size.height-kTopBarHeight);
    //        }];
    //        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    //    }
    //
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
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
    [MobClick event:@"click_item_from_feeds"];
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    GoodsInfo *goodsInfo = (GoodsInfo*)[dict objectForKey:[GoodsTableViewCell cellDictKeyForGoodsInfo]];
    [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsInfo.goodsId animated:YES];
}

- (void)$$handleGoodsInfoChanged:(id<MBNotification>)notifi goodsIds:(NSArray*)goodsIds
{
    WEAKSELF;
    if (notifi.key == (NSUInteger)weakSelf) return;
    
    [weakSelf.tableView reloadData];
}

@end

