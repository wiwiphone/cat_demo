//
//  RecommendButlerView.m
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecommendButlerView.h"
#import "PullRefreshTableView.h"
#import "DataListLogic.h"
#import "DataSources.h"
#import "BaseTableViewCell.h"
#import "RecommendButlerCell.h"
#import "UserHomeViewController.h"
#import "recommendButlerTitleCell.h"
#import "SepTableViewCell.h"
#import "Session.h"

@interface RecommendButlerView () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation RecommendButlerView

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pullDelegate = self;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        [self loadData];
        
    }
    return self;
}

- (void)loadData {
    WEAKSELF;
    if ([weakSelf.dataSources count]>0) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        //if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
        weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        // }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.dataListLogic) {
            [weakSelf.dataListLogic reloadDataListByForce];
        } else {
            [weakSelf initDataListLogic];
        }
    });
}

- (void)initDataListLogic {
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"user" path:@"get_adviser_page" pageSize:20];
    //    _dataListLogic.parameters = @{@"status" : [NSNumber numberWithInteger:weakSelf.status]};
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        [newList addObject:[recommendButlerTitleCell buildCellDict]];
        for (int i=0;i<[addedItems count];i++) {
            [newList addObject:[RecommendButlerCell buildCellDict:[[AdviserPage alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]]]];
            [newList addObject:[SegTabViewCellSmallTwo buildCellDict]];
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
        [newList addObject:[recommendButlerTitleCell buildCellDict]];
        for (int i=0;i<[addedItems count];i++) {
            [newList addObject:[RecommendButlerCell buildCellDict:[[AdviserPage alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]]]];
            [newList addObject:[SegTabViewCellSmallTwo buildCellDict]];
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
//            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
//                [weakSelf.dataListLogic reloadDataListByForce];
//            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
//        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        [weakSelf loadEndWithNoContentWithRetryButton:@"无服务管家"].handleRetryBtnClicked=^(LoadingView *view) {
//            [weakSelf.dataListLogic reloadDataListByForce];
//        };;
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
    if (ClsTableViewCell == [RecommendButlerCell class]) {
        AdviserPage *adviserPage = dict[@"viserPage"];
        
        UserHomeViewController *viewController = [[UserHomeViewController alloc] init];
        viewController.userId = adviserPage.userId;
//        NSDictionary *data = @{@"userId":[NSNumber numberWithInteger:adviserPage.userId]};
//        [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:HomeChosenUserHomeRegionCode referPageCode:UserHomeReferPageCode andData:data];
        
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
//    [self bringTopBarToTop];
    return view;
}

@end
