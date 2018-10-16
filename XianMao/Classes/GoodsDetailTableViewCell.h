//
//  GoodsDetailTableViewCell.h
//  XianMao
//
//  Created by simon cai on 27/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Command.h"

@class GoodsDetailInfo;
@class GoodsInfo;


@interface GoodsDetailBaseInfoCell : BaseTableViewCell
@property (nonatomic, copy) void(^handlegradeTagBlock)(GoodsGradeTag * gradeVo);

@property(nonatomic,weak,readonly) UIView *likeBtnView;

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item;
+ (NSString*)cellDictKeyForGoodsInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface SegTabViewTitleCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item;
+ (NSString*)cellDictKeyForGoodsInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;
@property(nonatomic,copy) void(^handleShareCommentsBlock)();
@property(nonatomic,copy) void(^handleShopCommentsBlock)();
@property(nonatomic,copy) void(^handleSupportCommentsBlock)(GoodsInfo *goodsInfo);


@end


@interface GoodsDetailAppoveTagsCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item;
+ (NSString*)cellDictKeyForGoodsInfo;

@property(nonatomic,copy) void(^handleMoreBtnClicked)();

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface GoodsDetailServeTagsCell : BaseTableViewCell

@property(nonatomic,copy) void(^handleMoreBtnClicked)();

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo*)detailInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface GoodsAttributesButtonCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
@end

@interface GoodsTagsCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSArray*)tagList goodsInfo:(GoodsInfo *)goodsInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface GoodsTagsView : UIView

+ (CGFloat)heightForOrientationPortrait:(NSArray*)tagList;
- (void)updateWithTagList:(NSArray*)tagList grade:(NSString *)gradeName;

@end


@interface GoodsRecommendSepCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
@end

@interface GoodsDescribeSepCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
@end

@interface DealguaranteCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict:(NSArray *)imageDescGroupItems;
@end

@protocol GoodsCommentTitleCellDelegata <NSObject>

@optional
-(void)replyTitleCell:(UITextField *)textField;

@end

@interface GoodsCommentTitleCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo*)item;
- (void)updateCellWithDict:(GoodsDetailInfo *)dict;
@property(nonatomic,copy) void(^handleAddCommentsBlock)();
@property (nonatomic, weak) id<GoodsCommentTitleCellDelegata> delegateTextField;
@end

@interface GoodsMoreCommentsCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
@property(nonatomic,copy) void(^handleMoreCommentsBlock)();
@end


@interface GoodsNoCommentsCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
@property(nonatomic,copy) void(^handleAddCommentsBlock)();
@end










