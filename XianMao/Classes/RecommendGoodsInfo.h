//
//  RecommendGoodsInfo.h
//  XianMao
//
//  Created by simon on 2/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GoodsInfo.h"
#import "User.h"
#import "RecommendVo.h"

@interface RecommendGoodsInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *goodsBrief;
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *goodsName;
@property(nonatomic,strong) GoodsStat *goodsStat;
@property(nonatomic,assign) BOOL isLiked;
@property(nonatomic,assign) double shopPrice;
@property(nonatomic,assign) double marketPrice;
@property(nonatomic,assign) NSInteger shopPriceCent;
@property(nonatomic,assign) NSInteger marketPriceCent;
@property(nonatomic,copy) NSString *thumbUrl;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) BOOL isDeleted;
@property(nonatomic,assign) BOOL isLimitActivity;
@property (nonatomic, assign) NSInteger supportType;
@property (nonatomic, copy) NSString * marketDesc;
@property(nonatomic,strong) PictureItem *coverItem;
@property(nonatomic,copy) NSString *admComment;
@property(nonatomic,strong) User *seller;

@property(nonatomic,assign) NSInteger grade;
@property (nonatomic, assign) NSInteger goods_type;

@property (nonatomic, strong) NSArray *serviceIcon;

@property (nonatomic, assign) NSInteger listType;
@property (nonatomic, strong) RecommendVo *recommendVo;
+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (BOOL)isOnSale;
- (NSString*)statusDescription;

- (NSString*)shopPriceString;
- (NSString*)marketPriceString;

- (BOOL)updateWithStatusInfo:(GoodsStatusDO*)statusInfo;
- (BOOL)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;

@end



