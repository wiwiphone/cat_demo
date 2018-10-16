//
//  GoodsInfo.h
//  XianMao
//
//  Created by simon on 12/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CachableItem.h"
#import "ApproveTagInfo.h"
#import "PictureItem.h"
#import "GoodsEditableInfo.h"

#import "EvaluateStatVo.h"
#import "User.h"

#import "GoodsGuarantee.h"

#import "RecommendVo.h"
#import "GradeVoList.h"

extern const NSInteger GOODS_STATUS_NOT_SALE;
extern const NSInteger GOODS_STATUS_ON_SALE;
extern const NSInteger GOODS_STATUS_LOCKED;
extern const NSInteger GOODS_STATUS_SOLD;

//=========================================================================
@class User;
@class GoodsStat;
@class GoodsLikedUsers;

@class GoodsPaymentTag;
@class GoodsServiceTag;
@class GoodsPromiseTag;
@class GoodsGradeTag;
@class GoodsCertTag;
@class GoodsSupportReturnTag;

@class GoodsStatusDO;
@class ActivityBaseInfo;

@interface GoodsInfo : NSObject<CachableItem>


@property(nonatomic,copy)   NSString *goodsId;
@property(nonatomic,copy)   NSString *goodsName;
@property(nonatomic,strong) User *seller;
@property(nonatomic,copy)   NSString *mainPicUrl;
@property(nonatomic,copy)   NSString *thumbUrl;
@property(nonatomic,copy)   NSString *summary;
@property(nonatomic,assign) double marketPrice;
@property(nonatomic,assign) double shopPrice;
@property(nonatomic,assign) NSInteger marketPriceCent;
@property(nonatomic,assign) NSInteger shopPriceCent;
@property(nonatomic,strong) GoodsStat *stat;
@property (nonatomic, strong) GradeVoList * gradeVoList;
@property(nonatomic,strong) NSMutableArray *likedUsers;
@property(nonatomic,strong) NSArray *gallaryItems;
@property(nonatomic,assign) NSInteger isRefresh; //是否擦亮
@property(nonatomic,assign) NSInteger surplusDay;
@property(nonatomic,assign) NSInteger fitPeople;
@property (nonatomic, assign) NSInteger supportType;
@property (nonatomic, copy) NSString * marketDesc;
@property(nonatomic,strong) NSArray *paymentTags;
@property(nonatomic,assign) NSInteger serviceType;
@property(nonatomic,strong) GoodsServiceTag *serviceTag;
@property(nonatomic,strong) NSArray *promiseTags;
@property (nonatomic, strong) NSArray *buyBackTags;
@property(nonatomic,assign) NSInteger grade;
@property(nonatomic,strong) GoodsGradeTag *gradeTag;
@property(nonatomic,strong) NSArray *certTags;
@property(nonatomic,assign) BOOL isSupportReturn;
@property(nonatomic,strong) GoodsSupportReturnTag *supportReturnTag;

@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) long long onsaleTime;
@property(nonatomic,assign) long long modifyTime;
@property(nonatomic,assign) BOOL isLiked;
@property(nonatomic,assign) BOOL isValid;
@property(nonatomic,assign) BOOL isDeleted;

@property(nonatomic,assign) double dealPrice;
@property(nonatomic,assign) NSInteger dealPriceCent;

@property(nonatomic,assign) BOOL isLimitActivity;
@property(nonatomic,strong) ActivityBaseInfo *activityBaseInfo;

@property(nonatomic,assign) NSInteger auditStatus;//audit_status, 0未审核1通过2拒绝

@property(nonatomic,strong) PictureItem *coverItem;
@property(nonatomic,copy) NSString *admComment;

@property(nonatomic,strong) EvaluateStatVo *evaluateStat;
@property (nonatomic, strong) NSMutableArray * goods_guarantee;
@property(nonatomic,assign) NSInteger expected_delivery_type;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) NSInteger goodsType;
@property (nonatomic, assign) NSInteger hasVoucher;
@property (nonatomic, strong) NSString *activityDesc;

@property (nonatomic, strong) NSArray *goodsFittings;
@property (nonatomic, copy) NSString *buyBackInfo;

@property (nonatomic, strong) NSArray *serviceIcon;
@property (nonatomic, strong) NSMutableArray * goodsBenefitInfo;

