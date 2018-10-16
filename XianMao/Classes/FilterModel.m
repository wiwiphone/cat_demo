//
//  FilterModel.m
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FilterModel.h"
#import "FilterItemModel.h"

@implementation FilterModel


+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = [dict stringValueForKey:@"name"];
        self.type = [dict integerValueForKey:@"type"];
        self.multi_selected = [dict integerValueForKey:@"multi_selected"];
        self.is_spread = [dict integerValueForKey:@"is_spread"];
        self.query_key = [dict stringValueForKey:@"query_key"];  
        self.items = [dict arrayValueForKey:@"items"];
    }
    return self;
}

@end
