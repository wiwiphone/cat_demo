//
//  PhotoTipListVo.m
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PhotoTipListVo.h"
#import "TipItemVo.h"

@implementation PhotoTipListVo

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super initWithJSONDictionary:dict];
    if (self) {
        
        NSMutableArray *gallaryArr = [[NSMutableArray alloc] init];
        NSArray *dictArray = [dict arrayValueForKey:@"tipItemList"];
        if ([dictArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray) {
                if ([dictTmp isKindOfClass:[NSDictionary class]]) {
//                    TipItemVo *gallary =[[TipItemVo alloc] initWithJSONDictionary:dictTmp];
                    TipItemVo * gallary = [TipItemVo modelWithJSONDictionary:dictTmp];
                    [gallaryArr addObject:gallary];
                }
            }
        }
        _tipItemList = gallaryArr;
        
    }
    return self;
}

@end
