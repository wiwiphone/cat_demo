//
//  PublishChooseGradeViewController.m
//  yuncangcat
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishChooseGradeViewController.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "GradeTitleCell.h"
#import "SepTableViewCell.h"
#import "GradeContentCell.h"
#import "NetworkManager.h"
#import "Error.h"
#import "GradeItemVo.h"
#import "GradeItemTitleCell.h"

@interface PublishChooseGradeViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation PublishChooseGradeViewController

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
        _tableView.enableLoadingMore = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setupTopBar];
    [super setupTopBarTitle:[NSString stringWithFormat:@"%@成色",self.cateName]];
    [super setupTopBarBackButton];
    
    WEAKSELF;
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_grade_desc" parameters:@{@"cate_id":@(self.cateId)} completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        [self.view addSubview:self.tableView];
        [self setUpUI];
        NSArray *gradeDescList = data[@"gradeVoList"];
        
        for (int i = 0; i < gradeDescList.count; i++) {
            NSDictionary * dict = [gradeDescList objectAtIndex:i];
            GradeItemVo * geadeItemVo = [GradeItemVo createWithDict:dict];
            [self.dataSources addObject:[GradeItemTitleCell buildCellDict:geadeItemVo.title]];
            for (int j = 0; j < geadeItemVo.gradeItemList.count; j++) {
                GradeDescInfo *descInfo = [geadeItemVo.gradeItemList objectAtIndex:j];
                NSArray *descArr = [descInfo.detailDesc componentsSeparatedByString:@"\n"];
                [self.dataSources addObject:[GradeContentCell buildCellDict:descArr gradeValueDesc:descInfo.gradeValueDesc grade:self.grade gradeDescInfo:descInfo]];
                [self.dataSources addObject:[SegTabViewCellSmallMF buildCellDict]];
            }
        }
        
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}


-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
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
    if (ClsTableViewCell == [GradeContentCell class]) {
        if ([self.gradeDelegate respondsToSelector:@selector(getGrade:andDescInfo:)]) {
            [self.gradeDelegate getGrade:[dict objectForKey:[GradeContentCell cellDictKeyForGradeValueDesc]] andDescInfo:[dict objectForKey:[GradeContentCell cellDictKeyForGradeDescInfo]]];
        }
        [self dismiss];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end
