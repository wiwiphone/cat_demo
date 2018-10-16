//
//  PayManager.h
//  XianMao
//
//  Created by simon on 12/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface PayManager : NSObject

@property(nonatomic,strong) NSMutableArray *orderIds;

+ (PayManager*)sharedInstance;

+ (void)pay:(NSString*)payUrl;
+ (BOOL)weixinPay:(PayReq*)req;
+ (void)pay:(NSString*)payUrl orderId:(NSString*)orderId;
+ (BOOL)weixinPay:(PayReq*)req orderId:(NSString*)orderId;
+ (void)pay:(NSString*)payUrl orderIds:(NSArray*)orderIds;
+ (BOOL)weixinPay:(PayReq*)req orderIds:(NSArray*)orderIds;

+(void)uppay:(NSString *)payId ;
+(void)uppay:(NSString *)payId orderId:(NSArray*)orderId;
+(void)uppay:(NSString *)payId orderIds:(NSArray*)orderIds;


+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end


@protocol PayResultReceiver <NSObject>
@optional
//- (void)$$handleAliPayResultCompletionNotification:(id<MBNotification>)notifi;
//- (void)$$handleAliPayResultCancelNotification:(id<MBNotification>)notifi;
//- (void)$$handleAliPayResultFailureNotification:(id<MBNotification>)notifi;

- (void)$$handlePayResultCompletionNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds;
- (void)$$handlePayResultCancelNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds;
- (void)$$handlePayResultFailureNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds;
@end
