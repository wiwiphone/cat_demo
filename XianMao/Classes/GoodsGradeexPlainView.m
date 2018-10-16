//
//  GoodsGradeexPlainView.m
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GoodsGradeexPlainView.h"
#import "PullRefreshTableView.h"
#import "GradeItemTitleCell.h"
#import "GradeContentCell.h"
#import "SepTableViewCell.h"
#import "GradeItemVo.h"
#import "GradeContentCell.h"

@interface GoodsGradeexPlainView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) UILabel * title;

@end

@implementation GoodsGradeexPlainView

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.height-40) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.enableLoadingMore = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        [self addSubview:self.title];
    }
    return self;
}


- (void)getGoodsGradeDataSources:(NSArray *)dataSources title:(NSString *)title{
    [self.dataSources removeAllObjects];
    for (int i = 0; i < dataSources.count; i++) {
        GradeItemVo * geadeItemVo = [dataSources objectAtIndex:i];
        [self.dataSources addObject:[GradeItemTitleCell buildCellDict:geadeItemVo.title]];
        for (int j = 0; j < geadeItemVo.gradeItemList.count; j++) {
            GradeDescInfo *descInfo = [geadeItemVo.gradeItemList objectAtIndex:j];
            NSArray *descArr = [descInfo.detailDesc componentsSeparatedByString:@"\n"];
            [self.dataSources addObject:[GradeContentCell buildCellDict:descArr gradeValueDesc:descInfo.gradeValueDesc grade:@"" gradeDescInfo:descInfo]];
            [self.dataSources addObject:[SegTabViewCellSmallMF buildCellDict]];
        }
    }
    if (title && title.length > 0) {
        self.title.text = title;
    }
    [self.tableView reloadData];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end
