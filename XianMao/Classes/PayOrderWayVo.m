//
//  PayOrderWayVo.m
//  XianMao
//
//  Created by WJH on 16/10/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayOrderWayVo.h"

@implementation PayOrderWayVo

+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = [dict stringValueForKey:@"name"];
        self.price = [dict doubleValueForKey:@"price" defaultValue:0];
        self.priceStr = [dict stringValueForKey:@"priceStr"];
    }
    return self;
}

@end
