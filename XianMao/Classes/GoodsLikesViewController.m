//
//  GoodsLikesViewController.m
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsLikesViewController.h"

#import "PullRefreshTableView.h"

#import "DataSources.h"

#import "CoordinatingController.h"

#import "DataListLogic.h"
#import "GoodsInfo.h"

#import "Session.h"
#import "NetworkAPI.h"

#import "UserHomeViewController.h"
#import "GoodsLikesTableViewCell.h"

@interface GoodsLikesViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic,retain) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation GoodsLikesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"想要的人"];
    [super setupTopBarBackButton];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [DataSources globalWhiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    
    if ([self.goodsId length]>0)
        [self initDataListLogic];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDataListLogic
{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"get_liked_users" pageSize:20];
    _dataListLogic.parameters = @{@"goods_id":self.goodsId};
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
        [weakSelf setupTopBarTitle:[NSString stringWithFormat:@"%lu人心动",(unsigned long)addedItems.count]];
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [newList addObject:[GoodsLikesTableViewCell buildCellDict:[User createWithDict:dict]]];
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
//        if (needReloadList) {
//            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//            for (int i=0;i<[addedItems count];i++) {
//                NSDictionary *dict = [addedItems objectAtIndex:i];
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    [newList addObject:[GoodsLikesTableViewCell buildCellDict:[User createWithDict:dict]]];
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
//                    [dataSources insertObject:[GoodsLikesTableViewCell buildCellDict:[User createWithDict:dict]] atIndex:i];
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
        
        NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
        for (NSDictionary *dict in addedItems) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [dataSources addObject:[GoodsLikesTableViewCell buildCellDict:[User createWithDict:dict]]];
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
        [weakSelf loadEndWithNoContent:@"还没有人喜欢该商品"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    User *user = [dict objectForKey:[GoodsLikesTableViewCell cellKeyForGoodsLikedUser]];
    if ([user isKindOfClass:[User class]]) {
        [[CoordinatingController sharedInstance] gotoUserHomeViewController:user.userId animated:YES];
    }
}

@end


