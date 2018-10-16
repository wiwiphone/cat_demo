//
//  PayTipVo.m
//  XianMao
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayTipVo.h"

@implementation PayTipVo

-(id)initWithJSONDictionary:(NSDictionary *)dict{
    self = [super initWithJSONDictionary:dict];
    if (self) {
        if (dict) {
            _showText = [dict stringValueForKey:@"showText"];
            _fuzhiText = [dict stringValueForKey:@"copyText"];
        }
    }
    return self;
}

@end
