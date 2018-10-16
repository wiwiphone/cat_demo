//
//  SearchNewViewController.m
//  XianMao
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchNewViewController.h"
#import "SearchViewController.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "RecommendTableViewCell.h"
#import "RecommendButlerView.h"
#import "NSString+URLEncoding.h"
#import "Error.h"
#import "SearchRecommendButlerCell.h"

@interface SearchNewViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) SearchBarView *searchBarView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *dataSourcesSellers;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *goodsArrayList;

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) UIView *promptHeaderView;

@property (nonatomic, strong) RecommendButlerView *guanjiaView;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) TapDetectingView *searchHistoryView;

@property (nonatomic, assign) long long timestamp;
@end

@implementation SearchNewViewController

- (TapDetectingView*)searchHistoryView {
    if (!_searchHistoryView) {
        _searchHistoryView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.font = [UIFont systemFontOfSize:13.f];
        titleLbl.text = @"搜索历史";
        [titleLbl sizeToFit];
        [_searchBarView addSubview:titleLbl];
        
        WEAKSELF;
        _searchHistoryView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [weakSelf.searchBarView setShowsCancelButton:NO animated:YES];
            [weakSelf.searchBarView resignFirstResponder];
            weakSelf.searchHistoryView.hidden = YES;
        };
        
    }
    return _searchHistoryView;
}

-(RecommendButlerView *)guanjiaView{
    if (!_guanjiaView) {
        _guanjiaView = [[RecommendButlerView alloc] initWithFrame:CGRectMake(0, self.topBarHeight, kScreenWidth, kScreenHeight-self.topBarHeight)];
    }
    return _guanjiaView;
}

-(UIView *)promptHeaderView{
    if (!_promptHeaderView) {
        _promptHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _promptHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _promptHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [self.topBarRightButton setTitle:@"图片" forState:UIControlStateNormal];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];

    _searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(45, topBarHeight-11.f-25, kScreenWidth-30-70.f, 29) isShowClearButton:NO isShowLeftCombBox:_isForSelected?NO:YES];
    _searchBarView.placeholder = _isForSelected?@"搜店铺商品":@"请输入关键词";
    _searchBarView.delegate = self;
    _searchBarView.currentSearchType = self.searchType;
    
    
    [_searchBarView enableCancelButton:NO];
    [self.topBar addSubview:_searchBarView];
    
    _searchBarView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.85];
    _searchBarView.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    _searchBarView.layer.borderWidth = 0.5;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    _dataSourcesSellers = [[NSMutableArray alloc] init];
    _dataSources = [[NSMutableArray alloc] init];
    _goodsArrayList = [[NSMutableArray alloc] init];
    
    _loadingView = [[LoadingView alloc] initWithFrame:_contentView.bounds];
    _loadingView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.08f];
    _loadingView.hidden = YES;
    [_contentView addSubview:_loadingView];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:_contentView.bounds];
    tableView.enableRefreshing = NO;
    tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    tableView.pullDelegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    //    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = self.promptHeaderView;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_contentView addSubview:tableView];
    
    _tableView = tableView;
    _tableView.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[RecommendGoodsCellSearch class]]) {
        RecommendGoodsCellSearch *recommendGoodsCellSearch = (RecommendGoodsCellSearch*)tableViewCell;
        recommendGoodsCellSearch.handleRecommendGoodsClickBlock = ^(RecommendGoodsInfo *recommendGoodsInfo) {
            if (weakSelf.isForSelected) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(searchViewGoodsSelected:recommendGoods:)]) {
                    [weakSelf.delegate searchViewGoodsSelected:weakSelf recommendGoods:recommendGoodsInfo];
                }
            } else {
                [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:GoodsDetailRegionCode referPageCode:GoodsDetailRegionCode andData:@{@"goodsId":recommendGoodsInfo.goodsId}];
                [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:recommendGoodsInfo.goodsId animated:YES];
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
    
}

