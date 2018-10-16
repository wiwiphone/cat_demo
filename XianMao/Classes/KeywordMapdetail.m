//
//  KeywordMapdetail.m
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "KeywordMapdetail.h"

@implementation KeywordMapdetail

@synthesize id;


+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.id = [dict integerValueForKey:@"id"];
        self.showText = [dict stringValueForKey:@"showText"];
        self.mapText = [dict stringValueForKey:@"mapText"];
        self.picUrl = [dict stringValueForKey:@"picUrl"];
        self.redirectUrl = [dict stringValueForKey:@"redirectUrl"];
        self.isValid = [dict integerValueForKey:@"isValid"];
        self.beginTime = [dict stringValueForKey:@"beginTime"];
        self.endTime = [dict stringValueForKey:@"endTime"];
        self.createtime = [dict stringValueForKey:@"createtime"];
        self.updatetime = [dict stringValueForKey:@"updatetime"];
    }
    return self;
}

@end
