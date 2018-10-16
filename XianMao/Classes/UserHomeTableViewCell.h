//
//  UserHomeTableViewCell.h
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class User;
@class StoreInfo;
@class UserDetailInfo;
@class SearchFilterInfo;

@interface UserTagsTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(User*)userInfo;
+ (NSString*)cellKeyForUserInfo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end


@interface UserSummaryTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(UserDetailInfo*)userDetailInfo;
+ (NSString*)cellKeyForUserDetailInfo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end

@interface UserIntroGalleryTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(UserDetailInfo*)userDetailInfo;
+ (NSString*)cellKeyForUserDetailInfo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end

@interface UserHomeSearchFilterCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSArray*)filterInfoArray;
+ (NSString*)cellKeyForFilterInfoArray;
- (void)updateCellWithDict:(NSDictionary*)dict;

@property(nonatomic,copy) void(^handleSearchFilterButtonActionBlock)(SearchFilterInfo *filterInfo);

@end


@interface UserHomeGoodsTotalNumCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSInteger)totalNum;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end


