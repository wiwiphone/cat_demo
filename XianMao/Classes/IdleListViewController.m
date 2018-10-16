//
//  IdleListViewController.m
//  XianMao
//
//  Created by Marvin on 2017/4/5.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "IdleListViewController.h"
#import "DataListLogic.h"
#import "PullRefreshTableView.h"
#import "GoodsInfo.h"
#import "IdleTableViewCell.h"
#import "IdleBannerTableViewCell.h"
#import "IdleSegCell.h"
#import "GoodsDetailViewController.h"

@interface IdleListViewController ()<UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) DataListLogic * dataListLogic;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) TapDetectingImageView *scrollTopBtn;

@end

@implementation IdleListViewController


-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

-(TapDetectingImageView *)scrollTopBtn{
    if (!_scrollTopBtn) {
        _scrollTopBtn = [[TapDetectingImageView alloc] initWithFrame:CGRectZero];
        _scrollTopBtn.image = [UIImage imageNamed:@"Back_Top_MF"];
    }
    return _scrollTopBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    WEAKSELF;
    [self.view addSubview:self.scrollTopBtn];
    _scrollTopBtn.layer.masksToBounds = YES;
    _scrollTopBtn.layer.cornerRadius = self.scrollTopBtn.image.size.width/2;
    _scrollTopBtn.frame = CGRectMake(self.view.width-50, _tableView.height-250, self.scrollTopBtn.image.size.width, self.scrollTopBtn.image.size.height);
    self.scrollTopBtn.hidden = YES;
    self.scrollTopBtn.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
        [weakSelf.tableView scrollViewToTop:YES];
    };
}

- (void)initDataListLogic:(NSInteger)index title:(NSString *)title{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"search_spare_goods" pageSize:20];
    _dataListLogic.parameters = @{@"keywords":@"",@"params":self.params?self.params:@"", @"selectName":title};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        for (int i=0;i<[addedItems count];i++) {
            GoodsInfo *goodsInfo = [GoodsInfo createWithDict:addedItems[i]];
            if (goodsInfo.listType == 0) {
                [newList addObject:[IdleTableViewCell buildCellDict:goodsInfo]];
                [newList addObject:[IdleSegCell buildCellDict]];
            } else if (goodsInfo.listType == 1){
                [newList addObject:[IdleBannerTableViewCell buildCellDict:goodsInfo.recommendInfo]];
                [newList addObject:[IdleSegCell buildCellDict]];
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            GoodsInfo *goodsInfo = [GoodsInfo createWithDict:addedItems[i]];
            if (goodsInfo.listType == 0) {
                [newList addObject:[IdleTableViewCell buildCellDict:goodsInfo]];
                [newList addObject:[IdleSegCell buildCellDict]];
            } else if (goodsInfo.listType == 1){
                [newList addObject:[IdleBannerTableViewCell buildCellDict:goodsInfo.recommendInfo]];
                [newList addObject:[IdleSegCell buildCellDict]];
            }
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                
            }
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
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
        [weakSelf loadEndWithNoContentWithRetryButton:@"无闲置商品"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [_dataListLogic reloadDataListByForce];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y > 300) {
        self.scrollTopBtn.hidden = NO;
    } else {
        self.scrollTopBtn.hidden = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if (ClsTableViewCell == [IdleTableViewCell class]) {
        GoodsInfo *goodsInfo = dict[@"goodsInfo"];
        GoodsDetailViewControllerContainer *detailViewController = [[GoodsDetailViewControllerContainer alloc] init];
        detailViewController.goodsId = goodsInfo.goodsId;
        [self pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end
