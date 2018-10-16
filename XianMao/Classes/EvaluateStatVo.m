//
//  EvaluateStatVo.m
//  XianMao
//
//  Created by simon cai on 12/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "EvaluateStatVo.h"

@implementation EvaluateStatVo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.statDescription = [dict stringValueForKey:@"description"];
        self.status = [dict integerValueForKey:@"status" defaultValue:0];
        self.redirectUri = [dict stringValueForKey:@"redirect_uri"];
        self.redirectDesc = [dict stringValueForKey:@"redirect_desc"];
    }
    return self;
}

@end
