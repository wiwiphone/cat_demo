//
//  CateNewView.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateNewView.h"
#import "LoadingView.h"
#import "NetworkManager.h"
#import "Error.h"
#import "CateNewInfo.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "CateBrandSecionView.h"
#import "CateBrandCateCell.h"
#import "SepTableViewCell.h"
#import "CateBrandCateHeaderCell.h"

@interface CateNewView () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *cateArr;

@end

@implementation CateNewView

-(NSMutableArray *)cateArr{
    if (!_cateArr) {
        _cateArr = [[NSMutableArray alloc] init];
    }
    return _cateArr;
}

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
        _tableView.enableLoadingMore = NO;
        _tableView.enableRefreshing = NO;
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        [self showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"search_category_tree" parameters:nil completionBlock:^(NSDictionary *data) {
            [weakSelf hideLoadingView];
            if (data) {
                NSArray *cateArr = data[@"search_category_tree"];
                [self.cateArr addObjectsFromArray:cateArr];
                for (int i = 0; i < cateArr.count; i++) {
                    CateNewInfo *cateInfo = [[CateNewInfo alloc] initWithJSONDictionary:cateArr[i]];
                    NSLog(@"%@", cateInfo);
                }
                
                [weakSelf addSubview:weakSelf.tableView];
                
                [weakSelf setUpUI];
                [weakSelf loadData];
            }
        } failure:^(XMError *error) {
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
        
    }
    return self;
}

-(void)setUpUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
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

-(void)loadData{
    [self.dataSources removeAllObjects];
    
    for (int i = 0; i < self.cateArr.count; i++) {
        CateNewInfo *cateInfo = [[CateNewInfo alloc] initWithJSONDictionary:self.cateArr[i]];
        
        [self.dataSources addObject:[CateBrandCateHeaderCell buildCellDict:cateInfo]];
        
        for (int i = 0; i < cateInfo.subCategoryList.count; i+=2) {
            
            if (cateInfo.subCategoryList.count % 2 != 0 && i + 1 == cateInfo.subCategoryList.count) {
                [self.dataSources addObject:[CateBrandCateCell buildCellDict:[[CateNewInfo alloc] initWithJSONDictionary:cateInfo.subCategoryList[i]] andBCateNewInfo2:nil]];
                if (i < cateInfo.subCategoryList.count) {
                    [self.dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
                }
            } else {
                [self.dataSources addObject:[CateBrandCateCell buildCellDict:[[CateNewInfo alloc] initWithJSONDictionary:cateInfo.subCategoryList[i]] andBCateNewInfo2:[[CateNewInfo alloc] initWithJSONDictionary:cateInfo.subCategoryList[i+1]]]];
                if (i < cateInfo.subCategoryList.count) {
                    [self.dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
                }
            }
        }
    }
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return self.cateArr.count;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    CateBrandSecionView *secView = [[CateBrandSecionView alloc] init];
//    CateNewInfo *cateNewInfo = [[CateNewInfo alloc] initWithJSONDictionary:self.cateArr[section]];
//    [secView getCateNewInfo:cateNewInfo];
//    
//    return secView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 70;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    [self.dataSources removeAllObjects];
//    NSInteger index ;
//    
//    if (section == self.cateArr.count - 1) {
//        index = 0;
//    } else {
//        index = section + 1;
//    }
//    
//    CateNewInfo *cateInfo = [[CateNewInfo alloc] initWithJSONDictionary:self.cateArr[index]];
//    
//    NSInteger count;
//    if (cateInfo.subCategoryList.count % 2 == 0) {
//        count = cateInfo.subCategoryList.count/2;
//    } else {
//        count = cateInfo.subCategoryList.count / 2 + 1;
//    }
    
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

@end
