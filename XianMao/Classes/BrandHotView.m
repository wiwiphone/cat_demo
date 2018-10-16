//
//  BrandHotView.m
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BrandHotView.h"
#import "PullRefreshTableView.h"
#import "Masonry.h"
#import "DataListLogic.h"
#import "Error.h"
#import "BaseTableViewCell.h"
#import "BrandVO.h"
#import "BrandNewCell.h"
#import "BrandMoreCell.h"

@interface BrandHotView () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation BrandHotView

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pullDelegate = self;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.tableView];
        [self setUpUI];
        
        [self initDataListLogic];
    }
    return self;
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)initDataListLogic {
    WEAKSELF;

    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"search_recommend_brand" pageSize:20];
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
        for (int i=0;i<[addedItems count];i+=2) {
            if (i>0) {
                //                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            if (addedItems.count % 2 != 0 && i + 1 == addedItems.count) {
                [newList addObject:[BrandNewCell buildCellDict:[[BrandVO alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andBrandVO2:nil]];
            } else {
                [newList addObject:[BrandNewCell buildCellDict:[[BrandVO alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andBrandVO2:[[BrandVO alloc] initWithJSONDictionary:[addedItems objectAtIndex:i+1]]]];
            }
        }
        [newList addObject:[BrandMoreCell buildCellDict]];
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i+=2) {
            if (i>0) {
//                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            if (addedItems.count % 2 != 0 && i + 1 == addedItems.count) {
                [newList addObject:[BrandNewCell buildCellDict:[[BrandVO alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andBrandVO2:nil]];
            } else {
                [newList addObject:[BrandNewCell buildCellDict:[[BrandVO alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andBrandVO2:[[BrandVO alloc] initWithJSONDictionary:[addedItems objectAtIndex:i+1]]]];
            }
//            [newList addObject:[BrandMoreCell buildCellDict]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
//                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.dataSources removeObject:[BrandMoreCell buildCellDict]];
            [weakSelf.dataSources addObject:[BrandMoreCell buildCellDict]];
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
//        [weakSelf hideLoadingView];
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
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        [weakSelf loadEndWithNoContentWithRetryButton:@"无在售商品"].handleRetryBtnClicked=^(LoadingView *view) {
//            [weakSelf.dataListLogic reloadDataListByForce];
//        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
//    [weakSelf showLoadingView];
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
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[BrandNewCell class]]) {
        BrandNewCell *brandCell = (BrandNewCell *)tableViewCell;
        [brandCell updateCellWithDict:dict];
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

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
