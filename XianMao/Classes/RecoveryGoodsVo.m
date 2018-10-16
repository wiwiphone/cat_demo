//
//  RecoveryGoodsVo.m
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoveryGoodsVo.h"
#import "Gallary.h"

const NSInteger GOODS_STATUS_NOT_SALES = 0;
const NSInteger GOODS_STATUS_ON_SALES = 1;
const NSInteger GOODS_STATUS_LOCKEDS = 2;
const NSInteger GOODS_STATUS_SOLDS = 3;

@implementation RecoveryGoodsVo

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        NSMutableArray *gallaryArr = [[NSMutableArray alloc] init];
        NSArray *dictArray = [dict arrayValueForKey:@"gallary"];
        if ([dictArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray) {
                if ([dictTmp isKindOfClass:[NSDictionary class]]) {
                    MainPic *gallary =[[MainPic alloc] initWithJSONDictionary:dictTmp];
                    [gallaryArr addObject:gallary];
                }
            }
        }
        _gallary = gallaryArr;
    }
    return self;
}

- (BOOL)isConsignGoods {
    return self.service_type==1?YES:NO;
}

- (BOOL)isOnSales {
    return _status==GOODS_STATUS_ON_SALES;
}

- (BOOL)isNotOnSales {
    return _status == GOODS_STATUS_NOT_SALES;
    
}

+ (NSString*)goodsStatusDescription:(NSInteger)status {
    NSString *description = @"已失效";
    switch (status) {
        case GOODS_STATUS_NOT_SALES:
            description = @"已下架";
            break;
        case GOODS_STATUS_ON_SALES:
            description = @"在售";
            break;
        case GOODS_STATUS_LOCKEDS:
            description = @"付款中";//@"已锁定"; 已售罄 已被抢 已
            break;
        case GOODS_STATUS_SOLDS:
            description = @"已售罄";
            break;
    }
    //    if (status!=GOODS_STATUS_NOT_SALE) {
    //        description = @"已失效";
    //    }
    return description;
}

@end
