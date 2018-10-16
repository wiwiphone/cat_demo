//
//  OrderDetailNewViewController.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderDetailNewViewController.h"
#import "PullRefreshTableView.h"
#import "NetworkManager.h"
#import "BaseTableViewCell.h"
#import "LogisticsViewController.h"
#import "AddressInfo.h"
#import "OrderInfo.h"
#import "GoodsService.h"
#import "PayOrderWayVo.h"
#import "Masonry.h"
#import "OrderServiceCell.h"
#import "NSDate+Category.h"

#import "OrderStatusCell.h"
#import "OrderAddressCell.h"
#import "OrderSmallLineCell.h"
#import "OrderMessageCell.h"
#import "SepTableViewCell.h"
#import "WristWhiteRecovertCell.h"
#import "OrderGoodsTableViewCell.h"
#import "WristwatchRecoveryDetailCell.h"
#import "OrderOtherExpenseCell.h"
#import "OrderPriceCell.h"
#import "OrderTimeCell.h"
#import "GoodsDetailTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "OrderGoodsTypeCell.h"

#import "GoodsDetailViewController.h"

#import "WristApplyViewController.h"
#import "ProgressQueryViewController.h"
#import "ProtocolViewController.h"
#import "ReturnGoodsViewController.h"
#import "WashIllustrateCell.h"
#import "User.h"
#import "BuyBackCell.h"

#import "NetworkAPI.h"
#import "Error.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "WCAlertView.h"
#import "Session.h"
#import "LoginViewController.h"
#import "BoughtViewController.h"
#import "TradeService.h"
#import "UIActionSheet+Blocks.h"
#import "NSDictionary+Additions.h"
#import "OfferedViewController.h"
#import "BlackView.h"
#import "TipView.h"

#import "NetworkAPI.h"
#import "UserService.h"
#import "PayManager.h"
#import "EvaluateView.h"
#import "FenQiLePayViewController.h"
#import "SuccessfulPayViewController.h"
#import "AuthService.h"
#import "PartialView.h"
#import "PartialPayWayView.h"
#import "WalletTwoViewController.h"
#import "SoldViewController.h"
#import "Error.h"
#import "UserAddressViewController.h"
#import "ScanCodePaymentViewController.h"

@interface OrderDetailNewViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>


@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) AddressInfo *addressInfo;
@property (nonatomic, strong) OrderInfo *orderInfo;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *buyer;
@property (nonatomic, strong) MailInfo * mailInfo;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *goodsRecommendList;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CommandButton *seeLogistics;

@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, strong) CommandButton *bottomBtn;

@property (nonatomic, strong) TipView *tipView;
@property (nonatomic, strong) BlackView *tipBgView;

@property (nonatomic, strong) BonusInfo *cancelBonusInfo;
@property (nonatomic, strong) AccountCard *cancelAccountCard;

@property (nonatomic, strong) BlackView *partialBgView;
@property (nonatomic, strong) PartialView *partialView;
@property (nonatomic, strong) PartialPayWayView *partialPayWayView;
@end

@implementation OrderDetailNewViewController

-(PartialPayWayView *)partialPayWayView{
    if (!_partialPayWayView) {
        _partialPayWayView = [[PartialPayWayView alloc] initWithFrame:CGRectZero];
        _partialPayWayView.backgroundColor = [UIColor whiteColor];
    }
    return _partialPayWayView;
}

-(BlackView *)partialBgView{
    if (!_partialBgView) {
        _partialBgView = [[BlackView alloc] initWithFrame:CGRectZero];
        _partialBgView.alpha = 0;
    }
    return _partialBgView;
}

-(PartialView *)partialView{
    if (!_partialView) {
        _partialView = [[PartialView alloc] initWithFrame:CGRectZero];
        _partialView.backgroundColor = [UIColor whiteColor];
    }
    return _partialView;
}

-(BlackView *)tipBgView{
    if (!_tipBgView) {
        _tipBgView = [[BlackView alloc] initWithFrame:CGRectZero];
    }
    return _tipBgView;
}

-(TipView *)tipView{
    if (!_tipView) {
        _tipView = [[TipView alloc] initWithFrame:CGRectZero];
        _tipView.backgroundColor = [UIColor whiteColor];
    }
    return _tipView;
}

-(CommandButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_bottomBtn setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _bottomBtn.layer.borderColor = [UIColor colorWithHexString:@"242424"].CGColor;
        _bottomBtn.layer.borderWidth = 0.5f;
    }
    return _bottomBtn;
}

-(CommandButton *)seeLogistics{
    if (!_seeLogistics) {
        _seeLogistics = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_seeLogistics setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
        _seeLogistics.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _seeLogistics.layer.borderColor = [UIColor colorWithHexString:@"242424"].CGColor;
        _seeLogistics.layer.borderWidth = 0.5f;
    }
    return _seeLogistics;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _bottomView;
}

-(NSMutableArray *)goodsRecommendList{
    if (!_goodsRecommendList) {
        _goodsRecommendList = [[NSMutableArray alloc] init];
    }
    return _goodsRecommendList;
}

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
    NSLog(@"orderInfo.buttonStats%ld",(long)self.orderInfo.buttonStats);
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"订单详情"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAccountCard:) name:@"cancelAccountCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBonusInfo:) name:@"cancelBonusInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSurpPay:) name:@"notificationSurpPay" object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelAccountCard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelBonusInfo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationSurpPay" object:nil];
}

-(void)notificationSurpPay:(NSNotification *)notify{
    NSNumber *payWayNum = notify.object;
    NSInteger payWay = payWayNum.integerValue;
    self.partialDo.payType = payWay;
    //    self.partialDo = partialDo;
    [self showPartialView];
}

-(void)cancelBonusInfo:(NSNotification *)notify{
    BonusInfo *cancelBonusInfo = notify.object;
    self.cancelBonusInfo = cancelBonusInfo;
}

-(void)cancelAccountCard:(NSNotification *)notify{
    AccountCard *cancelAccountCard = notify.object;
    self.cancelAccountCard = cancelAccountCard;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self load];
    
}

