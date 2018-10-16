//
//  meowRecordDetailVo.m
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MeowRecordDetailVo.h"

@implementation MeowRecordDetailVo

+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.dayMeowNumber = [dict integerValueForKey:@"dayMeowNumber"];
        self.signType = [dict integerValueForKey:@"signType"];
        self.timeName = [dict stringValueForKey:@"timeName"];
    }
    return self;
}

@end
