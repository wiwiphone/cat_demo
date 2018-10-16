//
//  RecoveryPreference.m
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoveryPreference.h"
#import "RecoveryItem.h"

@implementation RecoveryPreference

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        NSMutableArray *itemsArr = [[NSMutableArray alloc] init];
        if (self.type == 0) {
            NSArray *dictArray = [dict arrayValueForKey:@"items"];
            if ([dictArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dictTmp in dictArray) {
                    if ([dictTmp isKindOfClass:[NSDictionary class]]) {
                        RecoveryItem *item =[[RecoveryItem alloc] initWithJSONDictionary:dictTmp];
                        [itemsArr addObject:item];
                    }
                }
            }
            _items = itemsArr;
        } else if (self.type == 1) {
            NSArray *dictArray = [dict arrayValueForKey:@"items"];
            if ([dictArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dictTmp in dictArray) {
                    if ([dictTmp isKindOfClass:[NSDictionary class]]) {
                        RecoveryPreference *item =[[RecoveryPreference alloc] initWithJSONDictionary:dictTmp];
                        [itemsArr addObject:item];
                    }
                }
            }
            _items = itemsArr;
        }
    }
    
    return self;
}

@end
