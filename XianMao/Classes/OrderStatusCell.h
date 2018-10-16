//
//  OrderStatusCell.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderInfo.h"

@interface OrderStatusCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo;
+ (NSMutableDictionary*)buildCellDict:(OrderInfo *)orderInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
