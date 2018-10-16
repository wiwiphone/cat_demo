//
//  SendSaleDetailViewController.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSaleDetailViewController.h"
#import "PullRefreshTableView.h"
#import "GoodsPictrueCell.h"
#import "SepTableViewCell.h"
#import "AnticipantpCell.h"
#import "SendSaleGoodsDescCell.h"
#import "SendSalerCell.h"
#import "SendSaleOrderTimeCell.h"
#import "SendSaleAddressCell.h"
#import "SendSaleVo.h"
#import "SendsaleActionCell.h"
#import "NSDate+Category.h"
#import "WCAlertView.h"
#import "TradeService.h"
#import "SoldViewController.h"
#import "AddressInfo.h"
#import "UserAddressViewController.h"
#import "WebViewController.h"
#import "GoodsDetailViewController.h"


@interface SendSaleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate>
@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) NSArray *mailTypeList;
@property (nonatomic, strong) AddressInfo * addressInfo;

@end

@implementation SendSaleDetailViewController

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 65.5, kScreenWidth, kScreenHeight-65.5)];
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
    [super setupTopBarTitle:@"寄卖详情"];
    [super setupTopBarBackButton];
    WEAKSELF;
    NSDictionary * paramters = @{@"id":@(self.requestId)};
    [self showLoadingView];
    [[NetworkManager sharedInstance] requestWithMethodGET:@"consignment" path:@"get_consignment_detail" parameters:paramters completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        NSDictionary * dict = [data objectForKey:@"get_consignment_detail"];
        SendSaleVo *sendVo = [SendSaleVo createWithDict:dict];
        [self.view addSubview:self.tableView];
        [self loadCell:sendVo];
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil];
    
}

