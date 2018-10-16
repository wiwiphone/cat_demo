//
//  ExpectedDeliveryCell.h
//  XianMao
//
//  Created by 阿杜 on 16/9/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"
#import "GoodsGuarantee.h"

@interface ExpectedDeliveryCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)GoodsInfo;
+ (NSMutableDictionary*)buildCellDict;
+ (NSMutableDictionary*)buildGoodsGuaranteeCellDict:(GoodsGuarantee *)goodsGuarantee;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
