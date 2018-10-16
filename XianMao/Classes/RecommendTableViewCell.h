//
//  RecommendTableViewCell.h
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecommendInfo.h"
#import "Command.h"

@interface RecommendTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(RecommendInfo*)recommendInfo;
+ (NSString*)cellKeyForRecommendInfo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end

@interface RecommendSeperatorCell : RecommendTableViewCell

@end


@interface RecommendWaterFollowCell : RecommendTableViewCell

@end

@interface RecommendWaterFollowView : UIView

- (void)updateWithRecommendInfo:(RecommendInfo*)recommendInfo;
+ (CGFloat)rowHeightForPortrait:(RecommendInfo*)recommendInfo;

@property(nonatomic,strong) NSMutableArray *visibleSubviewRects;
@property(nonatomic,strong) NSMutableArray *resolvedSubviewRects;
@property(nonatomic,strong) NSMutableArray *visibleSubviews;

@end

@interface RecommendTitleCell : RecommendTableViewCell

@end

@interface RecommendTableCellWithTitle : RecommendTableViewCell

@property(nonatomic,strong) UIView *itemsView;

@end

@interface RecommendActivityLimitPriceCell : RecommendTableCellWithTitle

@end

@interface RecommendCategoryCell : RecommendTableCellWithTitle

@end

@interface RecommendHotRankCell : RecommendTableCellWithTitle

@end

@interface RecommendBrandCell : RecommendTableCellWithTitle

@end


@class RecommendGoodsView;
@interface RecommendGoodsCell : RecommendTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSArray*)goodsInfoArray;
+ (NSString*)cellKeyForGoodsInfoArray;

- (RecommendGoodsView*)createRecommendGoodsView;

@end
@interface RecommendGoodsCellSearch : RecommendGoodsCell

- (RecommendGoodsView*)createRecommendGoodsView;

@property(nonatomic,copy) void(^handleRecommendGoodsClickBlock)(RecommendGoodsInfo *recommendGoodsInfo);

@end


typedef void(^clickCell)(BOOL isYes);
@interface RecommendDiscoverCell : RecommendTableViewCell

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) clickCell clickCell;
@end

@interface RecommendBannerCell : RecommendTableViewCell

@end

@interface RecommendBannerCellVolHeight : RecommendBannerCell

@end

@interface RecommendAdsCell : RecommendTableViewCell

@property(nonatomic,copy) NSString *redirectUri;
@property (nonatomic, strong) RedirectInfo *redirectInfo;


@end

@interface RecommendTopicCell : RecommendTableViewCell

@property(nonatomic,copy) NSString *redirectUri;
@property (nonatomic, strong) RedirectInfo *redirectInfo;

@end

@interface RecommendTitleView : TapDetectingView

@property(nonatomic,copy) NSString *redirectUri;
@property (nonatomic, strong) RedirectInfo *redirectInfo;

+ (CGFloat)rowHeightForPortrait;
- (void)updateWithRecommendInfo:(RecommendInfo*)recommendInfo;

@end

typedef NS_ENUM(NSInteger, RedirectInfoViewContentMode) {
    RedirectInfoViewContentModeTop,
    RedirectInfoViewContentModeTopLeft,
    RedirectInfoViewContentModeTopRight,
    RedirectInfoViewContentModeMiddleLeft,
    RedirectInfoViewContentModeMiddleRight,
};

@interface RedirectInfoView : TapDetectingView

@property(nonatomic,assign) CGFloat infoViewTileMarginTop;
@property(nonatomic,assign) CGFloat infoViewTileMarginLeft;
@property(nonatomic,assign) RedirectInfoViewContentMode infoViewContentMode;

@property(nonatomic,copy) NSString *redirectUri;
@property (nonatomic, strong) RedirectInfo *redirectInfo;

- (void)prepareForReuse;
- (void)updateWithRedirectInfo:(RedirectInfo*)redirectInfo imageSize:(CGSize)imageSize;

@end

@interface RedirectInfoViewCatetory : RedirectInfoView
@end

@interface RedirectInfoViewBrand : RedirectInfoView
@end

@interface RecommendActivityLimitedView : TapDetectingView

@property(nonatomic,copy) NSString *goodsId;

+ (CGFloat)rowHeightForPortrait;
- (void)prepareForReuse;
- (void)updateWithRedirectInfo:(ActivityGoodsInfo*)activityInfo;

@end


@interface RecommendGoodsView : TapDetectingView

@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,strong) RecommendGoodsInfo *recommendGoodsInfo;

+ (CGFloat)rowHeightForPortrait:(RecommendInfo *)info;
- (void)updateWithRedirectInfo:(RecommendGoodsInfo*)recommendGoodsInfo;

