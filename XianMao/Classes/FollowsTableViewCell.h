//
//  FollowsCell.h
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class User;

@protocol FollowsTableViewCellDelegate;

@interface FollowsTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(User*)user;
+ (NSString*)cellKeyForFollowsUser;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


@protocol FollowsTableViewCellDelegate <BaseTableViewCellDelegate>
@optional

@end