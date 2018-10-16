//
//  OrderGoodsTypeCell.h
//  XianMao
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderInfo.h"

@interface OrderGoodsTypeCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo;
+ (NSMutableDictionary*)buildCellTitle:(NSString *)title imageName:(NSString *)imageName isHTTP:(NSNumber *)isYes orderInfo:(OrderInfo *)orderInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
