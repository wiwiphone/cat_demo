//
//  AccountList.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AccountList.h"


@implementation AccountList



+(instancetype)creatWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        NSMutableArray * addAccountIconVo = [[NSMutableArray alloc] init];
        NSArray * addAccountIconVoList = [dict arrayValueForKey:@"addAccountIconVoList"];
        for (NSDictionary * dict in addAccountIconVoList) {
            AddAccountIconVo * addAccount = [AddAccountIconVo creatWithDict:dict];
            [addAccountIconVo addObject:addAccount];
        }
        self.addAccountIconVo = addAccountIconVo;
        
        
        NSMutableArray * withdrawals = [[NSMutableArray alloc] init];
        NSArray * withdrawalsVoList = [dict arrayValueForKey:@"withdrawalsAccountVoList"];
        for (NSDictionary * dict in withdrawalsVoList) {
            WithdrawalsAccountVo * WithdrawalsAccount= [WithdrawalsAccountVo creatWithDict:dict];
            [withdrawals addObject:WithdrawalsAccount];
        }
        self.withdrawalsAccountVo = withdrawals;
        
        
    }
    return self;
}

@end
