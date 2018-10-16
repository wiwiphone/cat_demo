//
//  BoughtViewController.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BoughtViewController.h"
#import "CoordinatingController.h"
#import "PullRefreshTableView.h"
#import "LogisticsViewController.h"
#import "OrderTableViewCell.h"
#import "SepTableViewCell.h"

#import "DataListLogic.h"
#import "Error.h"
#import "NetworkManager.h"

#import "DataSources.h"
#import "UIColor+Expanded.h"
#import "NSDictionary+Additions.h"

#import "Session.h"
#import "User.h"

#import "OrderInfo.h"

#import "Command.h"

#import "WCAlertView.h"
#import "PayManager.h"
#import "NetworkAPI.h"

#import "OrderDetailViewController.h"
#import "OrderDetailNewViewController.h"

#import "WebViewController.h"

#import "PayManager.h"
#import "OrderDetailInfo.h"
#import "URLScheme.h"

#import "QuanListPopupView.h"
#import "AuthService.h"
#import "TradeService.h"
#import "GoodsMemCache.h"
#import "PayViewController.h"

#import "UserService.h"
#import "UPPayPlugin.h"
#import "UIActionSheet+Blocks.h"
#import "WCAlertView.h"

#import "LoginViewController.h"
#import "WeakTimerTarget.h"
#import "FenQiLePayViewController.h"

#import "SoldViewController.h"
#import "UserAddressViewController.h"

#import "OrderGoodsTypeCell.h"
#import "PartialView.h"
#import "DigitalKeyboardView.h"
#import "ForumPostDetailViewController.h"
#import "BlackView.h"
#import "PartialPayWayView.h"
#import "WalletTwoViewController.h"
#import "EvaluateView.h"
#import "SuccessfulPayViewController.h"
#import "PublishViewController.h"
#import "PayXiHuCardViewController.h"
#import "TipView.h"
#import "ScanCodePaymentViewController.h"

#define kBoughtBottomBarHeight 59.f
#define kMode_Development             @"01"

@interface BoughtViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,PayResultReceiver,SwipeTableCellDelegate, UICollectionViewDataSource,OrderActionsViewDelegate>

@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,strong) UIImageView *bottomView;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) QuanListPopupView *quanListPopupView;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSMutableArray *orderIds;

@property(nonatomic,strong) NSArray *payWays;

@property (nonatomic, strong) NSMutableArray *mailTypeList;
@property(nonatomic,strong) AddressInfo *addressInfo;

@property (nonatomic, strong) OrderInfo *orderInfo;
//@property (nonatomic, strong) OrderDetailViewController *viewController;
@property (nonatomic, strong) OrderDetailNewViewController *viewController;

@property (nonatomic, assign) NSInteger isPayYes;//判断付款

@property (nonatomic, strong) ParyialDo *partialDo;
@property (nonatomic, strong) PartialView *partialView;
@property (nonatomic, assign) CGFloat payPrice;
@property (nonatomic, strong) BlackView *partialBgView;
@property (nonatomic, strong) PartialPayWayView *partialPayWayView;
@property (nonatomic, assign) NSInteger is_partial_pay;
@property (nonatomic, strong) AccountCard *cancelAccountCard;
@property (nonatomic, strong) BonusInfo *cancelBonusInfo;
@property (nonatomic, assign) NSInteger available_money_cent;

@property (nonatomic, strong) TipView *tipView;
@property (nonatomic, strong) BlackView *tipBgView;
@end

//static NSString *ID = @"collectionViewCellID";
@implementation BoughtViewController

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

-(ParyialDo *)partialDo{
    if (!_partialDo) {
        _partialDo = [[ParyialDo alloc] init];
    }
    return _partialDo;
}

- (id)init {
    self = [super init];
    if (self) {
        _orderIds = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dismiss:(BOOL)animated {
    [super dismiss:animated];
}

- (void)dismiss
{
    [super dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKSELF;
//    self.type = 1;
//    self.status = 1;
    CGFloat topBarHeight = [super topBarHeight];
////    [super setupTopBarTitle:@"我买的商品"];
//    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"商品",@"奢服务",nil];
//    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:segmentedArray];
//    segmentedController.frame = CGRectMake(kScreenWidth / 2 - 71, topBarHeight - 33, 142, 25);
//    segmentedController.selectedSegmentIndex = 0;
//    segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentedController.tintColor = [UIColor colorWithHexString:@"3e3a39"];
//    [segmentedController addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.topBar addSubview:segmentedController];
//    [super setupTopBarBackButton];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 0;
//    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - topBarHeight - 44);
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topBarHeight + 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight - 44) collectionViewLayout:layout];
//    collectionView.backgroundColor = [UIColor whiteColor];
//    collectionView.pagingEnabled = YES;
//    collectionView.showsHorizontalScrollIndicator = NO;
//    collectionView.dataSource = self;
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
//    [self.view addSubview:collectionView];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kScreenHeight - topBarHeight - 105)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    [self.view addSubview:self.tableView];
    
    
    self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-kBoughtBottomBarHeight, self.view.bounds.size.width, kBoughtBottomBarHeight);
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden = YES;
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
//    [self initDataListLogic];
    
//    self.partialDo.orderInfo = self.orderInfo;
//    self.partialDo.orderId = self.orderInfo.orderId;
    
    [UserService get_account:^(NSInteger reward_money_cent, NSInteger available_money_cent) {
        weakSelf.available_money_cent = available_money_cent;
    } failure:^(XMError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTypeTwo) name:@"setTypeTwo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setType) name:@"setType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpAlert) name:@"jumpAlert" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSurpPay:) name:@"notificationSurpPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrder:) name:@"payOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAccountCard:) name:@"cancelAccountCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBonusInfo:) name:@"cancelBonusInfo" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setTypeTwo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setType" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpAlert" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationSurpPay" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payOrder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelAccountCard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelBonusInfo" object:nil];
    [_quanListPopupView removeFromSuperview];
    _quanListPopupView = nil;
    
    [_timer invalidate];
    _timer = nil;
}

-(void)cancelBonusInfo:(NSNotification *)notify{
    BonusInfo *cancelBonusInfo = notify.object;
    self.cancelBonusInfo = cancelBonusInfo;
}

-(void)cancelAccountCard:(NSNotification *)notify{
    AccountCard *cancelAccountCard = notify.object;
    self.cancelAccountCard = cancelAccountCard;
}

-(void)setTypeTwo{
//    self.type = 2;
//    self.status = 1;
    [self initDataListLogic];
}

-(void)setType{
//    self.type = 1;
//    self.status = 1;
    [self initDataListLogic];
}

-(void)jumpAlert{
    self.isPayYes = 1;
    [self initDataListLogic];
}

-(void)payOrder:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    NSArray *orderIds = dict[@"orderIds"];
    ParyialDo *partialDo = dict[@"partialDo"];
    NSString *priceNum = dict[@"priceNum"];
    self.is_partial_pay = 1;
    self.payPrice = priceNum.doubleValue;
    [self doPayOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
}

-(void)notificationSurpPay:(NSNotification *)notify{
    NSNumber *payWayNum = notify.object;
    NSInteger payWay = payWayNum.integerValue;
    self.partialDo.payType = payWay;
//    self.partialDo = partialDo;
    [self showPartialView];
}

//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 5;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
////    cell.contentView.backgroundColor = [UIColor redColor];
////    self.tableView.frame = cell.bounds;
//    if (!cell) {
//        self.status = indexPath.item;
//        self.tableView = [[PullRefreshTableView alloc] initWithFrame:cell.bounds];
//        self.tableView.pullDelegate = self;
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
//        [cell.contentView addSubview:self.tableView];
//        [self initDataListLogic];
//    }
//    
//    return cell;
//}

//-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
//    NSInteger Index = Seg.selectedSegmentIndex;
//    NSLog(@"Index %ld", Index);
//    switch (Index) {
//        case 0:
//            self.type = 1;
//            [self initDataListLogic];
////            [self.tableView reloadData];
//            break;
//        case 1:
//            self.type = 2;
//            [self initDataListLogic];
////            [self.tableView reloadData];
//            break;
//        default:
//            break;
//    }
//}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTimer:(NSTimer*)theTimer
{
    WEAKSELF;
    [_orderIds removeAllObjects];
    BOOL stopTheTimer = YES;
    for (NSDictionary *dict in _dataSources) {
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        if (ClsTableViewCell == [OrderTableViewCell class]) {
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
            if (orderInfo) {
                if (orderInfo.orderStatus==0) {
                    if (orderInfo.payStatus==0 || orderInfo.payStatus==1) {
                        //付款倒计时，未付款
                        if (orderInfo.pay_remaining>0) {
                            orderInfo.pay_remaining-=1;
                        }
                        if (orderInfo.pay_remaining<=0) {
                            orderInfo.pay_remaining = 0;
                            orderInfo.orderStatus = 3;//无效
                            orderInfo.statusDesc = [orderInfo orderStatusString];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.tableView reloadData];
                            });
                        }
                        stopTheTimer = NO;
                        [_orderIds addObject:orderInfo.orderId];
                    } else if (orderInfo.shippingStatus==1) {
                        //订单确认倒计时，已发货
                        if (orderInfo.receive_remaining>0) {
                            orderInfo.receive_remaining-=1;
                        }
                        if (orderInfo.receive_remaining<=0) {
                            orderInfo.receive_remaining=0;
                            orderInfo.shippingStatus = 2;//已收获
                            orderInfo.orderStatus = 1;//交易完成
                            orderInfo.statusDesc = [orderInfo orderStatusString];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.tableView reloadData];
                            });
                        }
                        stopTheTimer = NO;
                        [_orderIds addObject:orderInfo.orderId];
                    }
                    else if (orderInfo.payStatus==2 && orderInfo.refund_status==1) {
                        if (orderInfo.refund_remaining>0) {
                            orderInfo.refund_remaining-=1;
                        }
                        if (orderInfo.refund_remaining<=0) {
                            orderInfo.refund_remaining=0;
//                            orderInfo.refund_status = 2; //自动确认为同意退款
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.tableView reloadData];
                            });
                        }
                        stopTheTimer = NO;
                        [_orderIds addObject:orderInfo.orderId];
                    }
                }
            }
        }
    }
    if ([_orderIds count]>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDoUpdateOrderInfoNotification object:_orderIds];
    }
    if (stopTheTimer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)doCheckStartOrStopTheTimer {
    BOOL needStartTimer = NO;
    for (NSDictionary *dict in _dataSources) {
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        if (ClsTableViewCell == [OrderTableViewCell class]) {
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
            if (orderInfo) {
                if (orderInfo.orderStatus==0) {
                    //付款倒计时，未付款
                    if (orderInfo.payStatus==0&&orderInfo.pay_remaining>0) {
                        needStartTimer = YES;
                    }
                    //订单确认倒计时，已发货
                    else if (orderInfo.shippingStatus==1 && orderInfo.receive_remaining>0) {
                        needStartTimer = YES;
                    }
                    else if (orderInfo.payStatus==2 && orderInfo.refund_status==1 && orderInfo.refund_remaining>0) {
                        needStartTimer = YES;
                    }
                }
            }
        }
    }
    
    if (needStartTimer && !_timer) {
        [_timer invalidate];
        _timer = nil;
        WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)showBottomView:(BOOL)isPresent {
    if (isPresent && self.bottomView.hidden) {
        CGRect beginFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, kBoughtBottomBarHeight);
        CGRect endFrame = CGRectMake(0, self.view.bounds.size.height-kBoughtBottomBarHeight, self.view.bounds.size.width, kBoughtBottomBarHeight);
        
        WEAKSELF;
        self.bottomView.frame = beginFrame;
        self.bottomView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.bottomView.frame = endFrame;
        } completion:^(BOOL finished) {
            weakSelf.bottomView.frame = endFrame;
            weakSelf.bottomView.hidden = NO;
        }];
    }
    if (!isPresent && !self.bottomView.hidden) {
        CGRect beginFrame = CGRectMake(0, self.view.bounds.size.height-kBoughtBottomBarHeight, self.view.bounds.size.width, kBoughtBottomBarHeight);
        CGRect endFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, kBoughtBottomBarHeight);
        
        WEAKSELF;
        self.bottomView.frame = beginFrame;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.bottomView.frame = endFrame;
        } completion:^(BOOL finished) {
            weakSelf.bottomView.frame = endFrame;
            weakSelf.bottomView.hidden = YES;
        }];
    }
}

