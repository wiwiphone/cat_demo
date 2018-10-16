//
//  ReturnGoodsCompanyCell.h
//  XianMao
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsReturnReasonCell.h"

@interface ReturnGoodsCompanyCell : ReturnGoodsReturnReasonCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSMutableArray*)reasonArr;
+ (NSMutableDictionary*)buildCellDict:(NSMutableArray*)reasonArr;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
