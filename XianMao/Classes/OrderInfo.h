//
//  OrderInfo.h
//  XianMao
//
//  Created by simon on 12/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MailInfo.h"
#import "PayTipVo.h"

@class OrderStatusInfo;

@interface OrderInfo : NSObject

@property(nonatomic,assign) NSInteger buyerId;
@property(nonatomic,assign) NSInteger sellerId;
@property(nonatomic,copy) NSString *orderId;
@property(nonatomic,assign) long long createTime;
@property (nonatomic, assign) long long pay_time;
@property (nonatomic, assign) long long finish_time;
@property(nonatomic,strong) NSArray *goodsList;
@property(nonatomic,assign) NSInteger orderStatus;//订单的状态 0进行中 1交易完成 2已取消 3无效 4退款(退货)完成 5申请回购 6申请退货 7回购拒绝 8回购结束 9退货成功
@property(nonatomic,assign) NSInteger payStatus;
@property(nonatomic,assign) NSInteger shippingStatus;
@property(nonatomic,assign) NSInteger securedStatus;
@property(nonatomic,assign) NSInteger payWay;
@property(nonatomic,assign) double totalPrice;
@property(nonatomic,assign) double actual_pay;
@property(nonatomic,assign) double bonus_pay;
@property(nonatomic,assign) double reward_money_pay;
@property(nonatomic,assign) NSInteger totalPrice_cent;
@property(nonatomic,assign) NSInteger actual_pay_cent;
@property(nonatomic,assign) NSInteger bonus_pay_cent;
@property(nonatomic,assign) NSInteger reward_money_pay_cent;
@property(nonatomic,assign) double adm_money_pay;
@property(nonatomic,assign) NSInteger adm_money_pay_cent;
@property(nonatomic,strong) MailInfo *mailInfo;
@property (nonatomic, assign) CGFloat mail_price;
@property (nonatomic, assign) CGFloat mail_price_cent;
@property (nonatomic, strong) PayTipVo *payTipVo;
@property(nonatomic,copy) NSString *statusDesc;
@property (nonatomic, copy) NSString *shortStatusDesc;
@property (nonatomic, copy) NSString *statusDescIcon;

@property(nonatomic,assign) NSInteger tradeType; //trade_type;// 1寄卖交易 2 商家（卖家）直接发货 3 商家（卖家）发货给爱丁猫，爱丁猫担保交易 4 服务商品交易 5 爱丁猫求回收交易,6 :爱丁猫求商家调货交易; 7：铺货订单 8：分销订单 9:线下洗护订单

@property (nonatomic, assign) NSInteger logic_type; //2原价回购  //3自选商品
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User * buyer;
//secured_status //0初始 1卖家发货 2鉴定中心收货 3通过 4不通过
//只有trade_type=3 只有担保交易才可以发货

@property(nonatomic,copy) NSString *message;
@property(nonatomic,assign) NSInteger receive_remaining; //剩余确认收货时间
@property(nonatomic,assign) NSInteger pay_remaining; //剩余付款时间
@property (nonatomic, assign) CGFloat remain_price;
@property (nonatomic, assign) NSInteger buttonStats;//退款 1申请退货 2查看退货进度 3申请回购 4查看回购进度

@property(nonatomic,readonly) NSAttributedString *receive_remainingString;
@property(nonatomic,readonly) NSAttributedString *pay_remainingString;

@property(nonatomic,assign) BOOL copy_enable;

@property(nonatomic,assign) BOOL refund_enable;
@property(nonatomic,assign) NSInteger refund_status; // 退款状态 0未退款 1申请退款中 2退款结束
@property(nonatomic,assign) NSInteger refund_remaining; // 退款倒计时
@property(nonatomic,readonly) NSAttributedString *refund_remainingString;
@property(nonatomic, strong) NSArray * payOrderWayList;
@property (nonatomic, assign) NSInteger repurchase_status;

//private int refund_status;// 退款状态 0未退款 1申请退款中 2退款结束
//private long refund_remaining;// 退款倒计时


+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (BOOL)isWaitingForPay;
- (BOOL)isConsignOrder;

- (NSString*)orderStatusString;
- (NSString*)payStatusString;
- (NSString*)shippingStatusString;

- (void)updateWithStatusInfo:(OrderStatusInfo*)statusInfo;

@end


@interface OrderStatusInfo : NSObject

@property(nonatomic,copy) NSString *orderId;
@property(nonatomic,assign) NSInteger orderStatus;
@property(nonatomic,assign) NSInteger payStatus;
@property(nonatomic,assign) NSInteger shippingStatus;
@property(nonatomic,assign) NSInteger securedStatus;
@property(nonatomic,copy) NSString *statusDesc;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