-(void)load{
    WEAKSELF;
    NSDictionary *param = @{@"order_id":self.orderId};
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"order_detail" parameters:param completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        
        NSDictionary *dict = data[@"order_detail"];
        AddressInfo *addressInfo = [[AddressInfo alloc] initWithDict:dict[@"address_info"]];
        OrderInfo *orderInfo = [[OrderInfo alloc] initWithDict:dict[@"order_info"]];
        MailInfo * mainInfo = [[MailInfo alloc] initWithDict:dict[@"mail_info"]];
        weakSelf.addressInfo = addressInfo;
        weakSelf.orderInfo = orderInfo;
        weakSelf.user = orderInfo.user;
        weakSelf.buyer = orderInfo.buyer;
        weakSelf.mailInfo = mainInfo;
        
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.bottomView];
        [self.bottomView addSubview:self.seeLogistics];
        [self.bottomView addSubview:self.bottomBtn];
        self.bottomBtn.hidden = YES;
        
        
        if (orderInfo.logic_type == RETURNGOODS || orderInfo.logic_type == SELFGOODS) {
            [self.seeLogistics setTitle:@"联系顾问" forState:UIControlStateNormal];
            self.seeLogistics.hidden = NO;
            self.seeLogistics.handleClickBlock = ^(CommandButton *sender){
                
                
                
                
                
                //                //申请退货
                //                ReturnGoodsViewController *returnGoodsController = [[ReturnGoodsViewController alloc] init];
                //                returnGoodsController.orderID = weakSelf.orderId;
                //                [weakSelf pushViewController:returnGoodsController animated:YES];
                
                
                
                
                
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                    
                    AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                    [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                    
                } failure:^(XMError *error) {
                } queue:nil]];
            };
        } else {
            if (orderInfo.user.userId != [Session sharedInstance].currentUserId) {
                [self.seeLogistics setTitle:@"联系卖家" forState:UIControlStateNormal];
                self.seeLogistics.hidden = NO;
                self.seeLogistics.handleClickBlock = ^(CommandButton *sender){
                    if ([orderInfo goodsList].count>0) {
                        GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:0];
                        //                [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                        [UserSingletonCommand chatWithoutGoodsId:goodsInfo.goodsId];
                    } else {
                        [UserSingletonCommand chatWithUser:orderInfo.sellerId];
                    }
                };
            }else{
                self.seeLogistics.hidden = YES;
            }
        }
        
        if (orderInfo.orderStatus == 0) {
            if (orderInfo.payStatus == 0) {
                if (orderInfo.payWay == PayWayOffline) {
                    
                } else {
                    
                    
                }
            } else if (orderInfo.payStatus == 1) {
                
            } else if (orderInfo.payStatus == 2) {
                
                if (orderInfo.shippingStatus == 0) {
                    if (orderInfo.payWay != PayWayOffline) {
                        if (orderInfo.securedStatus==0) {
                            if (orderInfo.refund_enable || orderInfo.refund_status==1) {
                                if (orderInfo.refund_enable) {
                                    if (orderInfo.tradeType == 4) {
                                        
                                        
                                    } else {
                                        
                                    }
                                    
                                } else if (orderInfo.refund_status==1) {
                                    
                                }
                                
                            } else {
                                
                            }
                            
                        } else {
                            
                        }
                    }
                    //联系卖家、顾问
                } else if (orderInfo.shippingStatus == 1) {
                    
                    
                    NSArray * otherButton = [[NSArray alloc] init];
                    if (orderInfo.sellerId == [Session sharedInstance].currentUserId) {
                        otherButton = @[@"查看物流"];
                    }else{
                        otherButton = @[@"延长收货",@"查看物流"];
                    }
                    
                    if (orderInfo.payWay != PayWayOffline) {
                        [self.bottomBtn setTitle:@"···" forState:UIControlStateNormal];
                        self.bottomBtn.hidden = NO;
                        self.bottomBtn.handleClickBlock = ^(CommandButton *sender) {
                            [UIActionSheet showInView:weakSelf.view
                                            withTitle:nil
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:otherButton
                                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                                 if (orderInfo.sellerId == [Session sharedInstance].currentUserId) {
                                                     if (buttonIndex == 0) {
                                                         NSString *html5Url = kURLLogisticsFormat(orderInfo.orderId);
                                                         LogisticsViewController *viewController = [[LogisticsViewController alloc] init];
                                                         viewController.url = html5Url;
                                                         viewController.mailInfo = weakSelf.mailInfo;
                                                         viewController.orderInfo = orderInfo;
                                                         viewController.title = @"物流信息";
                                                         [weakSelf pushViewController:viewController animated:YES];
                                                     }
                                                     
                                                 }else{
                                                     if (buttonIndex == 0 ) {
                                                         NSString *orderId = orderInfo.orderId;
                                                         weakSelf.request = [[NetworkAPI sharedInstance] tryDelayReceipt:orderId completion:^(NSInteger result, NSString *message) {
                                                             //result:2 , message: 亲，您已经延长过收货时间啦
                                                             //result:0 , message: 确认延长收货时间？\n每笔订单只能延长一次哦
                                                             //result:1 , message: 亲，距离结束时间前3天才可以申请哦
                                                             if (result == 0) {
                                                                 [weakSelf showDelayAlertView:orderId message:message];
                                                             } else {
                                                                 [weakSelf showHUD:message hideAfterDelay:0.8f];
                                                             }
                                                         } failure:^(XMError *error) {
                                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                                         }];
                                                     } else if (buttonIndex==1) {
                                                         NSString *html5Url = kURLLogisticsFormat(orderInfo.orderId);
                                                         LogisticsViewController *viewController = [[LogisticsViewController alloc] init];
                                                         viewController.url = html5Url;
                                                         viewController.mailInfo = weakSelf.mailInfo;
                                                         viewController.orderInfo = orderInfo;
                                                         viewController.title = @"物流信息";
                                                         [weakSelf pushViewController:viewController animated:YES];
                                                     }
                                                 }
                                             }];
                        };
                    }
                    
                    //联系顾问
                }
            }
        } else {
            
        }
        
        NSArray *goodsList = self.orderInfo.goodsList;
        if (goodsList.count > 0) {
            GoodsInfo *goodsInfo = goodsList[0];
            [GoodsService recommend_goods:goodsInfo.goodsId completion:^(NSArray *goods_list) {
                
                NSMutableArray *goodsRecommendList = [[NSMutableArray alloc] init];
                for (NSInteger i=0;i<[goods_list count];i+=2) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:[goods_list objectAtIndex:i]];
                    if (i+1>=[goods_list count]) {
                        [goodsRecommendList addObject:array];
                        break;
                    }
                    [array addObject:[goods_list objectAtIndex:i+1]];
                    [goodsRecommendList addObject:array];
                }
                
                weakSelf.goodsRecommendList = goodsRecommendList;
                [weakSelf loadLikeGoodsCell];
            } failure:^(XMError *error) {
                
            }];
        }
        
        [weakSelf setUpUI];
        [weakSelf reloadData:orderInfo];
    } failure:^(XMError *error) {
        
    } queue:nil]];
}

-(void)reloadData:(OrderInfo *)orderInfo{
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:[OrderStatusCell buildCellDict:self.orderInfo]];
    if (orderInfo.tradeType != 9) {
        [self.dataSources addObject:[OrderAddressCell buildCellDict:self.addressInfo]];
        if (self.orderInfo.message.length > 0) {
            [self.dataSources addObject:[OrderSmallLineCell buildCellDict]];
            [self.dataSources addObject:[OrderMessageCell buildCellDict:self.orderInfo]];
        }
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    }
    
    NSArray *goodsList = self.orderInfo.goodsList;
    //    GoodsInfo *goodsInfo = goodsList[0];
    for (int i = 0; i < goodsList.count; i++) {
        GoodsInfo *goodsInfo = goodsList[i];
        
        if (self.orderInfo.logic_type == NOMALGOODS) {
            if (self.isMysold) {
                [self.dataSources addObject:[OrderGoodsTypeCell buildCellTitle:self.buyer.userName imageName:self.buyer.avatarUrl isHTTP:@1 orderInfo:self.orderInfo]];
            }else{
                [self.dataSources addObject:[OrderGoodsTypeCell buildCellTitle:self.user.userName imageName:self.user.avatarUrl isHTTP:@1 orderInfo:self.orderInfo]];
            }
        } else if (self.orderInfo.logic_type == RETURNGOODS) {
            [self.dataSources addObject:[OrderGoodsTypeCell buildCellTitle:@"原价回购" imageName:@"WristwatchRecovery_GoodsDetail_Icon_Black" isHTTP:@0 orderInfo:self.orderInfo]];
        } else if (self.orderInfo.logic_type == SELFGOODS) {
            [self.dataSources addObject:[OrderGoodsTypeCell buildCellTitle:@"自选商品" imageName:@"Self_Goods" isHTTP:@0 orderInfo:self.orderInfo]];
        }
        
        if (self.orderInfo.logic_type == RETURNGOODS) {
            [self.dataSources addObject:[OrderTabViewCellSmallTwo buildCellDict]];
        }
        [self.dataSources addObject:[OrderGoodsTableViewCell buildCellDict:goodsInfo orderInfo:self.orderInfo]];
        
        for (int i = 0; i < goodsInfo.goodsFittings.count; i++) {
            if (self.orderInfo.logic_type == RETURNGOODS) {
                GoodsFittings *fitting = goodsInfo.goodsFittings[i];
                if (fitting.type == 2) {
                    [self.dataSources addObject:[OrderSmallLineCell buildCellDict]];
                    [self.dataSources addObject:[WristwatchRecoveryDetailCell buildCellDict:fitting]];
                }
            }
        }
        if (goodsInfo.buyBackInfo.length > 0) {
            [self.dataSources addObject:[SepTableViewCell buildCellDict]];
            [self.dataSources addObject:[BuyBackCell buildCellTitle:goodsInfo.buyBackInfo]];
        }
        
        if (goodsInfo.guarantee.iconUrl.length > 0) {
            [self.dataSources addObject:[OrderSmallLineCell buildCellDict]];
            [self.dataSources addObject:[WashIllustrateCell buildCellDict:goodsInfo.guarantee]];
        }
        //        [self.dataSources addObject:[OrderSmallLineCell buildCellDict]];
        //        [self.dataSources addObject:[OrderServiceCell buildCellDictisNeedSelect:NO andShoppingCar:nil]];
    }
    
    
    [self.dataSources addObject:[OrderSmallLineCell buildCellDict]];
    [self.dataSources addObject:[OrderOtherExpenseCell buildCellDict:[NSString stringWithFormat:@"%.2f", self.orderInfo.mail_price] title:@"邮费"]];
    
    for (PayOrderWayVo * payOrderWay in self.orderInfo.payOrderWayList) {
        [self.dataSources addObject:[OrderOtherExpenseCell buildCellDict:[NSString stringWithFormat:@"%@", payOrderWay.priceStr] title:payOrderWay.name]];
    }
    
    [self.dataSources addObject:[OrderSmallLineCell buildCellDict]];
    [self.dataSources addObject:[OrderPriceCell buildCellDict:self.orderInfo]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    [self.dataSources addObject:[OrderTimeCell buildCellDict:nil title:@"订单编号" isCopy:YES orderId:self.orderInfo.orderId]];
    
    if (self.orderInfo.createTime > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.orderInfo.createTime/1000];
        NSString *createStr = [date XMformattedDateDescription];
        [self.dataSources addObject:[OrderTimeCell buildCellDict:nil title:@"创建时间" isCopy:NO orderId:createStr]];
    }
    
    
    NSString *payStr = [[NSString alloc] init];
    if (self.orderInfo.pay_time>0) {
        NSDate *payDate = [NSDate dateWithTimeIntervalSince1970:self.orderInfo.pay_time/1000];
        payStr = [payDate XMformattedDateDescription];
        [self.dataSources addObject:[OrderTimeCell buildCellDict:nil title:@"付款时间" isCopy:NO orderId:payStr]];
    }
    
    
    
    NSString *finishStr = [[NSString alloc] init];
    if (self.orderInfo.finish_time > 0) {
        NSDate *finishDate = [NSDate dateWithTimeIntervalSince1970:self.orderInfo.finish_time/1000];
        finishStr = [finishDate XMformattedDateDescription];
        [self.dataSources addObject:[OrderTimeCell buildCellDict:nil title:@"成交时间" isCopy:NO orderId:finishStr]];
    }
    
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    
    [self loadLikeGoodsCell];
}

