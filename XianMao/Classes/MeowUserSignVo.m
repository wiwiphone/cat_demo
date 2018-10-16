//
//  MeowUserSignVo.m
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MeowUserSignVo.h"

@implementation MeowUserSignVo


+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.userId = [dict integerValueForKey:@"userId"];
        self.meowNumber = [dict integerValueForKey:@"meowNumber"];
        self.awardType = [dict integerValueForKey:@"awardType"];
        self.signTime = [dict stringValueForKey:@"signTime"];
        self.createtime = [dict stringValueForKey:@"createtime"];
        self.updatetime = [dict stringValueForKey:@"updatetime"];
        self.signType = [dict integerValueForKey:@"signType"];
    }
    return self;
}

@end
