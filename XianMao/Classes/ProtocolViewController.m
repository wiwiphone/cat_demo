//
//  ProtocolViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/7/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ProtocolViewController.h"
#import "PullRefreshTableView.h"
#import "NetworkManager.h"
#import "BaseTableViewCell.h"
#import "SepTableViewCell.h"
#import "Error.h"
#import "SecionTitleCell.h"
#import "ReturnGoodsViewController.h"
#import "ProtocolModel.h"
#import "ProtocolTitleCell.h"
#import "ProtocolItemsCell.h"
#import "WristApplyViewController.h"
#import "SmallLineCellTwo.h"
@interface ProtocolViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) PullRefreshTableView * tableView;
@property (nonatomic,strong) UIButton * confirmBtn;
@property (nonatomic,strong) ProtocolModel * protocolModel;

@end

@implementation ProtocolViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = [UIColor blackColor];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_confirmBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

-(void)buttonClick
{
    //type 0:退货 1:回购
    if ([self.protocolModel.type integerValue] == 0) {
        ReturnGoodsViewController *returnGoodsController = [[ReturnGoodsViewController alloc] init];
        returnGoodsController.orderID = self.orderID;
        [self pushViewController:returnGoodsController animated:YES];
    }else if ([self.protocolModel.type integerValue] == 1){
        WristApplyViewController * applyVC = [[WristApplyViewController alloc] init];
        applyVC.orderID = self.orderID;
        [self pushViewController:applyVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    
    if ([self.type integerValue] == 0) {
        self.barTitle = @"申请退货";
    }else if ([self.type integerValue] == 1){
        self.barTitle = @"申请回购";
    }
    
    [super setupTopBarTitle:self.barTitle];
    [self showLoadingView];
    [self netWorkingRequest];
}

-(void)netWorkingRequest
{
    WEAKSELF
    NSDictionary * param = @{@"type":self.type};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"repurchase" path:@"get_protocol" parameters:param completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        ProtocolModel * model  = [[ProtocolModel alloc] initWithJSONDictionary:data[@"get_protocol"]];
        self.protocolModel = model;
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.confirmBtn];
        [weakSelf createUI];
        [weakSelf loadData];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}



-(void)createUI
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-150);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-100);
        make.center.equalTo(self.tableView.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
    }];
}

-(void)loadData
{
    [self.dataArray addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataArray addObject:[ProtocolTitleCell buildCellTitle:self.protocolModel.title]];
    
    NSArray * itemsArr = self.protocolModel.items;
    for (int i = 0; i < itemsArr.count; i++) {
        NSString * itemsStr = [NSString stringWithFormat:@"%d.%@",i+1,itemsArr[i]];
        [self.dataArray addObject:[ProtocolItemsCell buildCellTitle:itemsStr]];
        [self.dataArray addObject:[SegTabViewCellSmall buildCellDict]];
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
