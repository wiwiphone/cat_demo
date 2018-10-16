//
//  ScanCodePaymentViewController.m
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ScanCodePaymentViewController.h"
#import "RentalView.h"
#import "CouponView.h"
#import "PayWayButton.h"
#import "NetworkAPI.h"
#import "PayWayDO.h"
#import "Error.h"
#import "BonusInfo.h"
#import "PayViewController.h"
#import "PayManager.h"
#import "WCAlertView.h"
#import "BoughtCollectionViewController.h"
#import "XiHuOrderSuccessViewController.h"
#import "RentalSubView.h"


@interface ScanCodePaymentViewController ()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) RentalView * consumer_online;
@property (nonatomic, strong) RentalSubView * consumer_offline;
@property (nonatomic, strong) UIButton * extendButton;
@property (nonatomic, strong) UIButton * payOrderButton;
@property (nonatomic, strong) CouponView * couponView;
@property (nonatomic, strong) UILabel * chooseTitle;
@property (nonatomic, strong) NSArray * payWayList;
@property (nonatomic, copy) NSString * total_price; //消费总额
@property (nonatomic, copy) NSString * deductible_amount; // 免线上支付金额
@property (nonatomic, strong) NSMutableArray * bonusItemArray;
@property (nonatomic, strong) BonusInfo * bonusInfo;
@property (nonatomic, assign) NSInteger pay_way;
@property (nonatomic, assign) BOOL * isRequest;
@property (nonatomic, copy) NSString * tempStr;





@end

@implementation ScanCodePaymentViewController

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}

-(RentalView *)consumer_online{
    if (!_consumer_online) {
        _consumer_online = [[RentalView alloc] initWithFrame:CGRectZero title:@"消费总额:"];
        _consumer_online.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _consumer_online.layer.borderWidth = 1;
        _consumer_online.layer.masksToBounds = YES;
        _consumer_online.layer.cornerRadius = 25;
    }
    return _consumer_online;
}

-(RentalSubView *)consumer_offline{
    if (!_consumer_offline) {
        _consumer_offline = [[RentalSubView alloc] initWithFrame:CGRectZero title:@"免线上支付金额:"];
        _consumer_offline.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _consumer_offline.layer.borderWidth = 1;
        _consumer_offline.layer.masksToBounds = YES;
        _consumer_offline.layer.cornerRadius = 25;
        _consumer_offline.hidden = YES;
    }
    return _consumer_offline;
}

