//
//  RecommendInfo.h
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ActivityInfo.h"
#import "GoodsInfo.h"
#import "RecommendGoodsInfo.h"
#import "RedirectInfo.h"

#define kRecommendTypeCategory  1
#define kRecommendTypeBrand     2
#define kRecommendTypeHotRank   3
#define kRecommendTypeBannerVolHeight   9 //volatile可变高度
#define kRecommendTypeBanner   10
#define kRecommendTypeAds      11
#define kRecommendActivityCover   12 // 活动封面   返回结构
#define kRecommendActivityCoverWithRedirect 13 //
#define kRecommendLimitActivity   14 //限时活动

#define kRecommendTypeTitle    15
#define kRecommendTypeWaterFollow 16

#define kRecommendTypeTouTiao 20

#define kRecommendTypeSideSlip 21


#define kRecommendTypeGoods    100
#define kRecommendTypeActivityLimitPrice 101
#define kRecommendTypeGoodsWithCover    104
#define kRecommendTypeSeller    106

#define kRecommendTypeTopic     108

#define kRecommendTypeSep      200

#define kRecommendTypeFloatBox 111//107

#define kRecommendTypeSegCell 109

#define kRecommendTypeDayNew 112//今日上新
#define kRecommendTypeFindGoodGoods 113//发现好货
#define kRecommendTypeTopCell 114//头部标题
#define kRecommendTypeLimitRushCell 110//商品限时抢购
//跟app展示相关
//1 分类浏览形式
//2 大牌竞选形式
//3 最热排行形式
//
//10 banner
//11单条广告位
//
//100 单个宝贝
//101 限时降价

@interface RecommendInfo : NSObject<NSCoding>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) RedirectInfo *moreInfo;
@property(nonatomic,strong) NSMutableArray *list;
@property(nonatomic,assign) long long createTime;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (Class)recommendCellCls;
- (BOOL)isValid;
- (BOOL)isCompatible;
- (BOOL)isRecommendTypeActivityLimitPrice;
- (BOOL)isRecommendTypeGoods;
- (BOOL)isRecommendTypeGoodsWithCover;
- (UIImage*)localTitleIcon;

@end


//createtime": 1423311086326,
//"title": null,
//"icon_url": null,
//"type": 11,
//"more": null,
//"list":


//public static final int SIDESLIP = 21; //侧滑  @白骁  @卢云  小二后台增加个类型 ”侧滑“，同首焦配置 @HYL


