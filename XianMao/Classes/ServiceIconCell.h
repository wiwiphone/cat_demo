//
//  ServiceIconCell.h
//  XianMao
//
//  Created by WJH on 16/10/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsGuarantee.h"

@interface ServiceIconCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsGuarantee *)goodsGuarantee;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