-(UIButton *)extendButton{
    if (!_extendButton) {
        _extendButton = [[UIButton alloc] init];
        [_extendButton setImage:[UIImage imageNamed:@"extendButton"] forState:UIControlStateNormal];
        [_extendButton setImage:[UIImage imageNamed:@"extendButton2"] forState:UIControlStateSelected];
        [_extendButton setTitle:@"输入免线上支付金额" forState:UIControlStateNormal];
        [_extendButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        _extendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_extendButton setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
    }
    return _extendButton;
}

-(CouponView *)couponView{
    if (!_couponView) {
        _couponView = [[CouponView alloc] initWithFrame:CGRectZero];
    }
    return _couponView;
}

-(UIButton *)payOrderButton{
    if (!_payOrderButton) {
        _payOrderButton = [[UIButton alloc] init];
        [_payOrderButton setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
        [_payOrderButton setTitle:@"确认支付" forState:UIControlStateNormal];
        _payOrderButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_payOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payOrderButton.enabled = NO;
        _payOrderButton.layer.masksToBounds = YES;
        _payOrderButton.layer.cornerRadius = 33/2;
        
    }
    return _payOrderButton;
}

-(UILabel *)chooseTitle{
    if (!_chooseTitle) {
        _chooseTitle = [[UILabel alloc] init];
        _chooseTitle.text = @"选择支付方式";
        _chooseTitle.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _chooseTitle.font = [UIFont systemFontOfSize:12];
        [_chooseTitle sizeToFit];
    }
    return _chooseTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pay_way = -1;
    [super setupTopBar];
    [super setupTopBarTitle:self.topBarTitle];
    [super setupTopBarBackButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.scrollView];
    [super bringTopBarToTop];
    [self.scrollView addSubview:self.consumer_online];
    [self.scrollView addSubview:self.extendButton];
    [self.scrollView addSubview:self.consumer_offline];
    [self.scrollView addSubview:self.couponView];
    [self.scrollView addSubview:self.payOrderButton];
    [self.scrollView addSubview:self.chooseTitle];
    [self payWayListNetwork];
  
    [self.extendButton addTarget:self action:@selector(extendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.payOrderButton addTarget:self action:@selector(payOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isFromOrder && self.orderInfo) {
        [self.payOrderButton setTitle:@"计算中..." forState:UIControlStateNormal];
        [self.consumer_online getOrderPrice:self.orderInfo];
        self.total_price = [NSString stringWithFormat:@"%.2f",self.orderInfo.totalPrice];
        self.deductible_amount = [NSString stringWithFormat:@"%.2f",self.orderInfo.reward_money_pay];
        
        if (self.deductible_amount.doubleValue > 0) {
            self.consumer_offline.hidden = NO;
            [self.consumer_offline getreWardMoneyPay:self.orderInfo];
            [self layoutViews];
        }else{
            self.consumer_offline.hidden = YES;
            [self.consumer_offline getreWardMoneyPay:self.orderInfo];
            [self layoutViews];
        }
        
        [self userBonusListNetWork];
        
    }
    
    WEAKSELF;
    self.consumer_online.sumOfConsumption= ^(NSString * string){
        weakSelf.total_price = string;
        [weakSelf userBonusListNetWork];
    };
    
    
    self.consumer_offline.sumOfConsumption= ^(NSString * string){
        weakSelf.deductible_amount = string;
        [weakSelf userBonusListNetWork];
    };
    
    self.couponView.selectBouns = ^(NSMutableArray * bounsArray){
        PayQuanViewController * viewController = [[PayQuanViewController alloc] init];
        viewController.quanItemList = bounsArray;
        viewController.seletedBonusInfo = weakSelf.bonusInfo;
        viewController.isHaveUnableLbl = YES;
        viewController.handleDidSelectBonusInfo =^(PayQuanViewController *viewController, BonusInfo *bonusInfo){
            [viewController dismiss:YES];
           CGFloat preferentialpPrice =  [weakSelf.couponView getBounsInfo:bonusInfo];
            _bonusInfo = bonusInfo;
            
            NSString * orderPrice = [NSString stringWithFormat:@"%.2f",weakSelf.total_price.doubleValue-self.deductible_amount.doubleValue-preferentialpPrice];
            [weakSelf.payOrderButton setTitle:[NSString stringWithFormat:@"确认支付%.2f元",(orderPrice.doubleValue>0?orderPrice.doubleValue:0)] forState:UIControlStateNormal];
            weakSelf.payOrderButton.enabled = YES;//doubleValue
            weakSelf.payOrderButton.backgroundColor = [UIColor colorWithHexString:@"f4433e"];
            
        };
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    };
    
    
    //消费总额变化,,,,免线上支付价格重置为0
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(totalPriceChange:) name:@"totalPriceChange" object:nil];

}

- (void)totalPriceChange:(NSNotification *)n{
    
    UITextField * tf = n.object;
    if (tf.tag == 1229) {
        self.deductible_amount = @"0";
    }

}

//支付取消
- (void)$$handlePayResultCancelNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds{
    BoughtCollectionViewController * viewCtrl = [[BoughtCollectionViewController alloc] init];
    [self pushViewController:viewCtrl animated:YES];
}

//支付成功
- (void)$$handlePayResultCompletionNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds{
    XiHuOrderSuccessViewController * viewCtrl = [[XiHuOrderSuccessViewController alloc] init];
    viewCtrl.presentPriceStr = self.total_price;
    viewCtrl.consumePriceStr = self.deductible_amount;
    [self pushViewController:viewCtrl animated:YES];
}

- (void)payWayListNetwork{
    WEAKSELF;
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"store" path:@"pay_way_list" parameters:nil completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        NSArray * payWayList = data[@"pay_way_list"];
        _payWayList = payWayList;
        if (payWayList && payWayList.count > 0) {
            for (int i = 0; i < payWayList.count; i++) {
                PayWayButton * payWay = [[PayWayButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                payWay.backgroundColor = [UIColor whiteColor];
                payWay.tag = 1126+i;
                NSDictionary * dict = [payWayList objectAtIndex:i];
                PayWayDO * payWayDO = [[PayWayDO alloc] initWithJSONDictionary:dict error:nil];
                payWay.payWayDO = payWayDO;
                if (i == 0) {
                    payWay.selectedButton.selected = YES;
                    self.pay_way = payWay.payWayDO.pay_way;
                    NSLog(@"12423143242314321423423----%ld",(long)payWay.payWayDO.pay_way);
                }
                [self.scrollView addSubview:payWay];
                [payWay addTarget:self action:@selector(payWayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        [weakSelf layoutViews];
        
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
}

- (void)userBonusListNetWork{
    
    WEAKSELF;
    weakSelf.payOrderButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
    weakSelf.payOrderButton.enabled = NO;
    [weakSelf.payOrderButton setTitle:@"计算中..." forState:UIControlStateNormal];
    double delayInSeconds = 1.0;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        
        NSDictionary * paramters = @{@"total_price":self.total_price?self.total_price:@"",
                                     @"deductible_amount":self.deductible_amount?self.deductible_amount:@""};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"store" path:@"user_bonus_list" parameters:paramters completionBlock:^(NSDictionary *data) {
            NSArray * array = [data arrayValueForKey:@"list"];
            CGFloat preferentialpPrice = 0;
            NSMutableArray * bonusItemArray = [[NSMutableArray alloc] init];
            if (array && array.count > 0) {
                for (NSDictionary * dict in array) {
                    BonusInfo * bouns = [BonusInfo createWithDict:dict];
                    [bonusItemArray addObject:bouns];
                }
                
                _bonusItemArray = bonusItemArray;
                _bonusInfo = [weakSelf.couponView getbouns:self.bonusItemArray];
                preferentialpPrice = _bonusInfo.amount;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary * dict = @{@"total_price":self.total_price?self.total_price:@"",
                                        @"deductible_amount":self.deductible_amount?self.deductible_amount:@""};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:deductibleAmountNotification object:self.bonusInfo userInfo:dict];
            });
            
            
            [weakSelf.couponView getBounsInfo:self.bonusInfo];
            NSString * orderPrice = [NSString stringWithFormat:@"%.2f",self.total_price.doubleValue-self.deductible_amount.doubleValue-preferentialpPrice];
            [weakSelf.payOrderButton setTitle:[NSString stringWithFormat:@"确认支付%.2f元",(orderPrice.doubleValue>0?orderPrice.doubleValue:0)] forState:UIControlStateNormal];
            weakSelf.payOrderButton.enabled = YES;
            weakSelf.payOrderButton.backgroundColor = [UIColor colorWithHexString:@"f4433e"];
        } failure:^(XMError *error) {
            [self showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
        
    });
    
    
}


- (void)payWayButtonClick:(PayWayButton *)button
{
    NSInteger tag = button.tag;
    for (int i = 0; i < _payWayList.count; i++) {
        PayWayButton * btn = [self.view viewWithTag:i+1126];
        if (btn.tag == tag && btn.selected == 1) {
            btn.selected = NO;
            btn.selectedButton.selected = NO;
            break ;
        }
        if (btn.tag == tag) {
            btn.selected = YES;
            btn.selectedButton.selected = YES;
        } else {
            btn.selected = NO;
            btn.selectedButton.selected = NO;
        }
    }
    
    if (button.selected) {
        self.pay_way = button.payWayDO.pay_way;
    }else{
        self.pay_way = -1;
    }
}

- (void)payOrderButtonClick:(UIButton *)button{
    

        BOOL isValid = [self savePayInfo];
        if (isValid) {
            PayWayType payway = self.pay_way;
            if (PayWayWxpay == payway && ![WXApi isWXAppInstalled]) {
                [self showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
                return;
            }
            NSString *bonusId;
            if (self.bonusInfo) {
                if (![self.bonusInfo.bonusId isEqualToString:@"-1000"]) {
                    bonusId = self.bonusInfo.bonusId;
                }else{
                    bonusId = @"";
                }
            }else{
                bonusId = @"";
            }
            NSInteger storeId = self.orderInfo?self.orderInfo.sellerId:self.userId;
            
            NSDictionary * paras = @{@"store_id":[NSNumber numberWithInteger:storeId],
                                     @"pay_way":[NSNumber numberWithInteger:self.pay_way],
                                     @"bonus_id":bonusId,
                                     @"deductible_amount":self.deductible_amount?self.deductible_amount:@"",
                                     @"total_price":self.total_price?self.total_price:@"",
                                     @"order_id":self.orderId?self.orderId:@""};
            
            [self showProcessingHUD:nil];
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"store" path:@"pay_store" parameters:paras completionBlock:^(NSDictionary *data) {
                [[CoordinatingController sharedInstance] hideHUD];
                
                if(_pay_way == PayWayAlipay) {
                    NSString *payUrl = [data stringValueForKey:@"pay_url"];
                    if (payUrl && [payUrl length]>0) {
                        [PayManager pay:payUrl];
                    }
                } else if (_pay_way == PayWayWxpay) {
                    NSDictionary *payReq = [data objectForKey:@"pay_req"];
                    PayReq *request = nil;
                    if (payReq != nil && [payReq isKindOfClass:[NSDictionary class]]) {
                        request = [[PayReq alloc] init];
                        request.openID = [payReq stringValueForKey:@"appid"];
                        request.partnerId = [payReq stringValueForKey:@"partnerid"];
                        request.prepayId= [payReq stringValueForKey:@"prepayid"];
                        request.package = [payReq stringValueForKey:@"packagestr"];
                        request.nonceStr= [payReq stringValueForKey:@"noncestr"];
                        request.timeStamp = [[payReq stringValueForKey:@"timestamp"] intValue];
                        request.sign= [payReq stringValueForKey:@"sign"];
                        
                        [PayManager weixinPay:request];
                    }
                }
                
                
            } failure:^(XMError *error) {
                [self showHUD:[error errorMsg] hideAfterDelay:1.2];
            } queue:nil]];
            
        }
}

-(BOOL)savePayInfo
{
    BOOL isValid = YES;

    if (isValid) {
        if (self.pay_way == -1) {
            [WCAlertView showAlertWithTitle:nil message:@"请选择付款方式" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            isValid = NO;
        }
    }
    return isValid;
}


- (void)extendButtonClick:(UIButton *)button{
    self.consumer_offline.hidden = !self.consumer_offline.hidden;
    button.selected = !button.selected;
    
    //免线上支付隐藏  重置免线上支付价格为0 重新算价格
    if (self.consumer_offline.hidden) {
        self.deductible_amount = @"0";
        self.consumer_offline.tf.text = @"";
    }
    [self userBonusListNetWork];
    [self layoutViews];
}

- (void)layoutViews {
    
    CGFloat marginTop = 114;
    self.consumer_online.frame = CGRectMake(24, marginTop, kScreenWidth-48, 50);
    marginTop += 50;
    self.extendButton.frame = CGRectMake(0, marginTop, kScreenWidth, 38);
    marginTop += 38;
    if (self.consumer_offline.hidden) {
        self.consumer_offline.frame = CGRectMake(24, marginTop, kScreenWidth-48, 0);
        marginTop += 0;
        marginTop += 0;
    }else{
        self.consumer_offline.frame = CGRectMake(24, marginTop, kScreenWidth-48, 50);
        marginTop += 50;
        marginTop += 40;
    }
    self.couponView.frame = CGRectMake(0, marginTop, kScreenWidth, 44);
    
    marginTop += 44;
    self.chooseTitle.frame = CGRectMake(18, marginTop, kScreenWidth, 40);
    marginTop += 40;
    for (int i = 0; i < self.payWayList.count; i++) {
        PayWayButton * payWay = [self.view viewWithTag:1126+i];
        payWay.frame = CGRectMake(0, marginTop, kScreenWidth, 44);
        marginTop += 44;
    }
    
    marginTop += 30;
    self.payOrderButton.frame = CGRectMake(kScreenWidth/375*95, marginTop, kScreenWidth-2*kScreenWidth/375*95, 33);
    marginTop += 40;
    
    
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, marginTop);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"totalPriceChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deductibleAmountNotification object:nil];
}

@end
