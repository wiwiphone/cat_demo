//
//  TradeService.h
//  XianMao
//
//  Created by simon cai on 13/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"
#import "NetworkManager.h"
#import "AddressInfo.h"
#import "OrderInfo.h"
#import "BonusInfo.h"
#import "PayWayDO.h"
#import "SendSaleVo.h"

@class GoodsNewPrice;

typedef enum{
    Consign = 1,
}MailType;

@interface TradeService : BaseService

+ (void)cancelCurOption;

+ (void)modifyPrice:(NSString*)orderId goodsNewPriceArray:(NSArray*)goodsNewPriceArray
         completion:(void (^)())completion
            failure:(void (^)(XMError *error))failure;

+ (void)sendToConsignment:(NSString *)consigmentSn
               logistical:(NSString *)logistical
            logisticalNum:(NSString *)logisticalNum
               completion:(void (^)(SendSaleVo * sendVo))completion
                  failure:(void (^)(XMError *error))failure;

+ (void)sendToAudit:(NSString*)orderId
             mailSN:(NSString*)mailSN
           mailType:(NSString*)mailType
         completion:(void (^)(OrderStatusInfo *statusInfo))completion
            failure:(void (^)(XMError *error))failure;

+ (void)confirmOfflinePaid:(NSString*)orderId
                  password:(NSString*)password
                completion:(void (^)(OrderStatusInfo *statusInfo))completion
                   failure:(void (^)(XMError *error))failure;

+ (void)deliverGoodsOffline:(NSString*)orderId
                 completion:(void (^)(OrderStatusInfo *statusInfo))completion
                    failure:(void (^)(XMError *error))failure;

+ (void)authConfirmReceived:(NSString*)orderId
                   password:(NSString*)password
                 completion:(void (^)(OrderStatusInfo *statusInfo))completion
                    failure:(void (^)(XMError *error))failure;

//trade/modify_price[POST] {order_id, goods[{goods_id(s), new_price(d)}]} 修改价格
//trade/send_to_audit[POST] 发货给爱丁猫

//express/get_mail_type 获取所有快递公司

//trade/confirm_offline_paid [POST] {order_id} 线下确认收款， 只有当pay_way=99，order_status=0, pay_status=0才出现
//trade/deliver_goods [POST]{order_id} 线下确认收款后发货，只有当pay_way=99，order_status=0, pay_status=2, shipping_status=0才出现

+ (void)listAllExpress:(NSString*)order_id
            completion:(void (^)(NSArray *mailTypeList, AddressInfo *addressInfo))completion
               failure:(void (^)(XMError *error))failure;

+ (void)listAllExpress:(NSString*)order_id
              mailType:(MailType)mailType
            completion:(void (^)(NSArray *mailTypeList, AddressInfo *addressInfo))completion
               failure:(void (^)(XMError *error))failure;

+ (void)remind_deliver:(NSString*)order_id
            completion:(void (^)(NSInteger result, NSString *message))completion
               failure:(void (^)(XMError *error))failure;

+ (void)cancel_order:(NSString*)order_id
          completion:(void (^)(OrderStatusInfo *statusInfo))completion
             failure:(void (^)(XMError *error))failure;


+ (void)pay_ways:(NSNumber *)pay_amount
      completion:(void (^)(NSArray *payWays))completion
         failure:(void (^)(XMError *error))failure;


+ (void)apply_refund:(NSString*)order_id
              reason:(NSString*)reason
          completion:(void (^)(OrderInfo *order_info))completion
             failure:(void (^)(XMError *error))failure;

+ (void)cancel_refund:(NSString*)order_id
          completion:(void (^)(OrderInfo *order_info))completion
             failure:(void (^)(XMError *error))failure;

+ (void)agree_refund:(NSString*)order_id
           completion:(void (^)(OrderInfo *order_info))completion
              failure:(void (^)(XMError *error))failure;


+ (void)delete_order:(NSString*)order_id
          completion:(void (^)(NSString *order_id))completion
             failure:(void (^)(XMError *error))failure;

+ (void)reviseOrderId:(NSString *)orderId
               mainSN:(NSString *)mailSN
             mailType:(NSString *)mailType
           completion:(void(^)())completion
              failure:(void(^)(XMError *error))failure;

//trade/delete_order[POST] {order_id, user_id}

@end

//auth_confirm_received 确认收货  confirm_offline_paid 都增加password（加密）