-(void)loadLikeGoodsCell{
    if ([self.goodsRecommendList count]>0) {
        [self.dataSources addObject:[GoodsRecommendSepCell buildCellDict]];
        for (NSInteger i=0;i<[self.goodsRecommendList count];i++) {
            
            NSArray *array = [self.goodsRecommendList objectAtIndex:i];
            [self.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
            
            [self.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
        }
    } else {
        [self.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
    }
    [self.tableView reloadData];
}

-(void)setUpUI{
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.seeLogistics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.width.equalTo(@64);
        make.height.equalTo(@24);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.seeLogistics.mas_centerY);
        make.right.equalTo(self.seeLogistics.mas_left).offset(-8);
        make.width.equalTo(@64);
        make.height.equalTo(@24);
    }];
    
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
    
    if ([tableViewCell isKindOfClass:[OrderPriceCell class]]) {
        WEAKSELF;
        
        ((OrderPriceCell*)tableViewCell).handleOrderActionTryDelayBlock = ^(NSString *orderId) {
            
            weakSelf.request = [[NetworkAPI sharedInstance] tryDelayReceipt:orderId completion:^(NSInteger result, NSString *message) {
                //result:2 , message: 亲，您已经延长过收货时间啦
                //result:0 , message: 确认延长收货时间？\n每笔订单只能延长一次哦
                //result:1 , message: 亲，距离结束时间前3天才可以申请哦
                if (result == 0) {
                    [weakSelf showDelayAlertView:orderId message:message];
                } else {
                    [weakSelf showHUD:message hideAfterDelay:0.8f];
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
        ((OrderPriceCell*)tableViewCell).handleOrderActionLogisticsBlock = ^(NSString *orderId) {
            // weakSelf.request = [[NetworkAPI sharedInstance] logistics:orderId completion:^(NSString *html5Url) {
            //            NSString *html5Url = kURLLogisticsFormat(orderId);
            NSString *htmlWuLiuUrl = kURLLogisticsFormat(orderId);
            LogisticsViewController *viewController = [[LogisticsViewController alloc] init];
            viewController.mailInfo = self.mailInfo;
            viewController.url = htmlWuLiuUrl;
            viewController.orderInfo = weakSelf.orderInfo;
            [weakSelf pushViewController:viewController animated:YES];
            //            } failure:^(XMError *error) {
            //                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            //            }];
            
        };
        ((OrderPriceCell*)tableViewCell).handleOrderActionConfirmReceivingBlock = ^(NSString *orderId) {
            
            if (![Session sharedInstance].isBindingPhoneNumber) {
                [WCAlertView showAlertWithTitle:@"温馨提示" message:@"为了保证交易安全，请您绑定手机号，并设置密码" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (buttonIndex==0) {
                        
                    } else {
                        //                        CheckPhoneViewController *presenedViewController = [[CheckPhoneViewController alloc] init];
                        //                        presenedViewController.isForBindPhoneNumber = YES;
                        //                        presenedViewController.title = @"绑定手机号";
                        GetCaptchaCodeViewController *presenedViewController = [[GetCaptchaCodeViewController alloc] init];
                        presenedViewController.title = @"绑定手机号";
                        presenedViewController.isRetry = YES;
                        presenedViewController.captchaType = 4;
                        presenedViewController.index = 4;
                        UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
                        UIViewController *visibleController = [CoordinatingController sharedInstance].visibleController;
                        [visibleController presentViewController:navController animated:YES completion:nil];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            } else {
                [VerifyPasswordView showInView:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
                    [weakSelf showProcessingHUD:nil];
                    
                    [TradeService authConfirmReceived:orderId password:password completion:^(OrderStatusInfo *statusInfo) {
                        [weakSelf hideHUD];
                        
                        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                                OrderInfo *orderInfo = [dict objectForKey:@"orderInfo"];
                                if ([orderInfo.orderId isEqualToString:orderId]) {
                                    [orderInfo updateWithStatusInfo:statusInfo];
                                    break;
                                }
                            }
                        }
                        [weakSelf.tableView reloadData];
                        //                        [weakSelf doCheckStartOrStopTheTimer];
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                    //                [AuthService validatePassword:password completion:^{
                    //                    weakSelf.request = [[NetworkAPI sharedInstance] confirmReceived:orderId completion:^(NSDictionary *statusInfoDict) {
                    //                        [weakSelf hideHUD];
                    //
                    //                        OrderStatusInfo *orderStatusInfo = [OrderStatusInfo createWithDict:statusInfoDict];
                    //                        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                    //                            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                    //                            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    //                                OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                    //                                if ([orderInfo.orderId isEqualToString:orderStatusInfo.orderId]) {
                    //                                    [orderInfo updateWithStatusInfo:orderStatusInfo];
                    //                                    break;
                    //                                }
                    //                            }
                    //                        }
                    //                        [weakSelf.tableView reloadData];
                    //                    } failure:^(XMError *error) {
                    //                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    //                    }];
                    //
                    //                } failure:^(XMError *error) {
                    //                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    //                }];
                }];
            }
            
        };
        ((OrderPriceCell*)tableViewCell).handleOrderActionPayBlock = ^(NSString *orderId, NSInteger payWay, OrderInfo *orderInfo) {
            //线下洗护订单
            if (orderInfo.tradeType == 9) {
                ScanCodePaymentViewController *viewController = [[ScanCodePaymentViewController alloc] init];
                viewController.orderId = orderId;
                viewController.payWay = payWay;
                viewController.orderInfo = orderInfo;
                viewController.isFromOrder = YES;
                viewController.topBarTitle = orderInfo.buyer.userName;
                [weakSelf pushViewController:viewController animated:YES];
                return ;
            }
            
            weakSelf.partialDo.surplusPriceNum = orderInfo.remain_price;
            weakSelf.partialDo.payWays = weakSelf.payWays;
            weakSelf.partialDo.payType = payWay;
            weakSelf.partialDo.orderId = orderId;
            weakSelf.partialDo.orderInfo = orderInfo;
            weakSelf.partialDo.avaMoneyCent = weakSelf.available_money_cent;
            if (orderInfo.payStatus == 1) {
                if (payWay == PayWayPartial) {
                    
                    [weakSelf showPartialView];
                    
                } else {
                    if (orderId && [orderId length]>0) {
                        weakSelf.is_partial_pay = 0;
                        NSMutableArray *orderIds = [[NSMutableArray alloc] init];
                        [orderIds addObject:orderId];
                        [weakSelf doPayOrderList:@[orderId] payWay:payWay orderInfo:orderInfo];
                    }
                }
            } else {
                if (orderId && [orderId length]>0) {
                    weakSelf.is_partial_pay = 0;
                    NSMutableArray *orderIds = [[NSMutableArray alloc] init];
                    [orderIds addObject:orderId];
                    [weakSelf doPayOrderList:@[orderId] payWay:payWay orderInfo:orderInfo];
                }
            }
        };
        
        ((OrderPriceCell*)tableViewCell).handleOrderActionChatBlock = ^(NSInteger userId,OrderInfo *orderInfo, NSInteger isConsultant) {
            if (isConsultant == 1) {
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                    
                    AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                    [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                    
                } failure:^(XMError *error) {
                    
                    if ([orderInfo goodsList].count>0) {
                        GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:0];
                        //                [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                        [UserSingletonCommand chatWithoutGoodsId:goodsInfo.goodsId];
                    } else {
                        [UserSingletonCommand chatWithUser:orderInfo.sellerId];
                    }
                    
                } queue:nil]];
            } else {
                if ([orderInfo goodsList].count>0) {
                    GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:0];
                    //                [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                    [UserSingletonCommand chatWithoutGoodsId:goodsInfo.goodsId];
                } else {
                    [UserSingletonCommand chatWithUser:userId];
                }
            }
        };
        
        ((OrderPriceCell *)tableViewCell).handleOrderBuyerActionChatBlock = ^(NSInteger userId,OrderInfo *orderInfo) {
            [UserSingletonCommand chatWithUser:orderInfo.buyerId];
        };
        
        ((OrderPriceCell*)tableViewCell).handleOrderActionRemindShippingGoodsBlock = ^(OrderInfo *orderInfo) {
            [weakSelf showProcessingHUD:nil];
            [TradeService remind_deliver:orderInfo.orderId completion:^(NSInteger result, NSString *message) {
                [weakSelf showHUD:message hideAfterDelay:1.2];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
            }];
        };
        ((OrderPriceCell*)tableViewCell).handleOrderActionSendBlock = ^(OrderInfo *orderInfo){
            //我要发货
            [weakSelf handleOrderActionSendBlock:orderInfo];
        };
        ((OrderPriceCell*)tableViewCell).handleOrderActionMoreBlock = ^(OrderInfo *orderInfo, NSInteger type) {
            if (type==1) {
                //关闭交易，付款遇到问题，取消
                [UIActionSheet showInView:weakSelf.view
                                withTitle:nil
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:[NSArray arrayWithObjects:@"关闭交易", @"付款遇到问题",nil]
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     if (buttonIndex == 0 ) {
                                         
                                         [WCAlertView showAlertWithTitle:@""
                                                                 message:@"确认关闭该订单？"
                                                      customizationBlock:^(WCAlertView *alertView) {
                                                          alertView.style = WCAlertViewStyleWhite;
                                                      } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                                          if (buttonIndex == 0) {
                                                              
                                                          } else {
                                                              NSString *orderId = orderInfo.orderId;
                                                              [weakSelf showProcessingHUD:nil];
                                                              [TradeService cancel_order:orderId completion:^(OrderStatusInfo *statusInfo) {
                                                                  [weakSelf hideHUD];
                                                                  
                                                                  for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                                                                      NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                                                                      if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                                                                          OrderInfo *orderInfo = [dict objectForKey:@"orderInfo"];
                                                                          if ([orderInfo.orderId isEqualToString:orderId]) {
                                                                              [orderInfo updateWithStatusInfo:statusInfo];
                                                                              break;
                                                                          }
                                                                      }
                                                                  }
                                                                  [weakSelf.tableView reloadData];
                                                                  
                                                                  //                                                                  [weakSelf doCheckStartOrStopTheTimer];
                                                                  
                                                              } failure:^(XMError *error) {
                                                                  [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                                              }];
                                                          }
                                                      } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                         
                                     } else if (buttonIndex==1) {
                                         NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                     }
                                 }];
                
            }
            else if (type==2) {
                //延长收货，查看物流，取消
                WEAKSELF;
                [UIActionSheet showInView:weakSelf.view
                                withTitle:nil
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:[NSArray arrayWithObjects:@"延长收货", @"查看物流",nil]
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     if (buttonIndex == 0 ) {
                                         NSString *orderId = orderInfo.orderId;
                                         weakSelf.request = [[NetworkAPI sharedInstance] tryDelayReceipt:orderId completion:^(NSInteger result, NSString *message) {
                                             //result:2 , message: 亲，您已经延长过收货时间啦
                                             //result:0 , message: 确认延长收货时间？\n每笔订单只能延长一次哦
                                             //result:1 , message: 亲，距离结束时间前3天才可以申请哦
                                             if (result == 0) {
                                                 [weakSelf showDelayAlertView:orderId message:message];
                                             } else {
                                                 [weakSelf showHUD:message hideAfterDelay:0.8f];
                                             }
                                         } failure:^(XMError *error) {
                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                         }];
                                     } else if (buttonIndex==1) {
                                         NSString *html5Url = kURLLogisticsFormat(orderInfo.orderId);
                                         LogisticsViewController *viewController = [[LogisticsViewController alloc] init];
                                         viewController.url = html5Url;
                                         viewController.mailInfo = self.mailInfo;
                                         viewController.orderInfo = self.orderInfo;
                                         [weakSelf pushViewController:viewController animated:YES];
                                     }
                                 }];
            }
        };
        
        ((OrderPriceCell*)tableViewCell).handleOrderActionApplyRefundBlock = ^(OrderInfo *orderInfo) {
            //            [WCAlertView showAlertWithTitle:@"提示" message:@"请到列表页进行操作" customizationBlock:^(WCAlertView *alertView) {
            //
            //            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            //
            //                if (buttonIndex == 0) {
            //                    [weakSelf dismiss];
            //                }
            //
            //            } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [UIActionSheet showInView:weakSelf.view
                            withTitle:nil
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:[NSArray arrayWithObjects:@"卖家缺货", @"卖家迟迟不发货",@"其他原因",nil]
                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex==3) {
                                     
                                 } else {
                                     NSInteger reason = 0;
                                     if (buttonIndex==0) reason=1;
                                     if (buttonIndex==1) reason=2;
                                     
                                     [weakSelf showProcessingHUD:nil];
                                     [TradeService apply_refund:orderInfo.orderId reason:[NSString stringWithFormat:@"%ld",(long)reason] completion:^(OrderInfo *order_info) {
                                         [weakSelf hideHUD];
                                         //                                         SEL selector = @selector($$handleApplyRefundNotification:order_info:);
                                         //                                         MBGlobalSendNotificationForSELWithBody(selector, order_info);
                                         [weakSelf showHUD:@"操作成功" hideAfterDelay:0.8];
                                         [weakSelf dismiss];
                                     } failure:^(XMError *error) {
                                         [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                     }];
                                 }
                             }];
        };
        
        ((OrderPriceCell*)tableViewCell).handleOrderActionCancelRefundBlock = ^(OrderInfo *orderInfo) {
            [WCAlertView showAlertWithTitle:@"确认撤销退款?" message:@"撤销之后不能再次申请!" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==0) {
                    
                } else {
                    [weakSelf showProcessingHUD:nil];
                    [TradeService cancel_refund:orderInfo.orderId completion:^(OrderInfo *order_info) {
                        [weakSelf hideHUD];
                        [weakSelf showHUD:@"撤销成功" hideAfterDelay:0.8];
                        [weakSelf dismiss];
                        //                            SEL selector = @selector($$handleCancelRefundNotification:order_info:);
                        //                            MBGlobalSendNotificationForSELWithBody(selector, order_info);
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            
        };
        
        
        //联系客服
        ((OrderPriceCell*)tableViewCell).handleOrderActionServiceBlock = ^(OrderInfo *orderInfo){
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"em_user" parameters:nil completionBlock:^(NSDictionary *data) {
                EMAccount *emAccount = [[EMAccount alloc] initWithDict:data[@"emUser"]];
                [[Session sharedInstance] setUserKEFUEMAccount:emAccount];
                [UserSingletonCommand chatWithGroup:emAccount isShowDownTime:YES message:@"亲爱的，有什么可以帮您？" isKefu:YES];
            } failure:^(XMError *error) {
                
            } queue:nil]];
        };
        
        //申请退货
        ((OrderPriceCell*)tableViewCell).handleOrderActionrefundGoods = ^(OrderInfo *orderInfo){
            ProtocolViewController * protocol = [[ProtocolViewController alloc] init];
            protocol.orderID = weakSelf.orderId;
            protocol.type = @"0";
            [weakSelf pushViewController:protocol animated:YES];
            
        };
        
        //退货进度
        ((OrderPriceCell*)tableViewCell).handleOrderActionrefundGoodsProgress = ^(OrderInfo *orderInfo){
            ProgressQueryViewController * pq = [[ProgressQueryViewController alloc] init];
            pq.orderID = self.orderId;
            pq.orderInfo = self.orderInfo;
            [self.navigationController pushViewController:pq animated:YES];
        };
        
        
        //申请回购
        ((OrderPriceCell*)tableViewCell).handleOrderActionApplyReturn = ^(OrderInfo *orderInfo){
            ProtocolViewController * protocol = [[ProtocolViewController alloc] init];
            protocol.orderID = weakSelf.orderId;
            protocol.type = @"1";
            [weakSelf pushViewController:protocol animated:YES];
            
        };
        
        ((OrderPriceCell *)tableViewCell).handleQuestionBlock = ^(OrderInfo *orderInfo){
            [[CoordinatingController sharedInstance].visibleController.view addSubview:weakSelf.tipBgView];
            [[CoordinatingController sharedInstance].visibleController.view addSubview:weakSelf.tipView];
            [weakSelf.tipView getOrderInfo:orderInfo];
            
            weakSelf.tipBgView.alpha = 0;
            weakSelf.tipView.alpha = 0;
            
            weakSelf.tipBgView.frame = [UIScreen mainScreen].bounds;
            weakSelf.tipView.frame = CGRectMake(30, (kScreenHeight-250)/2, kScreenWidth-60, 250);
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.tipBgView.alpha = 0.7;
                weakSelf.tipView.alpha = 1;
            }];
            
            weakSelf.tipBgView.dissMissBlackView = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.tipView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.tipView removeFromSuperview];
                    weakSelf.tipView = nil;
                }];
            };
            
            weakSelf.tipView.handleDisButton = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.tipView.alpha = 0;
                    weakSelf.tipBgView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.tipView removeFromSuperview];
                    [weakSelf.tipBgView removeFromSuperview];
                    weakSelf.tipBgView = nil;
                    weakSelf.tipView = nil;
                }];
            };
            
        };
        
        //回购进度
        ((OrderPriceCell*)tableViewCell).handleOrderActionApplyProgress = ^(OrderInfo *orderInfo){
            ProgressQueryViewController * pq = [[ProgressQueryViewController alloc] init];
            pq.orderID = self.orderId;
            pq.orderInfo = self.orderInfo;
            [self.navigationController pushViewController:pq animated:YES];
        };
    }
    
    if ([tableViewCell isKindOfClass:[BuyBackCell class]]) {
        BuyBackCell * buyBackCell = (BuyBackCell *)tableViewCell;
        buyBackCell.rtLabelSelect = ^(NSURL * url){
            
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = [url absoluteString];
            viewController.title = @"原价回购标准";
            [self pushViewController:viewController animated:YES];
        };
    }
    
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

