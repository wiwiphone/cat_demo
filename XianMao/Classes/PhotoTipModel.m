//
//  PhotoTipModel.m
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PhotoTipModel.h"
#import "PhotoTipListVo.h"

@implementation PhotoTipModel

-(instancetype)initWithJSONDictionary:(NSDictionary *)dict{
    self = [super initWithJSONDictionary:dict];
    if (self) {
        NSMutableArray *gallaryArr = [[NSMutableArray alloc] init];
        NSArray *dictArray = [dict arrayValueForKey:@"categoryPhotoTipList"];
        if ([dictArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray) {
                if ([dictTmp isKindOfClass:[NSDictionary class]]) {
                    PhotoTipListVo *gallary =[[PhotoTipListVo alloc] initWithJSONDictionary:dictTmp];
                    [gallaryArr addObject:gallary];
                }
            }
        }
        _categoryPhotoTipList = gallaryArr;
    }
    return self;
}

@end
