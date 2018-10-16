//
//  WristApplyViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/6/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristApplyViewController.h"
#import "PullRefreshTableView.h"
#import "NetworkManager.h"
#import "NSDate+Category.h"
#import "Masonry.h"

#import "OrderInfo.h"
#import "AddressInfo.h"
#import "GoodsInfo.h"

#import "BaseTableViewCell.h"
#import "SepTableViewCell.h"
#import "SecionTitleCell.h"
#import "SmallLineCellTwo.h"
#import "OrderGoodsTableViewCell.h"
#import "ApplyGoodsDetailCell.h"
#import "ApplyGoodsBranchCell.h"
#import "OrderTimeCell.h"
#import "SendBackDetailCell.h"
#import "OrderAddressCell.h"

#import "ApplyLogisticsCell.h"
#import "OrderGoodsTableViewCell.h"
#import "WristwatchRecoveryDetailCell.h"
#import "OrderSmallLineCell.h"
#import "LogisticsNumberCell.h"
#import "PaymentWayCell.h"
#import "LeaveMessageCell.h"
#import "ReturnGoodsAddressCell.h"
#import "BuyBackCell.h"
#import "BuyackTimeCell.h"
#import "SupportvalueCell.h"
#import "AccessoriesListCell.h"
#import "Error.h"

#import "BuybackOrderModel.h"
#import "MailinfoModel.h"
#import "WebViewController.h"
#import "GoodsFittings.h"

@interface WristApplyViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,PaymentWayCellDelegate>


@property (nonatomic,strong) PullRefreshTableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) OrderInfo * orderInfo;
@property (nonatomic,strong) AddressInfo * address;
@property (nonatomic,strong) BuybackOrderModel * buybackOrderModel;
@property (nonatomic,assign) NSInteger switchRow;
@property (nonatomic,copy) NSString * mailType;
@property (nonatomic,copy) NSString * mailNumber;
@property (nonatomic,copy) NSString * leaseMessage;

@end

@implementation WristApplyViewController

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
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-53)];
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
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"申请回购"];
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
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"buyback" path:@"order_info" parameters:param completionBlock:^(NSDictionary *data) {

        [weakSelf hideLoadingView];
        NSDictionary * dict = data[@"orderInfo"];
        
        BuybackOrderModel * buyBackOrder = [[BuybackOrderModel alloc] initWithJSONDictionary:dict error:nil];

        weakSelf.buybackOrderModel = buyBackOrder;
        
        [self.view addSubview:self.tableView];
        
        [weakSelf loadData];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)loadData
{

    [self.dataArray addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataArray addObject:[SecionTitleCell buildCellTitle:@"商品信息"]];
    [self.dataArray addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataArray addObject:[ApplyGoodsDetailCell buildCellDict:self.buybackOrderModel]];

    
    NSArray * array = self.buybackOrderModel.goodsLossFittingsList;
    for (int i = 0; i < array.count; i++) {
        [self.dataArray addObject:[ApplyGoodsBranchCell buildCellDictWithList:array[i]]];
    }
    
    

    [self.dataArray addObject:[SmallLineCellTwo buildCellDict]];
    NSString * buyBackInfoMessage = self.buybackOrderModel.buyBackInfoMessage;
    [self.dataArray addObject:[BuyBackCell buildCellTitle:buyBackInfoMessage]];
    [self.dataArray addObject:[SmallLineCellTwo buildCellDict]];
    
    NSString *timeStamp = self.buybackOrderModel.receivedTime;
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:([timeStamp doubleValue] / 1000.0)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateString = [formatter stringFromDate:time];
    [self.dataArray addObject:[BuyackTimeCell buildCellDict:@"收货时间" andDateString:dateString]];
    
    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    long long time1 = a - [timeStamp doubleValue]/1000;
    NSDate *datNew = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000.0];
    NSString * payStr = [datNew nowtimeIntervalDescription];

    [self.dataArray addObject:[BuyackTimeCell buildCellDict:@"距今已有" andDateString:payStr]];
    [self.dataArray addObject:[BuyBackCell buildCellTitle:self.buybackOrderModel.supportMessage]];
    [self.dataArray addObject:[SepTableViewCell buildCellDict]];
    [self.dataArray addObject:[SecionTitleCell buildCellTitle:@"寄回明细"]];
    [self.dataArray addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataArray addObject:[SendBackDetailCell buildCellDict:self.buybackOrderModel]];

    //寄回明细
    if (self.buybackOrderModel.goodsCommoonFittingsList.count > 0) {
        for (int i = 0;  i < self.buybackOrderModel.goodsCommoonFittingsList.count; i++) {
            GoodsFittingsListModel * model = self.buybackOrderModel.goodsCommoonFittingsList[i];
            if (i == 0) {
                [self.dataArray addObject:[AccessoriesListCell buildCellDictWithList:model Andccessories:@"配件:"]];
            }else{
                [self.dataArray addObject:[AccessoriesListCell buildCellDictWithList:model Andccessories:nil]];
            }
        }
    };
    
    
    
    [self.dataArray addObject:[SmallLineCellTwo buildCellDict]];
    [self.dataArray addObject:[BuyBackCell buildCellTitle:self.buybackOrderModel.warringMessage withColor:[UIColor redColor]]];
    [self.dataArray addObject:[SepTableViewCell buildCellDict]];
    [self.dataArray addObject:[SecionTitleCell buildCellTitle:@"寄回地址"]];
    [self.dataArray addObject:[SegTabViewCellSmallTwo buildCellDict]];


    AddressInfo * addree = [[AddressInfo alloc] init];
    addree.receiver = self.buybackOrderModel.userName;
    addree.areaDetail = self.buybackOrderModel.address;
    addree.phoneNumber = self.buybackOrderModel.phone;
    [self.dataArray addObject:[ReturnGoodsAddressCell buildCellDict:addree]];
    
    [self.dataArray addObject:[ApplyLogisticsCell buildCellDict]];
    [self.dataArray addObject:[LogisticsNumberCell buildCellDict]];
    [self.dataArray addObject:[SmallLineCellTwo buildCellDict]];
    [self.dataArray addObject:[PaymentWayCell buildCellDict]];
    [self.dataArray addObject:[SmallLineCellTwo buildCellDict]];
    [self.dataArray addObject:[LeaveMessageCell buildCellDict]];
    
    
    //提交回购申请
    [self createSubmitBtn];
    
    
}

