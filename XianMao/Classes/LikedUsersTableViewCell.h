//
//  LikedUsersTableViewCell.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LikedUsersTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSString*)cellDictKeyForLikedUsers;
+ (NSMutableDictionary*)buildCellDict:(NSString*)goodsId totalNum:(NSInteger)totalNum likedUsers:(NSArray*)likedUsers;

@end
