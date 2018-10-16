//
//  GlobalSeekBannerVo.m
//  XianMao
//
//  Created by Marvin on 17/3/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GlobalSeekBannerVo.h"

@implementation GlobalSeekBannerVo

+ (instancetype)createWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.banner = [[RecommendVo alloc] initWithJSONDictionary:[[dict objectForKey:@"banner"] objectAtIndex:0]];
        self.desc = [dict stringValueForKey:@"desc"];
    }
    return self;
}

@end
