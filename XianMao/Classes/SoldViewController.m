//
//  SoldViewController.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SoldViewController.h"
#import "CoordinatingController.h"
#import "PullRefreshTableView.h"

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
#import "TradeService.h"
#import "GoodsService.h"

#import "UIActionSheet+Blocks.h"
#import "NSString+Addtions.h"

#include "AuthService.h"

#import "BoughtViewController.h"
#import "LoginViewController.h"

#import "WeakTimerTarget.h"

#import "GoodsService.h"
#import "LogisticsViewController.h"
#import "UserAddressViewController.h"

@interface SoldViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,SwipeTableCellDelegate>

@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) NSArray *mailTypeList;
@property(nonatomic,strong) AddressInfo *addressInfo;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSMutableArray *orderIds;

@end

@implementation SoldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    CGFloat topBarHeight = [super setupTopBar];
    //    [super setupTopBarTitle:@"已售"];
    //    [super setupTopBarBackButton];
    
    self.status = 1;
    CGFloat topBarHeight = 0.f;
    
    self.orderIds = [[NSMutableArray alloc] init];
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight - 105)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [DataSources globalWhiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    //    [self initDataListLogic];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGoods:) name:@"sendGoods" object:nil];
    
}

//-(void)sendGoods:(NSNotification *)notify{
//    OrderInfo *orderInfo = notify.object;
//    [self handleOrderActionSendBlock:orderInfo.orderId];
//}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)dealloc
{
    
}