- (UIView*)bottomView
{
    WEAKSELF;
    if (!_bottomView) {
        UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kBoughtBottomBarHeight)];
        _bottomView.userInteractionEnabled = YES;
        [_bottomView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
        
        CommandButton *selectAllBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kBoughtBottomBarHeight)];
        selectAllBtn.tag = 100;
        [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [selectAllBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        [selectAllBtn setImage:[UIImage imageNamed:@"shopping_cart_unchoose.png"] forState:UIControlStateNormal];
        [selectAllBtn setImage:[UIImage imageNamed:@"shopping_cart_choosed.png"] forState:UIControlStateSelected];
        selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7.5, 0, 0);
        selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7.5, 0, 0);
        [selectAllBtn sizeToFit];
        selectAllBtn.frame = CGRectMake(15, 0, selectAllBtn.bounds.size.width+7.5, _bottomView.bounds.size.height);
        [_bottomView addSubview:selectAllBtn];
        
        CGFloat marginRight = 8.5f;
        CommandButton *payBtn = [[CommandButton alloc] initWithFrame:CGRectMake(_bottomView.bounds.size.width-104, 0.5f, 104, _bottomView.bounds.size.height-0.5f)];
        payBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
//        payBtn.layer.masksToBounds = YES;
//        payBtn.layer.cornerRadius = 5.f;
        payBtn.titleLabel.font = [UIFont systemFontOfSize:14.5f];
        [payBtn setTitle:@"批量付款" forState:UIControlStateNormal];
//        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
        [_bottomView addSubview:payBtn];
        
        marginRight += payBtn.bounds.size.width;
        marginRight += 15.f;
        
        CGFloat priceLblX = selectAllBtn.frame.origin.x+selectAllBtn.bounds.size.width+20;
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        priceLbl.tag = 200;
        priceLbl.text = [NSString stringWithFormat:@"¥ %.2f", 0.00f];
        priceLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        priceLbl.font = [UIFont systemFontOfSize:15.5f];
        priceLbl.textAlignment = NSTextAlignmentRight;
        [priceLbl sizeToFit];
        priceLbl.frame = CGRectMake(priceLblX, 14, _bottomView.bounds.size.width-marginRight-priceLblX, priceLbl.bounds.size.height);
        [_bottomView addSubview:priceLbl];
        
        CGFloat mailInfoLblY = priceLbl.frame.origin.y+priceLbl.bounds.size.height+4.f;
        
        UILabel *mailInfoLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        mailInfoLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        mailInfoLbl.font = [UIFont systemFontOfSize:11.5f];
        mailInfoLbl.textAlignment = NSTextAlignmentRight;
        mailInfoLbl.text = @"包含邮费";
        [mailInfoLbl sizeToFit];
        mailInfoLbl.frame = CGRectMake(priceLblX, mailInfoLblY, _bottomView.bounds.size.width-marginRight-priceLblX,mailInfoLbl.bounds.size.height);
        [_bottomView addSubview:mailInfoLbl];
        
        selectAllBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf doSelectAll:!sender.selected];
            [weakSelf doUpdateTotalPrice];
        };
#pragma mark --------点击支付
        payBtn.handleClickBlock = ^(CommandButton *sender) {
            [MobClick event:@"click_pay_from_bought"];
            NSMutableArray *orderIds = [[NSMutableArray alloc] init];
            
            BOOL hasExistDiffPayway = NO;
            NSInteger payWay = -1;
            
            for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                BOOL isSelected = [dict boolValueForKey:[OrderTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                if (isSelected) {
                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                    _orderInfo = orderInfo;
                    if (orderInfo) {
                        if (payWay == -1) {
                            payWay = orderInfo.payWay;
                        } else if (payWay!=orderInfo.payWay) {
                            hasExistDiffPayway = YES;
                            break; //禁止不同类别的付款方式同时付款
                        }
                        [orderIds addObject:orderInfo.orderId];
                    }
                }
            }
            
            if (orderIds && [orderIds count]>0) {
                if (hasExistDiffPayway) {
                    [weakSelf showHUD:@"线下支付订单不能批量付款" hideAfterDelay:0.8f forView:weakSelf.tableView];
                } else {
                    //检查可用购物券
                    //付款
                    [weakSelf payOrderList:orderIds payWay:payWay orderInfo:weakSelf.orderInfo];
                }
            } else {
                [weakSelf showHUD:@"请至少选择一个订单" hideAfterDelay:0.8f forView:weakSelf.tableView];
            }
            
//            BOOL isExistInvalidGoods = NO;
//            NSMutableArray *items = [[NSMutableArray alloc] init];
//            for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
//                NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
//                BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
//                if (isSelected) {
//                    ShoppingCartItem *item = [dict objectForKeyedSubscript:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
//                    [items addObject:item];
//                    if (![GoodsInfo goodsStatusIsNormal:item.status]) {
//                        isExistInvalidGoods = YES;
//                    }
//                }
//            }
//            if ([items count]> 0) {
//                if (isExistInvalidGoods) {
//                    [weakSelf showHUD:@"存在失效商品" hideAfterDelay:0.8f forView:weakSelf.tableView];
//                } else {
//                    PayViewController *payViewController = [[PayViewController alloc] init];
//                    payViewController.items = items;
//                    payViewController.handlePayDidFnishBlock = ^(BaseViewController *payViewController) {
//                        [payViewController dismiss:NO];
//                        BoughtViewController *viewController = [[BoughtViewController alloc] init];
//                        [weakSelf pushViewController:viewController animated:YES];
//                    };
//                    [weakSelf.navigationController pushViewController:payViewController animated:YES];
//                }
//            } else {
//                [weakSelf showHUD:@"请至少选择一个商品" hideAfterDelay:0.8f forView:weakSelf.tableView];
//            }
        };
    }
    return _bottomView;
}

- (void)doSelectAll:(BOOL)selectAll
{
    BOOL hasWaitingForPayrOrders = NO;
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSMutableDictionary *dict = [self.dataSources objectAtIndex:i];
        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
        if (orderInfo
            && [orderInfo isWaitingForPay]
            && orderInfo.payWay != PayWayOffline) {
            [dict setObject:[NSNumber numberWithBool:selectAll] forKey:[OrderTableViewCell cellDictKeyForSeleted]];
            hasWaitingForPayrOrders = YES;
        }
    }
    
    if (hasWaitingForPayrOrders) {
        [self.tableView reloadData];
    } else {
        if (selectAll) {
            [self showHUD:@"没有需要付款的订单" hideAfterDelay:0.8 forView:self.view];
        }
    }
    
    UIButton *sender = (UIButton*)[self.bottomView viewWithTag:100];
    sender.selected = selectAll;
}

- (void)doUpdateTotalPrice
{
    double totalPrice = 0.f;
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
        BOOL isSelected = [dict boolValueForKey:[OrderTableViewCell cellDictKeyForSeleted] defaultValue:NO];
        if (isSelected) {
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
            if (orderInfo) {
                totalPrice += [orderInfo totalPrice];
            }
        }
    }
    UILabel *priceLbl = (UILabel*)[self.bottomView viewWithTag:200];
    priceLbl.text = [NSString stringWithFormat:@"¥ %.2f", totalPrice];
}

- (void)payOrderList:(NSArray*)orderIds payWay:(PayWayType)payWay orderInfo:(OrderInfo *)orderInfo
{
//    //检查可用购物券
//    if (payWay == PayWayOffline) {
//        [self doPayOrderList:orderIds payWay:payWay];
//    } else {
//        WEAKSELF;
//        [weakSelf showProcessingHUD:nil];
//        [weakSelf listAvailableBonusByOrderList:orderIds completion:^(NSArray *quanItemsArray) {
//            [weakSelf hideHUD];
//            if ([quanItemsArray count]>0) {
//                if (!weakSelf.quanListPopupView) {
//                    weakSelf.quanListPopupView = [[QuanListPopupView alloc] init];
//                }
//                [weakSelf.quanListPopupView showInView:nil bonusItems:quanItemsArray confirmClickedBlock:^(BonusInfo *bonusInfo) {
//                    [weakSelf doPayOrderList:orderIds payWay:payWay bonusId:bonusInfo.bonusId];
//                } cancelClickedBlock:^{
//                    [weakSelf doPayOrderList:orderIds payWay:payWay bonusId:nil];
//                }];
//            } else {
//                [weakSelf doPayOrderList:orderIds payWay:payWay bonusId:nil];
//            }
//        } failure:^(XMError *error) {
//            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//        }];
//    }
    
    [self doPayOrderList:orderIds payWay:payWay orderInfo:(OrderInfo *)orderInfo];
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
    for (NSString *orderId in orderIds) {
        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
            if (orderInfo && [orderInfo.orderId isEqualToString:orderId]) {
                totalPriceCent += [orderInfo remain_price]*100;
                break;
            }
        }
    }
    
//    NSInteger totalPriceCent = 0;
//    for (NSInteger i=0;i<[self.items count];i++) {
//        ShoppingCartItem *item = [self.items objectAtIndex:i];
//        totalPriceCent += item.shopPriceCent;
//    }
//    NSInteger realTotalPriceCent = totalPriceCent;
//    //1. 先判断优惠券
//    if (weakSelf.seletedBonusInfo) {
//        realTotalPriceCent = realTotalPriceCent-weakSelf.seletedBonusInfo.amountCent;
//        if (realTotalPriceCent<0)realTotalPriceCent=0;
//    }
//    //2. 奖金抵用
//    if (weakSelf.is_used_reward_money && realTotalPriceCent>0) {
//        realTotalPriceCent = realTotalPriceCent-weakSelf.reward_money_cent;
//        if (realTotalPriceCent<0)realTotalPriceCent=0;
//    }
//    //3. 余额
//    if (weakSelf.is_used_adm_money && realTotalPriceCent>0) {
//        realTotalPriceCent = realTotalPriceCent-weakSelf.available_money_cent;
//        if (realTotalPriceCent<0)realTotalPriceCent=0;
//    }
//    
//    PayWayType payway = weakSelf.footerView.payWay;
//    if (realTotalPriceCent==0 && payway!=PayWayOffline) {
//        WEAKSELF;
//        [VerifyPasswordView showInView:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
//            [weakSelf showProcessingHUD:nil];
//            [AuthService validatePassword:password completion:^{
//                payGoodsBlock();
//            } failure:^(XMError *error) {
//                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//            }];
//        }];
//    } else {
//        [weakSelf showProcessingHUD:nil];
//        payGoodsBlock();
//    }
    
    [weakSelf showProcessingHUD:nil];
//    [TradeService pay_ways:^(NSArray *payWays) {
//        weakSelf.payWays = payWays;
    
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
                                        [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:weakSelf.orderIds];
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
                            
