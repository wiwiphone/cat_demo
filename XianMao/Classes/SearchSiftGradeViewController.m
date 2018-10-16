//
//  SearchSiftGradeViewController.m
//  XianMao
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchSiftGradeViewController.h"
#import "NetworkManager.h"
#import "Error.h"
#import "PullRefreshTableView.h"
#import "DataListLogic.h"
#import "BaseTableViewCell.h"
#import "SearchSiftGradeVo.h"
#import "SearchSiftGradeDescVo.h"
#import "SearchSiftGradeCell.h"
#import "SearchSiftGradeHeaderCell.h"

@interface SearchSiftGradeViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *sectionList;
@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation SearchSiftGradeViewController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.enableLoadingMore = NO;
        _tableView.enableRefreshing = NO;
    }
    return _tableView;
}

-(NSMutableArray *)sectionList{
    if (!_sectionList) {
        _sectionList = [[NSMutableArray alloc] init];
    }
    return _sectionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"成色标准"];
    
    [weakSelf showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_all_grade_desc" parameters:nil completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        
        weakSelf.sectionList = data[@"get_all_grade_desc"];
        [weakSelf.view addSubview:weakSelf.tableView];
        
        [weakSelf setUpUI];
        [weakSelf loadData];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
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

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.sectionList.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 36.f;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    SearchSiftGradeVo *gradeVo = [[SearchSiftGradeVo alloc] initWithJSONDictionary:self.sectionList[section]];
//    
//    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLbl.font = [UIFont systemFontOfSize:15.f];
//    titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
//    titleLbl.text = gradeVo.categoryName;
//    [topView addSubview:titleLbl];
//    
//    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(topView.mas_centerX);
//        make.centerY.equalTo(topView.mas_centerY);
//    }];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    imageView.image = [UIImage imageNamed:@"Search_Sift_Grade"];
//    [topView addSubview:imageView];
//    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(topView.mas_centerX);
//        make.bottom.equalTo(topView.mas_bottom).offset(1);
//    }];
//    
//    return topView;
//}

-(void)loadData{
    [self.dataSources removeAllObjects];
    
    for (int i = 0; i < self.sectionList.count; i++) {
        SearchSiftGradeVo *gradeVo = [[SearchSiftGradeVo alloc] initWithJSONDictionary:self.sectionList[i]];
        
        [self.dataSources addObject:[SearchSiftGradeHeaderCell buildCellDict:gradeVo]];
        
        for (int i = 0; i < gradeVo.gradeDescVoList.count; i++) {
            SearchSiftGradeDescVo *gradeDescGradeVo = gradeVo.gradeDescVoList[i];
            [self.dataSources addObject:[SearchSiftGradeCell buildCellDict:gradeDescGradeVo]];
        }
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end
