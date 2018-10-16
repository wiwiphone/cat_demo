//
//  SendSaleOrderTimeCell.h
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SendSaleOrderTimeCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSNumber *)price title:(NSString *)title isCopy:(BOOL)isCopy orderId:(NSString *)orderId;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