- (void)onTimer:(NSTimer*)theTimer
{
    WEAKSELF;
    [_orderIds removeAllObjects];
    BOOL stopTheTimer = YES;
    for (NSDictionary *dict in _dataSources) {
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        if (ClsTableViewCell == [OrderTableViewCellSold class]) {
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
            if (orderInfo) {
                if (orderInfo.orderStatus==0) {
                    if (orderInfo.payStatus==0) {
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
        if (ClsTableViewCell == [OrderTableViewCellSold class]) {
            OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
            if (orderInfo) {
                if (orderInfo.orderStatus==0) {
                    //付款倒计时，未付款
                    if (orderInfo.payStatus==0&&orderInfo.pay_remaining>0) {
                        needStartTimer = YES;
                    }
                    //订单确认倒计时，已发货
                    if (orderInfo.shippingStatus==1 && orderInfo.receive_remaining>0) {
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


- (void)initDataListLogic {
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"common_sold" pageSize:20];
    _dataListLogic.parameters = @{@"status" : [NSNumber numberWithInteger:weakSelf.status]};
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            [newList addObject:[OrderTableViewCellSold buildCellDict:[OrderInfo createWithDict:[addedItems objectAtIndex:i]]]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        [weakSelf doCheckStartOrStopTheTimer];
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
            [newList addObject:[OrderTableViewCellSold buildCellDict:[OrderInfo createWithDict:[addedItems objectAtIndex:i]]]];
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
        [weakSelf loadEndWithNoContentWithRetryButton:@"无已售订单"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
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
    
    if ([tableViewCell isKindOfClass:[SwipeTableViewCell class]]) {
        ((SwipeTableViewCell*)tableViewCell).swipeCellDelegate = self;
    }
    
    if ([tableViewCell isKindOfClass:[OrderTableViewCellSold class]]) {
        
        [(OrderTableViewCellSold*)tableViewCell updateCellWithDict:dict];
        
        WEAKSELF;
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionTryDelayBlock = ^(NSString *orderId) {
            
            weakSelf.request = [[NetworkAPI sharedInstance] tryDelayReceipt:orderId completion:^(NSInteger result, NSString *message) {
                //result:2 , message: 亲，您已经延长过收货时间啦
                //result:0 , message: 确认延长收货时间？\n每笔订单只能延长一次哦
                //result:1 , message: 亲，距离结束时间前3天才可以申请哦
                if (result == 0) {
                    [weakSelf showDelayAlertView:orderId message:message];
                } else {
                    [weakSelf showHUD:message hideAfterDelay:0.8f forView:weakSelf.view];
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionLogisticsBlock = ^(OrderInfo * orderInfo) {
            // weakSelf.request = [[NetworkAPI sharedInstance] logistics:orderId completion:^(NSString *html5Url) {
            NSString *html5Url = kURLLogisticsFormat(orderInfo.orderId);
            LogisticsViewController *viewController = [[LogisticsViewController alloc] init];
            viewController.url = html5Url;
            viewController.mailInfo = orderInfo.mailInfo;
            viewController.orderInfo = orderInfo;
            [weakSelf pushViewController:viewController animated:YES];
            //            } failure:^(XMError *error) {
            //                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            //            }];
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionConfirmReceivingBlock = ^(NSString *orderId) {
            [VerifyPasswordView showInView:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
                [weakSelf showProcessingHUD:nil];
                [AuthService validatePassword:password completion:^{
                    weakSelf.request = [[NetworkAPI sharedInstance] confirmReceived:orderId completion:^(NSDictionary *statusInfoDict) {
                        [weakSelf hideHUD];
                        
                        OrderStatusInfo *orderStatusInfo = [OrderStatusInfo createWithDict:statusInfoDict];
                        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                                OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
                                if ([orderInfo.orderId isEqualToString:orderStatusInfo.orderId]) {
                                    [orderInfo updateWithStatusInfo:orderStatusInfo];
                                    break;
                                }
                            }
                        }
                        [weakSelf.tableView reloadData];
                        
                        [weakSelf doCheckStartOrStopTheTimer];
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                    }];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            }];
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionPayBlock = ^(NSString *orderId, NSInteger payWay, OrderInfo *orderInfo) {
            //            weakSelf.request = [[NetworkAPI sharedInstance] payOrder:orderInfo.orderId completion:^(NSString *payUrl) {
            //                [PayManager pay:payUrl orderId:orderInfo.orderId];
            //            } failure:^(XMError *error) {
            //                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            //            }];
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionChatBlock = ^(NSInteger userId,OrderInfo *orderInfo,NSInteger isConsultant) {
            if (isConsultant) {
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                    
                    AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                    [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                    
                } failure:^(XMError *error) {
                    
                } queue:nil]];
            } else {
                if ([orderInfo goodsList].count>0) {
                    GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:0];
                    
                    [UserSingletonCommand chatWithoutGoodsId:goodsInfo.goodsId];
                } else {
                    [UserSingletonCommand chatWithUser:userId];
                }
            }
        };
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderBuyerActionChatBlock = ^(NSInteger userId,OrderInfo *orderInfo) {
            
            [UserSingletonCommand chatWithUser:orderInfo.buyerId];
            
        };
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderGoodsModifyPriceBlock = ^(NSString *orderId,GoodsInfo *goodsInfo) {
            
            [ModifyOrderGoodsPriceView showInView:nil dealPrice:goodsInfo.dealPrice completionBlock:^(float newPrice) {
                [weakSelf showProcessingHUD:nil];
                [weakSelf hideHUD];
                NSArray *array = [NSArray arrayWithObjects:[GoodsNewPrice allocGoodsNewPrice:goodsInfo.goodsId newPrice:newPrice], nil];
                [TradeService modifyPrice:orderId goodsNewPriceArray:array completion:^{
                    for (NSDictionary *dict in weakSelf.dataSources) {
                        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
                        if ([orderInfo.orderId isEqualToString:orderId]) {
                            for (GoodsInfo *goodsInfo in orderInfo.goodsList) {
                                if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                                    if ([goodsInfo.goodsId isEqualToString:goodsInfo.goodsId]) {
                                        //orderInfo.totalPrice有点问题，每次都是零。使用orderInfo.totalPrice_cent
                                        orderInfo.totalPrice_cent = orderInfo.totalPrice_cent + newPrice * 100 - goodsInfo.dealPrice * 100;
                                        
                                        goodsInfo.dealPrice = newPrice;
                                        goodsInfo.dealPriceCent = newPrice * 100;
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                    }
                    [weakSelf.tableView reloadData];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            }];
        };
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionOfflineConfirmPaymentBlock = ^(NSString *orderId) {
            
            [VerifyPasswordView showInView:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
                [weakSelf showProcessingHUD:nil];
                [TradeService confirmOfflinePaid:orderId password:password completion:^(OrderStatusInfo *statusInfo) {
                    [weakSelf hideHUD];
                    for (NSDictionary *dict in weakSelf.dataSources) {
                        OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
                        if ([orderInfo.orderId isEqualToString:orderId]) {
                            [orderInfo updateWithStatusInfo:statusInfo];
                            break;
                        }
                    }
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf doCheckStartOrStopTheTimer];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            }];
            
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionOfflineSendBlock = ^(OrderInfo *orderInfo) {
            
            //            [TradeService deliverGoodsOffline:orderId completion:^(OrderStatusInfo *statusInfo) {
            //                for (NSDictionary *dict in weakSelf.dataSources) {
            //                    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
            //                    if ([orderInfo.orderId isEqualToString:orderId]) {
            //                        [orderInfo updateWithStatusInfo:statusInfo];
            //                        break;
            //                    }
            //                }
            //                [weakSelf.tableView reloadData];
            //
            //            } failure:^(XMError *error) {
            //                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            //            }];
            [weakSelf handleOrderActionSendBlock:orderInfo];
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionSendBlock = ^(OrderInfo *orderInfo) {
            [weakSelf handleOrderActionSendBlock:orderInfo];
            
        };
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionConnectADMBlock = ^(NSInteger sellerId) {
//            [UIActionSheet showInView:weakSelf.view.superview.superview
//                            withTitle:nil
//                    cancelButtonTitle:@"取消"
//               destructiveButtonTitle:nil
//                    otherButtonTitles:[NSArray arrayWithObjects:@"呼叫客服(工作日9点到20点)", nil]
//                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                                 if (buttonIndex == 0) {
//                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
//                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
//                                 }
//                             }];
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"em_user" parameters:nil completionBlock:^(NSDictionary *data) {
                EMAccount *emAccount = [[EMAccount alloc] initWithDict:data[@"emUser"]];
                [[Session sharedInstance] setUserKEFUEMAccount:emAccount];
                [UserSingletonCommand chatWithGroup:emAccount isShowDownTime:YES message:@"亲爱的，有什么可以帮您？" isKefu:YES];
            } failure:^(XMError *error) {
                
            } queue:nil]];
        };
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionRenewGoodsBlock = ^(NSString *goodsId) {
            [weakSelf showProcessingHUD:nil];
            [GoodsService sale_again:goodsId completion:^{
                [weakSelf showHUD:@"重新上架成功" hideAfterDelay:0.8f];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.5f];
            }];
        };
        
        ((OrderTableViewCellSold*)tableViewCell).handleOrderActionAgreeRefundBlock = ^(OrderInfo *orderInfoParam, BOOL isAgree) {
            
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请确认是否同意退款?"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 [weakSelf showProcessingHUD:nil];
                                 [TradeService agree_refund:orderInfoParam.orderId completion:^(OrderInfo *order_info) {
                                     [weakSelf hideHUD];
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
                                 } failure:^(XMError *error) {
                                     [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
                                 }];
                             }
                         } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            
        };
        
    } else {
        [tableViewCell updateCellWithDict:dict];
    }
    
    return tableViewCell;
}

- (void)handleOrderActionSendBlock:(OrderInfo*)orderInfo
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    OrderInfo *orderInfo = [dict objectForKey:[OrderTableViewCellSold cellDictKeyForOrderInfo]];
    if (orderInfo) {
        NSDictionary *data = @{@"orderId":orderInfo.orderId};
        [ClientReportObject clientReportObjectWithViewCode:self.viewCode regionCode:OrderDetailViewCode referPageCode:OrderDetailViewCode andData:data];
        //        OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
        OrderDetailNewViewController *viewController = [[OrderDetailNewViewController alloc] init];
        viewController.isMysold = YES;
        viewController.orderId = orderInfo.orderId;
        [self pushViewController:viewController animated:YES];
    }
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
                         } failure:^(XMError *error) {
                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                         }];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

@end

#import "PopupOverlayView.h"


@interface ModifyOrderGoodsPriceView ()
@property(nonatomic,assign) double dealPrice;
@end
@implementation ModifyOrderGoodsPriceView

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame dealPrice:(double)dealPrice {
    self = [super initWithFrame:frame];
    if (self) {
        _dealPrice = dealPrice;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.text = @"当前价格:";
        titleLbl.font = [UIFont systemFontOfSize:14.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(30, 43, titleLbl.width, titleLbl.height);
        [self addSubview:titleLbl];
        
        UILabel *shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        shopPriceLbl.text = [NSString stringWithFormat:@"%.2f",dealPrice];
        shopPriceLbl.font = [UIFont systemFontOfSize:14.f];
        shopPriceLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [shopPriceLbl sizeToFit];
        shopPriceLbl.frame = CGRectMake(titleLbl.right+5, titleLbl.top, shopPriceLbl.width, shopPriceLbl.height);
        [self addSubview:shopPriceLbl];
        
        UIInsetTextField *textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(30, shopPriceLbl.bottom+18, self.width-60, 40) rectInsetDX:10 rectInsetDY:0];
        textFiled.layer.borderColor = [UIColor colorWithHexString:@"c3c3c3"].CGColor;
        textFiled.layer.borderWidth = 0.5f;
        textFiled.placeholder = @"请输入新价格";
        textFiled.textColor = [UIColor colorWithHexString:@"333333"];
        textFiled.font = [UIFont systemFontOfSize:14.f];
        textFiled.keyboardType = UIKeyboardTypeDecimalPad;
        textFiled.tag = 100;
        [self addSubview:textFiled];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

+ (void)showInView:(UIView*)view dealPrice:(double)dealPrice completionBlock:(void (^)(float newPrice))completionBlock {
    
    ModifyOrderGoodsPriceView *priceView = [[ModifyOrderGoodsPriceView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-50, 155) dealPrice:dealPrice];
    
    __block UIInsetTextField *textFiled = (UIInsetTextField*)[priceView viewWithTag:100];
    __block PopupOverlayView *popupOverlayView = [[PopupOverlayView alloc] init];
    [popupOverlayView showInView:view conentView:priceView confirmBlock:^{
        [popupOverlayView removeFromSuperview];
        popupOverlayView = nil;
        if ([textFiled.text floatValue]>0 && [textFiled.text floatValue]!=dealPrice) {
            if (completionBlock) {
                completionBlock([textFiled.text floatValue]);
            }
        }
    } cancelBlock:^{
        [popupOverlayView removeFromSuperview];
        popupOverlayView = nil;
    }];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [textFiled becomeFirstResponder];
    });
    
}

@end


#import "QrCodeScanViewController.h"
#import "WCAlertView.h"

@interface DeliverInfoEditView () <UITableViewDataSource,UITableViewDelegate,QrCodeScanViewControllerDelegate>
@property(nonatomic,strong) NSArray *mailTypeList;
@property(nonatomic,strong) AddressInfo *addressInfo;
@property(nonatomic,strong) UIView *tableViewContainer;
@property(nonatomic,strong) MailTypeDO *selectedMailTypeDO;

- (NSString*)mailSN;

@end

@implementation DeliverInfoEditView

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame isSecuredTrade:(BOOL)isSecuredTrade mailTypeList:(NSArray*)mailTypeList addressInfo:(AddressInfo*)addressInfo isShowAddress:(BOOL)isShowAddress {
    self = [super initWithFrame:frame];
    if (self) {
        
        _mailTypeList = mailTypeList;
        _addressInfo = addressInfo;
        
        CommandButton *combBtn = [[CommandButton alloc] initWithFrame:CGRectMake(30, 30, self.width-60, 40.f)];
        combBtn.layer.masksToBounds = YES;
        combBtn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        combBtn.layer.borderWidth = 0.5f;
        [combBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        [combBtn setTitle:@"请选择快递公司" forState:UIControlStateNormal];
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trade_dropdown"]];
        [combBtn addSubview:arrow];
        arrow.frame = CGRectMake(combBtn.width-15-arrow.width, (combBtn.height-arrow.height)/2, arrow.width, arrow.height);
        combBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        combBtn.tag = 1000;
        [self addSubview:combBtn];
        
        
        UIInsetTextField *textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(30, combBtn.bottom+20, self.width-60, 40) rectInsetDX:10 rectInsetDY:0];
        textFiled.layer.borderColor = [UIColor colorWithHexString:@"c3c3c3"].CGColor;
        textFiled.layer.borderWidth = 0.5f;
        textFiled.placeholder = @"请输入运单号";
        textFiled.textColor = [UIColor colorWithHexString:@"333333"];
        textFiled.font = [UIFont systemFontOfSize:14.f];
        textFiled.keyboardType = UIKeyboardTypeEmailAddress;
        textFiled.tag = 100;
        [self addSubview:textFiled];
        
        CommandButton *qrBtn = [[CommandButton alloc] initWithFrame:CGRectMake(textFiled.right-textFiled.height, textFiled.top, textFiled.height, textFiled.height)];
        [qrBtn setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
        [self addSubview:qrBtn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, textFiled.bottom+18, self.width-30, 0)];
        lbl.text = [NSString stringWithFormat:@"收货人: %@\n地   址: %@\n电   话: %@",addressInfo.receiver, addressInfo.address,addressInfo.phoneNumber];;
        lbl.numberOfLines = 0;
        lbl.textColor  =[UIColor colorWithHexString:@"AAAAAA"];
        lbl.font = [UIFont systemFontOfSize:12.f];
        [lbl sizeToFit];
        lbl.frame = CGRectMake(15, textFiled.bottom+18, self.width-30, lbl.height);
        lbl.hidden = isShowAddress;
        [self addSubview:lbl];
        
        
        WEAKSELF;
        qrBtn.handleClickBlock = ^(CommandButton *sender) {
            QrCodeScanViewController *viewControler = [[QrCodeScanViewController alloc] init];
            viewControler.delegate = weakSelf;
            [[CoordinatingController sharedInstance] pushViewController:viewControler animated:YES];
        };
        
        combBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf toggleMailTypeListView];
        };
    }
    return self;
}

- (NSString*)mailSN {
    UIInsetTextField *textFiled = (UIInsetTextField*)[self viewWithTag:100];
    return [textFiled.text trim];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)toggleMailTypeListView
{
    UIView *combBtn = [self viewWithTag:1000];
    if (!_tableViewContainer) {
        _tableViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.height)];
        _tableViewContainer.layer.masksToBounds = YES;
        _tableViewContainer.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        _tableViewContainer.layer.borderWidth = 0.5f;
        _tableViewContainer.hidden = YES;
        _tableViewContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableViewContainer];
    }
    if (![_tableViewContainer viewWithTag:500]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
        tableView.tag = 500;
        [_tableViewContainer addSubview:tableView];
    }
    _tableViewContainer.hidden = ![_tableViewContainer isHidden];
    _tableViewContainer.frame = CGRectMake(combBtn.left, combBtn.bottom-0.5f, combBtn.width,self.height-combBtn.bottom-10);
    [_tableViewContainer viewWithTag:500].frame = _tableViewContainer.bounds;
    [(UITableView*)[_tableViewContainer viewWithTag:500] reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mailTypeList?[_mailTypeList count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Cell";
    
    UITableViewCell *tableViewCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    tableViewCell.textLabel.font = [UIFont systemFontOfSize:12.f];
    tableViewCell.textLabel.textColor = [UIColor colorWithHexString:@"282828"];
    
    
    MailTypeDO *mailTyeDO = (MailTypeDO*)[_mailTypeList objectAtIndex:[indexPath row]];
    tableViewCell.textLabel.text = mailTyeDO.mailCom;
    
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableViewContainer.hidden = YES;
    MailTypeDO *mailTyeDO = (MailTypeDO*)[_mailTypeList objectAtIndex:[indexPath row]];
    _selectedMailTypeDO = mailTyeDO;
    CommandButton *combBtn = (CommandButton*)[self viewWithTag:1000];
    [combBtn setTitle:mailTyeDO.mailCom forState:UIControlStateNormal];
}

- (void)processScanResults:(QrCodeScanViewController*)viewController data:(NSString*)data
{
    UIInsetTextField *textFiled = (UIInsetTextField*)[self viewWithTag:100];
    textFiled.text = data;
    [viewController dismiss];
}

+ (void)showInView:(UIView*)view
    isSecuredTrade:(BOOL)isSecuredTrade
      mailTypeList:(NSArray*)mailTypeList
       addressInfo:(AddressInfo*)addressInfo
   completionBlock:(BOOL (^)(NSString *mailSN, NSString* mailType))completionBlock
{
    DeliverInfoEditView *editView = [[DeliverInfoEditView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-50, isSecuredTrade?160+60:160) isSecuredTrade:isSecuredTrade mailTypeList:mailTypeList addressInfo:addressInfo isShowAddress:NO];
    
    __block PopupOverlayView *popupOverlayView = [[PopupOverlayView alloc] init];
    [popupOverlayView showInView:view conentView:editView confirmBlock:^{
        
        if ([editView.selectedMailTypeDO.mailType length]==0) {
            [[CoordinatingController sharedInstance] showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
            return;
        }
        if (editView.mailSN.length==0) {
            [[CoordinatingController sharedInstance] showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
            return;
        }
        
        [WCAlertView showAlertWithTitle:@""
                                message:@"请再次确认物流信息是否正确"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 0) {
                             
                         } else {
                             [popupOverlayView removeFromSuperview];
                             popupOverlayView = nil;
                             
                             if (completionBlock) {
                                 completionBlock(editView.mailSN, editView.selectedMailTypeDO.mailType);
                             }
                         }
                     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
    } cancelBlock:^{
        [popupOverlayView removeFromSuperview];
        popupOverlayView = nil;
    }];
    
}

+ (void)showInViewWithAdress:(UIView*)view
              isSecuredTrade:(BOOL)isSecuredTrade
                mailTypeList:(NSArray*)mailTypeList
                 addressInfo:(AddressInfo*)addressInfo
             completionBlock:(BOOL (^)(NSString *mailSN, NSString* mailType))completionBlock
{
    DeliverInfoEditView *editView = [[DeliverInfoEditView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-50, isSecuredTrade?160+60:160) isSecuredTrade:isSecuredTrade mailTypeList:mailTypeList addressInfo:addressInfo isShowAddress:YES];
    
    __block PopupOverlayView *popupOverlayView = [[PopupOverlayView alloc] init];
    [popupOverlayView showInView:view conentView:editView confirmBlock:^{
        
        if ([editView.selectedMailTypeDO.mailType length]==0) {
            [[CoordinatingController sharedInstance] showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
            return;
        }
        if (editView.mailSN.length==0) {
            [[CoordinatingController sharedInstance] showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
            return;
        }
        
        [WCAlertView showAlertWithTitle:@""
                                message:@"请再次确认物流信息是否正确"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 0) {
                             
                         } else {
                             [popupOverlayView removeFromSuperview];
                             popupOverlayView = nil;
                             
                             if (completionBlock) {
                                 completionBlock(editView.mailSN, editView.selectedMailTypeDO.mailType);
                             }
                         }
                     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
    } cancelBlock:^{
        [popupOverlayView removeFromSuperview];
        popupOverlayView = nil;
    }];
    
}

@end



@implementation SoldViewControllerForGoodsOrders

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"商品订单"];
    [super setupTopBarBackButton];
    
    self.tableView.frame = CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight);
    
    [super bringTopBarToTop];
}

- (void)initDataListLogic {
    WEAKSELF;
    
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"trade" path:@"goods_order_list" pageSize:20];
    self.dataListLogic.parameters = @{@"goods_id":self.goodsId?self.goodsId:@""};
    self.dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    self.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            NSDictionary *dict = [addedItems objectAtIndex:i];
            [newList addObject:[OrderTableViewCellSold buildCellDict:[OrderInfo createWithDict:[dict dictionaryValueForKey:@"order_info"]]]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        [weakSelf doCheckStartOrStopTheTimer];
    };
    self.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            NSDictionary *dict = [addedItems objectAtIndex:i];
            [newList addObject:[OrderTableViewCellSold buildCellDict:[OrderInfo createWithDict:[dict dictionaryValueForKey:@"order_info"]]]];
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
    self.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
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
    self.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton:@"无相关订单"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    self.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [self.dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}


@end