- (void)loadCell:(SendSaleVo *)sendVo{
    if (sendVo) {
        NSMutableArray * dataSources = [[NSMutableArray alloc] init];
        [dataSources addObject:[SepTableViewCell buildCellDict]];
        [dataSources addObject:[GoodsPictrueCell buildCellDict:sendVo]];
        [dataSources addObject:[AnticipantpCell buildCellDict:[NSString stringWithFormat:@"%.2f",sendVo.userHopePrice]]];
        [dataSources addObject:[SendSaleGoodsDescCell buildCellDict:sendVo]];
        [dataSources addObject:[SendSalerCell buildCellDict:sendVo]];
        
        
        [dataSources addObject:[SendSaleOrderTimeCell buildCellDict:nil title:@"寄卖编号" isCopy:YES orderId:sendVo.consigmentSn]];
        if (sendVo.outLineTime > 0) {
            NSDate *onlineDate = [NSDate dateWithTimeIntervalSince1970:sendVo.outLineTime/1000];
            [dataSources addObject:[SendSaleOrderTimeCell buildCellDict:nil title:@"上线时间" isCopy:NO orderId:[NSString stringWithFormat:@"%@",[onlineDate XMformattedDateDescription]]]];
        }
        
        if (sendVo.outLineTime > 0) {
            NSDate *outlineDate = [NSDate dateWithTimeIntervalSince1970:sendVo.outLineTime/1000];
            [dataSources addObject:[SendSaleOrderTimeCell buildCellDict:nil title:@"下线时间" isCopy:NO orderId:[NSString stringWithFormat:@"%@",[outlineDate XMformattedDateDescription]]]];
        }
        
        if (sendVo.dealTime > 0) {
            NSDate *dealDate = [NSDate dateWithTimeIntervalSince1970:sendVo.dealTime/1000];
             [dataSources addObject:[SendSaleOrderTimeCell buildCellDict:nil title:@"成交时间" isCopy:NO orderId:[NSString stringWithFormat:@"%@",[dealDate XMformattedDateDescription]]]];
        }
        
        [dataSources addObject:[SendSaleAddressCell buildCellDict:sendVo]];
        [dataSources addObject:[SendsaleActionCell buildCellDict:sendVo]];
        
        _dataSources = dataSources;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [_dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [_dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString * reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell * Cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (Cell == nil) {
        Cell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WEAKSELF;
    if ([Cell isKindOfClass:[SendsaleActionCell class]]) {
        ((SendsaleActionCell *)Cell).handleActionToConsigmentBlcok = ^(NSString * consigmentSn){
            [weakSelf handleOrderActionSendBlock:consigmentSn];
        };
        
        ((SendsaleActionCell *)Cell).handleActionSeeLogisticsBlcok = ^(SendSaleVo * sendVo){
            WebViewController *webview = [[WebViewController alloc] init];
            webview.url = [NSString stringWithFormat:@"http://activity.aidingmao.com/tools/mailinfo?mail_type=%@&mail_sn=%@", sendVo.logistical,sendVo.logisticalNum];
            [weakSelf pushViewController:webview animated:YES];
        };
        
        ((SendsaleActionCell *)Cell).handleActionContactAppraiserBlcok = ^(NSInteger estimatorId){
            [UserSingletonCommand chatWithGuwen:estimatorId isGuwen:NO];
        };
        
        ((SendsaleActionCell *)Cell).handleActionSeeGoodsDetailBlcok = ^(NSString *goodsSn){
            GoodsDetailViewControllerContainer * viewController = [[GoodsDetailViewControllerContainer alloc] init];
            viewController.goodsId = goodsSn;
            [self pushViewController:viewController animated:YES];
        };
    }
    
    [Cell updateCellWithDict:dict];
    return Cell;
}


- (void)handleOrderActionSendBlock:(NSString*)consigmentSn
{
    WEAKSELF;
    [weakSelf showProcessingHUD:nil];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
        
        if ([addressDictList count]>0) {
            if (weakSelf.mailTypeList == nil || [weakSelf.mailTypeList count]==0) {
                [TradeService listAllExpress:consigmentSn mailType:Consign completion:^(NSArray *mailTypeList, AddressInfo *addressInfo) {
                    [weakSelf hideHUD];
                    [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService sendToConsignment:consigmentSn logistical:mailType logisticalNum:mailSN completion:^(SendSaleVo * sendvo){
                                for (NSDictionary *dict in weakSelf.dataSources) {
                                    SendSaleVo *sendsaleVo = [dict objectForKey:[SendsaleActionCell cellKeyForsendVo]];
                                    if ([sendsaleVo.consigmentSn isEqualToString:sendvo.consigmentSn]) {
                                        sendsaleVo.labelNum = sendvo.labelNum;
                                        sendsaleVo.statusDesc = sendvo.statusDesc;
                                        sendsaleVo.logistical = sendvo.logistical;
                                        sendsaleVo.logisticalNum = sendvo.logisticalNum;
                                        sendsaleVo.goodsSn = sendvo.goodsSn;
                                        
                                        [[Session sharedInstance] reloadSendSaleData:sendvo];
                                        break;
                                    }
                                }
                                [weakSelf.tableView reloadData];
                            } failure:^(XMError *error) {
                                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
                            }];
                            return YES;
                        } else {
                            if ([mailSN length]==0) {
                                [weakSelf showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
                            }
                            else if ([mailType length]==0) {
                                [weakSelf showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
                            }
                            else {
                                [weakSelf showHUD:@"请填写完成的快递信息" hideAfterDelay:0.8f];
                            }
                            return NO;
                        }
                    }];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            } else {
                [weakSelf hideHUD];
                [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:_mailTypeList addressInfo:_addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                    
                    if ([mailSN length]>0 && [mailType length]>0) {
                        [TradeService sendToConsignment:consigmentSn logistical:mailType logisticalNum:mailSN completion:^(SendSaleVo * sendVo){
                            
                            for (NSDictionary *dict in weakSelf.dataSources) {
                                SendSaleVo *sendsaleVo = [dict objectForKey:[SendsaleActionCell cellKeyForsendVo]];
                                if ([sendsaleVo.consigmentSn isEqualToString:sendVo.consigmentSn]) {
                                    sendsaleVo.labelNum = sendVo.labelNum;
                                    sendsaleVo.statusDesc = sendVo.statusDesc;
                                    sendsaleVo.logistical = sendVo.logistical;
                                    sendsaleVo.logisticalNum = sendVo.logisticalNum;
                                    sendsaleVo.goodsSn = sendVo.goodsSn;
                                    
                                    [[Session sharedInstance] reloadSendSaleData:sendVo];
                                    break;
                                }
                            }
                            [weakSelf.tableView reloadData];
                            
                        } failure:^(XMError *error) {
                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
                        }];
                        return YES;
                    } else {
                        if ([mailSN length]==0) {
                            [weakSelf showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
                        }
                        else if ([mailType length]==0) {
                            [weakSelf showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
                        }
                        else {
                            [weakSelf showHUD:@"请填写完成的快递信息" hideAfterDelay:0.8f];
                        }
                        return NO;
                    }
                }];
            }
        } else {
            [weakSelf hideHUD];
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请添加退货地址"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 UserAddressViewController *viewController = [[UserAddressViewControllerReturn alloc] init];
                                 [weakSelf pushViewController:viewController animated:YES];
                             }
                         } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
    }]];
}

@end
