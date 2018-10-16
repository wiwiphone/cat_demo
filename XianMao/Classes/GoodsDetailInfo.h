//
//  GoodsDetailInfo.h
//  XianMao
//
//  Created by simon cai on 11/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GoodsInfo.h"
#import "BrandInfo.h"
#import "ImageDescDO.h"
#import "OrderLockInfo.h"
#import "TagVo.h"

//=========================================================================
@class GoodsGallaryItem;
@class GoodsDetailPicItem;
@class GoodsAttrItem;
@class AutotrophyGoodsVo;

@interface GoodsDetailInfo : NSObject

@property(nonatomic,strong) GoodsInfo *goodsInfo;
@property(nonatomic,strong) NSArray *tagList;
@property (nonatomic, assign) NSInteger comment_num;
@property(nonatomic,strong) NSArray *gallaryItems;
@property(nonatomic,strong) NSArray *detailPicItems;
@property(nonatomic,strong) NSArray *attrItems;
@property(nonatomic,strong) BrandInfo *brandInfo;
@property(nonatomic,strong) NSArray *imageDescGroupItems;
@property(nonatomic,strong) OrderLockInfo *orderLockInfo;
@property (nonatomic, assign) NSInteger contactType;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

//"goods_info": {goods_info},
//"detail_pics":[{"pic_id":"xxx1",
//    "pic_url":"xxx",
//    "pic_desc":"desc"},……],
//"gallary":[{"pic_id":"xxx1",
//    "pic_url":"xxx",
//    "pic_desc":"desc"},……],

@end

//=========================================================================
@interface GoodsDetailPicItem : PictureItem

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

//=========================================================================
@interface GoodsAttributeItem : NSObject

@property(nonatomic,assign) NSInteger attrId;
@property(nonatomic,copy) NSString *attrName;
@property(nonatomic,copy) NSString *attrValue;

+ (GoodsAttributeItem*)allocWithNameAndValue:(NSString*)name value:(NSString*)value;
+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


@interface GoodsAttributeItemWithHelpURL : GoodsAttributeItem

@property(nonatomic,copy) NSString *helpURL;

@end





