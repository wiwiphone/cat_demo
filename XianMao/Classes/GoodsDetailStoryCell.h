//
//  GoodsDetailStoryCell.h
//  XianMao
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class GoodsInfo;
@interface GoodsDetailStoryCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item;
+ (NSString*)cellDictKeyForGoodsInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
