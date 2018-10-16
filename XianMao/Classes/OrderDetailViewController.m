//
//  OrderDetailViewController.m
//  XianMao
//
//  Created by simon cai on 11/15/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailInfo.h"

#import "NetworkAPI.h"
#import "Session.h"

#import "OrderTableViewCell.h"
#import "JSONKit.h"

#import "Command.h"
#import "WebViewController.h"
#import "URLScheme.h"

#import "RecoverDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "WeakTimerTarget.h"

#import "UIActionSheet+Blocks.h"
#import "WCAlertView.h"
#import "TradeService.h"

#import "OfferedViewController.h"

@interface OrderDetailViewController ()

@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIView *contentView;

@property(nonatomic,strong) UIView *messageView;
@property(nonatomic,strong) UIView *addressInfoView;
@property(nonatomic,strong) UIView *mailInfoView;
@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) OrderDetailInfo *detailInfo;
@property(nonatomic,strong) NSMutableArray *orderIds;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,weak) UILabel *statusDescLbl;

@property (nonatomic, strong) OrderGoodsView *goodsView;
@end

@implementation OrderDetailViewController

//适配iOS7.0
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.goodsView layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"订单详情"];
    [super setupTopBarBackButton];
    
    _orderIds = [[NSMutableArray alloc] init];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    _scrollView.alwaysBounceVertical = YES;
    
    [self bringTopBarToTop];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)onTimer:(NSTimer*)theTimer
{
    BOOL stopTheTimer = YES;
    [_orderIds removeAllObjects];
    if (_detailInfo && _detailInfo.orderInfo && [_detailInfo.orderInfo.orderId length]>0) {
        OrderInfo *orderInfo = _detailInfo.orderInfo;
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
                        _statusDescLbl.text = orderInfo.statusDesc;
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
                        _statusDescLbl.text = orderInfo.statusDesc;
                    }
                    stopTheTimer = NO;
                    [_orderIds addObject:orderInfo.orderId];
                }
            }
        }
    }
    if ([_orderIds count]>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDoUpdateOrderInfoInDetailNotification object:_orderIds];
    }
    if (stopTheTimer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)loadData {
    WEAKSELF;
    _request = [[NetworkAPI sharedInstance] getOrderDetail:self.orderId completion:^(NSDictionary *orderDetail) {
        weakSelf.detailInfo = [OrderDetailInfo createWithDict:orderDetail];
        NSArray *subviews = [weakSelf.scrollView subviews];
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        UIView *contentView = [weakSelf buildContentView:weakSelf.detailInfo];
        [weakSelf.scrollView addSubview:contentView];
        if (weakSelf.scrollView.height<contentView.height)
        {
            weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.width, contentView.height);
        }
        weakSelf.contentView = contentView;
        
        [weakSelf.timer invalidate];
        WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
    }];
}

