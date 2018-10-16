//
//  BankCardManagerCtrl.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BankCardManagerCtrl.h"
#import "PullRefreshTableView.h"
#import "BandcardTableViewCell.h"
#import "SepTableViewCell.h"
#import "WCAlertView.h"
#import "NetworkAPI.h"
#import "BankCard.h"
#import "Error.h"
#import "DataListLogic.h"
#import "Session.h"
#import "URLScheme.h"
#import "WithdrawAccountCell.h"
#import "AccountList.h"
#import "AddAccountView.h"
#import "WithdrawalsAccountViewController.h"

@interface BankCardManagerCtrl ()<UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate>
@property (nonatomic,strong) PullRefreshTableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSources;
@property (nonatomic,strong) DataListLogic * dataListLogic;
@property (nonatomic,strong) AddAccountView * addAccountView;

@end

@implementation BankCardManagerCtrl

-(NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(AddAccountView *)addAccountView
{
    if (!_addAccountView) {
        _addAccountView = [[AddAccountView alloc] init];
        _addAccountView.backgroundColor = [UIColor whiteColor];
    }
    return _addAccountView;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.pullDelegate = self;
        _tableView.pullTableIsLoadingMore = NO;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"提现账号管理"];
    [self.view addSubview:self.addAccountView];
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
}

-(void)loadData
{
    
    NSDictionary * parm = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"bank" path:@"account_list" parameters:parm completionBlock:^(NSDictionary *data) {
        [self hideLoadingView];
        [self.dataSources removeAllObjects];
        NSDictionary * dict = data[@"account_list"];
        AccountList * account = [AccountList creatWithDict:dict];
        self.account = account;
        if (account) {
            
            NSArray * accountArray = self.account.withdrawalsAccountVo;
            if (accountArray.count > 0) {
                
                for (WithdrawalsAccountVo * withAccount in accountArray) {
                    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
                    [self.dataSources addObject:[WithdrawAccountCell buildCellDict:withAccount]];
                }
            }
            
            NSInteger count = self.account.addAccountIconVo.count;
            if (count > 0) {
                [self.addAccountView getAddAccountVo:self.account.addAccountIconVo];
                self.addAccountView.frame = CGRectMake(0, kScreenHeight - 68*count, kScreenWidth, 68*count);
                self.tableView.frame = CGRectMake(0, 65, kScreenWidth, kScreenHeight-64-68*count);
            }else{
                self.tableView.frame = CGRectMake(0, 65, kScreenWidth, kScreenHeight-64);
            }
        }
        [self.tableView reloadData];
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dict = [self.dataSources objectAtIndex:[indexPath row]];
    WithdrawalsAccountVo * withdrawalsVo = [dict objectForKey:[WithdrawAccountCell cellDictForWithdrawalsAccount]];
    WithdrawalsAccountViewController * account = [[WithdrawalsAccountViewController alloc] init];
    account.withdrawalsVo = withdrawalsVo;
    [self pushViewController:account animated:YES];
 
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
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
    
    
    [Cell updateCellWithDict:dict];
    return Cell;
}


@end
