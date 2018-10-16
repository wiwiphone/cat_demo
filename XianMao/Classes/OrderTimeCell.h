//
//  OrderTimeCell.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderInfo.h"
@interface OrderTimeCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo;
+ (NSMutableDictionary*)buildCellDict:(NSNumber *)price title:(NSString *)title isCopy:(BOOL)isCopy orderId:(NSString *)orderId;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
