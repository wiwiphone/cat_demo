//
//  RefundProgressViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RefundProgressViewController.h"
#import "PullRefreshTableView.h"
#import "NetworkManager.h"

#import "RefundSumOfMoneyCell.h"
#import "SepTableViewCell.h"
#import "RefundDescCell.h"
#import "RefundDetailCell.h"
#import "Error.h"
#import "getrderReturnsModel.h"
#import "RealRefundCell.h"
@interface RefundProgressViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property (nonatomic,strong) PullRefreshTableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) getrderReturnsModel * model;
@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic,strong) UILabel * refundSucLbl;
@end

@implementation RefundProgressViewController

-(UILabel *)refundSucLbl
{
    if (!_refundSucLbl) {
        _refundSucLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, kScreenHeight/2-15, kScreenWidth-100, 30)];
        _refundSucLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _refundSucLbl.text = @"钱款已打到您的爱丁猫钱包";
        _refundSucLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _refundSucLbl;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"钱款去向"];
    //回购完成
    if (self.orderInfo.orderStatus == 8) {
        [self.view addSubview:self.refundSucLbl];
        
        //退货完成
    }else if(self.orderInfo.orderStatus == 9){
        [self netWorkingRequest];
    }
}

-(void)netWorkingRequest
{

    
    NSDictionary * param = @{@"order_id":self.orderID};
    WEAKSELF;
    
//    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"buyback" path:@"order_info" parameters:param completionBlock:^(NSDictionary *data)
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"return" path:@"get_order_returns" parameters:param completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];

        getrderReturnsModel * model = [[getrderReturnsModel alloc] initWithJSONDictionary:data[@"get_order_returns"] error:nil];
        weakSelf.model = model;
        [self.view addSubview:self.tableView];
        [weakSelf loadData];
      
        
    } failure:^(XMError *error) {
        if (error) {
            
             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        }
    } queue:nil]];
}

-(void)loadData
{

    [self.dataArray addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataArray addObject:[RealRefundCell buildCellTitle:self.model.totalAmountStr]];
    [self.dataArray addObject:[RefundDescCell buildCellDict:self.model]];
    
    NSArray * arr = self.model.orderReturnItemList;
    for (int i = 0; i < arr.count; i++) {
        orderReturnItemListModel * model = arr[i];
        [self.dataArray addObject:[RefundSumOfMoneyCell buildCellDict:model]];
        [self.dataArray addObject:[SegTabViewCellSmall buildCellDict]];
        [self.dataArray addObject:[RefundDetailCell buildCellDict:model]];
        [self.dataArray addObject:[SepTableViewCell buildCellDict]];
    }
    
    
}

#pragma tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
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