@interface GoodsNewPrice : NSObject
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,assign) double newPrice;
@property(nonatomic,assign) NSInteger newPriceCent;
+ (GoodsNewPrice*)allocGoodsNewPrice:(NSString*)goodsId newPrice:(double)newPrice;
+ (GoodsNewPrice*)allocGoodsNewPrice:(NSString*)goodsId newPrice:(double)newPrice newPriceCent:(NSInteger)newPriceCent;
- (NSDictionary*)toDictionary;
@end



@interface MailTypeDO : NSObject
@property(nonatomic,copy) NSString *mailCom;
@property(nonatomic,copy) NSString *mailType;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


//bonus/convert_bonus[POST] {user_id, cdkey}  返回bonus结构
//cdkey可兑换有xk0001,fuk001,you007


@interface BonusService : BaseService

+ (void)convertBonus:(NSString*)codekey
          completion:(void (^)(BonusInfo *bonusInfo))completion
             failure:(void (^)(XMError *error))failure;

@end





//trade/pay_ways【GET】 "pay_ways": [
//                                 {
//                                     "pay_way": 1,
//                                     "pay_name": "微信支付",
//                                     "icon_url": "http://static99.aidingmao.com/boss/img/fe750e60-3c2c-11e5-b56c-33ba5cad5002.png"
//                                 },
//                                 {
//                                     "pay_way": 0,
//                                     "pay_name": "支付宝支付",
//                                     "icon_url": "http://static99.aidingmao.com/boss/img/fe6ad530-3c2c-11e5-b56c-33ba5cad5002.png"
//                                 },
//                                 {
//                                     "pay_way": 2,
//                                     "pay_name": "银联支付",
//                                     "icon_url": "http://static99.aidingmao.com/boss/img/fe683d20-3c2c-11e5-b56c-33ba5cad5002.png"
//                                 },
//                                 {
//                                     "pay_way": 50,
//                                     "pay_name": "分期乐支付",
//                                     "icon_url": "http://static99.aidingmao.com/boss/img/fe6a38f0-3c2c-11e5-b56c-33ba5cad5002.png"
//                                 }
//                                 ]



//trade/pay_goods[POST]{goods_list(json数组）, user_id(i), address_id(i), message(s), pay_way(i), bonus_id(s), is_used_reward_money(i), is_used_adm_money(i)} 商品生成订单，返回支付url ｛pay_url(s)支付宝, pay_req(map)微信, upPayTn(s)银联，pay_url（s）分期乐，    pay_way(i), lock_time(struct) ｝
//                                 
//                                 （弃用）trade/pay_order[POST]{order_id(s）, user_id(i), pay_way(i), bonus_id(s), is_used_reward_money(i), is_used_adm_money(i)} 订单支付，返回支付url ｛pay_url(s)支付宝, pay_req(map)微信, upPayTn(s)银联，pay_url（s）分期乐，    pay_way(i), lock_time(struct) ｝
//                                                                    
//                                                                    trade/pay_order_list[POST]{order_ids(string数组）, user_id(i), pay_way(i), bonus_id(s), is_used_reward_money(i), is_used_adm_money(i)} 批量订单支付，返回支付url ｛pay_url(s)支付宝, pay_req(map)微信, upPayTn(s)银联，pay_url（s）分期乐，    pay_way(i), lock_time(struct) ｝
//                                                                                                         
//                                                                                                         



//TradeOrderInfo中增加 	private int refund_enable;//能否退款
//
//private int refund_status;// 退款状态 0未退款 1申请退款中 2退款结束
//
//private long refund_remaining;// 退款倒计时


///refund/apply_refund[POST]{order_id, reason} 申请退款 {order_info[TradeOrderInfo结构]}
///refund/apply_refund[POST]{order_id} 撤销申请 {order_info[TradeOrderInfo结构]}
///refund/apply_refund[POST]{order_id} 同意申请 {order_info[TradeOrderInfo结构]}

///refund/apply_refund[POST]{order_id, reason} 申请退款 {order_info[TradeOrderInfo结构]}
///refund/cancel_refund[POST]{order_id} 撤销申请 {order_info[TradeOrderInfo结构]}
///refund/agree_refund[POST]{order_id} 同意申请 {order_info[TradeOrderInfo结构]}



//https://www.teambition.com/project/5451a35699c0c1746636c8d3/files/562f2440e4bf3de02c1e2280
//@白骁  拉黑功能 跟分享功能  个人主页优化了一下
//
//
//trade/delete_order[POST] {order_id, user_id} 删除订单 （已买和已售）