@end

@interface RecommendGoodsViewSearch : RecommendGoodsView

@property(nonatomic,copy) void(^handleRecommendGoodsClickBlock)(RecommendGoodsInfo *recommendGoodsInfo);

@end

@interface RecommendActivityCoverCell : RecommendTableViewCell

@end

@interface RecommendLimitActivityCoverCell : RecommendTableViewCell

@end

@interface RecommendActivityCoverWithRedirectCell : RecommendTableViewCell

@end

@interface RecommendGoodsWithCoverCell : RecommendTableViewCell

+ (NSMutableDictionary*)buildCellDict:(RecommendInfo*)recommendInfo isShowGoodsCover:(BOOL)isShowGoodsCover isShowFollowBtn:(BOOL)isShowFollowBtn;

+ (NSMutableDictionary*)buildCellDict:(RecommendInfo*)recommendInfo isShowGoodsCover:(BOOL)isShowGoodsCover isShowFollowBtn:(BOOL)isShowFollowBtn pageIndex:(NSInteger)pageIndex;

@end


@interface RecommendSellerCell : RecommendTableViewCell

@end


@interface RecommendTouTiaoCell : RecommendTableViewCell

@end

@interface RecommendSideSlipCell : RecommendTableViewCell

@end

@interface RecommendDayNewCell : RecommendTableViewCell

@end

@interface RecommendFindGoodGoodsCell : RecommendTableViewCell

@end

@interface RecommendTopViewCell : RecommendTableViewCell

@end

@interface RecommendLimitRushCell : RecommendTableViewCell

@end

@class RecommendFloatBoxCell;
@class SelectButton;
typedef void (^UrlBlock)();
@interface RecommendFloatBoxCell : RecommendTableViewCell
@property (nonatomic, weak) UIView *container;
@property (nonatomic, copy) UrlBlock niceBlock;
@property (nonatomic, copy) UrlBlock followBlock;
@property (nonatomic, weak) SelectButton *niceButton;
@property (nonatomic, weak) SelectButton *followButton;
@end

@interface SelectButton : UIButton

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *selectUrl;
- (void)setButtonStyle;
@end
@interface TapImageView : UIImageView
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, copy) NSString *url;
@end

@class RecommendForumCell;

typedef void (^TapImageBlock)(NSInteger index, NSArray *array, XMWebImageView *image);//TapImageView *image);
typedef void (^TapBlock)();
typedef void (^TapViewBlock) (NSInteger likeNum, BOOL islike, NSNumber *type, NSNumber *post_id);
typedef void (^TapTypeBlock) (NSNumber *type, NSNumber *post_id);
typedef void (^TapStrBlcok) (NSNumber *type,NSString *str);
typedef void (^TapReplyBlock) (NSNumber *type, NSNumber *post_id);
@interface RecommendForumCell : RecommendTableViewCell

@property (nonatomic, copy) TapImageBlock block;
@property (nonatomic, copy) TapViewBlock likeBlock;
@property (nonatomic, copy) TapTypeBlock commentBlock;
@property (nonatomic, copy) TapReplyBlock replyBlock;
@property (nonatomic, copy) TapBlock shatrBlock;
@property (nonatomic, copy) TapTypeBlock avatarBlock;
@property (nonatomic, copy) TapTypeBlock tagBlock;
@property (nonatomic, copy) TapStrBlcok strBlock;

@property (nonatomic, assign) NSInteger isChosen;

- (void)didSelectThisCell;
@end



@interface SideSlipRedirectInfoView : TapDetectingView

@property(nonatomic,copy) NSString *redirectUri;
@property (nonatomic, strong) RedirectInfo *redirectInfo;

- (void)prepareForReuse;
- (void)updateWithRedirectInfo:(RedirectInfo*)redirectInfo imageSize:(CGSize)imageSize;

@end


//
//包袋：品牌、材质、款式、功能、价格
//
//手表：品牌、机芯、表带、表壳、价格
//
//服务：类别、品牌、价格
//
//配饰：类别（如下）
//     腰带：品牌、类型、材质、长度、价格
//     帽子&手套：品牌、材质、价格
//     钥匙扣/袖口/包饰/其他：品牌、材质、价格
//     太阳镜/眼镜：品牌、功能、镜架材质、价格
//     围巾/披肩/领带：品牌、材质、价格
//     手镯/手链：品牌、材质、系列、价格
//     胸针：品牌、材质、价格
//     戒指/指环：品牌、材质、系列、价格
//     耳饰：品牌、材质、系列、价格
//     项链/吊坠：品牌、材质、系列、价格



