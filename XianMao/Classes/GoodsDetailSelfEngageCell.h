//
//  GoodsDetailSelfEngageCell.h
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsDetailInfo.h"

@interface GoodsDetailSelfEngageCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo;

@end
