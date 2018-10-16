//
//  GoodsInfoTableViewCell.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class GoodsInfo;

@interface GoodsInfoTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSString*)cellDictKeyForGoodsInfo;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo;

@end
