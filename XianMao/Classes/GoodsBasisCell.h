//
//  GoodsBasisCell.h
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"

@interface GoodsBasisCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
