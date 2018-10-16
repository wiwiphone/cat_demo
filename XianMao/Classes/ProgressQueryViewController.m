//
//  ProgressQueryViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ProgressQueryViewController.h"
#import "PullRefreshTableView.h"
#import "RefundProgressViewController.h"
#import "NetworkManager.h"

#import "BaseTableViewCell.h"
#import "SepTableViewCell.h"
#import "BusineTitleCell.h"
#import "BuyerApplyCell.h"
#import "SignForInfoCell.h"
#import "ReturnGoodsResultCell.h"
#import "getLogsModel.h"
#import "Error.h"
#import "URLScheme.h"
#import "WebViewController.h"
#import "RemarkCell.h"

@interface ProgressQueryViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property (nonatomic,strong) PullRefreshTableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * modelArray;

@end

@implementation ProgressQueryViewController


-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64)];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"进度查询"];
    [self showLoadingView];
    [self netWorkingRequest];
}


-(void)netWorkingRequest
{
    
    NSDictionary * param = @{@"order_id":self.orderID};
    WEAKSELF;
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"repurchase" path:@"get_logs" parameters:param completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
      
        NSMutableArray * arr = data[@"get_logs"];
        for (NSDictionary * dict in arr) {
            getLogsModel * model = [getLogsModel modelWithDict:dict];
            [self.modelArray addObject:model];
        }
        
        [self.view addSubview:self.tableView];
        [weakSelf loadData];
        
        //查看钱款去向
        [weakSelf createCheckMoneyBtn];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];

}

-(void)loadData
{
    for (int i = 0; i < self.modelArray.count; i++) {
        getLogsModel * model = self.modelArray[i];
        if ([model.actionUser integerValue] == 0) { //爱丁猫处理状态

            [self.dataArray addObject:[BusineTitleCell buildCellTime:model.createtime title:NO]];
            [self.dataArray addObject:[BuyerApplyCell buildCellDict:model]];
            
        }else if ([model.actionUser integerValue] == 1){ //用户处理状态
    
            [self.dataArray addObject:[BusineTitleCell buildCellTime:model.createtime title:YES]];
            [self.dataArray addObject:[SignForInfoCell buildCellDict:model]];
            
            if ([model.remark isEqual:[NSNull null]] == NO) {
                [self.dataArray addObject:[RemarkCell buildCellTitle:model.remark]];
            }
            
        }else{

//            [self.dataArray addObject:[BusineTitleCell buildCellTime:model.createtime title:YES]];
//            [self.dataArray addObject:[SignForInfoCell buildCellDict:model]];
        }

    }
}

//查看钱款去向
-(void)createCheckMoneyBtn
{
    UIButton * checkMoneyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    ////订单的状态 0进行中 1交易完成 2已取消 3无效 4退款(退货)完成 5申请回购 6申请退货 7回购拒绝 8回购结束 9退货成功

    if (self.orderInfo.orderStatus == 8 || self.orderInfo.orderStatus == 9) {
        [checkMoneyBtn setTitle:@"查看钱款去向" forState:UIControlStateNormal];
    }else{
        if (self.orderInfo.orderStatus == 6 || self.orderInfo.orderStatus == 0) {
            [checkMoneyBtn setTitle:@"查看退货物流" forState:UIControlStateNormal];
        }else if (self.orderInfo.orderStatus == 5 || self.orderInfo.orderStatus == 7){
            [checkMoneyBtn setTitle:@"查看回购物流" forState:UIControlStateNormal];
        }
    }
    
    
    [checkMoneyBtn setTitleColor:[UIColor colorWithHexString:@"494949"] forState:UIControlStateNormal];
    checkMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    checkMoneyBtn.layer.borderWidth = 1;
    checkMoneyBtn.layer.borderColor = [UIColor colorWithHexString:@"242424"].CGColor;
    [self.view addSubview:checkMoneyBtn];
    
    [checkMoneyBtn addTarget:self action:@selector(checkMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [checkMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
//        make.left.equalTo(self.view.mas_left).offset(200);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.width.mas_equalTo(@100);
    }];
}

-(void)checkMoneyBtnClick:(UIButton *)button
{
    if (self.orderInfo.orderStatus == 8 || self.orderInfo.orderStatus == 9) {
//        跳到钱款去向页面
        RefundProgressViewController * RP = [[RefundProgressViewController alloc] init];
        RP.orderID = self.orderID;
        RP.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:RP animated:YES];
    }else{
        
        NSString * html5Url = kURLLogisticsFormat(_orderInfo.orderId);
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.url = html5Url;
        viewController.title = @"物流信息";
        [self.navigationController pushViewController:viewController animated:YES];
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
