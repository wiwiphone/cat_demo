//
//  ServiceTagCell.h
//  XianMao
//
//  Created by WJH on 16/10/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"

@interface ServiceTagCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