//                            if (weakSelf.partialDo.payType == PayWayAdmMoney && payWay!=PayWayOffline) {
//                                
//                                if ([[Session sharedInstance] isBindingPhoneNumber]) {
//                                    [VerifyPasswordView showInViewMF:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
//                                        [weakSelf showProcessingHUD:nil];
//                                        [AuthService validatePassword:password completion:^{
//                                            payOrderListBlock();
//                                        } failure:^(XMError *error) {
//                                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//                                        }];
//                                    }];
//                                } else {
//                                    [WCAlertView showAlertWithTitle:@""
//                                                            message:@"确认使用余额付款？"
//                                                 customizationBlock:^(WCAlertView *alertView) {
//                                                     alertView.style = WCAlertViewStyleWhite;
//                                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                                                     if (buttonIndex == 0) {
//                                                         
//                                                     } else {
//                                                         payOrderListBlock();
//                                                     }
//                                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
//                                }
//                                
//                            } else {
//                                [weakSelf showProcessingHUD:nil];
//                                payOrderListBlock();
//                            }
                            
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
                    
                    [weakSelf hideHUD];
                    
                    //                NSString *payAmount = [[NSString alloc] init];
                    //                if (weakSelf.is_partial_pay == 1) {
                    //                    payAmount = [NSString stringWithFormat:@"%ld", weakSelf.payPrice];
                    //                } else {
                    //                    payAmount = @"";
                    //                }
                    
                    NSInteger index = 0;
                    if (orderInfo.tradeType == 5) {
                        index = 1;
                    }
                    NSLog(@"%ld", (long)index);
                    [ChoosePayWayView showInView:[CoordinatingController sharedInstance].visibleController.view totalPriceCent:totalPriceCent payWayDOArray:weakSelf.payWays payWay:(PayWayType)payWay index:index reward_money_cent:reward_money_cent available_money_cent:available_money_cent quanItemsArray:quanItemsArray xihuCardArray:xihuCardArr is_partial_pay:weakSelf.is_partial_pay partialDo:weakSelf.partialDo completionBlock:^(NSInteger payWay, BOOL is_used_reward_money, BOOL is_used_adm_money, BonusInfo *seletedBonusInfo, AccountCard *accountCard,NSInteger deterIndex, NSInteger index) {
                        
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
                                                [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:weakSelf.orderIds];
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
                                            [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:weakSelf.orderIds];
                                        } else if (payWay == PayWayZhaoH && payZHReg) {
                                            handled = YES;
                                            NSString *payZHUrl = [NSString stringWithFormat:@"%@%@?BranchID=%@&CoNo=%@&BillNo=%@&Amount=%@&Date=%@&ExpireTimeSpan=%@&MerchantUrl=%@&MerchantPara=%@&MerchantCode=%@&MerchantRetUrl=%@&MerchantRetPara=%@", payZHReg.pay_url, payZHReg.MfcISAPICommand, payZHReg.BranchID, payZHReg.CoNo, payZHReg.BillNo, payZHReg.Amount, payZHReg.Date, payZHReg.ExpireTimeSpan, payZHReg.MerchantUrl, payZHReg.MerchantPara, payZHReg.MerchantCode, payZHReg.MerchantRetUrl, payZHReg.MerchantRetPara];
                                            NSString * newUrl = [payZHUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                            NSLog(@"%@", newUrl);
                                            [FenQiLePayViewController presentFenQiLePay:newUrl orderIds:nil];
                                        } else if (payWay == PayWayTransfer) {
                                            OrderInfo *orderInfo2 = [[OrderInfo alloc] init];
                                            PayTipVo * payTipVo = [[PayTipVo alloc] init];
                                            payTipVo.showText = payUrl;
                                            payTipVo.fuzhiText = upPayTn;
                                            orderInfo2.payTipVo = payTipVo;
                                            [weakSelf showTipView:orderInfo2];
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
                            
//                            if (payWay == PayWayAdmMoney && payWay!=PayWayOffline) {//realTotalPriceCent==0
//                                
//                                if ([[Session sharedInstance] isBindingPhoneNumber]) {
//                                    [VerifyPasswordView showInViewMF:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
//                                        [weakSelf showProcessingHUD:nil];
//                                        [AuthService validatePassword:password completion:^{
//                                            payOrderListBlock();
//                                        } failure:^(XMError *error) {
//                                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//                                        }];
//                                    }];
//                                } else {
//                                    [WCAlertView showAlertWithTitle:@""
//                                                            message:@"确认使用余额付款？"
//                                                 customizationBlock:^(WCAlertView *alertView) {
//                                                     alertView.style = WCAlertViewStyleWhite;
//                                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                                                     if (buttonIndex == 0) {
//                                                         
//                                                     } else {
//                                                         payOrderListBlock();
//                                                     }
//                                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
//                                }
//                                
//                            } else {
//                                [weakSelf showProcessingHUD:nil];
//                                payOrderListBlock();
//                            }
                            
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
        
//    } failure:^(XMError *error) {
//        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//    }];
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
//        WEAKSELF;
//        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"goods_last_order" parameters:@{@"goods_sn":goodsInfo.goodsId} completionBlock:^(NSDictionary *data) {
        
//            OrderDetailInfo *detailInfo = data[@"order_detail"];
            SuccessfulPayViewController *controller = [[SuccessfulPayViewController alloc] init];
//            [controller getOrderDetailInfo:detailInfo];
            controller.goodsId = goodsInfo.goodsId;
            [self pushViewController:controller animated:YES];
            
//        } failure:^(XMError *error) {
//            
//        } queue:nil]];
    }
}

//?status=1&type=1
- (void)initDataListLogic {
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"bought" pageSize:20];
    _dataListLogic.parameters = @{@"status" : [NSNumber numberWithInteger:weakSelf.status], @"type" : [NSNumber numberWithInteger:weakSelf.type]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        if (addedItems.count > 0) {
            OrderInfo *orderInfo = [OrderInfo createWithDict:[addedItems objectAtIndex:0]];
            if (weakSelf.goonWithPayController == 1 && orderInfo.payTipVo) {
                [weakSelf showTipView:orderInfo];
                weakSelf.goonWithPayController = 0;
            }
        }
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
//            [newList addObject:[OrderGoodsTypeCell buildCellTitle:@"回购商品" imageName:@"WristwatchRecovery_GoodsDetail_Icon_Black"]];
            [newList addObject:[OrderTableViewCell buildCellDict:[OrderInfo createWithDict:[addedItems objectAtIndex:i]]]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        double totalPrice = 0.f;
        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
            if (orderInfo) {
                totalPrice += [orderInfo totalPrice];
            }
        }
        [TradeService pay_ways:[NSNumber numberWithDouble:totalPrice] completion:^(NSArray *payWays) {
            weakSelf.payWays = payWays;
            weakSelf.partialDo.payWays = payWays;
        } failure:^(XMError *error) {
            
        }];
        
        [weakSelf doSelectAll:NO];
        [weakSelf doCheckStartOrStopTheTimer];
        
//        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
//        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
//        
//        if (orderInfo.payStatus == 2) {
//            GoodsInfo *goodsInfo = orderInfo.goodsList[0];
//            _request = [[NetworkManager sharedInstance] requestWithMethodGET:@"trade/goods_last_order" path:@"" parameters:@{@"goods_sn":goodsInfo.goodsId} completionBlock:^(NSDictionary *data) {
//                OrderDetailInfo *orderDetailInfo = [[OrderDetailInfo alloc] initWithDict:data[@"order_detail"]];
//                SuccessfulPayViewController *controller = [[SuccessfulPayViewController alloc] init];
//                [controller getOrderDetailInfo:orderDetailInfo];
//                [weakSelf pushViewController:controller animated:YES];
//                
//                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"successPayOrder" object:orderInfo];
//                
//                return ;
//            } failure:^(XMError *error) {
//                
//            } queue:nil];
//        }
        
        if (weakSelf.isPayYes == 1) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                
                if (orderInfo.payStatus != 2) {
                    [WCAlertView showAlertWithTitle:@"付款已成功"
                                            message:@"订单支付状态同步中，请稍后刷新列表！"
                                 customizationBlock:^(WCAlertView *alertView) {
                                     alertView.style = WCAlertViewStyleWhite;
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex == 0) {
                                         weakSelf.isPayYes = 0;
                                         NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
                                         if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                                             OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                                             [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"cmbpay" path:@"query_order_pay_notify" parameters:@{@"order_id":orderInfo.orderId} completionBlock:^(NSDictionary *data) {
                                                 NSLog(@"%@", data);
                                                 [weakSelf initDataListLogic];
                                                 return ;
                                             } failure:^(XMError *error) {
                                                 
                                             } queue:nil]];
                                         }
                                     }
                                 } cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    return;
                }
            }
        }
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
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            [newList addObject:[OrderTableViewCell buildCellDict:[OrderInfo createWithDict:[addedItems objectAtIndex:i]]]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf doCheckStartOrStopTheTimer];
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
        [weakSelf loadEndWithNoContent:@"暂无订单"];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
    
    [weakSelf showLoadingView];
}