@property (nonatomic, strong) RecommendVo *recommendInfo;
@property (nonatomic, assign) NSInteger listType;
@property (nonatomic, strong) NSString * meowReduceTitle;
@property (nonatomic, strong) GoodsGuarantee *guarantee;
-(NSString *)gradeText;
+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSUInteger)getRetainCount;

- (NSInteger)approveTagsCount;
- (NSArray*)approveTags;

- (BOOL)isConsignGoods; //是否是寄售商品
- (BOOL)isOnSale;
- (BOOL)isNotOnSale;
- (BOOL)isLocked;
- (BOOL)B2CGoodsDetailOrC2CGoodsDetail;

- (NSString*)auditStatusDescription;
- (BOOL)isInAuditStatus;

- (NSString*)statusDescription;

- (void)addLikedUser:(User*)user;
- (void)removeUser:(NSInteger)userId;

- (BOOL)updateWithStatusInfo:(GoodsStatusDO*)statusInfo;
- (void)udpateWithEditableInfo:(GoodsEditableInfo*)editableInfo;

+ (BOOL)goodsStatusIsOnSale:(NSInteger)status;
+ (NSString*)goodsStatusDescription:(NSInteger)status;

+ (NSString*)formatLikesNum:(GoodsInfo*)goodsInfo withTitleAndNum:(BOOL)withTitleAndNum;
+ (NSString*)formatShareNum:(GoodsInfo*)goodsInfo withTitleAndNum:(BOOL)withTitleAndNum;
+ (NSString*)formattedDateDescription:(long long)createdTime;
+ (NSString*)formatPriceString:(double)priceDouble;
+ (NSString*)formatLikeNumString:(NSInteger)likeNum;
+ (NSString*)formatVisitNumString:(NSInteger)visitNum;

+ (NSString*)expected_delivery_desc:(NSInteger)expected_delivery_type;
+ (NSString*)expected_delivery_desc_for_detail:(NSInteger)expected_delivery_type;

@end

//=========================================================================

@interface GoodsPaymentTag : ApproveTagInfo
@end

@interface GoodsServiceTag : ApproveTagInfo
@end

@interface GoodsPromiseTag : ApproveTagInfo
@end

@interface GoodsGradeTag : ApproveTagInfo
@end

@interface GoodsCertTag : ApproveTagInfo
@end

@interface GoodsSupportReturnTag : ApproveTagInfo
@end

//=========================================================================

@interface GoodsStat : NSObject

@property(nonatomic,assign) NSInteger shareNum;
@property(nonatomic,assign) NSInteger commentNum;
@property(nonatomic,assign) NSInteger likeNum;
@property(nonatomic,assign) NSInteger visitNum;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (BOOL)updateWithOther:(GoodsStat*)other;

@end

//=========================================================================
@interface GoodsGallaryItem : PictureItem

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

//=========================================================================

@class OrderLockInfo;
@interface GoodsStatusDO : NSObject

@property(nonatomic,copy)   NSString *goodsId;
@property(nonatomic,assign) double shopPrice;
@property(nonatomic,assign) NSInteger shopPriceCent;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,strong) OrderLockInfo *orderLockInfo;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


/*
 
 service_tag { 1个 }       promise_tags { [7天包退] }     grade_tag { 1个 }
 service_type                  售后服务                             grade             cert_tags { [正品验证] }
平台寄售（is_consign），    7天包退                             级别                  正品验证，
担保，                     7天包退                              级别（自己定级）
 

 payment_tags {[]}

 
 
 
 "grade_tag" =                     {
 "icon_url" = "<null>";
 name = "\U5168\U65b0\U672a\U62c6";
 tagId = 1;
 value = "N\U7ea7";
 };
 
 
 
 "consign_tag" =                     {
 "icon_url" = "<null>";
 name = "\U5e73\U53f0\U5bc4\U552e";
 tagId = 1;
 value = "<null>";
 };
 
 service =                     (
 {
 "icon_url" = "<null>";
 name = "\U6b63\U54c1\U9a8c\U8bc1";
 tagId = 1;
 value = "<null>";
 },
 {
 "icon_url" = "<null>";
 name = "7\U5929\U5305\U6362";
 tagId = 2;
 value = "<null>";
 }
 );
 
 "consign_tag" =                     {
 "icon_url" = "<null>";
 name = "\U5e73\U53f0\U5bc4\U552e";
 tagId = 1;
 value = "<null>";
 };
 
 */