- (UIView*)buildContentView:(OrderDetailInfo*)detailInfo {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    
    CGFloat marginTop = 0.f;
    
    CALayer *topLayer = [CALayer layer];
    topLayer.backgroundColor = [UIColor colorWithHexString:@"282828"].CGColor;
    topLayer.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    [contentView.layer addSublayer:topLayer];
    
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 70)];
//    topView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    [contentView addSubview:topView];
//    marginTop += topView.height;
//    
//    UIButton *statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, marginTop, 100, 100)];
//    [statusBtn setTitle:@"退回中" forState:UIControlStateNormal];
//    [statusBtn setTitleColor:[UIColor colorWithHexString:@"2d2d2d"] forState:UIControlStateNormal];
//    [statusBtn setImage:[UIImage imageNamed:@"Wrist_Backing"] forState:UIControlStateNormal];
//    statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [statusBtn sizeToFit];
//    statusBtn.frame = CGRectMake((kScreenWidth-statusBtn.width)/2, 22, statusBtn.width, statusBtn.height);
//    [topView addSubview:statusBtn];
    
    UIButton *orderIdLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, marginTop, contentView.width, 40)];
    orderIdLbl.backgroundColor = [UIColor colorWithHexString:@"282828"];
    [orderIdLbl setTitle:[NSString stringWithFormat:@"订单号：%@",detailInfo.orderInfo.orderId] forState:UIControlStateDisabled];
    [orderIdLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [orderIdLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    orderIdLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    orderIdLbl.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    orderIdLbl.enabled = NO;
    [contentView addSubview:orderIdLbl];
    
    marginTop += orderIdLbl.height;
    marginTop += 20.f;
    
    OrderInfo *orderInfo = detailInfo.orderInfo;
    for (NSInteger i=0;i<[orderInfo.goodsList count];i++) {
        GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:i];
        self.goodsView = [[OrderGoodsView alloc] init];
        self.goodsView.frame = CGRectMake(0, marginTop, contentView.width, self.goodsView.height);
        
        WEAKSELF;
        self.goodsView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer){
            if (goodsInfo.serviceType == 10) {
//                RecoverDetailViewController *viewController = [[RecoverDetailViewController alloc] init];
                OfferedViewController *viewController = [[OfferedViewController alloc] init];
                viewController.goodID = goodsInfo.goodsId;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            } else {
                GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
                viewController.goodsId = goodsInfo.goodsId;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            }
        };
        
        [contentView addSubview:self.goodsView];
        
        [self.goodsView updateWithOrderInfo:goodsInfo orderInfo:orderInfo];
        marginTop += self.goodsView.height;
    }
    
    if ([orderInfo.goodsList count]>0) {
        marginTop += 30.f;
    }
    
    if (orderInfo.message && [orderInfo.message length]>0) {
        UIView *messageView = [self messageView:orderInfo.message];
        messageView.frame = CGRectMake(0, marginTop, messageView.width, messageView.height);
        [contentView addSubview:messageView];
        
        marginTop += messageView.height;
        marginTop += 35.f;
    }
    
    UIView *addressInfoView = [self addressInfoView:detailInfo.addressInfo];
    addressInfoView.frame = CGRectMake(0, marginTop, addressInfoView.width, addressInfoView.height);
    [contentView addSubview:addressInfoView];
    
    marginTop += addressInfoView.height;
    marginTop += 35.f;
    
    UIView *mailInfoView = [self mailInfoView:detailInfo.mailInfo orderInfo:detailInfo.orderInfo];
    mailInfoView.frame = CGRectMake(0, marginTop, mailInfoView.width, mailInfoView.height);
    [contentView addSubview:mailInfoView];
    
    marginTop += mailInfoView.height;
    
    
    //private int refund_status;// 退款状态 0未退款 1申请退款中 2退款结束
    //private long refund_remaining;// 退款倒计时
    
    WEAKSELF;
    if (detailInfo.orderInfo.payStatus == 2
        && detailInfo.orderInfo.shippingStatus == 0
        && detailInfo.orderInfo.payWay != PayWayOffline
        && detailInfo.orderInfo.securedStatus==0
        && (detailInfo.orderInfo.refund_enable || detailInfo.orderInfo.refund_status==1)
        && detailInfo.orderInfo.buyerId== [Session sharedInstance].currentUserId) {
        
        marginTop += 25;
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(0, marginTop, contentView.width, 1);
        [contentView.layer addSublayer:line];
        
        marginTop += line.bounds.size.height;
        marginTop += 20;
        
        if (detailInfo.orderInfo.refund_enable) {
            CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(contentView.width-15-90, marginTop, 90, 40)];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1.f;
            btn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5.f;
            btn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
            [btn setTitle:@"申请退款" forState:UIControlStateNormal];
            [contentView addSubview:btn];
            marginTop += btn.height;
            
            btn.handleClickBlock = ^(CommandButton *sender) {
                [UIActionSheet showInView:weakSelf.contentView
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
                                         [TradeService apply_refund:weakSelf.detailInfo.orderInfo.orderId reason:[NSString stringWithFormat:@"%ld",(long)reason] completion:^(OrderInfo *order_info) {
                                             [weakSelf hideHUD];
                                             SEL selector = @selector($$handleApplyRefundNotification:order_info:);
                                             MBGlobalSendNotificationForSELWithBody(selector, order_info);
                                         } failure:^(XMError *error) {
                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                         }];
                                     }
                                 }];
            };
            
        } else if (detailInfo.orderInfo.refund_status==1) {
            CommandButton *btn2 = [[CommandButton alloc] initWithFrame:CGRectMake(contentView.width-15-90, marginTop, 90, 40)];
            btn2.backgroundColor = [UIColor clearColor];
            [btn2 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
            btn2.layer.borderWidth = 1.f;
            btn2.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
            btn2.layer.masksToBounds = YES;
            btn2.layer.cornerRadius = 5.f;
            btn2.titleLabel.font = [UIFont systemFontOfSize:12.5f];
            [btn2 setTitle:@"撤销退款" forState:UIControlStateNormal];
            [contentView addSubview:btn2];
            marginTop += btn2.height;
            
            btn2.handleClickBlock = ^(CommandButton *sender) {
                
                [WCAlertView showAlertWithTitle:@"" message:@"确认撤销退款申请？" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (buttonIndex==0) {
                        
                    } else {
                        [weakSelf showProcessingHUD:nil];
                        [TradeService cancel_refund:weakSelf.detailInfo.orderInfo.orderId completion:^(OrderInfo *order_info) {
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
        marginTop += 25.f;
        
    } else {
        marginTop += 35.f;
    }
    
    contentView.frame = CGRectMake(0, 0, self.view.width, marginTop);
    
    return contentView;
}

- (void)$$handleApplyRefundNotification:(id<MBNotification>)notifi order_info:(OrderInfo*)order_info
{
    WEAKSELF;
    weakSelf.detailInfo.orderInfo = order_info;
    
    NSArray *subviews = [weakSelf.scrollView subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    UIView *contentView = [weakSelf buildContentView:weakSelf.detailInfo];
    [weakSelf.scrollView addSubview:contentView];
    if (weakSelf.scrollView.height<contentView.height)
    {
        weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.width, contentView.height);
    }
    weakSelf.contentView = contentView;
    
    [weakSelf.timer invalidate];
    WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
    weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    
}

- (void)$$handleCancelRefundNotification:(id<MBNotification>)notifi order_info:(OrderInfo*)order_info
{
    [self $$handleApplyRefundNotification:notifi order_info:order_info];
}


- (UIView*)messageView:(NSString*)message
{
    if (!_messageView) {
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        CGFloat marginTop = 0.f;
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.text = @"买家留言";
        titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        titleLbl.font = [UIFont systemFontOfSize:14.5f];
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(15, marginTop, titleLbl.width, titleLbl.height);
        [_messageView addSubview:titleLbl];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(15+titleLbl.width+15, marginTop+(titleLbl.height-1)/2, _messageView.width-15-(15+titleLbl.width+15), 1);
        [_messageView.layer addSublayer:line];
        
        marginTop += titleLbl.height;
        marginTop += 12.f;
        
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        messageLbl.text = message;
        messageLbl.font = [UIFont systemFontOfSize:14.f];
        messageLbl.numberOfLines = 0;
        messageLbl.frame = CGRectMake(15, marginTop, _messageView.width-15-15, 0);
        [messageLbl sizeToFit];
        messageLbl.frame = CGRectMake(15, marginTop, _messageView.width-15-15, messageLbl.height);
        [_messageView addSubview:messageLbl];
        
        marginTop += _messageView.height;
        marginTop += 12.f;
        
         _messageView.frame = CGRectMake(0, 0, self.view.width, marginTop);
    }
    return _messageView;
}

- (UIView*)addressInfoView:(AddressInfo*)addressInfo {
    if (!_addressInfoView) {
        _addressInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        CGFloat marginTop = 0.f;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.text = @"收货信息";
        titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        titleLbl.font = [UIFont systemFontOfSize:14.5f];
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(15, marginTop, titleLbl.width, titleLbl.height);
        [_addressInfoView addSubview:titleLbl];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(15+titleLbl.width+15, marginTop+(titleLbl.height-1)/2, _addressInfoView.width-15-(15+titleLbl.width+15), 1);
        [_addressInfoView.layer addSublayer:line];
        
        marginTop += titleLbl.height;
        marginTop += 12.f;
        
        UILabel *receiverLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        receiverLbl.text = [NSString stringWithFormat:@"联系人：    %@",addressInfo.receiver];
        receiverLbl.font = [UIFont systemFontOfSize:14.f];
        [receiverLbl sizeToFit];
        receiverLbl.frame = CGRectMake(15, marginTop, _addressInfoView.width-15-15, receiverLbl.height);
        [_addressInfoView addSubview:receiverLbl];
        
        marginTop += receiverLbl.height;
        marginTop += 12.f;
        
        UILabel *phoneNumberLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        phoneNumberLbl.text = [NSString stringWithFormat:@"手机号：    %@",addressInfo.phoneNumber];
        phoneNumberLbl.font = [UIFont systemFontOfSize:14.f];
        [phoneNumberLbl sizeToFit];
        phoneNumberLbl.frame = CGRectMake(15, marginTop, _addressInfoView.width-15-15, phoneNumberLbl.height);
        [_addressInfoView addSubview:phoneNumberLbl];
        
        marginTop += phoneNumberLbl.height;
        marginTop += 12.f;
        
        
        UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        addressTitleLbl.text = [NSString stringWithFormat:@"收货地址："];
        addressTitleLbl.font = [UIFont systemFontOfSize:14.f];
        [addressTitleLbl sizeToFit];
        addressTitleLbl.frame = CGRectMake(15, marginTop, addressTitleLbl.width, addressTitleLbl.height);
        [_addressInfoView addSubview:addressTitleLbl];
        
        CGFloat addressMarginLeft = addressTitleLbl.left+addressTitleLbl.width+2.f;
        
        UILabel *areaDetailLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        areaDetailLbl.text = [NSString stringWithFormat:@"%@",addressInfo.areaDetail];
        areaDetailLbl.font = [UIFont systemFontOfSize:14.f];
        areaDetailLbl.frame = CGRectMake(addressMarginLeft, marginTop, _addressInfoView.width-addressMarginLeft-15, 0);
        areaDetailLbl.numberOfLines = 0;
        [areaDetailLbl sizeToFit];
        areaDetailLbl.frame = CGRectMake(addressMarginLeft, marginTop, _addressInfoView.width-addressMarginLeft-15, areaDetailLbl.height);
        [_addressInfoView addSubview:areaDetailLbl];
        
        marginTop += areaDetailLbl.height;
        marginTop += 12.f;
        
        UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        addressLbl.text = [NSString stringWithFormat:@"%@",addressInfo.address];
        addressLbl.font = [UIFont systemFontOfSize:14.f];
        addressLbl.numberOfLines = 0;
        addressLbl.frame = CGRectMake(addressMarginLeft, marginTop, _addressInfoView.width-addressMarginLeft-15, 0);
        [addressLbl sizeToFit];
        addressLbl.frame = CGRectMake(addressMarginLeft, marginTop, _addressInfoView.width-addressMarginLeft-15, addressLbl.height);
        [_addressInfoView addSubview:addressLbl];
        
        marginTop += addressLbl.height;
        
        _addressInfoView.frame = CGRectMake(0, 0, self.view.width, marginTop);
    }
    return _addressInfoView;
}

- (UIView*)mailInfoView:(MailInfo*)mailInfo orderInfo:(OrderInfo*)orderInfo {
    if (!_mailInfoView) {
        _mailInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        CGFloat marginTop = 0.f;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.text = @"物流信息";
        titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        titleLbl.font = [UIFont systemFontOfSize:14.5f];
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(15, marginTop, titleLbl.width, titleLbl.height);
        [_mailInfoView addSubview:titleLbl];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(15+titleLbl.width+15, marginTop+(titleLbl.height-1)/2, kScreenWidth-15-(15+titleLbl.width+15), 1);
        [_mailInfoView.layer addSublayer:line];
        
        marginTop += titleLbl.height;
        marginTop += 12.f;
        
        NSString *statusString = @"未知";
//        if (orderInfo.orderStatus == 0) {
//            statusString = @"进行中";
//            if (orderInfo.payStatus == 0) {
//                statusString = @"待付款";
//            } else if (orderInfo.payStatus == 2) {
//                statusString = @"已付款";
//                if (orderInfo.shippingStatus == 0) {
//                    statusString = @"未发货";
//                } else if (orderInfo.shippingStatus == 1) {
//                    statusString = @"已发货";
//                } else if (orderInfo.shippingStatus == 2) {
//                    statusString = @"已收货";
//                }
//            }
//        } else if (orderInfo.orderStatus == 1) {
//            statusString = @"交易完成";
//        } else if (orderInfo.orderStatus == 2) {
//            statusString = @"已取消";
//        } else if (orderInfo.orderStatus == 3) {
//            statusString = @"订单无效";
//        }
        statusString = orderInfo.statusDesc;
        UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        statusLbl.text = [NSString stringWithFormat:@"当前状态："];
        statusLbl.font = [UIFont systemFontOfSize:14.f];
        statusLbl.frame = CGRectMake(15, marginTop, _mailInfoView.width-15-15, 0);
        statusLbl.numberOfLines = 0;
        [statusLbl sizeToFit];
        statusLbl.frame = CGRectMake(15, marginTop, statusLbl.width, statusLbl.height);
        [_mailInfoView addSubview:statusLbl];
        
        CGFloat marginLeft = statusLbl.right;
        
        UILabel *statusDescLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        statusDescLbl.text = [NSString stringWithFormat:@"%@",statusString];
        statusDescLbl.font = [UIFont systemFontOfSize:14.f];
        statusDescLbl.frame = CGRectMake(marginLeft, marginTop, _mailInfoView.width-15-marginLeft, 0);
        statusDescLbl.numberOfLines = 0;
        statusDescLbl.textAlignment = NSTextAlignmentLeft;
        [statusDescLbl sizeToFit];
        statusDescLbl.frame = CGRectMake(marginLeft, marginTop, _mailInfoView.width-15-marginLeft, statusDescLbl.height);
        [_mailInfoView addSubview:statusDescLbl];
        _statusDescLbl = statusDescLbl;
        
        if (statusDescLbl.height>statusLbl.height) {
            marginTop += statusDescLbl.height;
        } else {
            marginTop += statusLbl.height;
        }
        marginTop += 12.f;

        UILabel *mailCOMLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        mailCOMLbl.text = [NSString stringWithFormat:@"快递公司： %@",mailInfo.mailCOM?mailInfo.mailCOM:@"未知"];
        mailCOMLbl.font = [UIFont systemFontOfSize:14.f];
        [mailCOMLbl sizeToFit];
        mailCOMLbl.frame = CGRectMake(15, marginTop, _mailInfoView.width-15-15, mailCOMLbl.height);
        [_mailInfoView addSubview:mailCOMLbl];
        
        marginTop += mailCOMLbl.height;
        marginTop += 12.f;
        
        UILabel *mailSNLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        mailSNLbl.text = [NSString stringWithFormat:@"快递单号： %@",mailInfo.mailSN?mailInfo.mailSN:@"未知"];
        mailSNLbl.font = [UIFont systemFontOfSize:14.f];
        [mailSNLbl sizeToFit];
        mailSNLbl.frame = CGRectMake(15, marginTop, _mailInfoView.width-15-15, mailSNLbl.height);
        [_mailInfoView addSubview:mailSNLbl];
        
        marginTop += mailSNLbl.height;
        marginTop += 12.f;
        
        UILabel *logisticsLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        logisticsLbl.text = @"物流状态：";
        logisticsLbl.font = [UIFont systemFontOfSize:14.f];
        [logisticsLbl sizeToFit];
        logisticsLbl.frame = CGRectMake(15, marginTop, logisticsLbl.width, logisticsLbl.height);
        [_mailInfoView addSubview:logisticsLbl];
        
        CommandButton *logisticsBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
        logisticsBtn.backgroundColor = [UIColor clearColor];
        logisticsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [logisticsBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        logisticsBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [logisticsBtn sizeToFit];
        logisticsBtn.frame = CGRectMake(logisticsLbl.left+logisticsLbl.width+2, marginTop-(logisticsBtn.height-logisticsLbl.height)/2, 100, logisticsBtn.height);
        [_mailInfoView addSubview:logisticsBtn];
        
        marginTop += logisticsLbl.height;
        _mailInfoView.frame = CGRectMake(0, 0, self.view.width, marginTop);
        
        WEAKSELF;
        logisticsBtn.handleClickBlock = ^(CommandButton *sender) {
            NSString *html5Url = kURLLogisticsFormat(weakSelf.detailInfo.orderInfo.orderId);
            
//            weakSelf.request = [[NetworkAPI sharedInstance] logistics:weakSelf.detailInfo.orderInfo.orderId completion:^(NSString *html5Url) {
                WebViewController *viewController = [[WebViewController alloc] init];
                viewController.title = @"物流信息";
                viewController.url = html5Url;
                [weakSelf pushViewController:viewController animated:YES];
//            } failure:^(XMError *error) {
//                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
//            }];
        };
    }
    return _mailInfoView;
}

//
//- (NSString*)orderStatusString
//{
//    NSString *status = @"未知";
//    switch (_orderStatus) {
//        case 0: status = @"进行中"; break;
//        case 1: status = @"交易完成"; break;
//        case 2: status = @"已取消"; break;
//        case 3: status = @"无效"; break;
//    }
//    return status;
//}
//
//- (NSString*)payStatusString
//{
//    NSString *status = @"未知";
//    switch (_payStatus) {
//        case 0: status = @"待付款"; break;
//        case 2: status = @"已付款"; break;
//    }
//    return status;
//}
//
//- (NSString*)shippingStatusString
//{
//    NSString *status = @"未知";
//    switch (_shippingStatus) {
//        case 0: status = @"未发货"; break;
//        case 1: status = @"已发货"; break;
//        case 2: status = @"已收货"; break;
//    }
//    return status;
//}

@end


