//
//  publishCheckModel.m
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "publishCheckModel.h"

@implementation publishCheckModel

+(publishCheckModel *)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.pop = [dict integerValueForKey:@"pop"];
        self.msg = [dict stringValueForKey:@"msg"];
        self.qualification = [dict integerValueForKey:@"qualification"];
        self.buttonUrl = [dict stringValueForKey:@"buttonUrl"];
        self.buttonTxt = [dict stringValueForKey:@"buttonTxt"];
    }
    return self;
}

@end