-(NSArray*)createRightButtons
{
    int number = 1;
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[1] = {@" 删除 "};
    UIColor * colors[1] = {[UIColor redColor]};
    for (int i = 0; i < number; ++i)
    {
        SwipeCellButton * button = [SwipeCellButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(SwipeTableViewCell * sender){
            //            NSLog(@"Convenience callback received (right).");
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

-(NSArray*)swipeTableCell:(SwipeTableViewCell*) cell swipeButtonsForDirection:(SwipeDirection)direction
            swipeSettings:(SwipeSettings*) swipeSettings expansionSettings:(SwipeExpansionSettings*) expansionSettings {
    swipeSettings.transition = SwipeTransitionBorder;
    
    if (direction == SwipeDirectionLeftToRight) {
        return nil;
    }
    else {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = YES;
        return [self createRightButtons];
        
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
//        NSDictionary *dict = [_dataSources objectAtIndex:path.row];
//        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
//        if (orderInfo && [orderInfo isKindOfClass:[OrderInfo class]]) {
//            if (orderInfo.orderStatus!=0) {
//                expansionSettings.buttonIndex = -1;
//                expansionSettings.fillOnTrigger = YES;
//                return [self createRightButtons];
//            }
//        }
//        return nil;
    }
}

-(BOOL)swipeTableCell:(SwipeTableViewCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(SwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == SwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    WEAKSELF;
    if (direction == SwipeDirectionRightToLeft && index == 0) {
        //delete button
        
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        NSDictionary *dict = [_dataSources objectAtIndex:path.row];
        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
        if (orderInfo && [orderInfo isKindOfClass:[OrderInfo class]]) {
            
            if (orderInfo.orderStatus==0) {
                [weakSelf showHUD:@"不能删除进行中的订单" hideAfterDelay:1.2];
            } else {
                [weakSelf showProcessingHUD:nil];
                [TradeService delete_order:orderInfo.orderId completion:^(NSString *order_id) {
                    [weakSelf hideHUD];
                    
                    NSInteger index = -1;
                    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                        NSDictionary *dictTmp = [weakSelf.dataSources objectAtIndex:i];
                        OrderInfo *orderInfo = [dictTmp objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                        if (orderInfo && [orderInfo.orderId isEqualToString:order_id]) {
                            index = i;
                            break;
                        }
                    }
                    
                    if (index>=0 && index<[weakSelf.dataSources count]) {
                        if (index+1<[weakSelf.dataSources count]) {
                            NSDictionary *dictTmp = [weakSelf.dataSources objectAtIndex:index+1];
                            if ([dictTmp objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]]==nil) {
                                [weakSelf.dataSources removeObjectAtIndex:index+1];
                            }
                        }
                        [weakSelf.dataSources removeObjectAtIndex:index];
                    }
                    
                    [weakSelf.tableView reloadData];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
                }];
            }
        }
        
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
//        NSDictionary *dict = [_dataSources objectAtIndex:path.row];
//        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
//        
//        WEAKSELF;
//        NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
//        [goodsIds addObject:item.goodsId];
//        [_request cancel];
//        _request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
//            
//            //[weakSelf.dataSources removeObjectAtIndex:path.row];
//            //[self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//            [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
//        } failure:^(XMError *error) {
//            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
//        }];
    }
    
    return YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}

-(void)showPartialView{
    
//    NSDictionary *dict = @{@"partialDo":self.partialDo};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPartialView" object:self.partialDo];
//    [self.view addSubview:self.partialBgView];
//    self.partialBgView.frame = self.view.bounds;
//    [self.view addSubview:self.partialView];
//    self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
//    [self.partialView getPartialDo:self.partialDo];
    
    
    
//    self.partialView.inputPrice = ^(){
//        ForumQuoteInputView *inputView = [[ForumQuoteInputView alloc] initWithFrame:CGRectZero];
//        [DigitalKeyboardView showInViewBought:weakSelf.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
//            inputView.index = 1;
//            CGFloat priceCent = [((ForumQuoteInputView*)inputContainerView) priceCent];
//            CGFloat nextPriceCent = priceCent / 100;
//            if (nextPriceCent >0) {
//                
//                weakSelf.payPrice = nextPriceCent;
//                [weakSelf.partialView getPayingPrice:nextPriceCent];
//                
//            }
//        }];
//    };
    
//    self.partialBgView.dissMissBlackView = ^(){
//        [weakSelf dismissPartialView];
//        [weakSelf dismissPartialPayWayView];
//    };
//    self.partialView.clickProtialCloseBtn = ^(){
//        [weakSelf dismissPartialView];
//    };
//    self.partialView.inputPrice = ^(NSString *priceNum, ParyialDo *partialDo){
//        if (partialDo.payType == 20) {
//            [weakSelf showHUD:@"请选择支付方式" hideAfterDelay:0.8f];
//            return ;
//        }
//        weakSelf.payPrice = priceNum.doubleValue;
//        if (partialDo.orderId && [partialDo.orderId length]>0) {
//            NSMutableArray *orderIds = [[NSMutableArray alloc] init];
//            [orderIds addObject:partialDo.orderId];
//            //            [weakSelf payOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
//            weakSelf.is_partial_pay = 1;
//            
//            if (weakSelf.payPrice >= weakSelf.available_money_cent/100) {
//                [weakSelf showChongZhiView];
//                return ;
//            }
//            [weakSelf doPayOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
//        }
//        
////        ForumQuoteInputView *inputView = [[ForumQuoteInputView alloc] initWithFrame:CGRectZero];
////        [DigitalKeyboardView showInViewBought:weakSelf.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
////            inputView.index = 1;
////            CGFloat priceCent = [((ForumQuoteInputView*)inputContainerView) priceCent];
////            CGFloat nextPriceCent = priceCent / 100;
////            NSLog(@"%f, %f", priceCent, nextPriceCent);
////            if (nextPriceCent >0) {
////                
////                if (nextPriceCent > weakSelf.partialDo.surplusPriceNum) {
////                    nextPriceCent = weakSelf.partialDo.surplusPriceNum;
////                }
////                weakSelf.payPrice = nextPriceCent;
////                [weakSelf.partialView getPayingPrice:nextPriceCent];
////                
////            }
////        }];
//        
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"AAA" object:nil];
//        
//    };
//    
//    self.partialView.showPayWayView = ^(){
//        [weakSelf showPayWayView];
//    };
//    self.partialPayWayView.dismissPartialPayWayView = ^(){
//        [weakSelf dismissPartialPayWayView];
//    };
//    
//    self.partialPayWayView.changePayWay = ^(PayWayDO *payWay){
//        [weakSelf dismissPartialPayWayView];
//        weakSelf.partialDo.payWayIconUrl = payWay.icon_url;
//        weakSelf.partialDo.payType = payWay.pay_way;
//        weakSelf.partialDo.payWayTitle = payWay.pay_name;
//        weakSelf.partialDo.payWayContent = payWay.desc;
//        [weakSelf.partialView getPartialDo:weakSelf.partialDo];
//    };
//    
////    self.partialView.payBtn = ^(ParyialDo *partialDo){
////        NSLog(@"%ld, %ld", weakSelf.partialDo.payType, partialDo.payType);
//////        if (partialDo.payType == PayWayAdmMoney && self.payPrice > weakSelf.available_money_cent) {
//////            [weakSelf showChongZhiView];
//////            return;
//////        }
////        if (partialDo.orderId && [partialDo.orderId length]>0) {
////            NSMutableArray *orderIds = [[NSMutableArray alloc] init];
////            [orderIds addObject:partialDo.orderId];
//////            [weakSelf payOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
////            weakSelf.is_partial_pay = 1;
////            
////            if (weakSelf.payPrice >= weakSelf.available_money_cent/100) {
////                [weakSelf showChongZhiView];
////                return ;
////            }
////            [weakSelf doPayOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
////        }
////    };
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.partialBgView.alpha = 0.7;
//        weakSelf.partialView.frame = CGRectMake(0, kScreenHeight-365, kScreenWidth, 260);
//    }];
//    [weakSelf.partialView.textField becomeFirstResponder];
}
//-(void)showPayWayView{
//    [self.partialView.textField resignFirstResponder];
//    [self.view addSubview:self.partialPayWayView];
//    self.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359-105, kScreenWidth, 359);
//    [self.partialPayWayView getPartialDo:self.partialDo];
//    [UIView animateWithDuration:0.25 animations:^{
//        self.partialPayWayView.frame = CGRectMake(0, kScreenHeight-359-105, kScreenWidth, 359);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//-(void)showChongZhiView{
//    WEAKSELF;
//    [WCAlertView showAlertWithTitle:@"提示" message:@"钱包余额不足，请充值" customizationBlock:^(WCAlertView *alertView) {
//        
//    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//        
//        if (buttonIndex == 0) {
//            WalletTwoViewController *controller = [[WalletTwoViewController alloc] init];
//            [weakSelf pushViewController:controller animated:YES];
//        } else if (buttonIndex == 1) {
//            [weakSelf showPayWayView];
//        }
//        
//    } cancelButtonTitle:@"充值" otherButtonTitles:@"更换其他支付方式", nil];
//}

//-(void)changeInputPrice:(NSNotification*)notify{
//    NSNumber *nextPriceCentNum = notify.object;
//    CGFloat nextPriceCent = nextPriceCentNum.floatValue;
//    if (nextPriceCent >0) {
//        
//        if (nextPriceCent > self.partialDo.surplusPriceNum) {
//            nextPriceCent = self.partialDo.surplusPriceNum;
//        }
//        self.payPrice = nextPriceCent;
//        [self.partialView getPayingPrice:nextPriceCent];
//        
//    }
//}

//-(void)dismissPartialPayWayView{
//    WEAKSELF;
//    [self.partialView.textField becomeFirstResponder];
//    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359-105, kScreenWidth, 359);
//    } completion:^(BOOL finished) {
//        [weakSelf.partialPayWayView removeFromSuperview];
//    }];
//}
//
//-(void)dismissPartialView{
//    [self.partialView.textField resignFirstResponder];
//    [UIView animateWithDuration:0.25 animations:^{
//        self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
//        self.partialBgView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.partialBgView removeFromSuperview];
//    }];
//    [UIView animateWithDuration:0.25 animations:^{
//        
//    }];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    if ([tableViewCell isKindOfClass:[SwipeTableViewCell class]]) {
        ((SwipeTableViewCell*)tableViewCell).swipeCellDelegate = self;
    }
    
    if ([tableViewCell isKindOfClass:[OrderTableViewCell class]]) {
        WEAKSELF;
        ((OrderTableViewCell*)tableViewCell).actionsView.delegate = self;
        ((OrderTableViewCell*)tableViewCell).handleOrderActionTryDelayBlock = ^(NSString *orderId) {
            
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
        ((OrderTableViewCell*)tableViewCell).handleOrderActionLogisticsBlock = ^(OrderInfo *orderInfo) {
            // weakSelf.request = [[NetworkAPI sharedInstance] logistics:orderId completion:^(NSString *html5Url) {
//            NSString *html5Url = kURLLogisticsFormat(orderId);
//            WebViewController *viewController = [[WebViewController alloc] init];
//            viewController.url = html5Url;
//            viewController.title = @"物流信息";
            LogisticsViewController * viewController = [[LogisticsViewController alloc] init];
            NSString *html5Url = kURLLogisticsFormat(orderInfo.orderId);
            viewController.url = html5Url;
            viewController.mailInfo = orderInfo.mailInfo;
            viewController.orderInfo = orderInfo;
            [weakSelf pushViewController:viewController animated:YES];
            //            } failure:^(XMError *error) {
            //                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            //            }];

        };
        ((OrderTableViewCell*)tableViewCell).handleOrderActionConfirmReceivingBlock = ^(NSString *orderId) {
            
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
                                OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                                if ([orderInfo.orderId isEqualToString:orderId]) {
                                    [orderInfo updateWithStatusInfo:statusInfo];
                                    break;
                                }
                            }
                        }
                        [weakSelf.tableView reloadData];
                        [weakSelf doCheckStartOrStopTheTimer];
                        
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
        ((OrderTableViewCell*)tableViewCell).handleOrderActionPayBlock = ^(NSString *orderId, NSInteger payWay, OrderInfo *orderInfo) {
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
                        [weakSelf payOrderList:orderIds payWay:payWay orderInfo:orderInfo];
                    }
                }
            } else {
                if (orderId && [orderId length]>0) {
                    weakSelf.is_partial_pay = 0;
                    NSMutableArray *orderIds = [[NSMutableArray alloc] init];
                    [orderIds addObject:orderId];
                    [weakSelf payOrderList:orderIds payWay:payWay orderInfo:orderInfo];
                }
            }
            
            
//            weakSelf.request = [[NetworkAPI sharedInstance] payOrder:orderId completion:^(NSString *payUrl) {
//                [PayManager pay:payUrl orderId:orderId];
//            } failure:^(XMError *error) {
//                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//            }];
        };
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionChatBlock = ^(NSInteger userId,OrderInfo *orderInfo,NSInteger isConsultant) {
            if (isConsultant == 1) {
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                    
                    AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                    [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                    
                } failure:^(XMError *error) {
                    
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
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionShowPayTipBlock = ^(OrderInfo *orderInfo){
            [weakSelf showTipView:orderInfo];
        };
        
        ((OrderTableViewCellSold *)tableViewCell).handleOrderBuyerActionChatBlock = ^(NSInteger userId,OrderInfo *orderInfo) {
            [UserSingletonCommand chatWithUser:orderInfo.buyerId];
        };
        
        ((OrderTableViewCell*)tableViewCell).handleOrderActionSelectBlock = ^(NSString *orderId) {
            
            for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                    if ([orderInfo.orderId isEqualToString:orderId]) {
                        [dict setObject:[NSNumber numberWithBool:![dict boolValueForKey:[OrderTableViewCell cellDictKeyForSeleted] defaultValue:NO]] forKey:[OrderTableViewCell cellDictKeyForSeleted]];
                        [weakSelf.tableView reloadData];
                        break;
                    }
                }
            }
            
            [weakSelf doUpdateTotalPrice];
            
            BOOL isHasSelectedOrder = NO;
            BOOL isSelectedAll = YES;
            for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                    if ([orderInfo isWaitingForPay]
                        && orderInfo.payWay != PayWayOffline) {
                        BOOL selected = [dict boolValueForKey:[OrderTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                        if (!selected) {
                            isSelectedAll = NO;
                        }
                        if (selected) {
                            isHasSelectedOrder = YES;
                        }
                    }
                }
            }
            UIButton *sender = (UIButton*)[weakSelf.bottomView viewWithTag:100];
            sender.selected = isSelectedAll;
            
            if (isHasSelectedOrder) {
                [weakSelf showBottomView:YES];
            } else {
                [weakSelf showBottomView:NO];
            }
        };
        
        ((OrderTableViewCell*)tableViewCell).handleOrderActionSendBlock = ^(OrderInfo *orderInfo) {
            [weakSelf handleOrderActionSendBlock:orderInfo];
        };
        
        ((OrderTableViewCell*)tableViewCell).handleOrderActionRemindShippingGoodsBlock = ^(OrderInfo *orderInfo) {
            [weakSelf showProcessingHUD:nil];
            [TradeService remind_deliver:orderInfo.orderId completion:^(NSInteger result, NSString *message) {
                [weakSelf showHUD:message hideAfterDelay:1.2];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
            }];
        };
        ((OrderTableViewCell*)tableViewCell).handleOrderActionMoreBlock = ^(OrderInfo *orderInfo, NSInteger type) {
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
                                                                          OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                                                                          if ([orderInfo.orderId isEqualToString:orderId]) {
                                                                              [orderInfo updateWithStatusInfo:statusInfo];
                                                                              break;
                                                                          }
                                                                      }
                                                                  }
                                                                  [weakSelf.tableView reloadData];
                                                                  
                                                                  [weakSelf doCheckStartOrStopTheTimer];
                                                                  
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
                                         LogisticsViewController * viewController = [[LogisticsViewController alloc] init];
                                         NSString *html5Url = kURLLogisticsFormat(orderInfo.orderId);
                                         viewController.url = html5Url;
                                         viewController.orderInfo = orderInfo;
                                         viewController.mailInfo = orderInfo.mailInfo;
                                         [weakSelf pushViewController:viewController animated:YES];
                                     }
                                 }];
            }
        };
        
        ((OrderTableViewCell*)tableViewCell).handleOrderActionApplyRefundBlock = ^(OrderInfo *orderInfo) {
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
                                         SEL selector = @selector($$handleApplyRefundNotification:order_info:);
                                         MBGlobalSendNotificationForSELWithBody(selector, order_info);
                                     } failure:^(XMError *error) {
                                         [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                     }];
                                 }
                             }];
        };
        
        ((OrderTableViewCell *)tableViewCell).handleOrderActionDeleteOrderBlock = ^(OrderInfo *orderInfo){
            if (orderInfo.orderStatus==0) {
                [weakSelf showHUD:@"不能删除进行中的订单" hideAfterDelay:1.2];
            } else {
                [weakSelf showProcessingHUD:nil];
                [TradeService delete_order:orderInfo.orderId completion:^(NSString *order_id) {
                    [weakSelf hideHUD];
                    
                    NSInteger index = -1;
                    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                        NSDictionary *dictTmp = [weakSelf.dataSources objectAtIndex:i];
                        OrderInfo *orderInfo = [dictTmp objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                        if (orderInfo && [orderInfo.orderId isEqualToString:order_id]) {
                            index = i;
                            break;
                        }
                    }
                    
                    if (index>=0 && index<[weakSelf.dataSources count]) {
                        if (index+1<[weakSelf.dataSources count]) {
                            NSDictionary *dictTmp = [weakSelf.dataSources objectAtIndex:index+1];
                            if ([dictTmp objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]]==nil) {
                                [weakSelf.dataSources removeObjectAtIndex:index+1];
                            }
                        }
                        [weakSelf.dataSources removeObjectAtIndex:index];
                    }
                    
                    [weakSelf.tableView reloadData];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
                }];
            }
        };
        
        ((OrderTableViewCell *)tableViewCell).handleOrderActionSeriviceBlock = ^(OrderInfo *orderInfo){
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"em_user" parameters:nil completionBlock:^(NSDictionary *data) {
                EMAccount *emAccount = [[EMAccount alloc] initWithDict:data[@"emUser"]];
                [[Session sharedInstance] setUserKEFUEMAccount:emAccount];
                [UserSingletonCommand chatWithGroup:emAccount isShowDownTime:YES message:@"亲爱的，有什么可以帮您？" isKefu:YES];
            } failure:^(XMError *error) {
                
            } queue:nil]];
        };
        
        ((OrderTableViewCell*)tableViewCell).handleOrderActionCancelRefundBlock = ^(OrderInfo *orderInfo) {
            
            [WCAlertView showAlertWithTitle:@"确认撤销退款?" message:@"撤销之后不能再次申请!" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==0) {
                    
                } else {
                    [weakSelf showProcessingHUD:nil];
                    [TradeService cancel_refund:orderInfo.orderId completion:^(OrderInfo *order_info) {
                        [weakSelf hideHUD];
                        SEL selector = @selector($$handleCancelRefundNotification:order_info:);
                        MBGlobalSendNotificationForSELWithBody(selector, order_info);
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
        };
        
    }
    
    return tableViewCell;
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

-(void)handleOrderActionResellGoods:(NSString *)goodsId order:(NSString *)orderId
{
    PublishViewController * publish = [[PublishViewController alloc] init];
    publish.goodsId = goodsId;
    publish.isEditGoods = YES;
    publish.isResell = YES;
    publish.orderId = orderId;
    [self pushViewController:publish animated:YES];
}
- (void)handleOrderActionSendBlock:(OrderInfo *)orderInfo
{
    WEAKSELF;
    [weakSelf showProcessingHUD:nil];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
        
        if ([addressDictList count]>0) {
            if (weakSelf.mailTypeList == nil || [weakSelf.mailTypeList count]==0) {
                [TradeService listAllExpress:orderInfo.orderId completion:^(NSArray *mailTypeList, AddressInfo *addressInfo) {
                    [weakSelf hideHUD];
                    [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService sendToAudit:orderInfo.orderId mailSN:mailSN mailType:mailType completion:^(OrderStatusInfo *statusInfo){
                                for (NSDictionary *dict in weakSelf.dataSources) {
                                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
                                    if ([orderInfo.orderId isEqualToString:orderInfo.orderId]) {
                                        [orderInfo updateWithStatusInfo:statusInfo];
                                        break;
                                    }
                                }
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf doCheckStartOrStopTheTimer];
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
                [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:_mailTypeList addressInfo:_addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                    
                    if ([mailSN length]>0 && [mailType length]>0) {
                        [TradeService sendToAudit:orderInfo.orderId mailSN:mailSN mailType:mailType completion:^(OrderStatusInfo *statusInfo){
                            for (NSDictionary *dict in weakSelf.dataSources) {
                                OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
                                if ([orderInfo.orderId isEqualToString:orderInfo.orderId]) {
                                    [orderInfo updateWithStatusInfo:statusInfo];
                                    break;
                                }
                            }
                            [weakSelf.tableView reloadData];
                            
                            [weakSelf doCheckStartOrStopTheTimer];
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
                    [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService sendToAudit:orderInfo.orderId mailSN:mailSN mailType:mailType completion:^(OrderStatusInfo *statusInfo){
                                for (NSDictionary *dict in weakSelf.dataSources) {
                                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
                                    if ([orderInfo.orderId isEqualToString:orderInfo.orderId]) {
                                        [orderInfo updateWithStatusInfo:statusInfo];
                                        break;
                                    }
                                }
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf doCheckStartOrStopTheTimer];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
    if (orderInfo) {
        NSDictionary *data = @{@"orderId":orderInfo.orderId};
        [ClientReportObject clientReportObjectWithViewCode:self.viewCode regionCode:OrderDetailViewCode referPageCode:OrderDetailViewCode andData:data];
//        OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
        OrderDetailNewViewController *viewController = [[OrderDetailNewViewController alloc] init];
        self.viewController = viewController;
        viewController.orderId = orderInfo.orderId;
        viewController.isMysold = NO;
        viewController.is_partial_pay = self.is_partial_pay;
        viewController.payWays = self.payWays;
        viewController.partialDo = self.partialDo;
        viewController.payPrice = self.payPrice;
        viewController.available_money_cent = self.available_money_cent;
        viewController.mailTypeList = self.mailTypeList;
        [self pushViewController:viewController animated:YES];
    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.viewController viewWillLayoutSubviews];
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
                [weakSelf showHUD:[NSString stringWithFormat:@"已成功延长 %ld天 收货",(long)delayDays] hideAfterDelay:0.8f];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                        if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                            if (i == 0){
                                [weakSelf showPaySuccess:orderInfo];
                            }
                            if ([orderInfo.orderId isEqualToString:orderDefailInfo.orderInfo.orderId]) {
                                [dict setObject:orderDefailInfo.orderInfo forKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                                break;
                            }
                        }
                    }
                }
                
                for (GoodsInfo *goodsInfo in orderDefailInfo.orderInfo.goodsList) {
                    if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                        [goodsIds addObject:goodsInfo.goodsId];
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
            
            [weakSelf doCheckStartOrStopTheTimer];
            
            if (payStatusErrorExist) {
                
                [self initDataListLogic];
                
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
        [_dataListLogic reloadDataListByForce];
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

- (void)showSelectPayWayBottom
{
    
}

- (void)$$handlePayResultCancelNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    
}

- (void)$$handlePayResultFailureNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    WEAKSELF;
    [weakSelf showHUD:@"付款失败" hideAfterDelay:1.2f];
}

- (void)$$handleApplyRefundNotification:(id<MBNotification>)notifi order_info:(OrderInfo*)order_info
{
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
        if ([dict isKindOfClass:[NSMutableDictionary class]]) {
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
            if ([orderInfo.orderId isEqualToString:order_info.orderId]) {
                [dict setObject:order_info forKey:[OrderTableViewCell cellDictKeyForOrderInfo]];
                break;
            }
        }
    }
    [weakSelf.tableView reloadData];
    
    [self doCheckStartOrStopTheTimer];
}

- (void)$$handleCancelRefundNotification:(id<MBNotification>)notifi order_info:(OrderInfo*)order_info
{
    [self $$handleApplyRefundNotification:notifi order_info:order_info];
}

@end

#import "PopupOverlayView.h"
#import "NSString+Addtions.h"

@interface VerifyPasswordView ()

@end


@implementation VerifyPasswordView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.text = @"请输入你的登录密码:";
        titleLbl.font = [UIFont systemFontOfSize:14.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(30, 43, titleLbl.width, titleLbl.height);
        [self addSubview:titleLbl];
        
        UIInsetTextField *textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(30, titleLbl.bottom+18, self.width-60, 40) rectInsetDX:10 rectInsetDY:0];
        textFiled.unCopyable = YES;
        textFiled.layer.borderColor = [UIColor colorWithHexString:@"c3c3c3"].CGColor;
        textFiled.layer.borderWidth = 0.5f;
        textFiled.placeholder = @"登录密码";
        textFiled.textColor = [UIColor colorWithHexString:@"333333"];
        textFiled.font = [UIFont systemFontOfSize:14.f];
        textFiled.tag = 100;
        textFiled.keyboardType = UIKeyboardTypeEmailAddress;
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFiled.secureTextEntry = YES;

        [self addSubview:textFiled];
    }
    return self;
}

+ (void)showInView:(UIView*)view
   completionBlock:(void (^)(NSString *password))completionBlock
{
    VerifyPasswordView *priceView = [[VerifyPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-50, 150)];
    
    __block UIInsetTextField *textFiled = (UIInsetTextField*)[priceView viewWithTag:100];
    __block PopupOverlayView *popupOverlayView = [[PopupOverlayView alloc] init];
    [popupOverlayView showInView:view conentView:priceView confirmBlock:^{
        [popupOverlayView removeFromSuperview];
        popupOverlayView = nil;
        
        NSString *password = [textFiled.text trim];
        if ([password length]>0) {
            if (completionBlock) {
                completionBlock(password);
            }
        }
    } cancelBlock:^{
        if ([textFiled isFirstResponder]) {
            [textFiled resignFirstResponder];
        } else {
            [popupOverlayView removeFromSuperview];
            popupOverlayView = nil;
        }
    }];
}

+ (void)showInViewMF:(UIView*)view
   completionBlock:(void (^)(NSString *password))completionBlock
{
    VerifyPasswordView *priceView = [[VerifyPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-50, 150)];
    
    __block UIInsetTextField *textFiled = (UIInsetTextField*)[priceView viewWithTag:100];
    [textFiled becomeFirstResponder];
    __block PopupOverlayView *popupOverlayView = [[PopupOverlayView alloc] init];
    [popupOverlayView showInViewMF:view conentView:priceView confirmBlock:^{
        [popupOverlayView removeFromSuperview];
        popupOverlayView = nil;
        
        NSString *password = [textFiled.text trim];
        if ([password length]>0) {
            if (completionBlock) {
                completionBlock(password);
            }
        }
    } cancelBlock:^{
        if ([textFiled isFirstResponder]) {
            [textFiled resignFirstResponder];
        } else {
            [popupOverlayView removeFromSuperview];
            popupOverlayView = nil;
        }
    }];
}

@end

#import "PopupOverlayView.h"

@implementation PayWayListView

- (id)initWithFrame:(CGRect)frame
        payWayArray:(NSArray*)payWayDOArray defaultPayWay:(NSInteger)payWay {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat marginTop = 0.f;
        CGFloat totalWidth = kScreenWidth;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.text = @"请选择付款方式";
        titleLbl.textColor = [UIColor colorWithHexString:@"666666"];
        titleLbl.font = [UIFont systemFontOfSize:13.5f];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.userInteractionEnabled =YES;
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(0, marginTop, kScreenWidth, 44);
        [self addSubview:titleLbl];
        
        WEAKSELF;
        UIImage *backImage = [UIImage imageNamed:@"back"];
        CommandButton *backBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 15+backImage.size.width+15, titleLbl.height)];
        [backBtn setImage:backImage forState:UIControlStateNormal];
        [titleLbl addSubview:backBtn];
        backBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleBackClickedBlock) {
                weakSelf.handleBackClickedBlock(weakSelf);
            }
        };
        
        marginTop += titleLbl.height;
        
        CALayer *topLine = [CALayer layer];
        topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        topLine.frame = CGRectMake(0, marginTop, totalWidth, 0.5f);
        [self.layer addSublayer:topLine];
        marginTop += topLine.bounds.size.height;
        
//        CALayer *line = nil;
//        if (available_money_cent>0) {
//            PayTableFooterItemView *itemViewAidingmao = [[PayTableFooterItemView alloc] init:@"pay_icon_aidingmiao" title:@"余额支付" subTitle:[NSString stringWithFormat:@"¥ %.2f",((float)available_money_cent)/100] isCanSelected:YES indicatorTitle:@""];
//            itemViewAidingmao.frame = CGRectMake(0, marginTop, totalWidth, 44);
//            [self addSubview:itemViewAidingmao];
//            itemViewAidingmao.selected = YES;
//            marginTop += itemViewAidingmao.height;
//            
//            itemViewAidingmao.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                PayTableFooterItemView *tmp = ((PayTableFooterItemView*)view);
//                [tmp setSelected:![tmp selected]];
//                if (weakSelf.handleUseAdmMoneyBlock) {
//                    weakSelf.handleUseAdmMoneyBlock(weakSelf,[tmp selected]);
//                }
//            };
//            
//            line = [CALayer layer];
//            line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
//            line.frame = CGRectMake(15 + 25 , marginTop, totalWidth-30 , 0.5);
//            [self.layer addSublayer:line];
//            marginTop += line.bounds.size.height;
//        }
        
        UIView *payItemsContainerview = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, totalWidth, 0)];
        [self addSubview:payItemsContainerview];
        
        CGFloat itemMarginTop = marginTop;
        if ([payWayDOArray count]>0) {
            WEAKSELF;
            for (NSInteger index=0;index<[payWayDOArray count];index++) {
                PayWayDO *payWayDO = [payWayDOArray objectAtIndex:index];
                PaySelectedItemView *itemView = [[PaySelectedItemView alloc] init:payWayDO.icon_url placeHolder:[payWayDO localIconName] title:payWayDO.pay_name];;
                itemView.frame = CGRectMake(0, itemMarginTop, totalWidth, 44);
                itemView.tag = payWayDO.pay_way;
                [self addSubview:itemView];
                itemMarginTop += itemView.height;
                
                if (index!=[payWayDOArray count]-1) {
                    CALayer *line = [CALayer layer];
                    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
                    line.frame = CGRectMake(15 + 25 , itemMarginTop, totalWidth-30 , 0.5);
                    [self.layer addSublayer:line];
                    itemMarginTop += line.frame.size.height;
                }
                
                if (payWayDO.pay_way==payWay) {
                    [itemView setSelected:YES];
                }
                itemView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                    NSArray *subiews = [weakSelf subviews];
                    for (UIView *subview in subiews) {
                        if ([subview isKindOfClass:[PaySelectedItemView class]]) {
                            if (subview==view) {
                                [(PaySelectedItemView*)subview setSelected:YES];
                                if (weakSelf.handlePayWayChangedBlock) {
                                    weakSelf.handlePayWayChangedBlock(weakSelf,view.tag);
                                }
                            } else {
                                [(PaySelectedItemView*)subview setSelected:NO];
                            }
                        }
                    }
                };
            }
        }
    }
    return self;
}

