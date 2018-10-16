//
//  ReturnGoodsViewController.m
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsViewController.h"
#import "PullRefreshTableView.h"
#import "ReturnGoodsSucViewController.h"

#import "Masonry.h"

#import "BaseTableViewCell.h"
#import "ReturnGoodsInformationCell.h"
#import "SepTableViewCell.h"
#import "OrderGoodsTableViewCell.h"
#import "ReturnGoodsAddressCell.h"
#import "ReturnGoodsReturnReasonCell.h"
#import "ApplyLogisticsCell.h"
#import "LogisticsNumberCell.h"
#import "SmallLineCellTwo.h"
#import "PaymentWayCell.h"
#import "SecionTitleCell.h"
#import "LeaveMessageCell.h"
#import "ReturnGoodsCompanyCell.h"
#import "BuybackOrderModel.h"
#import "NetworkManager.h"
#import "Error.h"
#import "ApplyGoodsDetailCell.h"
#import "SupportvalueCell.h"
#import "MailinfoModel.h"
#import "SendBackDetailCell.h"
#import "ScanningViewController.h"
#import "AccessoriesListCell.h"
@interface ReturnGoodsViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate,PaymentWayCellDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) BuybackOrderModel * buybackOrderModel;
@property (nonatomic,copy) NSString * mailType;
@property (nonatomic,copy) NSString * mailNumber;
@property (nonatomic,copy) NSString * leaseMessage;
@property (nonatomic,copy) NSString * reasonMessage;
@property (nonatomic,assign) NSInteger switchRow;
@property (nonatomic,strong) ScanningViewController * scanning;

@end

@implementation ReturnGoodsViewController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"申请退货"];
    [self showLoadingView];
    [self netWorkingRequest];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannedResultString:) name:@"scannedResult" object:nil];
  
}

