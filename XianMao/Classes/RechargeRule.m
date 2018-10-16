//
//  RechargeRule.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RechargeRule.h"

@implementation RechargeRule

+ (instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.min = [dict doubleValueForKey:@"min" defaultValue:0];
        self.max = [dict doubleValueForKey:@"max" defaultValue:0];
        self.give = [dict doubleValueForKey:@"give" defaultValue:0];
        self.desc = [dict stringValueForKey:@"desc"];
    }
    return self;
}
@end