@end

@interface ChoosePayWayView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;
// 点击背景取消
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

//@property(nonatomic,weak) UIView *payItemsContainerview;

@property(nonatomic,strong) NSArray *quanItemArray;
@property (nonatomic, strong) NSArray *xihuCardArray;
@property(nonatomic,strong) BonusInfo *seletedBonusInfo;
@property (nonatomic, strong) AccountCard * selectAccountCard;

@property(nonatomic,assign) BOOL is_used_reward_money;
@property(nonatomic,assign) BOOL is_used_adm_money;

@property(nonatomic,assign) NSInteger totalPriceCent;
@property(nonatomic,assign) NSInteger reward_money_cent;
@property(nonatomic,assign) NSInteger available_money_cent;

@property(nonatomic,strong) NSArray *payWayDOArray;
@property(nonatomic,assign) NSInteger payWay;

@property(nonatomic,weak) PayWayListView *listView;
@property (nonatomic, assign) NSInteger deterIndex;
@property (nonatomic, weak) UIButton *deterBtn;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ParyialDo *partialDo;
@end

@implementation ChoosePayWayView

- (id)initWithFrame:(CGRect)frame
     totalPriceCent:(NSInteger)totalPriceCent
      payWayDOArray:(NSArray*)payWayDOArray
             payWay:(PayWayType)payWay
       recoverIndex:(NSInteger)recoverIndex
  reward_money_cent:(NSInteger)reward_money_cent
