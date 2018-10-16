//
//  TipItemVo.m
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TipItemVo.h"

@implementation TipItemVo

+(instancetype)modelWithJSONDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithJSONDictionary:dict];
}

-(id)initWithJSONDictionary:(NSDictionary *)dict{
    if (self = [super initWithJSONDictionary:dict]) {
        self.picGuide = [dict arrayValueForKey:@"picGuide"];
        self.tip = [dict stringValueForKey:@"tip"];
    }
    return self;
}

@end
