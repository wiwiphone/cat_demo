//
//  PayManager.m
//  XianMao
//
//  Created by simon on 12/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "PayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPayPlugin.h"
#import "SynthesizeSingleton.h"
#import "AppDelegate.h"

#define kMode_Development             @"00"

@interface PayManager ()

@end

@implementation PayManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PayManager, sharedInstance);

- (void)initialize
{
    
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@", resultDic);
            NSString *resultStatus = [resultDic stringValueForKey:@"resultStatus"];
            //NSString *result = [resultDic stringValueForKey:@"result"];
            //NSString *memo = [resultDic stringValueForKey:@"memo"];
            if ([resultStatus isEqualToString:@"9000"]) {
                //完成
//                SEL selector = @selector($$handleAliPayResultCompletionNotification:);
//                MBGlobalSendNotificationForSEL(selector);
                SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
                MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
            } else if ([resultStatus isEqualToString:@"6001"]) {
                //取消
//                SEL selector = @selector($$handleAliPayResultCancelNotification:);
//                MBGlobalSendNotificationForSEL(selector);
                SEL selector = @selector($$handlePayResultCancelNotification:orderIds:);
                MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
            } else {
                //失败
//                SEL selector = @selector($$handleAliPayResultFailureNotification:);
//                MBGlobalSendNotificationForSEL(selector);
                SEL selector = @selector($$handlePayResultFailureNotification:orderIds:);
                MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
            }
            [PayManager sharedInstance].orderIds = nil;
        }];
        return YES;
    }
    return NO;
}

+ (BOOL)weixinPay:(PayReq *)req
{
    return [self weixinPay:req orderId:nil];
}

+ (BOOL)weixinPay:(PayReq *)req orderId:(NSString*)orderId
{
    NSMutableArray *orderIds = [[NSMutableArray alloc] init];
    if (orderId && [orderId length]>0) {
        [orderIds addObject:orderId];
    }
    return [self weixinPay:req orderIds:orderIds];
}

+ (BOOL)weixinPay:(PayReq *)req orderIds:(NSArray*)orderIds
{
    [PayManager sharedInstance].orderIds = [[NSMutableArray alloc] initWithArray:orderIds];
    return [WXApi sendReq:req];
}

+ (void)pay:(NSString *)payUrl
{
    [self pay:payUrl orderId:nil];
}

+ (void)pay:(NSString*)payUrl orderId:(NSString*)orderId
{
    NSMutableArray *orderIds = [[NSMutableArray alloc] init];
    if (orderId && [orderId length]>0) {
        [orderIds addObject:orderId];
    }
    [self pay:payUrl orderIds:orderIds];
}

+ (void)pay:(NSString*)payUrl orderIds:(NSArray*)orderIds {
    [PayManager sharedInstance].orderIds = [[NSMutableArray alloc] initWithArray:orderIds];
    
//    UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    firstWindow.hidden = YES;
    [[AlipaySDK defaultService] payOrder:payUrl fromScheme:@"aidingmao" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic); //真机没有返回
        NSString *resultStatus = [resultDic stringValueForKey:@"resultStatus"];
        //NSString *result = [resultDic stringValueForKey:@"result"];
        //NSString *memo = [resultDic stringValueForKey:@"memo"];
        if ([resultStatus isEqualToString:@"9000"]) {
            //完成
            //            SEL selector = @selector($$handleAliPayResultCompletionNotification:);
            //            MBGlobalSendNotificationForSEL(selector);
            SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
            MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_COMPLETION object:[PayManager sharedInstance].orderIds];
        } else if ([resultStatus isEqualToString:@"6001"]) {
            //取消
            //            SEL selector = @selector($$handleAliPayResultCancelNotification:);
            //            MBGlobalSendNotificationForSEL(selector); 
            SEL selector = @selector($$handlePayResultCancelNotification:orderIds:);
            MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_CANCEL object:[PayManager sharedInstance].orderIds];
        } else {
            //失败
            //            SEL selector = @selector($$handleAliPayResultFailureNotification:);
            //            MBGlobalSendNotificationForSEL(selector);
            SEL selector = @selector($$handlePayResultFailureNotification:orderIds:);
            MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_FAILURE object:[PayManager sharedInstance].orderIds];
        }
        [PayManager sharedInstance].orderIds = nil;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAY_RESULT_COMPLETION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAY_RESULT_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAY_RESULT_FAILURE object:nil];
}

+(void)uppay:(NSString *)payId
{
    [self uppay:payId orderId:nil];
}

+(void)uppay:(NSString *)payId orderId:(NSString*)orderId
{
    NSMutableArray *orderIds = [[NSMutableArray alloc] init];
    if (orderId && [orderId length]>0) {
        [orderIds addObject:orderId];
    }
    [self uppay:payId orderIds:orderIds];
}

+(void)uppay:(NSString *)payId orderIds:(NSArray*)orderIds
{
    
    [PayManager sharedInstance].orderIds = [[NSMutableArray alloc] initWithArray:orderIds];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [UPPayPlugin startPay:payId mode:kMode_Development
           viewController:[CoordinatingController sharedInstance].visibleController
                 delegate:appdelegate];
}



@end