available_money_cent:(NSInteger)available_money_cent
     quanItemsArray:(NSArray*)quanItemsArray
      xihuCardArray:(NSArray *)xihuCardArray
          partialDo:(ParyialDo *)partialDo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF;
        self.partialDo = partialDo;
        self.is_used_reward_money = YES;
        self.totalPriceCent = totalPriceCent;
        self.reward_money_cent = reward_money_cent;
        self.available_money_cent = available_money_cent;
        
        self.quanItemArray = quanItemsArray;
        self.xihuCardArray = xihuCardArray;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.] ;
        CGFloat marginTop = 0.f;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat totalWidth = kScreenWidth;
        marginTop += 0.f;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.text = @"请选择付款方式";
        titleLbl.textColor = [UIColor colorWithHexString:@"666666"];
        titleLbl.font = [UIFont systemFontOfSize:13.5f];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.userInteractionEnabled = YES;
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(0, marginTop, kScreenWidth, 44);
        [_contentView addSubview:titleLbl];
        
        UIImage *backImage = [UIImage imageNamed:@"close"];
        CommandButton *backBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 15+backImage.size.width+15, titleLbl.height)];
        [backBtn setImage:backImage forState:UIControlStateNormal];
        [titleLbl addSubview:backBtn];
        backBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf dismissContentView:YES];
        };
        
        marginTop += titleLbl.height;
        
        CALayer *topLine = [CALayer layer];
        topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        topLine.frame = CGRectMake(0, marginTop, totalWidth, 0.5f);
        [_contentView.layer addSublayer:topLine];
        marginTop += topLine.bounds.size.height;
        
        if (reward_money_cent>0) {
            
            double reward_money = (double)reward_money_cent/100.f;
            
            CommandButton *rewardBtn = [[CommandButton alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 44)];
            rewardBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [rewardBtn setTitle:@"奖励现金抵用" forState:UIControlStateNormal];
            [rewardBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            rewardBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            [rewardBtn setImage:[UIImage imageNamed:@"reward_checkbox_0"] forState:UIControlStateNormal];
            [rewardBtn setImage:[UIImage imageNamed:@"reward_checkbox_1"] forState:UIControlStateSelected];
            [rewardBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            rewardBtn.tag = 1000;
            [_contentView addSubview:rewardBtn];
            
            UILabel *rewardLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            rewardLbl.text = [NSString stringWithFormat:@"- %.2f",reward_money];
            rewardLbl.font = [UIFont systemFontOfSize:13.f];
            rewardLbl.textColor = [UIColor colorWithHexString:@"181818"];
            [rewardLbl sizeToFit];
            rewardLbl.frame = CGRectMake(rewardBtn.width-rewardLbl.width, (rewardBtn.height-rewardLbl.height)/2, rewardLbl.width, rewardLbl.height);
            [rewardBtn addSubview:rewardLbl];
            rewardBtn.selected = YES;
            
            WEAKSELF;
            rewardBtn.handleClickBlock = ^(CommandButton *sender){
                sender.selected = !sender.isSelected;
                if (sender.isSelected){
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_1"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_1"] forState:UIControlStateSelected];
                } else {
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_0"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_0"] forState:UIControlStateSelected];
                }
                weakSelf.is_used_reward_money = sender.isSelected;
                [weakSelf updateTotalPriceLbl];
            };
            
            marginTop += rewardBtn.height;
            
            CALayer *line = [CALayer layer];
            line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
            line.frame = CGRectMake(15, marginTop, totalWidth, 0.5f);
            [_contentView.layer addSublayer:line];
            marginTop += line.bounds.size.height;
        }
        
        if (recoverIndex == 1) {
            PayTableFooterItemView *deterViewQuan = [[PayTableFooterItemView alloc] init:nil title:@"鉴定方式" subTitle:@"请选择鉴定方式" isCanSelected:NO indicatorTitle:@""];
            UIButton *deterBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 35, 10, 20, 20)];
            [deterBtn setImage:[UIImage imageNamed:@"Raisal_G_MF"] forState:UIControlStateSelected];
            [deterBtn setImage:[UIImage imageNamed:@"Raisal_S_MF"] forState:UIControlStateNormal];
            //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 35, 10, 20, 20)];
            //        label.text = @"请选择鉴定方式";
            //        [label sizeToFit];
            //        [deterViewQuan addSubview:label];
            [deterBtn bringSubviewToFront:self];
            deterViewQuan.frame = CGRectMake(0, marginTop, totalWidth, 44);
            deterViewQuan.tag = 6000;
            [_contentView addSubview:deterViewQuan];
            [deterViewQuan addSubview:deterBtn];
            deterBtn.hidden = YES;
            //        label.hidden = NO;
            self.deterBtn = deterBtn;
            marginTop += deterViewQuan.bounds.size.height;
            
            deterViewQuan.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                WEAKSELF;
                [UIActionSheet showInView:self
                                withTitle:nil
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:[NSArray arrayWithObjects:@"爱丁猫鉴定后再发货给我", @"无需爱丁猫鉴定卖家直接寄给我",nil]
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     if (buttonIndex == 0) {
                                         deterViewQuan.subTitle = nil;
                                         deterBtn.hidden = NO;
                                         //                                     label.hidden = YES;
                                         weakSelf.deterIndex = 1;
                                         weakSelf.deterBtn.selected = NO;
                                         [weakSelf setNeedsDisplay];
                                     }
                                     else if (buttonIndex==1) {
                                         deterViewQuan.subTitle = nil;
                                         deterBtn.hidden = NO;
                                         //                                     label.hidden = YES;
                                         weakSelf.deterIndex = 2;
                                         weakSelf.deterBtn.selected = YES;
                                         [weakSelf setNeedsDisplay];
                                         
                                     }
                                 }];
                
                //            [weakSelf toggleListView:NO];
            };
        }
        
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(15, marginTop, totalWidth, 0.5f);
        [_contentView.layer addSublayer:line];
        marginTop += line.bounds.size.height;
        
        PayTableFooterItemView *itemViewQuan = [[PayTableFooterItemView alloc] init:nil title:@"优惠券" subTitle:@"未使用" isCanSelected:NO indicatorTitle:[NSString stringWithFormat:@"%d张可用",self.quanItemArray.count]];
        itemViewQuan.frame = CGRectMake(0, marginTop, totalWidth, 44);
        itemViewQuan.tag = 600;
        [_contentView addSubview:itemViewQuan];
        marginTop += itemViewQuan.height;
        
        itemViewQuan.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            PayQuanViewController *viewController = [[PayQuanViewController alloc] init];
            viewController.quanItemList = weakSelf.quanItemArray;
            viewController.isHaveUnableLbl = NO;
            if (weakSelf.seletedBonusInfo) {
                viewController.seletedBonusInfo = weakSelf.seletedBonusInfo;
            } else {
                weakSelf.seletedBonusInfo = [[BonusInfo alloc] init];
                weakSelf.seletedBonusInfo.bonusId = @"-1000";
            }
            viewController.handleDidSelectBonusInfo = ^(PayQuanViewController *viewController, BonusInfo *bonusInfo) {
                weakSelf.seletedBonusInfo = bonusInfo;
                PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[weakSelf.contentView viewWithTag:600];
                
                if ([bonusInfo.bonusId isEqualToString:@"-1000"]) {
                    itemViewQuanTmp.subTitle = @"未使用";
                } else {
                    itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元",((double)bonusInfo.amountCent)/100.f];
                }
                [viewController dismiss];
                
                [weakSelf updateTotalPriceLbl];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBonusInfo" object:weakSelf.seletedBonusInfo];
            };
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
//        if (self.xiHuCardArray && self.xiHuCardArray.count>0) {
        PayTableFooterItemView *itemViewXiHuCard = [[PayTableFooterItemView alloc] init:nil title:@"消费卡" subTitle:@"未使用" isCanSelected:NO indicatorTitle:[NSString stringWithFormat:@"%lu张可用",(unsigned long)self.xihuCardArray.count]];//xihuCard
        itemViewXiHuCard.frame = CGRectMake(0, marginTop, totalWidth, 44);
        itemViewXiHuCard.tag = 700;
        [_contentView addSubview:itemViewXiHuCard];
        marginTop += itemViewXiHuCard.height;
        
        itemViewXiHuCard.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer){
            PayXiHuCardViewController *cardViewController = [[PayXiHuCardViewController alloc] init];
            cardViewController.xiHuCardArray = [[NSMutableArray alloc] initWithArray:weakSelf.xihuCardArray];
            if (weakSelf.selectAccountCard) {
                cardViewController.selectAccountCard = weakSelf.selectAccountCard;
            } else {
                weakSelf.selectAccountCard = [[AccountCard alloc] init];
                weakSelf.selectAccountCard.cardType = -1000;
            }
            cardViewController.selectAccountCard = weakSelf.selectAccountCard;
            
            cardViewController.selectedAccountCard = ^(PayXiHuCardViewController *controller, AccountCard *accountCard){
                PayTableFooterItemView *itemViewXihuTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:700];
                if (accountCard.cardType == -1000) {
                    itemViewXihuTmp.subTitle = @"未使用";
                } else {
                    itemViewXihuTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元", accountCard.cardCanPayMoney];
                }
                
                weakSelf.selectAccountCard = accountCard;
                [weakSelf updateTotalPriceLbl];
                [controller dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAccountCard" object:weakSelf.selectAccountCard];
            };
            
            [[CoordinatingController sharedInstance] pushViewController:cardViewController animated:YES];
        };
