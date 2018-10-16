//
//  OrderDetailInfo.m
//  XianMao
//
//  Created by simon on 1/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "OrderDetailInfo.h"

@implementation OrderDetailInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _orderInfo = [OrderInfo createWithDict:[dict dictionaryValueForKey:@"order_info"]];
        _addressInfo = [AddressInfo createWithDict:[dict dictionaryValueForKey:@"address_info"]];
        _mailInfo = [MailInfo createWithDict:[dict dictionaryValueForKey:@"mail_info"]];
    }
    return self;
}

@end




