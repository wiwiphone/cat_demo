//
//  SendSaleNewViewController.m
//  XianMao
//
//  Created by WJH on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSaleNewViewController.h"
#import "PullRefreshTableView.h"
#import "SendSaleTableViewCell.h"
#import "SepTableViewCell.h"
#import "SendSaleDetailViewController.h"
#import "DataListLogic.h"
#import "SendSaleVo.h"
#import "WCAlertView.h"
#import "TradeService.h"
#import "SoldViewController.h"
#import "UserAddressViewController.h"
#import "WebViewController.h"
#import "BlackView.h"
#import "GoodsDetailViewController.h"




@interface SendSaleNewViewController ()<UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSArray *mailTypeList;
@property (nonatomic, strong) AddressInfo *addressInfo;
@property (nonatomic, strong) SendSaleGuideView * guideView;
@property (nonatomic, strong) HTTPRequest * request;
@end

@implementation SendSaleNewViewController

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 65.5, kScreenWidth, kScreenHeight-65.5)];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
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
    [super setupTopBarTitle:@"我的寄卖"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [self constomTopBarRightButton];
    
    [self.view addSubview:self.tableView];
    
    [self initDataListLogic];
    
    if (self.isNeesGuideView) {
        _guideView = [[SendSaleGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_guideView show:self.view];
    }
}

- (void)$$handleSendSaleGoodsChangedNotification:(id<MBNotification>)notifi sendSaleVo:(SendSaleVo *)sendvo{
    for (NSDictionary *dict in self.dataSources) {
        SendSaleVo *sendsaleVo = [dict objectForKey:[SendSaleTableViewCell cellKeyForsendVo]];
        if ([sendsaleVo.consigmentSn isEqualToString:sendvo.consigmentSn]) {
            sendsaleVo.labelNum = sendvo.labelNum;
            sendsaleVo.statusDesc = sendvo.statusDesc;
            sendsaleVo.logistical = sendvo.logistical;
            sendsaleVo.logisticalNum = sendvo.logisticalNum;
            sendsaleVo.goodsSn = sendvo.goodsSn;
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)initDataListLogic{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"consignment" path:@"get_consignment_list" pageSize:20];
    //    _dataListLogic.parameters = @{@"status" : [NSNumber numberWithInteger:weakSelf.status]};
    _dataListLogic.parameters = @{@"type":@(0)};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        [newList addObject:[SepTableViewCell buildCellDict]];
        for (int i=0;i<[addedItems count];i++) {
            SendSaleVo *sendVo = [SendSaleVo createWithDict:addedItems[i]];
            [newList addObject:[SepTableViewCell buildCellDict]];
            [newList addObject:[SendSaleTableViewCell buildCellDict:sendVo]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            SendSaleVo *sendVo = [SendSaleVo createWithDict:addedItems[i]];
            [newList addObject:[SepTableViewCell buildCellDict]];
            [newList addObject:[SendSaleTableViewCell buildCellDict:sendVo]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                
            }
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton:@"无闲置商品"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [_dataListLogic reloadDataListByForce];
    //    [_dataListLogic firstLoadFromCache];
    
    //    [weakSelf showLoadingView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataListByForce];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    SendSaleVo * sendVo = [dict objectForKey:[SendSaleTableViewCell cellKeyForsendVo]];
    SendSaleDetailViewController * viewCtrl = [[SendSaleDetailViewController alloc] init];
    viewCtrl.requestId = sendVo.ID;
    [self pushViewController:viewCtrl animated:YES];
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
    
    
    //发货给寄卖中心
    WEAKSELF;
    if ([Cell isKindOfClass:[SendSaleTableViewCell class]]) {
        ((SendSaleTableViewCell *)Cell).handleActionToConsigmentBlcok = ^(NSString * consigmentSn){
            [weakSelf handleOrderActionSendBlock:consigmentSn];
        };
        
        ((SendSaleTableViewCell *)Cell).handleActionSeeLogisticsBlcok = ^(SendSaleVo * sendVo){
            WebViewController *webview = [[WebViewController alloc] init];
            webview.url = [NSString stringWithFormat:@"http://activity.aidingmao.com/tools/mailinfo?mail_type=%@&mail_sn=%@", sendVo.logistical,sendVo.logisticalNum];
            [weakSelf pushViewController:webview animated:YES];
        };
        
        ((SendSaleTableViewCell *)Cell).handleActionContactAppraiserBlcok = ^(NSInteger estimatorId){
            [UserSingletonCommand chatWithGuwen:estimatorId isGuwen:NO];
        };
        
        ((SendSaleTableViewCell *)Cell).handleActionSeeGoodsDetailBlcok = ^(NSString *goodsSn){
            GoodsDetailViewControllerContainer * viewController = [[GoodsDetailViewControllerContainer alloc] init];
            viewController.goodsId = goodsSn;
            [self pushViewController:viewController animated:YES];
        };
        
        ((SendSaleTableViewCell *)Cell).handleActionConfirmDeleteBlcok = ^(NSInteger ID) {
            [WCAlertView showAlertWithTitle:nil message:@"确定要取消寄卖吗" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex == 1) {
                    [_request cancel];
                    [weakSelf showProcessingHUD:nil];
                    _request = [[NetworkAPI sharedInstance] deleteConsignGoods:ID completion:^{
                        [weakSelf hideHUD];
                        for (int i = 0; i < self.dataSources.count; i++) {
                            NSDictionary *dict = [self.dataSources objectAtIndex:i];
                            SendSaleVo *sendVo = [dict objectForKey:[SendSaleTableViewCell cellKeyForsendVo]];
                            if (sendVo.ID == ID) {
                                [self.dataSources removeObjectAtIndex:i];
                            }
                        }
                        
                        [self.tableView reloadData];
                        
                    } failure:^(XMError *error) {
                        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                    [DeliverInfoEditView showInView:weakSelf.view isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService sendToConsignment:consigmentSn logistical:mailType logisticalNum:mailSN completion:^(SendSaleVo * sendvo){
                                for (NSDictionary *dict in weakSelf.dataSources) {
                                    SendSaleVo *sendsaleVo = [dict objectForKey:[SendSaleTableViewCell cellKeyForsendVo]];
                                    if ([sendsaleVo.consigmentSn isEqualToString:sendvo.consigmentSn]) {
                                        sendsaleVo.labelNum = sendvo.labelNum;
                                        sendsaleVo.statusDesc = sendvo.statusDesc;
                                        sendsaleVo.logistical = sendvo.logistical;
                                        sendsaleVo.logisticalNum = sendvo.logisticalNum;
                                        sendsaleVo.goodsSn = sendvo.goodsSn;
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
                [DeliverInfoEditView showInView:weakSelf.view isSecuredTrade:YES mailTypeList:_mailTypeList addressInfo:_addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                    
                    if ([mailSN length]>0 && [mailType length]>0) {
                        [TradeService sendToConsignment:consigmentSn logistical:mailType logisticalNum:mailSN completion:^(SendSaleVo * sendVo){
                            
                            for (NSDictionary *dict in weakSelf.dataSources) {
                                SendSaleVo *sendsaleVo = [dict objectForKey:[SendSaleTableViewCell cellKeyForsendVo]];
                                if ([sendsaleVo.consigmentSn isEqualToString:sendVo.consigmentSn]) {
                                    sendsaleVo.labelNum = sendVo.labelNum;
                                    sendsaleVo.statusDesc = sendVo.statusDesc;
                                    sendsaleVo.logistical = sendVo.logistical;
                                    sendsaleVo.logisticalNum = sendVo.logisticalNum;
                                    sendsaleVo.goodsSn = sendVo.goodsSn;
                                    break;
                                }
                            }
                            [weakSelf.tableView reloadData];
                            
                        } failure:^(XMError *error) {
                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
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

- (void)constomTopBarRightButton {
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    CGRect rect = super.topBarRightButton.frame;
    CGFloat width = rect.size.width;
    CGFloat frameX = rect.origin.x;
    width += 40;
    frameX -= 40;
    rect.size.width = width;
    rect.origin.x = frameX;
    self.topBarRightButton.frame = rect;
    [self.topBarRightButton setTitle:@"寄卖咨询" forState:UIControlStateNormal];
    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.url = SENDPUBLISH;
    [self pushViewController:viewController animated:YES];
}

@end


@implementation SendSaleGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        WEAKSELF;
        self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        BlackView * blackView = [[BlackView alloc] initWithFrame:self.bounds];
        [self addSubview:blackView];
        
        UIImage * guideImage = [UIImage imageNamed:@"SendSaleGuideImage"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - guideImage.size.width -20, 250, guideImage.size.width, guideImage.size.height)];
        imageView.image = guideImage;
        [self addSubview:imageView];
        
        blackView.dissMissBlackView = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        };
        
    }
    return self;
}


- (void)show:(UIView *)view{
    if (view) {
        [view addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}


@end
