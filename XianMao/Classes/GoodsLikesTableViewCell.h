//
//  GoodsLikesTableViewCell.h
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class User;
@interface GoodsLikesTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(User*)user;
+ (NSString*)cellKeyForGoodsLikedUser;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
