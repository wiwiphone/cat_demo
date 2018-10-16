//
//  TradeService.m
//  XianMao
//
//  Created by simon cai on 13/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "TradeService.h"
#import "Session.h"
#import "NSString+URLEncoding.h"
#import "NSString+AES.h"
#import "NSData+AES.h"


#define KEY_VALUE @"AbcdEfgHijkLmnOp"

@interface TradeService ()
@property(nonatomic,strong) HTTPRequest *request;
@end

@implementation TradeService

+ (void)cancelCurOption {
    TradeService *service = (TradeService*)[TradeService instance];
    [service.request cancel];
    service.request = nil;
}

+ (void)modifyPrice:(NSString*)orderId goodsNewPriceArray:(NSArray*)goodsNewPriceArray
         completion:(void (^)())completion
            failure:(void (^)(XMError *error))failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (GoodsNewPrice *newPrice in goodsNewPriceArray) {
        if ([newPrice isKindOfClass:[GoodsNewPrice class]]) {
            [array addObject:[newPrice toDictionary]];
        }
    }
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"order_id":orderId,
                                 @"order_goods":array};
    
    TradeService *service = (TradeService*)[TradeService instance];
    typeof(TradeService*) __weak weakTradeService = service;
    
    service.request = [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"modify_price" parameters:parameters completionBlock:^(NSDictionary *data) {
        weakTradeService.request = nil;
        if (completion) completion();
    } failure:^(XMError *error) {
        weakTradeService.request = nil;
        if (failure)failure(error);
    } queue:nil];
}

+ (void)sendToConsignment:(NSString *)consigmentSn
               logistical:(NSString *)logistical
            logisticalNum:(NSString *)logisticalNum
               completion:(void (^)(SendSaleVo * sendVo))completion
                  failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"consigment_sn":consigmentSn,
                                 @"logistical":logistical,
                                 @"logistical_num":logisticalNum};
    
    TradeService *service = (TradeService*)[TradeService instance];
    typeof(TradeService*) __weak weakTradeService = service;
    service.request = [[NetworkManager sharedInstance] requestWithMethodPOST:@"consignment" path:@"set_logistical" parameters:parameters completionBlock:^(NSDictionary *data) {
        weakTradeService.request = nil;
        SendSaleVo * sendVo = [SendSaleVo createWithDict:[data dictionaryValueForKey:@"set_logistical"]];
        if (completion)completion(sendVo);
    } failure:^(XMError *error) {
        weakTradeService.request = nil;
        if (failure)failure(error);
    } queue:nil];
}

+ (void)sendToAudit:(NSString*)orderId
             mailSN:(NSString*)mailSN
           mailType:(NSString*)mailType
         completion:(void (^)(OrderStatusInfo *statusInfo))completion
            failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *mailInfo = @{@"mail_sn":mailSN, @"mail_type":mailType};
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"order_id":orderId,
                                 @"mail_info":mailInfo};
    
    TradeService *service = (TradeService*)[TradeService instance];
    typeof(TradeService*) __weak weakTradeService = service;
    
    service.request = [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"send_to_audit" parameters:parameters completionBlock:^(NSDictionary *data) {
        weakTradeService.request = nil;
        OrderStatusInfo *statusInfo = [OrderStatusInfo createWithDict:[data dictionaryValueForKey:@"status_info"]];
        if (completion)completion(statusInfo);
    } failure:^(XMError *error) {
        weakTradeService.request = nil;
        if (failure)failure(error);
    } queue:nil];
}

+ (void)reviseOrderId:(NSString *)orderId
              mainSN:(NSString *)mailSN
            mailType:(NSString *)mailType
          completion:(void(^)())completion
             failure:(void(^)(XMError *error))failure{
    
    NSDictionary *parameters = @{@"mailSn":mailSN,
                                 @"orderId":orderId,
                                 @"mailType":mailType};
    TradeService *service = (TradeService*)[TradeService instance];
    typeof(TradeService*) __weak weakTradeService = service;
    
    service.request = [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"modify_secured_delivery" parameters:parameters completionBlock:^(NSDictionary *data) {
        weakTradeService.request = nil;
        if (completion)completion(data);
    } failure:^(XMError *error) {
        weakTradeService.request = nil;
        if (failure)failure(error);
    } queue:nil];
}

