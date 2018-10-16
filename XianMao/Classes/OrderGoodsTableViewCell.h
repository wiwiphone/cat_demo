//
//  OrderGoodsTableViewCell.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"
#import "OrderInfo.h"

@interface OrderGoodsTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(GoodsInfo*)goodsInfo;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo orderInfo:(OrderInfo *)orderInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