//        }
        
        for (int i = 0 ; i < xihuCardArray.count; i++) {
            AccountCard *card = xihuCardArray[i];
            if (!self.selectAccountCard) {
                self.selectAccountCard = card;
            } else {
                if (self.selectAccountCard.cardCanPayMoney > card.cardCanPayMoney) {
                    
                } else {
                    self.selectAccountCard = card;
                }
            }
            
            if (i == xihuCardArray.count - 1) {
                if (self.selectAccountCard && [self.selectAccountCard isKindOfClass:[AccountCard class]]) {
                    PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[self.contentView viewWithTag:700];
                    //                            itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                    itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元", self.selectAccountCard.cardCanPayMoney];
                    [weakSelf updateTotalPriceLbl];
                }
            }
        }
        
        for (int i = 0 ; i < quanItemsArray.count; i++) {
            BonusInfo *info = quanItemsArray[i];
            if (!self.seletedBonusInfo) {
                self.seletedBonusInfo = info;
            } else {
                if (self.seletedBonusInfo.amountCent > info.amountCent) {
                    
                } else {
                    self.seletedBonusInfo = info;
                }
            }
            
            if (i == quanItemsArray.count - 1) {
                PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[self.contentView viewWithTag:600];
                itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元",((double)self.seletedBonusInfo.amountCent)/100.f];
                
                [self updateTotalPriceLbl];
            }
        }
        
        line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(15 + 25 , marginTop, totalWidth-30 , 0.5);
        [_contentView.layer addSublayer:line];
        marginTop += line.bounds.size.height;
        

//        PayTableFooterItemView *itemViewAidingmao = [[PayTableFooterItemView alloc] init:nil title:@"余额支付" subTitle:[NSString stringWithFormat:@"¥ %.2f",((double)available_money_cent)/100.f] isCanSelected:YES indicatorTitle:@""];
//        itemViewAidingmao.frame = CGRectMake(0, marginTop, totalWidth, 44);
//        itemViewAidingmao.tag = 1300;
//        [_contentView addSubview:itemViewAidingmao];
//        marginTop += itemViewAidingmao.height;
//        if (available_money_cent>0) {
//            weakSelf.is_used_adm_money = YES;
//            itemViewAidingmao.selected = YES;
//        }
//        itemViewAidingmao.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//            PayTableFooterItemView *tmp = ((PayTableFooterItemView*)view);
//            [tmp setSelected:![tmp selected]];
//            weakSelf.is_used_adm_money = [tmp selected];
//            [weakSelf updateTotalPriceLbl];
//        };
//        
//        
//        line = [CALayer layer];
//        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
//        line.frame = CGRectMake(15, marginTop, totalWidth, 0.5f);
//        [_contentView.layer addSublayer:line];
//        marginTop += line.bounds.size.height;
        
        PayTableFooterItemView *itemViewPayWay = [[PayTableFooterItemView alloc] init:nil title:@"付款方式" subTitle:@"选择付款方式" isCanSelected:NO indicatorTitle:nil];
        itemViewPayWay.frame = CGRectMake(0, marginTop, totalWidth, 44);
        itemViewPayWay.tag = 800;
        [_contentView addSubview:itemViewPayWay];
        marginTop += itemViewPayWay.height;
        itemViewPayWay.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [weakSelf toggleListView:NO];
        };
        
        line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(15, marginTop, totalWidth, 0.5f);
        [_contentView.layer addSublayer:line];
        marginTop += line.bounds.size.height;
        
        UIView *totalPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 55)];
        totalPriceView.tag = 2000;
        [_contentView addSubview:totalPriceView];
        
        marginTop += totalPriceView.height;
        
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, totalPriceView.height)];
        priceLbl.textColor = [UIColor colorWithHexString:@"181818"];
        priceLbl.font = [UIFont systemFontOfSize:14.f];
        priceLbl.text = @"还需付款";
        [totalPriceView addSubview:priceLbl];
        
        UILabel *totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, totalPriceView.height)];
        totalPriceLbl.textAlignment = NSTextAlignmentRight;
        totalPriceLbl.text = @"";
        totalPriceLbl.textColor = [UIColor colorWithHexString:@"333333"];
        totalPriceLbl.font = [UIFont systemFontOfSize:18.f];
        totalPriceLbl.tag = 1000;
        [totalPriceView addSubview:totalPriceLbl];
        
        if (marginTop<240) {
            marginTop = 240;
        }
        
//        if (available_money_cent>0) {
//            PayTableFooterItemView *itemViewAidingmao = [[PayTableFooterItemView alloc] init:@"pay_icon_aidingmiao" title:@"余额支付" subTitle:[NSString stringWithFormat:@"¥ %.2f",((float)available_money_cent)/100] isCanSelected:YES indicatorTitle:@""];
//            itemViewAidingmao.frame = CGRectMake(0, marginTop, totalWidth, 44);
//            [_contentView addSubview:itemViewAidingmao];
//            itemViewAidingmao.selected = YES;
//            marginTop += itemViewAidingmao.height;
//            
//            itemViewAidingmao.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                PayTableFooterItemView *tmp = ((PayTableFooterItemView*)view);
//                [tmp setSelected:![tmp selected]];
//                weakSelf.is_used_adm_money = [tmp selected];
//            };
//            
//            line = [CALayer layer];
//            line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
//            line.frame = CGRectMake(15 + 25 , marginTop, totalWidth-30 , 0.5);
//            [_contentView.layer addSublayer:line];
//            marginTop += line.bounds.size.height;
//        }
        
//        UIView *payItemsContainerview = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, totalWidth, 0)];
//        [_contentView addSubview:payItemsContainerview];
//        _payItemsContainerview = payItemsContainerview;
//        
//        CGFloat itemMarginTop = 0.f;
//        if ([payWayDOArray count]>0) {
//            WEAKSELF;
//            for (NSInteger index=0;index<[payWayDOArray count];index++) {
//                PayWayDO *payWayDO = [payWayDOArray objectAtIndex:index];
//                PaySelectedItemView *itemView = [[PaySelectedItemView alloc] init:payWayDO.icon_url placeHolder:[payWayDO localIconName] title:payWayDO.pay_name];;
//                itemView.frame = CGRectMake(0, itemMarginTop, totalWidth, 44);
//                itemView.tag = payWayDO.pay_way;
//                [_payItemsContainerview addSubview:itemView];
//                itemMarginTop += itemView.height;
//                
//                if (index!=[payWayDOArray count]-1) {
//                    CALayer *line = [CALayer layer];
//                    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
//                    line.frame = CGRectMake(15 + 25 , itemMarginTop, totalWidth-30 , 0.5);
//                    [_payItemsContainerview.layer addSublayer:line];
//                    itemMarginTop += line.frame.size.height;
//                }
//                
//                if (payWayDO.pay_way==payWay) {
//                    [itemView setSelected:YES];
//                }
//                itemView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                    NSArray *subiews = [weakSelf.payItemsContainerview subviews];
//                    for (PayTableFooterItemView *subview in subiews) {
//                        if (subview==view) {
//                            [subview setSelected:YES];
//                            weakSelf.payWay = view.tag;
//                        } else {
//                            [subview setSelected:NO];
//                        }
//                    }
//                };
//            }
//        }
//        
//        _payItemsContainerview.frame = CGRectMake(0, marginTop, totalWidth, itemMarginTop);
//        
//        marginTop += _payItemsContainerview.height;
        
        self.payWay = payWay;
        self.payWayDOArray = payWayDOArray;
        for (PayWayDO *payWayDO in weakSelf.payWayDOArray) {
            if (payWayDO.pay_way==payWay) {
                weakSelf.payWay = payWay;
                [itemViewPayWay setSubTitle:payWayDO.pay_name];
                break;
            }
        }
        
        UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0,marginTop, self.bounds.size.width, 50)];
        bottomView.userInteractionEnabled = YES;
        bottomView.backgroundColor = [UIColor clearColor];
        UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
        [bottomView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
        
        CGFloat marginLeft = 0.f;
        
//        _cancelBtn = [[CommandButton alloc] initWithFrame:CGRectMake(marginLeft, 0.5f, bottomView.width/2, bottomView.height-0.5f)];
//        _cancelBtn.backgroundColor = [UIColor colorWithHexString:@"E2BB66"];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
//        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//        [bottomView addSubview:_cancelBtn];
//        
//        marginLeft += _cancelBtn.width;
        
        _buyBtn = [[CommandButton alloc] initWithFrame:CGRectMake(marginLeft, 0.5f, bottomView.width, bottomView.height-0.5f)];
        _buyBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        [_buyBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [bottomView addSubview:_buyBtn];
        
        CALayer *sepLine = [CALayer layer];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
        sepLine.frame = CGRectMake(0, marginTop, totalWidth- 30, 1);
        [bottomView.layer addSublayer:sepLine];
        
        marginTop += bottomView.height;
        
        [_contentView addSubview:bottomView];
        
        [_contentView setFrame:CGRectMake(0, frame.size.height - marginTop, frame.size.width, marginTop)];
        [self addSubview:_contentView];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];
        
        PayWayListView *listView = [[PayWayListView alloc] initWithFrame:CGRectMake(0, _contentView.top-20, _contentView.width, _contentView.height+20) payWayArray:payWayDOArray defaultPayWay:payWay];
        listView.backgroundColor = [UIColor whiteColor];
        listView.hidden = YES;
        [[listView layer] setShadowOffset:CGSizeMake(1, 1)];
        [[listView layer] setShadowRadius:5];
        [[listView layer] setShadowOpacity:1];
        [[listView layer] setShadowColor:[UIColor blackColor].CGColor];
        [self addSubview:listView];
        _listView = listView;
        
        listView.handleBackClickedBlock = ^(PayWayListView *listView) {
            [weakSelf toggleListView:YES];
        };
        listView.handlePayWayChangedBlock = ^(PayWayListView *listView, NSInteger payWay) {
            if (payWay == PayWayPartial) {
//                [weakSelf toggleListView:NO];
//                [weakSelf showContentView:NO];
                [weakSelf dismissContentView:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSurpPay" object:@(payWay)];
            } else {
                PayTableFooterItemView *itemView = (PayTableFooterItemView*)[weakSelf.contentView viewWithTag:800];
                for (PayWayDO *payWayDO in weakSelf.payWayDOArray) {
                    if (payWayDO.pay_way==payWay) {
                        weakSelf.payWay = payWay;
                        [itemView setSubTitle:payWayDO.pay_name];
                        break;
                    }
                }
                [weakSelf toggleListView:YES];
            }
        };
        
        [weakSelf updateTotalPriceLbl];
    }
    return self;
}

