//
//  OrderLockInfo.m
//  XianMao
//
//  Created by simon cai on 25/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "OrderLockInfo.h"

#import "Session.h"

@implementation OrderLockInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        _orderId = [dict stringValueForKey:@"order_id"];
        _buyerId = [dict integerValueForKey:@"buyer_id"];
        _remainTime = [dict integerValueForKey:@"remain_time"];
    }
    return self;
}

@end
