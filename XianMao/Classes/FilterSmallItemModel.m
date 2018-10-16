//
//  FilterSmallItemModel.m
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FilterSmallItemModel.h"

@implementation FilterSmallItemModel



+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.logo_url = [dict stringValueForKey:@"logo_url"];
        self.query_value = [dict stringValueForKey:@"query_value"];
        self.sortIndex = [dict integerValueForKey:@"sortIndex"];
        self.title = [dict stringValueForKey:@"title"];
        self.rate = [dict stringValueForKey:@"rate"];
    }
    return self;
}

@end
