//
//  ExpenseCardView.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ExpenseCardView.h"
#import "PullRefreshTableView.h"
#import "NetworkAPI.h"
#import "AccountCard.h"
#import "ExpenseCardCell.h"
#import "Error.h"
#import "ConsumptionRechargeViewController.h"
#import "RechargeSucViewController.h"
#import "SepTableViewCell.h"

@interface ExpenseCardView()<PullRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) AccountCard * accountCard;
@end

@implementation ExpenseCardView

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
    }
    return _tableView;
}


-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
        [self netWorkingRequest];
        [self addSubview:self.tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultCompletionNotification:) name:PAY_RESULT_COMPLETION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultCancelNotification:) name:PAY_RESULT_CANCEL object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultFailureNotification:) name:PAY_RESULT_FAILURE object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAY_RESULT_COMPLETION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAY_RESULT_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAY_RESULT_FAILURE object:nil];
}

- (void)payResultCompletionNotification:(NSNotification *)n
{
    RechargeSucViewController * suc = [[RechargeSucViewController alloc] init];
    suc.accountCard = self.accountCard;
    [[CoordinatingController sharedInstance] pushViewController:suc animated:YES];
    [self netWorkingRequest];
}

- (void)payResultCancelNotification:(NSNotification *)n
{
//    [[CoordinatingController sharedInstance] showHUD:@"支付取消" hideAfterDelay:1.2 forView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)payResultFailureNotification:(NSNotification *)n
{
    [[CoordinatingController sharedInstance] showHUD:@"支付错误" hideAfterDelay:1.2 forView:[[UIApplication sharedApplication] keyWindow]];
}

-(void)netWorkingRequest
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"account_card" path:@"list" parameters:nil completionBlock:^(NSDictionary *data) {
        
        NSArray * cardList = data[@"card_list"];
        NSMutableArray * dataSources = [[NSMutableArray alloc] init];
        if (cardList && cardList.count > 0) {
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            for (NSDictionary * dict in cardList) {
                AccountCard * accountCard = [[AccountCard alloc] initWithJSONDictionary:dict error:nil];
                [dataSources addObject:[ExpenseCardCell buildCellDict:accountCard selected:NO]];
            }
            
            self.dataSources = dataSources;
            [self.tableView reloadData];
            self.tableView.pullTableIsRefreshing = NO;
        }
    } failure:^(XMError *error) {
        [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self];
    } queue:nil]];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}


- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    _tableView.pullTableIsRefreshing = YES;
    [self netWorkingRequest];
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
//        AccountCard * accountCard = [dict objectForKey:[ExpenseCardCell cellDictKeyForCardInfo]];
//        ConsumptionRechargeViewController * recharge = [[ConsumptionRechargeViewController alloc] init];
//        recharge.accountCard = accountCard;
//        [[CoordinatingController sharedInstance] pushViewController:recharge animated:YES];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
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
            weakSelf.accountCard = accountCard;
        };
    }

    [Cell updateCellWithDict:dict];
    return Cell;
}

@end