-(void)scannedResultString:(NSNotification *)n
{
    NSDictionary * dict = n.userInfo;
    self.mailNumber = dict[@"scannedResult"];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)netWorkingRequest
{
    NSDictionary * param = @{@"orderId":self.orderID};
    WEAKSELF;
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"buyback" path:@"back_order_info" parameters:param completionBlock:^(NSDictionary *data) {
        
        [weakSelf hideLoadingView];
        NSDictionary * dict = data[@"orderInfo"];

        BuybackOrderModel * buyBackOrder = [[BuybackOrderModel alloc] initWithJSONDictionary:dict error:nil];
        weakSelf.buybackOrderModel = buyBackOrder;
        
        [self.view addSubview:self.tableView];
        [weakSelf setUpUI];
        [weakSelf loadCell];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)loadCell{
    
    [self.dataSources addObject:[ReturnGoodsInformationCell buildCellTitle:@"商品信息"]];
    [self.dataSources addObject:[OrderTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[ApplyGoodsDetailCell buildCellDict:self.buybackOrderModel]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    [self.dataSources addObject:[SecionTitleCell buildCellTitle:@"寄回明细"]];
    [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    
    [self.dataSources addObject:[SendBackDetailCell buildCellDict:self.buybackOrderModel]];
    if (self.buybackOrderModel.goodsCommoonFittingsList.count > 0) {
        for (int i = 0;  i < self.buybackOrderModel.goodsCommoonFittingsList.count; i++) {
            GoodsFittingsListModel * model = self.buybackOrderModel.goodsCommoonFittingsList[i];
            if (i == 0) {
                [self.dataSources addObject:[AccessoriesListCell buildCellDictWithList:model Andccessories:@"配件:"]];
            }else{
                [self.dataSources addObject:[AccessoriesListCell buildCellDictWithList:model Andccessories:nil]];
            }
        }
    };
    
    [self.dataSources addObject:[ReturnGoodsInformationCell buildCellTitle:@"退货地址"]];
    [self.dataSources addObject:[OrderTabViewCellSmallTwo buildCellDict]];
    
    AddressInfo * addree = [[AddressInfo alloc] init];
    addree.receiver = self.buybackOrderModel.userName;
    addree.areaDetail = self.buybackOrderModel.address;
    addree.phoneNumber = self.buybackOrderModel.phone;
    [self.dataSources addObject:[ReturnGoodsAddressCell buildCellDict:addree]];
    
    [self.dataSources addObject:[ReturnGoodsReturnReasonCell buildCellDict:nil]];

    [self.dataSources addObject:[ApplyLogisticsCell buildCellDict]];
    [self.dataSources addObject:[LogisticsNumberCell buildCellDict]];
    [self.dataSources addObject:[SmallLineCellTwo buildCellDict]];
    [self.dataSources addObject:[PaymentWayCell buildCellDict]];
    [self.dataSources addObject:[SmallLineCellTwo buildCellDict]];
    [self.dataSources addObject:[LeaveMessageCell buildCellDict]];

    

//    [self.dataSources addObject:[ReturnGoodsCompanyCell buildCellDict:nil]];
//    [self.dataSources addObject:[ReturnGoodsCompanyCell buildCellDict:nil]];
    
    //提交退货申请
    [self createSubmitBtn];

}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    
}

-(void)createSubmitBtn
{
    UIButton * SubmitBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, kScreenHeight-40, kScreenWidth-28, 40)];
    
    [SubmitBtn setBackgroundColor:[UIColor blackColor]];
    [SubmitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [SubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SubmitBtn];
}

-(void)submitBtnClick:(UIButton *)button
{

    
    if (self.mailNumber != nil && self.mailNumber.length != 0 && self.mailType != nil && self.mailType.length!= 0) {
        
        if (self.leaseMessage.length == 0) {
            self.leaseMessage = @"";
        }
        
        MailinfoModel * mailinfo = [[MailinfoModel alloc] init];
        mailinfo.mail_sn = self.mailNumber;
        mailinfo.mail_type = self.mailType;
        mailinfo.mail_com = @"";
        
        NSDictionary * param = @{@"order_id":self.orderID,
                                 @"mail_info":mailinfo?[mailinfo toJSONDictionary]:@"",@"reason":self.reasonMessage?self.reasonMessage:@"",
                                 @"message":self.leaseMessage
                                 };
        WEAKSELF;
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"repurchase" path:@"apply" parameters:param completionBlock:^(NSDictionary *data) {
            
            //退货成功
            ReturnGoodsSucViewController * returnSuc = [[ReturnGoodsSucViewController alloc] init];
            [self.navigationController pushViewController:returnSuc animated:YES];
            
        } failure:^(XMError *error) {
            //        [weakSelf showHUD:@"退货只能提交一次" hideAfterDelay:0.8];
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
    }else if (self.mailType == nil || self.mailType.length == 0){
        [self showHUD:@"请选择物流公司" hideAfterDelay:0.8];
    }else if (self.mailNumber == nil || self.mailNumber.length == 0){
        [self showHUD:@"请填写物流单号" hideAfterDelay:0.8];
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
    
    if ([tableViewCell isKindOfClass:[ApplyLogisticsCell class]]) {
        ApplyLogisticsCell * applyCell = (ApplyLogisticsCell *)tableViewCell;
        applyCell.logistics = ^(NSString *name){
            
            if ([name isEqualToString:@"顺丰速运"]) {
                self.mailType = @"shunfeng";
            }else if ([name isEqualToString:@"EMS"]){
                self.mailType = @"ems";
            }
            
        };
    }
    
    if ([tableViewCell isKindOfClass:[LogisticsNumberCell class]]) {
        LogisticsNumberCell * applyCell = (LogisticsNumberCell *)tableViewCell;
        applyCell.logistics = ^(NSString *name){
            
            self.mailNumber = name;
            
        };
    }
    
    if ([tableViewCell isKindOfClass:[LeaveMessageCell class]]) {
        LeaveMessageCell * messageCell = (LeaveMessageCell *)tableViewCell;
        messageCell.message = ^(NSString * message){
            
            self.leaseMessage = message;
        };
    }
    
    if ([tableViewCell isKindOfClass:[ReturnGoodsReturnReasonCell class]]) {
        ReturnGoodsReturnReasonCell * messageCell = (ReturnGoodsReturnReasonCell *)tableViewCell;
        messageCell.returnReason = ^(NSString * reason){
            
            self.reasonMessage = reason;
            
        };
    }
    
    //是否保价到付
    if ([tableViewCell isKindOfClass:[PaymentWayCell class]]) {
        PaymentWayCell * cell = (PaymentWayCell *)tableViewCell;
        cell.delegate = self;
        _switchRow = indexPath.row;
    }
    
    //二维码扫描订单
    if ([tableViewCell isKindOfClass:[LogisticsNumberCell class]]) {
        LogisticsNumberCell * cell = (LogisticsNumberCell *)tableViewCell;
        cell.two_dimension_code = ^(ScanningViewController *scanning){
            [self presentViewController:scanning animated:YES completion:nil];
        };
    }
    
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
//    //临时入口
//    if (ClsTableViewCell == [ReturnGoodsInformationCell class]) {
//        //退货成功
//        ReturnGoodsSucViewController * returnSuc = [[ReturnGoodsSucViewController alloc] init];
//        [self.navigationController pushViewController:returnSuc animated:YES];
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}




//保价到付
-(void)showPaymentWay:(UISwitch *)sw
{
    
    [self.dataSources insertObject:[SupportvalueCell buildCellDict:self.buybackOrderModel] atIndex:_switchRow+1];
    [self.tableView reloadData];
    
}

-(void)dismissPaymentWay:(UISwitch *)sw
{
    [self.dataSources removeObjectAtIndex:_switchRow+1];
    [self.tableView reloadData];
}

@end
