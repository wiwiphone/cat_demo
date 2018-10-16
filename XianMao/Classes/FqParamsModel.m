//
//  FqParamsModel.m
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FqParamsModel.h"

@implementation FqParamsModel

+ (instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.qk = [dict stringValueForKey:@"qk"];
        self.qv = [dict stringValueForKey:@"qv"];
    }
    return self;
}

@end
