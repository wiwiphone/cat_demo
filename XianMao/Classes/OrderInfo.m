//
//  OrderInfo.m
//  XianMao
//
//  Created by simon on 12/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "OrderInfo.h"
#import "GoodsInfo.h"
#import "PayOrderWayVo.h"

@implementation OrderInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)totalPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_totalPrice_cent);
}

- (double)actual_pay {
    return CENT_INTEGER_TO_FLOAT_YUAN(_actual_pay_cent);
}

- (double)bonus_pay {
    return CENT_INTEGER_TO_FLOAT_YUAN(_bonus_pay_cent);
}

- (double)reward_money_pay {
    return CENT_INTEGER_TO_FLOAT_YUAN(_reward_money_pay_cent);
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _buyerId = [dict integerValueForKey:@"buyer_id" defaultValue:0];
        _sellerId = [dict integerValueForKey:@"seller_id" defaultValue:0];
        
        _orderId = [dict stringValueForKey:@"orderId"];
        _createTime = [dict longLongValueForKey:@"create_time" defaultValue:0];
        
        NSMutableArray *goodsList = [[NSMutableArray alloc] init];
        NSArray *goodsListDicts = [dict arrayValueForKey:@"goods_list"];
        for (NSInteger i=0; i<[goodsListDicts count]; i++) {
            NSDictionary *dict = [goodsListDicts objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
               [goodsList addObject:[GoodsInfo createWithDict:dict]];
            }
        }
        _goodsList = goodsList;
        _orderStatus = [dict integerValueForKey:@"order_status" defaultValue:0];
        _payStatus = [dict integerValueForKey:@"pay_status" defaultValue:0];
        _shippingStatus = [dict integerValueForKey:@"shipping_status" defaultValue:0];
        _payWay = [dict integerValueForKey:@"pay_way" defaultValue:0];
        
        _totalPrice = [[dict decimalNumberKey:@"total_price"] doubleValue];
        _actual_pay = [[dict decimalNumberKey:@"actual_pay"] doubleValue];
        _bonus_pay = [[dict decimalNumberKey:@"bonus_pay"] doubleValue];
        _reward_money_pay = [[dict decimalNumberKey:@"reward_money_pay"] doubleValue];
        
        _totalPrice_cent = [dict integerValueForKey:@"total_price_cent"];
        _actual_pay_cent = [dict integerValueForKey:@"actual_pay_cent"];
        _bonus_pay_cent = [dict integerValueForKey:@"bonus_pay_cent"];
        _reward_money_pay_cent = [dict integerValueForKey:@"reward_money_pay_cent"];
        _mailInfo = [MailInfo createWithDict:[dict dictionaryValueForKey:@"mail_info"]];
        _statusDesc = [dict stringValueForKey:@"status_desc"];
        
        _securedStatus = [dict integerValueForKey:@"secured_status" defaultValue:0];
        _tradeType = [dict integerValueForKey:@"trade_type" defaultValue:0];
        
        _message = [dict stringValueForKey:@"message"];
        _receive_remaining = [dict integerValueForKey:@"receive_remaining" defaultValue:0];
        _pay_remaining = [dict integerValueForKey:@"pay_remaining" defaultValue:0];
        _buttonStats = [dict integerValueForKey:@"buttonStats" defaultValue:0];
        
        _copy_enable = [dict integerValueForKey:@"copy_enable" defaultValue:0]>0?YES:NO;

        
        _adm_money_pay = [[dict decimalNumberKey:@"adm_money_pay"] doubleValue];
        _adm_money_pay_cent = [dict integerValueForKey:@"adm_money_pay_cent"];
        
        _refund_enable = [dict integerValueForKey:@"refund_enable"]>0?YES:NO;
        _refund_status = [dict integerValueForKey:@"refund_status"];
        _refund_remaining = [dict integerValueForKey:@"refund_remaining"];
        
        _mail_price = [dict doubleValueForKey:@"mail_price"];
        _mail_price_cent = [dict doubleValueForKey:@"mail_price_cent"];
        
        _remain_price = [dict doubleValueForKey:@"remain_price"];
        
        _pay_time = [dict longLongValueForKey:@"pay_time"];
        _finish_time = [dict longLongValueForKey:@"finish_time"];
        _logic_type = [dict integerValueForKey:@"logic_type"];
        
        _user = [[User alloc] initWithDict:dict[@"userVo"]];
        _buyer = [[User alloc] initWithDict:dict[@"buyerVo"]];
        _statusDescIcon = [dict stringValueForKey:@"statusDescIcon"];
        _shortStatusDesc = [dict stringValueForKey:@"shortStatusDesc"];
        _repurchase_status = [dict integerValueForKey:@"repurchase_status"];
        
        NSMutableArray * payOrderWayList = [[NSMutableArray alloc] init];
        NSArray * payWayArr = [dict arrayValueForKey:@"payOrderWayList"];
        for (NSDictionary * dict in payWayArr) {
            [payOrderWayList addObject:[PayOrderWayVo createWithDict:dict]];
        }
        _payOrderWayList = payOrderWayList;
        _payTipVo = [[PayTipVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"payTipVo"]];
    }
    return self;
}

