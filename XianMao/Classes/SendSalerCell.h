//
//  SendSalerCell.h
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class SendSaleVo;

@interface SendSalerCell : BaseTableViewCell


+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
