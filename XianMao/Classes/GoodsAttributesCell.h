//
//  GoodsAttributesCell.h
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class GoodsAttributeItem;
@interface GoodsAttributesCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSString*)cellDictKeyForAttributeItems;
+ (NSMutableDictionary*)buildCellDict:(NSArray*)items;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


