//
//  C2CActivityCell.h
//  XianMao
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"

@interface C2CActivityCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
