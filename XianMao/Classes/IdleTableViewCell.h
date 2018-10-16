//
//  IdleTableViewCell.h
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsInfo.h"

@interface IdleTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo;
+ (NSString *)cellDictKeyForGoodsInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