-(NSString *)getUTCFormateDate:(NSString *)newsDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    NSLog(@"time=%f",(double)time);
    
    NSString *dateContent;
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月前"];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",days,@"天前"];
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hours,@"小时前"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟前"];
    }
    
    //    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    
    

    return dateContent;
}



-(void)createSubmitBtn
{
    UIButton * SubmitBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(self.tableView.frame), kScreenWidth-28, 40)];
    
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
        
        NSDictionary * param = @{@"order_id":self.orderID,@"mail_info":mailinfo?[mailinfo toJSONDictionary]:@"",@"reason":@"",@"message":self.leaseMessage};
        WEAKSELF;
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"repurchase" path:@"apply" parameters:param completionBlock:^(NSDictionary *data) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHUD:@"提交成功" hideAfterDelay:0.8];
                NSArray * array = self.navigationController.childViewControllers;
                NSInteger num = array.count;
                [self.navigationController popToViewController:array[num-3] animated:YES];
            });
            
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
    }else if (self.mailType == nil || self.mailType.length == 0){
        [self showHUD:@"请选择物流公司" hideAfterDelay:0.8];
    }else if (self.mailNumber == nil || self.mailNumber.length == 0){
        [self showHUD:@"请填写物流单号" hideAfterDelay:0.8];
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
    
    if ([Cell isKindOfClass:[ApplyLogisticsCell class]]) {
        ApplyLogisticsCell * applyCell = (ApplyLogisticsCell *)Cell;
        applyCell.logistics = ^(NSString *name){
           
            if ([name isEqualToString:@"顺丰速运"]) {
                self.mailType = @"shunfeng";
            }else if ([name isEqualToString:@"EMS"]){
                self.mailType = @"ems";
            }
  
        };
    }
    
    if ([Cell isKindOfClass:[LogisticsNumberCell class]]) {
        LogisticsNumberCell * applyCell = (LogisticsNumberCell *)Cell;
        applyCell.logistics = ^(NSString *name){
       
            self.mailNumber = name;
        };
    }
    
    if ([Cell isKindOfClass:[LeaveMessageCell class]]) {
        LeaveMessageCell * messageCell = (LeaveMessageCell *)Cell;
        messageCell.message = ^(NSString * message){
  
            self.leaseMessage = message;
        };
    }
    
    if ([Cell isKindOfClass:[BuyBackCell class]]) {
        BuyBackCell * buyBackCell = (BuyBackCell *)Cell;
        buyBackCell.rtLabelSelect = ^(NSURL * url){
            
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = [url absoluteString];
            viewController.title = @"原价回购标准";
            [self pushViewController:viewController animated:YES];
        };
    }
    
    //是否保价到付
    if ([Cell isKindOfClass:[PaymentWayCell class]]) {
        PaymentWayCell * cell = (PaymentWayCell *)Cell;
        cell.delegate = self;
        _switchRow = indexPath.row;
    }
    
    //二维码扫描订单
    if ([Cell isKindOfClass:[LogisticsNumberCell class]]) {
        LogisticsNumberCell * cell = (LogisticsNumberCell *)Cell;
        cell.two_dimension_code = ^(ScanningViewController *scanning){
            [self presentViewController:scanning animated:YES completion:nil];
        };
    }
    
    [Cell updateCellWithDict:dict];
    return Cell;
}

-(void)showPaymentWay:(UISwitch *)sw
{
    [self.dataArray insertObject:[SupportvalueCell buildCellDict:self.buybackOrderModel] atIndex:_switchRow+1];
    [self.tableView reloadData];

}

-(void)dismissPaymentWay:(UISwitch *)sw
{
    [self.dataArray removeObjectAtIndex:_switchRow+1];
    [self.tableView reloadData];
}

@end
