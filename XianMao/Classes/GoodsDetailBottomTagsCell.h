//
//  GoodsDetailBottomTagsCell.h
//  XianMao
//
//  Created by simon on 1/28/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GoodsDetailBottomTagsCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;

@end
