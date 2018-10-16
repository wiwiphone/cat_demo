//
//  ParyialDo.h
//  XianMao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfo.h"

@interface ParyialDo : NSObject

@property (nonatomic, assign) CGFloat surplusPriceNum;
@property (nonatomic, assign) long long surplusTime;
@property (nonatomic, copy) NSString *payWayIconUrl;
@property (nonatomic, copy) NSString *payWayTitle;
@property (nonatomic, copy) NSString *payWayContent;
@property (nonatomic, strong) NSArray *payWays;
@property (nonatomic, assign) NSInteger payType;

@property (nonatomic, assign) NSInteger avaMoneyCent;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) OrderInfo *orderInfo;
@end
