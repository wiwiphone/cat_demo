//
//  RecoveryGoodsVo.h
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "SellerBasicInfo.h"
#import "MainPic.h"
@interface RecoveryGoodsVo : JSONModel

extern const NSInteger GOODS_STATUS_NOT_SALE;
extern const NSInteger GOODS_STATUS_ON_SALE;
extern const NSInteger GOODS_STATUS_LOCKED;
extern const NSInteger GOODS_STATUS_SOLD;

@property (nonatomic, copy) NSString *goodsSn;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, assign) long long exprTime;
@property (nonatomic, strong) NSArray *gallary;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger service_type;
@property (nonatomic, assign) NSInteger is_valid;
@property (nonatomic, assign) NSInteger is_delete;
@property (nonatomic, assign) long long updatetime;
@property (nonatomic, copy) NSString *goodsBrief;
@property (nonatomic, assign) NSInteger is_liked;
@property (nonatomic, assign) NSInteger offSaleFixTime;

@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, assign) NSInteger offerCount;
@property (nonatomic, assign) long long offSaleTime;
@property (nonatomic, assign) long long leftMilTime;
@property (nonatomic, assign) long long saleTime;

//添加推荐
@property (nonatomic, assign) NSInteger isRecommend;
@property (nonatomic, assign) NSInteger maxOfferPrice;

@property (nonatomic, strong) SellerBasicInfo *sellerBasicInfo;
@property (nonatomic, strong) MainPic *mainPic;

- (BOOL)isConsignGoods;
- (BOOL)isOnSales;
- (BOOL)isNotOnSales;
+ (NSString*)goodsStatusDescription:(NSInteger)status;
@end