+ (void)confirmOfflinePaid:(NSString*)orderId
                  password:(NSString*)password
                completion:(void (^)(OrderStatusInfo *statusInfo))completion
                   failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":orderId,@"password":encryPwd};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"confirm_offline_paid" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        OrderStatusInfo *statusInfo = [OrderStatusInfo createWithDict:[data dictionaryValueForKey:@"status_info"]];
        if (completion)completion(statusInfo);
        
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)deliverGoodsOffline:(NSString*)orderId
                 completion:(void (^)(OrderStatusInfo *statusInfo))completion
                    failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":orderId};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"deliver_goods" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        OrderStatusInfo *statusInfo = [OrderStatusInfo createWithDict:[data dictionaryValueForKey:@"status_info"]];
        if (completion)completion(statusInfo);
        
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)authConfirmReceived:(NSString*)orderId
                   password:(NSString*)password
                     completion:(void (^)(OrderStatusInfo *statusInfo))completion
                        failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"order_id":orderId
                                 ,@"user_id":[NSNumber numberWithInteger:userId]
                                 ,@"password":encryPwd};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"auth_confirm_received" parameters:parameters completionBlock:^(NSDictionary *data) {
        OrderStatusInfo *statusInfo = [OrderStatusInfo createWithDict:[data dictionaryValueForKey:@"status_info"]];
        if (completion)completion(statusInfo);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)listAllExpress:(NSString*)order_id
            completion:(void (^)(NSArray *mailTypeList, AddressInfo *addressInfo))completion
               failure:(void (^)(XMError *error))failure
{
    //express/get_mail_type 获取所有快递公司
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"order_id":order_id};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"express" path:@"get_mail_type" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        AddressInfo *addressInfo = nil;
        if ([data dictionaryValueForKey:@"address"]) {
            addressInfo = [AddressInfo createWithDict:[data dictionaryValueForKey:@"address"]];
        }
        
        NSMutableArray *mailTypeList = [[NSMutableArray alloc] init];;
        NSArray *dicts = [data arrayValueForKey:@"mail_type_list"];
        for (NSDictionary *dictMailTye in dicts) {
            if ([dictMailTye isKindOfClass:[NSDictionary class]]) {
                [mailTypeList addObject:[MailTypeDO createWithDict:dictMailTye]];
            }
        }
        
        if (completion) {
            completion(mailTypeList,addressInfo);
        }
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)listAllExpress:(NSString*)order_id
              mailType:(MailType)mailType
            completion:(void (^)(NSArray *mailTypeList, AddressInfo *addressInfo))completion
               failure:(void (^)(XMError *error))failure{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"order_id":order_id, @"type":@(mailType)};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"express" path:@"get_mail_type" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        AddressInfo *addressInfo = nil;
        if ([data dictionaryValueForKey:@"address"]) {
            addressInfo = [AddressInfo createWithDict:[data dictionaryValueForKey:@"address"]];
        }
        
        NSMutableArray *mailTypeList = [[NSMutableArray alloc] init];;
        NSArray *dicts = [data arrayValueForKey:@"mail_type_list"];
        for (NSDictionary *dictMailTye in dicts) {
            if ([dictMailTye isKindOfClass:[NSDictionary class]]) {
                [mailTypeList addObject:[MailTypeDO createWithDict:dictMailTye]];
            }
        }
        
        if (completion) {
            completion(mailTypeList,addressInfo);
        }
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)remind_deliver:(NSString*)order_id
            completion:(void (^)(NSInteger result, NSString *message))completion
               failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":order_id?order_id:@""};

    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"remind_delive" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"result"],[data stringValueForKey:@"message"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)cancel_order:(NSString*)order_id
            completion:(void (^)(OrderStatusInfo *statusInfo))completion
               failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":order_id?order_id:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"cancel_order" parameters:parameters completionBlock:^(NSDictionary *data) {
        OrderStatusInfo *statusInfo = [OrderStatusInfo createWithDict:[data dictionaryValueForKey:@"status_info"]];
        if (completion)completion(statusInfo);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


