//
//  GoodsTableViewCell.h
//  XianMao
//
//  Created by simon cai on 11/9/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Command.h"

@class GoodsInfo;
@interface GoodsTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item;
+ (NSString*)cellDictKeyForGoodsInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

//=============

@class User;

@interface GoodsSellerInfoView : UIView
+ (CGFloat)heightForOrientationPortrait;

- (id)initWithFrame:(CGRect)frame showChatBtn:(BOOL)showChatBtn;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;
- (void)updateWithSellerInfo:(User*)seller;
- (void)prepareForReuse;

@end

@interface GoodsSellerInfoViewForGoodsDetail : GoodsSellerInfoView

@end

@interface SellerTagsView : TapDetectingView

+ (CGFloat)heightForOrientationPortrait:(NSArray*)tags showTitle:(BOOL)showTitle;
+ (CGFloat)widthForOrientationPortrait:(NSArray*)tags showTitle:(BOOL)showTitle;

- (void)updateWithUserInfo:(NSArray*)tags showTitle:(BOOL)showTitle;

@end

@interface GoodsApproveTagsView : UIView

+ (CGFloat)heightForOrientationPortrait:(GoodsInfo*)goodsInfo;
+ (CGFloat)heightForOrientationPortrait:(GoodsInfo*)goodsInfo showTitle:(BOOL)showTitle;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo showTitle:(BOOL)showTitle;

@end

@interface GoodsPricesView : UIView

+ (CGFloat)heightForOrientationPortrait;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;

@end

@interface GoodsLikedUsersView : UIView

+ (CGFloat)heightForOrientationPortrait;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;
- (void)updateWithLikedUsers:(NSString*)goodsId totalNum:(NSInteger)totalNum likedUsers:(NSArray*)likedUsers;
- (void)prepareForReuse;

@end

@interface GoodsActionButtonsView : UIView

+ (CGFloat)heightForOrientationPortrait;

- (id)initWithFrame:(CGRect)frame alignLeft:(BOOL)alignLeft;
- (id)initWithFrame:(CGRect)frame alignLeft:(BOOL)alignLeft isPortraitDirection:(BOOL)isPortraitDirection;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo withTitleAndNum:(BOOL)withTitleAndNum;

@end


//=============





