//
//  AddAccountIconVo.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AddAccountIconVo.h"

@implementation AddAccountIconVo

+(instancetype)creatWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.type = [dict integerValueForKey:@"type"];
        self.name = [dict stringValueForKey:@"name"];
        self.icon = [dict stringValueForKey:@"icon"];
        self.caption = [dict stringValueForKey:@"caption"];
    }
    return self;
}

@end
