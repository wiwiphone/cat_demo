//
//  KeyworldAssociateView.m
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "KeyworldAssociateView.h"
#import "PullRefreshTableView.h"
#import "KeyworldAssociateCell.h"
#import "SepTableViewCell.h"

@interface KeyworldAssociateView()<PullRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataSources;

@end

@implementation KeyworldAssociateView


-(NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:self.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.tableView];
    }
    return self;
}



- (void)getKeyworldsArr:(NSArray *)array keyworlds:(NSString *)SearchKeyworlds
{
    [self.dataSources removeAllObjects];
    if ([array count] > 0) {
        for (NSString * keyworlds in array) {
            [self.dataSources addObject:[KeyworldAssociateCell buildCellDict:keyworlds searchKeyworlds:SearchKeyworlds]];
            [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
        }
    }
    [_tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}

float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keybordResignFirstResponder)]) {
            [self.delegate keybordResignFirstResponder];
        }
    }else{
        //tableview下滚
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString * reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell * Cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (Cell == nil) {
        Cell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([Cell isKindOfClass:[KeyworldAssociateCell class]]) {
        ((KeyworldAssociateCell *)Cell).keyworldsDidSelected = ^(NSString * keyworlds){
            
            if ([self.delegate respondsToSelector:@selector(doSearchWithKeyworlds:)]) {
                [self.delegate doSearchWithKeyworlds:keyworlds];
            }
        };
    }

    [Cell updateCellWithDict:dict];
    return Cell;
}



@end
