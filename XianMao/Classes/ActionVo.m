//
//  ActionVo.m
//  XianMao
//
//  Created by WJH on 17/3/1.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ActionVo.h"

@implementation ActionVo


+ (instancetype)createWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.status = [dict intValueForKey:@"status"];
        self.title = [dict stringValueForKey:@"title"];
    }
    return self;
}

@end