//- (void)$$handleApplyRefundNotification:(id<MBNotification>)notifi order_info:(OrderInfo*)order_info
//{
//    WEAKSELF;
//    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
//        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
//        if ([dict isKindOfClass:[NSMutableDictionary class]]) {
//            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
//            if ([orderInfo.orderId isEqualToString:order_info.orderId]) {
//                [dict setObject:order_info forKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
//                break;
//            }
//        }
//    }
//    [weakSelf.tableView reloadData];
//
////    [self doCheckStartOrStopTheTimer];
//}
//
//- (void)$$handleCancelRefundNotification:(id<MBNotification>)notifi order_info:(OrderInfo*)order_info
//{
//    [self $$handleApplyRefundNotification:notifi order_info:order_info];
//}

- (void)handleOrderActionSendBlock:(OrderInfo*)orderInfo
{
    WEAKSELF;
    [weakSelf showProcessingHUD:nil];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
        
        if ([addressDictList count]>0) {
            if (weakSelf.mailTypeList == nil || [weakSelf.mailTypeList count]==0) {
                [TradeService listAllExpress:orderInfo.orderId completion:^(NSArray *mailTypeList, AddressInfo *addressInfo) {
                    [weakSelf hideHUD];
                    [DeliverInfoEditView showInView:weakSelf.view isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService sendToAudit:orderInfo.orderId mailSN:mailSN mailType:mailType completion:^(OrderStatusInfo *statusInfo){
                                if ([self.orderInfo.orderId isEqualToString:orderInfo.orderId]) {
                                    [self.orderInfo updateWithStatusInfo:statusInfo];
                                }
                                [weakSelf.tableView reloadData];
                                
                                //                                [weakSelf doCheckStartOrStopTheTimer];
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
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            } else {
                [weakSelf hideHUD];
                [DeliverInfoEditView showInView:weakSelf.view isSecuredTrade:YES mailTypeList:_mailTypeList addressInfo:_addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                    
                    if ([mailSN length]>0 && [mailType length]>0) {
                        [TradeService sendToAudit:orderInfo.orderId mailSN:mailSN mailType:mailType completion:^(OrderStatusInfo *statusInfo){
                            if ([self.orderInfo.orderId isEqualToString:orderInfo.orderId]) {
                                [self.orderInfo updateWithStatusInfo:statusInfo];
                            }
                            [weakSelf.tableView reloadData];
                            
                            //                            [weakSelf doCheckStartOrStopTheTimer];
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
            if (orderInfo.tradeType != 4) {//购买鉴定的服务,退货地址就 取用户提交订单时所选的那个地址。不需要选择退货地址
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
            }else{
                [TradeService listAllExpress:orderInfo.orderId completion:^(NSArray *mailTypeList, AddressInfo *addressInfo) {
                    [weakSelf hideHUD];
                    [DeliverInfoEditView showInView:weakSelf.view isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService sendToAudit:orderInfo.orderId mailSN:mailSN mailType:mailType completion:^(OrderStatusInfo *statusInfo){
                                if ([self.orderInfo.orderId isEqualToString:orderInfo.orderId]) {
                                    [self.orderInfo updateWithStatusInfo:statusInfo];
                                }
                                [weakSelf.tableView reloadData];
                                
                                //                                [weakSelf doCheckStartOrStopTheTimer];
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
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            }
            
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
    }]];
}


- (void)listXihuCardByOrderList:(NSArray*)orderIds
                        bonusId:(NSString *)bonusId
               isUseRewardMoney:(NSInteger)isUseRewardMoney
                     completion:(void (^)(NSArray *xihuCardArr))completion
                        failure:(void (^)(XMError *error))failure {
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] listXiHuCardByOrderList:orderIds bonusId:bonusId isUseRewardMoney:isUseRewardMoney completion:^(NSArray *itemList) {
        NSMutableArray *xihuCardArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in itemList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [xihuCardArr addObject:[[AccountCard alloc] initWithJSONDictionary:dict]];
            }
        }
        if (completion)completion(xihuCardArr);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }]];
}

- (void)listAvailableBonusByOrderList:(NSArray*)orderIds
                           completion:(void (^)(NSArray *quanItemsArray))completion
                              failure:(void (^)(XMError *error))failure {
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] listAvailableBonusByOrderList:orderIds completion:^(NSArray *itemList) {
        NSMutableArray *quanItemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in itemList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [quanItemsArray addObject:[BonusInfo createWithDict:dict]];
            }
        }
        if (completion)completion(quanItemsArray);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }]];
}

- (void)doPayOrderList:(NSArray*)orderIds payWay:(PayWayType)payWay orderInfo:(OrderInfo *)orderInfo{
    WEAKSELF;
    NSInteger totalPriceCent = 0;
    totalPriceCent += [orderInfo remain_price]*100;
    
    [weakSelf showProcessingHUD:nil];
    if (orderInfo.payStatus == 1) {//分次支付
        
        [UserService get_account:^(NSInteger reward_money_cent, NSInteger available_money_cent) {
            [weakSelf listAvailableBonusByOrderList:orderIds completion:^(NSArray *quanItemsArray) {
                NSInteger isUseReward = 0;
                if (reward_money_cent > 0) {
                    isUseReward = 1;
                } else {
                    isUseReward = 0;
                }
                
                BonusInfo *bonusInfo = [[BonusInfo alloc] init];
                for (int i = 0 ; i < quanItemsArray.count; i++) {
                    BonusInfo *info = quanItemsArray[i];
                    if (bonusInfo.amountCent > info.amountCent) {
                        
                    } else {
                        bonusInfo = info;
                    }
                    //                    self.seletedBonusInfo = bonusInfo;
                }
                
                [weakSelf listXihuCardByOrderList:orderIds bonusId:bonusInfo.bonusId isUseRewardMoney:isUseReward completion:^(NSArray *xihuCardArr) {
                    
                    [weakSelf hideHUD];
                    
                    NSInteger index = 0;
                    if (orderInfo.tradeType == 5) {
                        index = 1;
                    }
                    NSLog(@"%ld", (long)index);
                    [ChoosePayWayView showInView:[CoordinatingController sharedInstance].visibleController.view totalPriceCent:totalPriceCent payWayDOArray:weakSelf.payWays payWay:(PayWayType)payWay index:index reward_money_cent:reward_money_cent available_money_cent:available_money_cent quanItemsArray:quanItemsArray xihuCardArray:xihuCardArr is_partial_pay:1 partialDo:weakSelf.partialDo completionBlock:^(PayWayType payWay, BOOL is_used_reward_money, BOOL is_used_adm_money, BonusInfo *seletedBonusInfo, AccountCard *accountCard,NSInteger deterIndex, NSInteger index) {
                        
                        //分次支付第二次支付
                        accountCard = nil;
                        seletedBonusInfo = nil;
                        
                        if (payWay == PayWayWxpay && ![WXApi isWXAppInstalled]) {
                            [self showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
                        } else {
                            
                            NSInteger realTotalPriceCent = totalPriceCent;
                            //1. 先判断优惠券
                            //                            if (seletedBonusInfo) {
                            //                                realTotalPriceCent = realTotalPriceCent-seletedBonusInfo.amountCent;
                            //                                if (realTotalPriceCent<0)realTotalPriceCent=0;
                            //                                //                            weakSelf.partialDo.surplusPriceNum = realTotalPriceCent;
                            //                            }
                            //优惠券
                            if (seletedBonusInfo) {
                                if ([seletedBonusInfo.bonusId isEqualToString:@"-1000"]) {
                                    seletedBonusInfo = nil;
                                } else {
                                    realTotalPriceCent = realTotalPriceCent-seletedBonusInfo.amountCent;
                                    if (realTotalPriceCent<0)realTotalPriceCent=0;
                                }
                            }
                            //优惠卡
                            if (accountCard) {
                                if (accountCard.cardType == -1000) {
                                    accountCard = nil;
                                } else {
                                    realTotalPriceCent = realTotalPriceCent-accountCard.cardCanPayMoney*100;
                                    if (realTotalPriceCent<0)realTotalPriceCent=0;
                                }
                            }
                            //2. 奖金抵用
                            if (is_used_reward_money && realTotalPriceCent>0) {
                                realTotalPriceCent = realTotalPriceCent-reward_money_cent;
                                if (realTotalPriceCent<0)realTotalPriceCent=0;
                                //                            weakSelf.partialDo.surplusPriceNum = realTotalPriceCent;
                            }
                            //3. 余额
                            if (weakSelf.partialDo.payType == PayWayAdmMoney && realTotalPriceCent>0) {
                                realTotalPriceCent = realTotalPriceCent-available_money_cent;
                                if (realTotalPriceCent<0)realTotalPriceCent=0;
                                //                            weakSelf.partialDo.surplusPriceNum = realTotalPriceCent;
                            }
                            
                            //                        [weakSelf.partialView getPartialDo:self.partialDo];
                            
                            void(^payOrderListBlock)() = ^() {
                                weakSelf.request = [[NetworkAPI sharedInstance] payOrderList:orderIds payWay:weakSelf.partialDo.payType bonus:seletedBonusInfo?seletedBonusInfo.bonusId:@"" accountCard:accountCard deterIndex:deterIndex is_used_reward_money:0 is_used_adm_money:0 is_partial_pay:1 partial_pay_amount:weakSelf.payPrice completion:^(NSString *payUrl,PayReq *payReq,NSString *upPayTn,PayZhaoHangReg *payZHReg) {
                                    [weakSelf hideHUD];
                                    NSLog(@"%ld", (long)deterIndex);
                                    BOOL handled = NO;
                                    if (payWay == PayWayOffline) {
                                        
                                    } else if(payWay == PayWayAlipay && payUrl && [payUrl length]>0) {
                                        handled = YES;
                                        
                                        [PayManager pay:payUrl orderIds: orderIds];
                                    } else if (payWay == PayWayWxpay && payReq) {
                                        handled = YES;
                                        [PayManager weixinPay:payReq orderIds: orderIds];
                                    } else if (payWay == PayWayUpay && upPayTn && [upPayTn length] > 0) {
                                        handled = YES;
                                        //                        [UPPayPlugin startPay:upPayTn mode:kMode_Development viewController:self delegate:self];
                                        [PayManager uppay:upPayTn orderIds: orderIds];
                                    } else if (payWay == PayWayFenQiLe && payUrl && [payUrl length]>0) {
                                        handled = YES;
                                        [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:orderIds];
                                    } else if (payWay == PayWayZhaoH && payZHReg) {
                                        handled = YES;
                                        NSString *payZHUrl = [NSString stringWithFormat:@"%@%@?BranchID=%@&CoNo=%@&BillNo=%@&Amount=%@&Date=%@&ExpireTimeSpan=%@&MerchantUrl=%@&MerchantPara=%@&MerchantCode=%@&MerchantRetUrl=%@&MerchantRetPara=%@", payZHReg.pay_url, payZHReg.MfcISAPICommand, payZHReg.BranchID, payZHReg.CoNo, payZHReg.BillNo, payZHReg.Amount, payZHReg.Date, payZHReg.ExpireTimeSpan, payZHReg.MerchantUrl, payZHReg.MerchantPara, payZHReg.MerchantCode, payZHReg.MerchantRetUrl, payZHReg.MerchantRetPara];
                                        NSString * newUrl = [payZHUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                        NSLog(@"%@", newUrl);
                                        [FenQiLePayViewController presentFenQiLePay:newUrl orderIds:nil];
                                    } else if (payWay == PayWayTransfer) {
                                        [weakSelf showTipView:orderInfo];
                                        return ;
                                    }
                                    
                                    if (!handled) {
                                        [weakSelf $$handlePayResultCompletionNotification:nil orderIds:orderIds];
                                    }
                                    
                                } failure:^(XMError *error) {
                                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                }];
                            };
                            
                            if (realTotalPriceCent==0 && payWay!=PayWayOffline) {//(realTotalPriceCent==0 && payway!=PayWayOffline) || (
                                WEAKSELF;
                                if ([[Session sharedInstance] isBindingPhoneNumber]) {
                                    [VerifyPasswordView showInViewMF:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
                                        [weakSelf showProcessingHUD:nil];
                                        [AuthService validatePassword:password completion:^{
                                            payOrderListBlock();
                                        } failure:^(XMError *error) {
                                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                        }];
                                    }];
                                } else {
                                    [WCAlertView showAlertWithTitle:@""
                                                            message:@"确认付款？"
                                                 customizationBlock:^(WCAlertView *alertView) {
                                                     alertView.style = WCAlertViewStyleWhite;
                                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                                     if (buttonIndex == 0) {
                                                         
                                                     } else {
                                                         payOrderListBlock();
                                                     }
                                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                                }
                            } else {
                                [weakSelf showProcessingHUD:nil];
                                payOrderListBlock();
                            }
                        }
                    }];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
            
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        }];
        
    } else {
        [UserService get_account:^(NSInteger reward_money_cent, NSInteger available_money_cent) {
            [weakSelf listAvailableBonusByOrderList:orderIds completion:^(NSArray *quanItemsArray) {
                
                NSInteger isUseReward = 0;
                if (reward_money_cent > 0) {
                    isUseReward = 1;
                } else {
                    isUseReward = 0;
                }
                
                BonusInfo *bonusInfo = [[BonusInfo alloc] init];
                for (int i = 0 ; i < quanItemsArray.count; i++) {
                    BonusInfo *info = quanItemsArray[i];
                    if (bonusInfo.amountCent > info.amountCent) {
                        
                    } else {
                        bonusInfo = info;
                    }
                    //                    self.seletedBonusInfo = bonusInfo;
                }
                
                [weakSelf listXihuCardByOrderList:orderIds bonusId:bonusInfo.bonusId isUseRewardMoney:isUseReward completion:^(NSArray *xihuCardArr) {
                    
                    NSInteger index = 0;
                    if (orderInfo.tradeType == 5) {
                        index = 1;
                    }
                    [TradeService pay_ways:[NSNumber numberWithDouble:orderInfo.totalPrice] completion:^(NSArray *payWays) {
                        [weakSelf hideHUD];
                        weakSelf.payWays = payWays;
                        //                        weakSelf.partialDo.payWays = payWays;
                    } failure:^(XMError *error) {
                        
                    }];
                    NSLog(@"%ld", (long)index);
                    [ChoosePayWayView showInView:[CoordinatingController sharedInstance].visibleController.view totalPriceCent:totalPriceCent payWayDOArray:weakSelf.payWays payWay:(PayWayType)payWay index:index reward_money_cent:reward_money_cent available_money_cent:available_money_cent quanItemsArray:quanItemsArray xihuCardArray:xihuCardArr is_partial_pay:weakSelf.is_partial_pay partialDo:weakSelf.partialDo completionBlock:^(NSInteger payWay, BOOL is_used_reward_money, BOOL is_used_adm_money, BonusInfo *seletedBonusInfo, AccountCard *accountCard,NSInteger deterIndex, NSInteger index) {
                        
                        if (payWay == PayWayWxpay && ![WXApi isWXAppInstalled]) {
                            [self showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
                        } else {
                            
                            NSInteger realTotalPriceCent = totalPriceCent;
                            //优惠券
                            if (seletedBonusInfo) {
                                if ([seletedBonusInfo.bonusId isEqualToString:@"-1000"]) {
                                    seletedBonusInfo = nil;
                                } else {
                                    realTotalPriceCent = realTotalPriceCent-seletedBonusInfo.amountCent;
                                    if (realTotalPriceCent<0)realTotalPriceCent=0;
                                }
                            }
                            //优惠卡
                            if (accountCard) {
                                if (accountCard.cardType == -1000) {
                                    accountCard = nil;
                                } else {
                                    realTotalPriceCent = realTotalPriceCent-accountCard.cardCanPayMoney*100;
                                    if (realTotalPriceCent<0)realTotalPriceCent=0;
                                }
                            }
                            //2. 奖金抵用
                            if (is_used_reward_money && realTotalPriceCent>0) {
                                realTotalPriceCent = realTotalPriceCent-reward_money_cent;
                                if (realTotalPriceCent<0)realTotalPriceCent=0;
                                //                            weakSelf.partialDo.surplusPriceNum = realTotalPriceCent;
                            }
                            //3. 余额
                            if (payWay == PayWayAdmMoney && realTotalPriceCent>0) {//weakSelf.partialDo.payType
                                realTotalPriceCent = realTotalPriceCent-available_money_cent;
                                if (realTotalPriceCent<0)realTotalPriceCent=0;
                                //                            weakSelf.partialDo.surplusPriceNum = realTotalPriceCent;
                            }
                            
                            //                        [weakSelf.partialView getPartialDo:self.partialDo];
                            
                            
                            if (weakSelf.is_partial_pay == 1) {
                                seletedBonusInfo = weakSelf.cancelBonusInfo;
                                accountCard = weakSelf.cancelAccountCard;
                            }
                            void(^payOrderListBlock)() = ^() {
                                if (self.is_partial_pay==1) {
                                    [ChoosePayWayView getBonusInfoAndAccountCard:nil totalPriceCent:totalPriceCent payWayDOArray:weakSelf.payWays payWay:(PayWayType)payWay index:index reward_money_cent:reward_money_cent available_money_cent:available_money_cent quanItemsArray:quanItemsArray xihuCardArray:xihuCardArr is_partial_pay:weakSelf.is_partial_pay partialDo:weakSelf.partialDo completionBlock:^(NSInteger payWay1, BOOL is_used_reward_money1, BOOL is_used_adm_money1, BonusInfo *seletedBonusInfo1, AccountCard *accountCard1,NSInteger deterIndex1, NSInteger index1) {
                                        
                                        weakSelf.request = [[NetworkAPI sharedInstance] payOrderList:orderIds payWay:payWay bonus:seletedBonusInfo1?seletedBonusInfo1.bonusId:@""  accountCard:accountCard1 deterIndex:deterIndex is_used_reward_money:is_used_reward_money is_used_adm_money:is_used_adm_money is_partial_pay:weakSelf.is_partial_pay partial_pay_amount:weakSelf.payPrice completion:^(NSString *payUrl,PayReq *payReq,NSString *upPayTn,PayZhaoHangReg *payZHReg) {
                                            [weakSelf hideHUD];
                                            
                                            if (payWay == 20) {
                                                [weakSelf showPartialView];
                                                return ;
                                            }
                                            
                                            NSLog(@"%ld", deterIndex);
                                            BOOL handled = NO;
                                            if (payWay == PayWayOffline) {
                                                
                                            } else if(payWay == PayWayAlipay && payUrl && [payUrl length]>0) {
                                                handled = YES;
                                                [PayManager pay:payUrl orderIds: orderIds];
                                            } else if (payWay == PayWayWxpay && payReq) {
                                                handled = YES;
                                                BOOL isSuc = [PayManager weixinPay:payReq orderIds: orderIds];
                                                if (isSuc) {
                                                    [self showPaySuccess:orderInfo];
                                                }
                                            } else if (payWay == PayWayUpay && upPayTn && [upPayTn length] > 0) {
                                                handled = YES;
                                                //                        [UPPayPlugin startPay:upPayTn mode:kMode_Development viewController:self delegate:self];
                                                [PayManager uppay:upPayTn orderIds: orderIds];
                                            } else if (payWay == PayWayFenQiLe && payUrl && [payUrl length]>0) {
                                                handled = YES;
                                                [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:orderIds];
                                            } else if (payWay == PayWayZhaoH && payZHReg) {
                                                handled = YES;
                                                NSString *payZHUrl = [NSString stringWithFormat:@"%@%@?BranchID=%@&CoNo=%@&BillNo=%@&Amount=%@&Date=%@&ExpireTimeSpan=%@&MerchantUrl=%@&MerchantPara=%@&MerchantCode=%@&MerchantRetUrl=%@&MerchantRetPara=%@", payZHReg.pay_url, payZHReg.MfcISAPICommand, payZHReg.BranchID, payZHReg.CoNo, payZHReg.BillNo, payZHReg.Amount, payZHReg.Date, payZHReg.ExpireTimeSpan, payZHReg.MerchantUrl, payZHReg.MerchantPara, payZHReg.MerchantCode, payZHReg.MerchantRetUrl, payZHReg.MerchantRetPara];
                                                NSString * newUrl = [payZHUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                NSLog(@"%@", newUrl);
                                                [FenQiLePayViewController presentFenQiLePay:newUrl orderIds:nil];
                                            } else if (payWay == PayWayTransfer) {
                                                [weakSelf showTipView:orderInfo];
                                                return ;
                                            }
                                            
                                            if (!handled) {
                                                [weakSelf $$handlePayResultCompletionNotification:nil orderIds:orderIds];
                                            }
                                            
                                        } failure:^(XMError *error) {
                                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                        }];
                                        
                                    }];
                                } else {
                                    weakSelf.request = [[NetworkAPI sharedInstance] payOrderList:orderIds payWay:payWay bonus:seletedBonusInfo?seletedBonusInfo.bonusId:@""  accountCard:accountCard deterIndex:deterIndex is_used_reward_money:is_used_reward_money is_used_adm_money:is_used_adm_money is_partial_pay:weakSelf.is_partial_pay partial_pay_amount:weakSelf.payPrice completion:^(NSString *payUrl,PayReq *payReq,NSString *upPayTn,PayZhaoHangReg *payZHReg) {
                                        [weakSelf hideHUD];
                                        
                                        if (payWay == 20) {
                                            [weakSelf showPartialView];
                                            return ;
                                        }
                                        
                                        NSLog(@"%ld", deterIndex);
                                        BOOL handled = NO;
                                        if (payWay == PayWayOffline) {
                                            
                                        } else if(payWay == PayWayAlipay && payUrl && [payUrl length]>0) {
                                            handled = YES;
                                            [PayManager pay:payUrl orderIds: orderIds];
                                        } else if (payWay == PayWayWxpay && payReq) {
                                            handled = YES;
                                            BOOL isSuc = [PayManager weixinPay:payReq orderIds: orderIds];
                                            if (isSuc) {
                                                [self showPaySuccess:orderInfo];
                                            }
                                        } else if (payWay == PayWayUpay && upPayTn && [upPayTn length] > 0) {
                                            handled = YES;
                                            //                        [UPPayPlugin startPay:upPayTn mode:kMode_Development viewController:self delegate:self];
                                            [PayManager uppay:upPayTn orderIds: orderIds];
                                        } else if (payWay == PayWayFenQiLe && payUrl && [payUrl length]>0) {
                                            handled = YES;
                                            [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:orderIds];
                                        } else if (payWay == PayWayZhaoH && payZHReg) {
                                            handled = YES;
                                            NSString *payZHUrl = [NSString stringWithFormat:@"%@%@?BranchID=%@&CoNo=%@&BillNo=%@&Amount=%@&Date=%@&ExpireTimeSpan=%@&MerchantUrl=%@&MerchantPara=%@&MerchantCode=%@&MerchantRetUrl=%@&MerchantRetPara=%@", payZHReg.pay_url, payZHReg.MfcISAPICommand, payZHReg.BranchID, payZHReg.CoNo, payZHReg.BillNo, payZHReg.Amount, payZHReg.Date, payZHReg.ExpireTimeSpan, payZHReg.MerchantUrl, payZHReg.MerchantPara, payZHReg.MerchantCode, payZHReg.MerchantRetUrl, payZHReg.MerchantRetPara];
                                            NSString * newUrl = [payZHUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                            NSLog(@"%@", newUrl);
                                            [FenQiLePayViewController presentFenQiLePay:newUrl orderIds:nil];
                                        } else if (payWay == PayWayTransfer) {
                                            [weakSelf showTipView:orderInfo];
                                            return ;
                                        }
                                        
                                        if (!handled) {
                                            [weakSelf $$handlePayResultCompletionNotification:nil orderIds:orderIds];
                                        }
                                        
                                    } failure:^(XMError *error) {
                                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                    }];
                                }
                            };
                            if (realTotalPriceCent==0 && payWay!=PayWayOffline) {//(realTotalPriceCent==0 && payway!=PayWayOffline) || (
                                WEAKSELF;
                                if ([[Session sharedInstance] isBindingPhoneNumber]) {
                                    [VerifyPasswordView showInViewMF:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
                                        [weakSelf showProcessingHUD:nil];
                                        [AuthService validatePassword:password completion:^{
                                            payOrderListBlock();
                                        } failure:^(XMError *error) {
                                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                        }];
                                    }];
                                } else {
                                    [WCAlertView showAlertWithTitle:@""
                                                            message:@"确认付款？"
                                                 customizationBlock:^(WCAlertView *alertView) {
                                                     alertView.style = WCAlertViewStyleWhite;
                                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                                     if (buttonIndex == 0) {
                                                         
                                                     } else {
                                                         payOrderListBlock();
                                                     }
                                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                                }
                            } else {
                                [weakSelf showProcessingHUD:nil];
                                payOrderListBlock();
                            }
                        }
                    }];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
            
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        }];
    }
    
}

-(void)showTipView:(OrderInfo *)orderInfo{
    WEAKSELF;
    [[CoordinatingController sharedInstance].visibleController.view addSubview:weakSelf.tipBgView];
    [[CoordinatingController sharedInstance].visibleController.view addSubview:weakSelf.tipView];
    [weakSelf.tipView getOrderInfo:orderInfo];
    
    weakSelf.tipBgView.alpha = 0;
    weakSelf.tipView.alpha = 0;
    
    weakSelf.tipBgView.frame = [UIScreen mainScreen].bounds;
    weakSelf.tipView.frame = CGRectMake(30, (kScreenHeight-250)/2, kScreenWidth-60, 250);
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.tipBgView.alpha = 0.7;
        weakSelf.tipView.alpha = 1;
    }];
    
    weakSelf.tipBgView.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.tipView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.tipView removeFromSuperview];
            weakSelf.tipView = nil;
        }];
    };
    
    weakSelf.tipView.handleDisButton = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.tipView.alpha = 0;
            weakSelf.tipBgView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.tipView removeFromSuperview];
            [weakSelf.tipBgView removeFromSuperview];
            weakSelf.tipBgView = nil;
            weakSelf.tipView = nil;
        }];
    };
    
}

- (void)showPaySuccess:(OrderInfo *)orderInfo
{
    //支付成功提示框
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    if (userId != [Session sharedInstance].currentUser.userId) {
        EvaluateView * view = [[EvaluateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [view show];
    }
    
    if (orderInfo.goodsList.count > 0) {
        GoodsInfo *goodsInfo = orderInfo.goodsList[0];
        SuccessfulPayViewController *controller = [[SuccessfulPayViewController alloc] init];
        controller.goodsId = goodsInfo.goodsId;
        [self pushViewController:controller animated:YES];
    }
}

-(void)showPartialView{
    
    WEAKSELF;
    [self.view addSubview:self.partialBgView];
    self.partialBgView.frame = self.view.bounds;
    [self.view addSubview:self.partialView];
    self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
    [self.partialView getPartialDo:self.partialDo];
    
    self.partialBgView.dissMissBlackView = ^(){
        [weakSelf dismissPartialView];
        [weakSelf dismissPartialPayWayView];
    };
    self.partialView.clickProtialCloseBtn = ^(){
        [weakSelf dismissPartialView];
    };
    
    self.partialView.inputPrice = ^(NSString *priceNum, ParyialDo *partialDo){
        if (partialDo.payType == 20) {
            [weakSelf showHUD:@"请选择支付方式" hideAfterDelay:0.8f];
            return ;
        }
        weakSelf.payPrice = priceNum.doubleValue;
        if (weakSelf.orderId && [weakSelf.orderId length]>0) {
            NSMutableArray *orderIds = [[NSMutableArray alloc] init];
            [orderIds addObject:weakSelf.orderId];
            //            [weakSelf payOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
            weakSelf.is_partial_pay = 1;
            
            if (partialDo.payType == PayWayAdmMoney) {
                if (weakSelf.payPrice > weakSelf.available_money_cent/100) {
                    [weakSelf showChongZhiView];
                    return ;
                }
            }
            
            [weakSelf dismissPartialView];
            //            [weakSelf dismissPartialPayWayView];
            NSDictionary *dict = @{@"orderIds":orderIds, @"partialDo":partialDo, @"priceNum":priceNum};
            
            NSArray *orderIdss = dict[@"orderIds"];
            ParyialDo *partialDo = dict[@"partialDo"];
            NSString *priceNum = dict[@"priceNum"];
            weakSelf.is_partial_pay = 1;
            weakSelf.payPrice = priceNum.doubleValue;
            [weakSelf doPayOrderList:orderIdss payWay:partialDo.payType orderInfo:weakSelf.orderInfo];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrder" object:dict];
        }
    };
    
    self.partialView.showPayWayView = ^(){
        [weakSelf showPayWayView];
    };
    self.partialPayWayView.dismissPartialPayWayView = ^(){
        [weakSelf dismissPartialPayWayView];
    };
    
    self.partialPayWayView.changePayWay = ^(PayWayDO *payWay){
        [weakSelf dismissPartialPayWayView];
        weakSelf.partialDo.payWayIconUrl = payWay.icon_url;
        weakSelf.partialDo.payType = payWay.pay_way;
        weakSelf.partialDo.payWayTitle = payWay.pay_name;
        weakSelf.partialDo.payWayContent = payWay.desc;
        [weakSelf.partialView getPartialDo:weakSelf.partialDo];
    };
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialBgView.alpha = 0.7;
        weakSelf.partialView.frame = CGRectMake(0, kScreenHeight-260, kScreenWidth, 260);
    }];
    //    [weakSelf.partialView.textField becomeFirstResponder];
}

-(void)showPayWayView{
    
    [self.view addSubview:self.partialPayWayView];
    self.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359, kScreenWidth, 359);
    [self.partialPayWayView getPartialDo:self.partialDo];
    [UIView animateWithDuration:0.25 animations:^{
        self.partialPayWayView.frame = CGRectMake(0, kScreenHeight-359, kScreenWidth, 359);
    } completion:^(BOOL finished) {
        [self.partialView.textField resignFirstResponder];
    }];
}

-(void)showChongZhiView{
    WEAKSELF;
    [WCAlertView showAlertWithTitle:@"提示" message:@"钱包余额不足，请充值" customizationBlock:^(WCAlertView *alertView) {
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if (buttonIndex == 0) {
            WalletTwoViewController *controller = [[WalletTwoViewController alloc] init];
            [weakSelf pushViewController:controller animated:YES];
        } else if (buttonIndex == 1) {
            [weakSelf showPayWayView];
        }
        
    } cancelButtonTitle:@"充值" otherButtonTitles:@"更换其他支付方式", nil];
}

-(void)dismissPartialPayWayView{
    WEAKSELF;
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359, kScreenWidth, 359);
    } completion:^(BOOL finished) {
        [weakSelf.partialPayWayView removeFromSuperview];
        [self.partialView.textField becomeFirstResponder];
    }];
}

-(void)dismissPartialView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
        self.partialBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.partialBgView removeFromSuperview];
        [self.partialView.textField resignFirstResponder];
    }];
}