- (void)doSearch:(NSString*)keywords params:(NSString*)params timestamp:(long long)timestamp
{
    WEAKSELF;
    //NSInteger requireFilter = 1;
    
    
    
    [weakSelf.view addSubview:self.guanjiaView];
    weakSelf.guanjiaView.hidden = YES;
    _dataListLogic = nil;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"list" pageSize:16 fetchSize:32];
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.parameters = @{@"keywords":keywords?[keywords URLEncodedString]:@"",
                                  @"params":params?params:@"",
                                  @"seller_id":[NSNumber numberWithInteger:self.sellerId],
                                  @"timestamp":[NSNumber numberWithLongLong:timestamp]};
    
    // @"require_filter":[NSNumber numberWithInteger:requireFilter]
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        weakSelf.guanjiaView.hidden = YES;
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView.hidden = YES;
        
        weakSelf.searchHistoryView.hidden = YES;
        weakSelf.tableView.hidden = NO;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        
//        if (weakSelf.totalNum>0) {
//            [weakSelf.dataSources addObject:[SearchTableTotalNumViewCell buildCellDict:weakSelf.totalNum keywords:weakSelf.keywords isForSeller:weakSelf.sellerId>0?YES:NO]];
//            //            [weakSelf.dataSources addObject:[SearchRecommendButlerCell buildCellDict]];
//        }
        
        for (NSInteger i=0;i<[addedItems count];i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
            if (i+1>=[addedItems count]) {
                [weakSelf.goodsArrayList addObject:array];
                break;
            }
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
            [weakSelf.goodsArrayList addObject:array];
        }
        
        for (NSInteger i=0;i<[weakSelf.goodsArrayList count];i++) {
            if ([weakSelf.dataSources count]>0) {
                [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
            }
            NSArray *array = [weakSelf.goodsArrayList objectAtIndex:i];
            [weakSelf.dataSources addObject:[RecommendGoodsCellSearch buildCellDict:array]];
        }
        [weakSelf.dataSources insertObject:[SearchTableSepViewCell buildCellDict] atIndex:0];
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollViewToTop:YES];
    };
    
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView.hidden = YES;
        
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
        
        NSMutableArray *addedGoodsArrayList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[addedItems count]-ignoreCount;i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
            if (i+1>=[addedItems count]-ignoreCount) {
                //                [weakSelf.goodsArrayList addObject:array];
                [addedGoodsArrayList addObject:array];
                break;
            }
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
            //[weakSelf.goodsArrayList addObject:array];
            [addedGoodsArrayList addObject:array];
        }
        
        [weakSelf.goodsArrayList addObjectsFromArray:addedGoodsArrayList];
        
        for (NSInteger i=0;i<[addedGoodsArrayList count];i++) {
            if ([weakSelf.dataSources count]>0) {
                [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
            }
            NSArray *array = [addedGoodsArrayList objectAtIndex:i];
            [weakSelf.dataSources addObject:[RecommendGoodsCellSearch buildCellDict:array]];
        }
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
        }
        
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        
        if ([weakSelf.dataSources count]==0) {
            weakSelf.loadingView.hidden = NO;
            [weakSelf.loadingView loadEndWithError:nil];
            weakSelf.loadingView.handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf doSearch:keywords params:params timestamp:weakSelf.timestamp];
            };
        }
        
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f forView:weakSelf.view];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        [weakSelf hideHUD];
        weakSelf.guanjiaView.hidden = YES;
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView.hidden = YES;
        
        weakSelf.searchHistoryView.hidden = YES;
        weakSelf.tableView.hidden = NO;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        
        //        if (weakSelf.isForSelected && weakSelf.sellerId>0) {
        //            [weakSelf.loadingView loadEndWithNoContent:@"暂无商品" image:[UIImage imageNamed:@"no_content_icon.png"] withRetryButton:NO];
        //        } else {
        //            [weakSelf.loadingView loadEndWithNoContent:@"无搜索结果" image:[UIImage imageNamed:@"no_content_icon.png"] withRetryButton:NO];
        //        }
        
        [weakSelf.dataSources addObject:[SearchRecommendButlerCell buildCellDict]];
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
}


@end
