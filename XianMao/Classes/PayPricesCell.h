//
//  PayPricesCell.h
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderDetailInfo.h"

@interface PayPricesCell : BaseTableViewCell


+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(OrderDetailInfo *)orderDetailInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
