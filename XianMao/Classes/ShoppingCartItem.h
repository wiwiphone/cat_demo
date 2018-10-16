//
//  ShoppingCartGoodsInfo.h
//  XianMao
//
//  Created by simon on 12/8/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "GoodsGuarantee.h"
#import "MeowReduceVo.h"
#import "JDServiceVo.h"
@class GoodsGradeTag;
@class GoodsInfo;

@interface ShoppingCartItem : NSObject<NSCoding>

@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *goodsName;
@property(nonatomic,copy) NSString *thumbUrl;
@property(nonatomic,assign) NSInteger grade;
@property(nonatomic,strong) GoodsGradeTag *gradeTag;
@property(nonatomic,assign) BOOL isDeleted;
@property(nonatomic,assign) BOOL isValid;
@property(nonatomic,assign) double shopPrice;
@property(nonatomic,assign) double marketPrice;
@property(nonatomic,assign) double last_shop_price;
@property(nonatomic,assign) NSInteger shopPriceCent;
@property(nonatomic,assign) NSInteger marketPriceCent;
@property (nonatomic, assign) NSInteger service_type;
@property (nonatomic, assign) NSInteger supportType;
@property (nonatomic, strong) NSArray *goodsFittings;
@property (nonatomic, copy) NSString *buyBackInfo;
@property (nonatomic, strong) NSArray * serviceGiftList;
@property(nonatomic,assign) NSInteger status;
@property (nonatomic, strong) User *sellerInfo;
@property(nonatomic,strong) NSArray *approveTags;
@property (nonatomic, strong) GoodsGuarantee *guarantee;

@property (nonatomic, assign) NSInteger is_use_meow;
@property (nonatomic, assign) NSInteger is_use_jdvo;

@property (nonatomic, assign) BOOL isChooseJianD;
@property (nonatomic, assign) BOOL isOnJianD;
@property (nonatomic, assign) BOOL isOnDik;
@property (nonatomic, strong) MeowReduceVo *meowReduceVo;
@property (nonatomic, strong) JDServiceVo *serviceVo;
@property (nonatomic, copy) NSString *message;

+ (instancetype)createWithGoodsInfo:(GoodsInfo*)goodsInfo;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (BOOL)isOnSale;
- (NSString*)statusDescription;

@end


