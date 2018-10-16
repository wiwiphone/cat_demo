//
//  WithdrawAccountCell.h
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "WithdrawalsAccountVo.h"

@interface WithdrawAccountCell : BaseTableViewCell


+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(WithdrawalsAccountVo *)WithdrawalsAccountVo;
+ (NSString*)cellDictForWithdrawalsAccount;
- (void)updateCellWithDict:(NSDictionary *)dict;


@end
