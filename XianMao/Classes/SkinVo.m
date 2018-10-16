//
//  SkinVo.m
//  XianMao
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SkinVo.h"

@implementation SkinVo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        if ([dict objectForKey:@"iosUrl"]) {
            self.iosUrl = [dict stringValueForKey:@"iosUrl"];
        }
        if ([dict objectForKey:@"version"]) {
            self.version = [dict stringValueForKey:@"version"];
        }
        self.startTime = [dict longLongValueForKey:@"startTime"];
        self.endTime = [dict longLongValueForKey:@"endTime"];
    }
    return self;
}

@end
