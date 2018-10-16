//
//  WithdrawalsAccountVo.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WithdrawalsAccountVo.h"

@implementation WithdrawalsAccountVo


+(instancetype)creatWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.type = [dict integerValueForKey:@"type"];
        self.account = [dict stringValueForKey:@"account"];
        self.breviaryAccount = [dict stringValueForKey:@"breviary_account"];
        self.bankName = [dict stringValueForKey:@"bank_name"];
        self.belong = [dict stringValueForKey:@"belong"];
        self.icon = [dict stringValueForKey:@"icon"];
        self.identityCard = [dict stringValueForKey:@"identity_card"];
        self.available = [dict doubleValueForKey:@"available"];
        self.usedAvailable = [dict stringValueForKey:@"used_available"];
        self.surplusAvailable = [dict doubleValueForKey:@"surplus_available" defaultValue:0];
        self.withdrawalsEexplain = [dict stringValueForKey:@"withdrawals_explain"];
        self.region = [dict stringValueForKey:@"region"];
        self.bankDeposit = [dict stringValueForKey:@"bank_deposit"];
        self.bankid = [dict integerValueForKey:@"bank_id" defaultValue:0];
        self.idd = [dict integerValueForKey:@"id"];
    }
    return self;
}

@end
