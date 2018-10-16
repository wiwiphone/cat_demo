//
//  PayXiHuCardViewController.m
//  XianMao
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayXiHuCardViewController.h"
#import "PullRefreshTableView.h"
#import "ExpenseCardCell.h"
#import "ConsumptionRechargeViewController.h"
#import "BonusNoChooseTableViewCell.h"
#import "SepTableViewCell.h"

@interface PayXiHuCardViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation PayXiHuCardViewController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
        _tableView.enableLoadingMore = NO;
        _tableView.enableRefreshing = NO;
    }
    return _tableView;
}

-(void)viewDidLoad{
    
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"可用消费卡"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self setUpUI];
    [self setCell];
}

-(void)setCell{
    
    BOOL select = NO;
    for (int i = 0; i < self.xiHuCardArray.count; i++) {
        AccountCard *card = self.xiHuCardArray[i];
        if (card.cardType == self.selectAccountCard.cardType) {
            select = YES;
        } else {
            select = NO;
        }
        [self.dataSources addObject:[ExpenseCardCell buildCellDict:card selected:select]];
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
        if (i == self.xiHuCardArray.count - 1) {
            BOOL noChoose = NO;
            if (self.selectAccountCard.cardType == -1000 || !self.selectAccountCard) {
                noChoose = YES;
            } else {
                noChoose = NO;
            }
            [self.dataSources addObject:[BonusNoChooseTableViewCell buildCellDict:@"不使用消费卡" selected:noChoose]];
        }
    }
    
}

-(void)setUpUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
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
    _tableView.pullTableIsRefreshing = YES;
//    [self netWorkingRequest];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    
    if (clsTableViewCell == [ExpenseCardCell class]) {
        AccountCard * accountCard = [dict objectForKey:[ExpenseCardCell cellDictKeyForCardInfo]];
//        ConsumptionRechargeViewController * recharge = [[ConsumptionRechargeViewController alloc] init];
//        recharge.accountCard = accountCard;
//        [[CoordinatingController sharedInstance] pushViewController:recharge animated:YES];
        if (self.selectedAccountCard) {
            self.selectedAccountCard(self, accountCard);
        }
    } else if (clsTableViewCell == [BonusNoChooseTableViewCell class]) {
        AccountCard *card = [[AccountCard alloc] init];
        card.cardType = -1000;
        if (self.selectedAccountCard) {
            self.selectedAccountCard(self, card);
        }
    }
    
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
    
    if ([Cell isKindOfClass:[ExpenseCardCell class]]) {
        ExpenseCardCell * expenseCardCell = (ExpenseCardCell *)Cell;
        expenseCardCell.handleRechargeBlock = ^(AccountCard * accountCard){
            ConsumptionRechargeViewController * recharge = [[ConsumptionRechargeViewController alloc] init];
            recharge.accountCard = accountCard;
            [[CoordinatingController sharedInstance] pushViewController:recharge animated:YES];
        };
    }
    
    [Cell updateCellWithDict:dict];
    return Cell;
}

@end