+ (void)pay_ways:(NSNumber *)pay_amount
      completion:(void (^)(NSArray *payWays))completion
         failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"pay_amount":pay_amount};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"pay_ways" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSMutableArray *payWayDOArray = [[NSMutableArray alloc] init];
        NSArray *payWayDicts = [data arrayValueForKey:@"pay_ways"];
        if ([payWayDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in payWayDicts) {
                PayWayDO *payWay =[[PayWayDO alloc] initWithJSONDictionary:dict];
                if (payWay) {
                    [payWayDOArray addObject:payWay];
                }
            }
        }
        if (completion)completion(payWayDOArray);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)apply_refund:(NSString*)order_id
              reason:(NSString*)reason
          completion:(void (^)(OrderInfo *order_info))completion
             failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":order_id?order_id:@"",@"reason":reason?reason:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"return" path:@"apply_refund" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([OrderInfo createWithDict:[data dictionaryValueForKey:@"order_info"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

///refund/apply_refund[POST]{order_id, reason} 申请退款 {order_info[TradeOrderInfo结构]}
///refund/cancel_refund[POST]{order_id} 撤销申请 {order_info[TradeOrderInfo结构]}
///refund/agree_refund[POST]{order_id} 同意申请 {order_info[TradeOrderInfo结构]}

+ (void)cancel_refund:(NSString*)order_id
           completion:(void (^)(OrderInfo *order_info))completion
              failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":order_id?order_id:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"return" path:@"cancel_refund" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([OrderInfo createWithDict:[data dictionaryValueForKey:@"order_info"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)agree_refund:(NSString*)order_id
          completion:(void (^)(OrderInfo *order_info))completion
             failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":order_id?order_id:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"return" path:@"agree_refund" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([OrderInfo createWithDict:[data dictionaryValueForKey:@"order_info"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

//trade/delete_order[POST] {order_id, user_id}

+ (void)delete_order:(NSString*)order_id
          completion:(void (^)(NSString *order_id))completion
             failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"order_id":order_id?order_id:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"delete_order" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(order_id);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

//cancel_order 【POST】 {order_id} 返回 {status_info：状态结构}

//trade/remind_delive[POST] {order_id, user_id} 返回 ｛result(i), message(s)｝ 提醒发货

@end

@implementation GoodsNewPrice

+ (GoodsNewPrice*)allocGoodsNewPrice:(NSString*)goodsId newPrice:(double)newPrice {
    GoodsNewPrice *price = [[GoodsNewPrice alloc] init];
    price.goodsId = goodsId;
    price.newPrice = newPrice;
    price.newPriceCent = (NSInteger)(newPrice*100);
    return price;
}

+ (GoodsNewPrice*)allocGoodsNewPrice:(NSString*)goodsId newPrice:(double)newPrice newPriceCent:(NSInteger)newPriceCent {
    GoodsNewPrice *price = [[GoodsNewPrice alloc] init];
    price.goodsId = goodsId;
    price.newPrice = newPrice;
    price.newPriceCent = newPriceCent;
    return price;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithFloat:_newPrice] forKey:@"new_price"];
    [dict setObject:[NSNumber numberWithInteger:_newPriceCent] forKey:@"new_price_cent"];
    [dict setObject:_goodsId forKey:@"goods_id"];
    return dict;
}

@end


@implementation MailTypeDO

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.mailCom = [dict stringValueForKey:@"mail_com"];
        self.mailType = [dict stringValueForKey:@"mail_type"];
    }
    return self;
}

@end



@implementation BonusService

//bonus/convert_bonus[POST] {user_id, cdkey}  返回bonus结构

+ (void)convertBonus:(NSString*)codekey
          completion:(void (^)(BonusInfo *bonusInfo))completion
             failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSString *encryKey = [codekey AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]
                                 ,@"cdkey":encryKey};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"bonus" path:@"convert_bonus" parameters:parameters completionBlock:^(NSDictionary *data) {
        BonusInfo *bonusInfo = [data dictionaryValueForKey:@"bonus"]!=nil?[BonusInfo createWithDict:[data dictionaryValueForKey:@"bonus"]]:nil;
        if (completion)completion(bonusInfo);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

@end