- (void)toggleListView:(BOOL)hidden {
    if (hidden) {
        if (![_listView isHidden]) {
            WEAKSELF;
            CGRect endFrame = CGRectMake(kScreenWidth, weakSelf.listView.top, weakSelf.listView.width, weakSelf.listView.height);
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.listView.frame = endFrame;
            } completion:^(BOOL finished) {
                weakSelf.listView.frame = endFrame;
                weakSelf.listView.hidden = YES;
            }];
        }
    } else {
        if ([_listView isHidden]) {
            WEAKSELF;
            CGRect beginFrame = CGRectMake(kScreenWidth, weakSelf.listView.top, weakSelf.listView.width, weakSelf.listView.height);
            CGRect endFrame = CGRectMake(0, weakSelf.listView.top, weakSelf.listView.width, weakSelf.listView.height);
            weakSelf.listView.frame = beginFrame;
            weakSelf.listView.hidden = NO;
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.listView.frame = endFrame;
            } completion:^(BOOL finished) {
                weakSelf.listView.frame = endFrame;
            }];
        }
    }
}

- (void)updateTotalPriceLbl {
    
    PayTableFooterItemView *itemViewAidingmao = (PayTableFooterItemView*)[_contentView viewWithTag:1300];
    
    WEAKSELF;
    NSInteger realTotalPriceCent = _totalPriceCent;
    //优惠券
    if (weakSelf.seletedBonusInfo) {
        if ([weakSelf.seletedBonusInfo.bonusId isEqualToString:@"-1000"]) {
            
        } else {
            realTotalPriceCent = realTotalPriceCent-weakSelf.seletedBonusInfo.amountCent;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
    }
    //优惠卡
    if (weakSelf.selectAccountCard) {
        if (weakSelf.selectAccountCard.cardType == -1000) {
            weakSelf.selectAccountCard = nil;
        } else {
            realTotalPriceCent = realTotalPriceCent-weakSelf.selectAccountCard.cardCanPayMoney*100;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
    }
    //2. 奖金抵用
    if (weakSelf.is_used_reward_money && realTotalPriceCent>0) {
        realTotalPriceCent = realTotalPriceCent-weakSelf.reward_money_cent;
        if (realTotalPriceCent<0)realTotalPriceCent=0;
    }
    //3. 余额
    double availableMoney = ((double)_available_money_cent)/100.f;
    if (weakSelf.partialDo.payType == PayWayAdmMoney && realTotalPriceCent>0) {
        
        if (realTotalPriceCent>weakSelf.available_money_cent) {
            itemViewAidingmao.subTitle = [NSString stringWithFormat:@"- %.2f (%.2f元可用)",availableMoney,availableMoney];
        } else {
            itemViewAidingmao.subTitle = [NSString stringWithFormat:@"- %.2f (%.2f元可用)",(double)(realTotalPriceCent)/100.f,availableMoney];
        }
        
        realTotalPriceCent = realTotalPriceCent-weakSelf.available_money_cent;
        if (realTotalPriceCent<0)realTotalPriceCent=0;
    } else {
        itemViewAidingmao.subTitle = [NSString stringWithFormat:@"- 0.0 (%.2f元可用)",availableMoney];
    }
    
    
    
    UILabel *totalPriceLbl = (UILabel*)[[weakSelf.contentView viewWithTag:2000]viewWithTag:1000];
    totalPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",((double)realTotalPriceCent)/100.0f];
    weakSelf.partialDo.surplusPriceNum = ((double)realTotalPriceCent)/100.0f;
}

- (void)dealloc{
    [self removeGestureRecognizer:_tapGesture];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelAccountCard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelBonusInfo" object:nil];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:self];
   
    UIView *contentView = self.contentView;
    if (!CGRectContainsPoint(contentView.frame, touchPoint)) {
        [self dismissContentView:YES];
    }
}

+ (ChoosePayWayView*)showInView:(UIView*)view
                 totalPriceCent:(NSInteger)totalPriceCent
                  payWayDOArray:(NSArray*)payWayDOArray
                         payWay:(PayWayType)payWay
                          index:(NSInteger)index
              reward_money_cent:(NSInteger)reward_money_cent
           available_money_cent:(NSInteger)available_money_cent
                 quanItemsArray:(NSArray*)quanItemsArray
                  xihuCardArray:(NSArray *)xihuCardArray
                 is_partial_pay:(NSInteger)is_partial_pay
                      partialDo:(ParyialDo *)partialDo
                completionBlock:(void (^)(NSInteger payWay, BOOL is_used_reward_money, BOOL is_used_adm_money, BonusInfo *seletedBonusInfo, AccountCard *accountCard,NSInteger deterIndex, NSInteger index))completionBlock
{
    
    NSInteger recoverIndex = 0;
    if (index == 1) {
        recoverIndex = 1;
    }
    partialDo.payType = payWay;
    WEAKSELF;
    
    ChoosePayWayView *_chooseView = [[ChoosePayWayView alloc] initWithFrame:view.frame
                                                             totalPriceCent:totalPriceCent
                                                              payWayDOArray:payWayDOArray
                                                                     payWay:payWay
                                                               recoverIndex:recoverIndex
                                                          reward_money_cent:reward_money_cent
                                                       available_money_cent:available_money_cent
                                                             quanItemsArray:quanItemsArray
                                                              xihuCardArray:xihuCardArray
                                                                  partialDo:partialDo];
    __weak ChoosePayWayView *chooseView = _chooseView;
    
    chooseView.cancelBtn.handleClickBlock = ^(CommandButton *sender) {
        [chooseView dismissContentView:YES];
    };
    chooseView.buyBtn.handleClickBlock = ^(CommandButton *sender) {
        
        if (is_partial_pay == 0) {
            if (index == 1) {
                if (!chooseView.deterIndex) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择鉴定方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return ;
                }
            }
        }
        
        if (completionBlock) {
            completionBlock(chooseView.payWay, chooseView.is_used_reward_money,chooseView.is_used_adm_money,chooseView.seletedBonusInfo, chooseView.selectAccountCard,chooseView.deterIndex, chooseView.index);
        }
        if (is_partial_pay == 0) {
            [chooseView dismissContentView:YES];
        }
        
    };
    if (is_partial_pay == 0) {
        [view addSubview:chooseView];
        [chooseView showContentView:YES];
    }
    
    if (is_partial_pay == 1) {
        if (completionBlock) {
            completionBlock(chooseView.payWay, chooseView.is_used_reward_money,chooseView.is_used_adm_money,chooseView.seletedBonusInfo, chooseView.selectAccountCard,chooseView.deterIndex, chooseView.index);
        }
    }
    
    return _chooseView;
}

+ (ChoosePayWayView*)getBonusInfoAndAccountCard:(UIView*)view
                 totalPriceCent:(NSInteger)totalPriceCent
                  payWayDOArray:(NSArray*)payWayDOArray
                         payWay:(PayWayType)payWay
                          index:(NSInteger)index
              reward_money_cent:(NSInteger)reward_money_cent
           available_money_cent:(NSInteger)available_money_cent
                 quanItemsArray:(NSArray*)quanItemsArray
                  xihuCardArray:(NSArray *)xihuCardArray
              is_partial_pay:(NSInteger)is_partial_pay
                      partialDo:(ParyialDo *)partialDo
                completionBlock:(void (^)(NSInteger payWay1, BOOL is_used_reward_money1, BOOL is_used_adm_money1, BonusInfo *seletedBonusInfo1, AccountCard *accountCard1,NSInteger deterIndex1, NSInteger index1))completionBlock
{
    
    NSInteger recoverIndex = 0;
    if (index == 1) {
        recoverIndex = 1;
    }
    partialDo.payType = payWay;
    WEAKSELF;
    
    ChoosePayWayView *_chooseView = [[ChoosePayWayView alloc] initWithFrame:view.frame
                                                             totalPriceCent:totalPriceCent
                                                              payWayDOArray:payWayDOArray
                                                                     payWay:payWay
                                                               recoverIndex:recoverIndex
                                                          reward_money_cent:reward_money_cent
                                                       available_money_cent:available_money_cent
                                                             quanItemsArray:quanItemsArray
                                                              xihuCardArray:xihuCardArray
                                                                  partialDo:partialDo];
    __weak ChoosePayWayView *chooseView = _chooseView;
    
    chooseView.cancelBtn.handleClickBlock = ^(CommandButton *sender) {
//        [chooseView dismissContentView:YES];
    };
    chooseView.buyBtn.handleClickBlock = ^(CommandButton *sender) {
        
        if (is_partial_pay == 0) {
//            if (index == 1) {
//                if (!chooseView.deterIndex) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择鉴定方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                    return ;
//                }
//            }
        }
        
        if (completionBlock) {
            completionBlock(chooseView.payWay, chooseView.is_used_reward_money,chooseView.is_used_adm_money,chooseView.seletedBonusInfo, chooseView.selectAccountCard,chooseView.deterIndex, chooseView.index);
        }
        if (is_partial_pay == 0) {
//            [chooseView dismissContentView:YES];
        }
       
    };
    if (is_partial_pay == 0) {
//        [view addSubview:chooseView];
//        [chooseView showContentView:YES];
    }
    
    if (is_partial_pay == 1) {
        if (completionBlock) {
            completionBlock(chooseView.payWay, chooseView.is_used_reward_money,chooseView.is_used_adm_money,chooseView.seletedBonusInfo, chooseView.selectAccountCard,chooseView.deterIndex, chooseView.index);
        }
    }
    
    return _chooseView;
}

- (void)showContentView:(BOOL)animated {
    CGRect beginFrame = CGRectMake(0, self.superview.height, self.contentView.width, self.contentView.height);
    CGRect endFrame = CGRectMake(0, self.superview.height-self.contentView.height, self.contentView.width, self.contentView.height);
    self.contentView.frame = beginFrame;
    WEAKSELF;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        weakSelf.contentView.frame = endFrame;
    } completion:^(BOOL finished) {
        weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        weakSelf.contentView.frame = endFrame;
    }];
}

- (void)dismissContentView:(BOOL)animated
{
    CGRect endFrame = CGRectMake(0, self.superview.height, self.contentView.width, self.contentView.height);
    WEAKSELF;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
        weakSelf.contentView.frame = endFrame;
    } completion:^(BOOL finished) {
        weakSelf.contentView.frame = endFrame;
        [weakSelf removeFromSuperview];
    }];
}

@end

@implementation PaySelectedItemView {
    
}

- (id)init:(NSString*)icon title:(NSString*)title {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) icon:icon title:title];
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon title:(NSString*)title {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *alipayImgView =[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-20)/2, 20, 20)];
        alipayImgView.image = [UIImage imageNamed:icon];
        [self addSubview:alipayImgView];
        
        CGFloat totalWidth = kScreenWidth;
        
        UILabel *alipayLbl =[[UILabel alloc] initWithFrame:CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, 0, totalWidth-30 - alipayImgView.size.width, self.height)];
        alipayLbl.text = title;
        alipayLbl.textColor = [UIColor colorWithHexString:@"181818"];
        alipayLbl.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:alipayLbl];
        
        
        UIImageView *flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_checkbox_uncheck"]];
        flagView.frame = CGRectMake(totalWidth-15-flagView.width, (self.height-flagView.height)/2, flagView.width, flagView.height);
        flagView.tag = 100;
        [self addSubview:flagView];
        
        _selected = NO;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)init:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) icon:iconUrl placeHolder:placeHolder title:title];
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *alipayImgView =[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-20)/2, 20, 20)];
        [alipayImgView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:placeHolder]];
        [self addSubview:alipayImgView];
        
        CGFloat totalWidth = kScreenWidth;
        
        UILabel *alipayLbl =[[UILabel alloc] initWithFrame:CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, 0, totalWidth-30 - alipayImgView.size.width, self.height)];
        alipayLbl.text = title;
        alipayLbl.textColor = [UIColor colorWithHexString:@"181818"];
        alipayLbl.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:alipayLbl];
        
        UIImageView *flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_checkbox_uncheck"]];
        flagView.frame = CGRectMake(totalWidth-15-flagView.width, (self.height-flagView.height)/2, flagView.width, flagView.height);
        flagView.tag = 100;
        [self addSubview:flagView];
        
        _selected = NO;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (_selected!=selected) {
        _selected = selected;
        
        UIView *flagView = [self viewWithTag:100];

        if ([flagView isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)flagView ).image = (_selected ? [UIImage imageNamed:@"pay_checkbox_checked"] : [UIImage imageNamed:@"pay_checkbox_uncheck"]);
        }
    }
}


@end




