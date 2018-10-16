//
//  UserLikesTableViewCell.h
//  XianMao
//
//  Created by simon on 1/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class GoodsInfo;

@interface UserLikesTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo isInEditMode:(BOOL)isInEditMode;
+ (NSString*)cellKeyForUserLikesGoodsInfo;
+ (NSString*)cellDictKeyForInEditMode;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
