//
//  WashIllustrateCell.h
//  XianMao
//
//  Created by WJH on 16/10/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"


@interface WashIllustrateCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsGuarantee *)guarantee;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