- (void)updateWithStatusInfo:(OrderStatusInfo*)statusInfo
{
    _orderStatus = statusInfo.orderStatus;
    _payStatus = statusInfo.payStatus;
    _shippingStatus = statusInfo.shippingStatus;
    _statusDesc = statusInfo.statusDesc;
    _securedStatus = statusInfo.securedStatus;
}

- (BOOL)isWaitingForPay
{
    return _orderStatus==0&&_payStatus==0?YES:NO;
}

- (BOOL)isConsignOrder
{
    return _tradeType==1;
}

- (NSString*)orderStatusString
{
    NSString *status = @"未知";
    switch (_orderStatus) {
        case 0: status = @"进行中"; break;
        case 1: status = @"交易完成"; break;
        case 2: status = @"已取消"; break;
        case 3: status = @"订单无效"; break;
    }
    return status;
}

- (NSString*)payStatusString
{
    NSString *status = @"未知";
    switch (_payStatus) {
        case 0: status = @"待付款"; break;
        case 2: status = @"已付款"; break;
    }
    return status;
}

- (NSString*)shippingStatusString
{
    NSString *status = @"未知";
    switch (_shippingStatus) {
        case 0: status = @"未发货"; break;
        case 1: status = @"已发货"; break;
        case 2: status = @"已收货"; break;
    }
    return status;
}

- (NSAttributedString*)refund_remainingString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"仅剩"];
    
    NSInteger remainTime = self.refund_remaining;
    NSInteger days = remainTime/(3600*24);
    NSInteger hours = (remainTime-days*3600*24)/3600;
    NSInteger mins = (remainTime%3600)/60;
    NSInteger seconds = (remainTime%3600)%60;
    
    int count = 0;
    if (days>0) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d天",(int)days]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    if ((hours>0||days>0) && count<2) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d小时",(int)hours]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-2)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    if (count<2) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d分",(int)mins]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    if (count<2) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d秒",(int)seconds]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    return attrString;
}

- (NSAttributedString*)receive_remainingString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"仅剩"];
    
    NSInteger remainTime = self.receive_remaining;
    NSInteger days = remainTime/(3600*24);
    NSInteger hours = (remainTime-days*3600*24)/3600;
    NSInteger mins = (remainTime%3600)/60;
    NSInteger seconds = (remainTime%3600)%60;
    
    int count = 0;
    if (days>0) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d天",(int)days]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    if ((hours>0||days>0) && count<2) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d小时",(int)hours]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-2)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    if (count<2) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d分",(int)mins]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    if (count<2) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d秒",(int)seconds]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
        count+=1;
    }
    return attrString;
}

- (NSAttributedString*)pay_remainingString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSInteger remainTime = self.pay_remaining;
    NSInteger mins = (remainTime%3600)/60;
    NSInteger seconds = (remainTime%3600)%60;
    
    if (mins>0) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d分",(int)mins]];
        [tmp addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"c2a79d"]
                           range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
    }
    if (seconds>0) {
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d秒",(int)seconds]];
        [tmp addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"c2a79d"]
                    range:NSMakeRange(0,tmp.length-1)];
        [attrString appendAttributedString:tmp];
    }
    return attrString;
}

@end


@implementation OrderStatusInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _orderId = [dict stringValueForKey:@"order_id"];
        _orderStatus = [dict integerValueForKey:@"order_status" defaultValue:0];
        _payStatus = [dict integerValueForKey:@"pay_status" defaultValue:0];
        _shippingStatus = [dict integerValueForKey:@"shipping_status" defaultValue:0];
        _securedStatus = [dict integerValueForKey:@"secured_status" defaultValue:0];
        _statusDesc = [dict stringValueForKey:@"status_desc"];
    }
    return self;
}

@end

//pay_status 支付状态;
//0待付款;
//2已付款

//order_status  订单的状态
//0 进行中
//1 交易完成
//2 已取消
//3 无效

//
//shipping_status   商品配送情况;
//0未发货,
//1已发货,
//2已收货,

//pay_status 支付状态;
//0待付款;
//2已付款