- (void)showDelayAlertView:(NSString*)orderId message:(NSString*)message
{
    WEAKSELF;
    [WCAlertView showAlertWithTitle:@""
                            message:message&&[message length]>0?message:@"确认延长收货时间？\n每笔订单只能延长一次哦"
                 customizationBlock:^(WCAlertView *alertView) {
                     alertView.style = WCAlertViewStyleWhite;
                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 0) {
                         
                     } else {
                         weakSelf.request = [[NetworkAPI sharedInstance] delayReceipt:orderId completion:^(NSInteger delayDays) {
                             [weakSelf showHUD:[NSString stringWithFormat:@"已成功延长 %ld天 收货",(long)delayDays] hideAfterDelay:0.8f forView:weakSelf.view];
                             self.orderInfo.receive_remaining += 3600*24*delayDays;
                             [_tableView reloadData];
                         } failure:^(XMError *error) {
                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                         }];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if (ClsTableViewCell == [OrderGoodsTableViewCell class]) {
        GoodsInfo *goodsInfo = dict[@"goodsInfo"];
        if (goodsInfo.serviceType == 10) {
            OfferedViewController *viewController = [[OfferedViewController alloc] init];
            viewController.goodID = goodsInfo.goodsId;
            [self pushViewController:viewController animated:YES];
        } else {
            GoodsDetailViewControllerContainer *goodsDetailViewController = [[GoodsDetailViewControllerContainer alloc] init];
            goodsDetailViewController.goodsId = goodsInfo.goodsId;
            [self pushViewController:goodsDetailViewController animated:YES];
        }
    }
    
    if (ClsTableViewCell == [OrderStatusCell class]) {
        
        //申请回购页面跳转(临时入口 要更换)
        //        WristApplyViewController * applyVC = [[WristApplyViewController alloc] init];
        //        applyVC.orderID = self.orderId;
        //        [self.navigationController pushViewController:applyVC animated:YES];
        
        //查看回购进度
        //        ProgressQueryViewController * pq = [[ProgressQueryViewController alloc] init];
        //        pq.orderID = self.orderId;
        //        pq.orderInfo = self.orderInfo;
        //        NSLog(@"self.orderInfo.buttonStats  == =   %ld",(long)self.orderInfo.buttonStats);
        //        [self.navigationController pushViewController:pq animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}


- (void)$$handlePayResultCompletionNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    if (orderIds!=nil && orderIds.count>0) {
        WEAKSELF;
        [weakSelf showProcessingHUD:nil];
        _request = [[NetworkAPI sharedInstance] getOrderDetailList:orderIds completion:^(NSArray *orderDetails) {
            [weakSelf hideHUD];
            NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
            
            BOOL payStatusErrorExist = NO;
            
            for (NSDictionary *dict in orderDetails) {
                OrderDetailInfo *orderDefailInfo = [OrderDetailInfo createWithDict:dict];
                if (orderDefailInfo.orderInfo.payStatus != 2) {
                    payStatusErrorExist = YES;
                } else {
                    //                    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                    //                        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                    //                        if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    //                            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                    //                            if (i == 0){
                    [weakSelf showPaySuccess:self.orderInfo];
                    //                            }
                    //                            if ([self.orderInfo.orderId isEqualToString:orderDefailInfo.orderInfo.orderId]) {
                    //                                [dict setObject:orderDefailInfo.orderInfo forKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                    //                                break;
                    //                            }
                    //                        }
                    //                    }
                }
                
                for (GoodsInfo *goodsInfo in orderDefailInfo.orderInfo.goodsList) {
                    if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                        [goodsIds addObject:goodsInfo.goodsId];
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
            
            //            [weakSelf doCheckStartOrStopTheTimer];
            
            if (payStatusErrorExist) {
                
                [self load];
                [self dismiss];
                
                //                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                //                if (self.dataSources.count > 0) {
                //                    dict = [self.dataSources objectAtIndex:0];
                //                }
                //                if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                //                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                //                    if (orderInfo.payStatus != 2) {
                //                [WCAlertView showAlertWithTitle:@"付款已成功"
                //                                        message:@"订单支付状态同步中，请稍后刷新列表！"
                //                             customizationBlock:^(WCAlertView *alertView) {
                //                                 alertView.style = WCAlertViewStyleWhite;
                //                             } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                //                                 if (buttonIndex == 0) {
                //                                     NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
                //                                     if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                //                                         OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                //
                //                                         [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"cmbpay" path:@"query_order_pay_notify" parameters:@{@"order_id":orderInfo.orderId} completionBlock:^(NSDictionary *data) {
                //                                             NSLog(@"%@", data);
                //                                             [weakSelf dismissPartialPayWayView];
                //                                             [weakSelf dismissPartialView];
                //                                             [weakSelf initDataListLogic];
                //                                             return ;
                //                                         } failure:^(XMError *error) {
                //
                //                                         } queue:nil]];
                //                                     }
                //                                 }
                //                             } cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                        return ;
                //                    }
                //                }
                
            }
            
            
            weakSelf.request = [[NetworkAPI sharedInstance] queryGoodsStatus:goodsIds completion:^(NSArray *goodsStatusDictArray) {
                [weakSelf hideHUD];
                NSMutableArray *goodsStatusArray = [[NSMutableArray alloc] initWithCapacity:[goodsStatusDictArray count]];
                for (NSDictionary *dict in goodsStatusDictArray) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        [goodsStatusArray addObject:[GoodsStatusDO createWithDict:dict]];
                    }
                }
                MBGlobalSendGoodsStatusUpdatedNotification(goodsStatusArray);
            } failure:^(XMError *error) {
                
            }];
        } failure:^(XMError *error) {
            [weakSelf showHUD:@"更新订单失败" hideAfterDelay:1.f forView:[UIApplication sharedApplication].keyWindow];
        }];
    } else {
        [self load];
        [self dismiss];
    }
    
    
    
    
    //    [weakSelf showProcessingHUD:nil];
    //    _request = [[NetworkAPI sharedInstance] getOrderDetail:orderId completion:^(NSDictionary *data) {
    //        [weakSelf hideHUD];
    //        OrderDetailInfo *orderDefailInfo = [OrderDetailInfo createWithDict:data];
    //        if (orderDefailInfo.orderInfo.payStatus != 2) {
    //            [WCAlertView showAlertWithTitle:@"付款已成功"
    //                                    message:@"抱歉支付宝还未与爱丁猫同步，请耐心等待！"
    //                         customizationBlock:^(WCAlertView *alertView) {
    //                             alertView.style = WCAlertViewStyleWhite;
    //                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
    //                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //        } else {
    //            if (orderId && [orderId length]>0) {
    //                for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
    //                    NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
    //                    if ([dict isKindOfClass:[NSMutableDictionary class]]) {
    //                        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
    //                        if ([orderInfo.orderId isEqualToString:orderDefailInfo.orderInfo.orderId]) {
    //                            [dict setObject:orderDefailInfo.orderInfo forKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
    //                            break;
    //                        }
    //                    }
    //                }
    //                [weakSelf.tableView reloadData];
    //            }
    //        }
    //    } failure:^(XMError *error) {
    //        [weakSelf showHUD:@"更新订单失败" hideAfterDelay:1.f];
    //    }];
}

@end

