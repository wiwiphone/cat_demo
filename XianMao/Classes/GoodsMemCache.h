//
//  GoodsMemCache.h
//  XianMao
//
//  Created by simon on 12/31/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CachableItem.h"

@interface ZeroingWeakMemCache : NSObject

@end


@class GoodsInfo;
@interface GoodsMemCache : NSObject

+ (instancetype)sharedInstance;

- (GoodsInfo*)storeData:(GoodsInfo*)goodsInfo isDataChanged:(BOOL*)isDataChanged;

- (GoodsInfo*)dataForKey:(NSString*)goodsId;

@end

