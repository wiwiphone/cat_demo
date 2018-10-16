//
//  User.h
//  XianMao
//
//  Created by simon on 11/24/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "CachableItem.h"
#import "ApproveTagInfo.h"
#import "OrderGoodsInfoVo.h"
#import "AutotrophyVo.h"
#import "RecommendVo.h"

@class ThirdPartyAccountInfo;
@class MsgCount;

@interface User : NSObject<CachableItem,NSCoding>

@property(nonatomic,assign) NSUInteger userId;
@property(nonatomic,assign) NSInteger type; //客服：1
@property(nonatomic,copy)   NSString  *userName;
@property(nonatomic,copy) NSString * realName;
@property(nonatomic,assign) NSInteger  gender;
@property(nonatomic,assign) long long  birthday;
@property(nonatomic,copy)   NSString  *phoneNumber;
@property(nonatomic,copy)   NSString * weixinId;
@property(nonatomic,copy)   NSString  *avatarUrl;
@property(nonatomic,copy)   NSString  *frontUrl;
@property(nonatomic,assign) NSInteger boughtNum;
@property(nonatomic,assign) NSInteger soldNum;
@property(nonatomic,assign) NSInteger goodsNum;
@property(nonatomic,assign) NSInteger likesNum;
@property(nonatomic,assign) NSInteger bonusNum;
@property(nonatomic,assign) NSInteger followingsNum;
@property(nonatomic,assign) NSInteger fansNum;
@property(nonatomic,assign) BOOL      isfollowing;
@property(nonatomic,assign) BOOL      isfans;
@property(nonatomic,assign) NSInteger authType; //0没有认证，1已经认证
@property (nonatomic, strong) AutotrophyVo *autotrophyGoodsVo;
@property(nonatomic,assign) BOOL      isSupportReturn;
@property(nonatomic,assign) BOOL      hasStore;
@property(nonatomic,assign) NSInteger sellerRank;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,assign) NSInteger score;
@property (nonatomic, assign) NSInteger storeType; //1 代表个人店铺，2，代表商城店铺 3.描述喵钻商城
@property(nonatomic, strong) NSArray *authTypes;
@property (nonatomic, strong) NSMutableArray * sellerBanners;
@property (nonatomic, strong) NSMutableArray *thirdPart;
@property (nonatomic, strong) NSArray *adBanner;

@property(nonatomic,strong) ThirdPartyAccountInfo *thirdPartyAccountInfo;

//新增字段统计个人页面数量
@property (nonatomic, strong) OrderGoodsInfoVo *orderGoodsInfoVo;

- (NSArray*)approveTags;
- (NSArray*)authTags;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (void)updateWithUserInfo:(User*)userInfo;
- (BOOL)updateByMsgCount:(MsgCount*)msgCount;

- (BOOL)isAuthSeller;
- (BOOL)isChengXinSeller;
- (BOOL)isB2CGoods;
- (BOOL)isC2CGoods;
- (BOOL)isMeowGoods;


@end

@interface UserTagInfo : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) UIImage *icon;
+ (UserTagInfo*)createTagInfo:(NSString*)name icon:(UIImage*)icon;
@end


@interface EMAccount : NSObject<NSCoding>

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (void)updateWithEMAccount:(EMAccount*)emAccount;

@property(nonatomic,copy) NSString *emUserName;
@property(nonatomic,copy) NSString *emPassword;
@property(nonatomic,assign) NSInteger userId;

@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *avatar;

@end


@interface MsgCount : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger bought;
@property(nonatomic,assign) NSInteger consign;
@property(nonatomic,assign) NSInteger enjoy;
@property(nonatomic,assign) NSInteger fans;
@property(nonatomic,assign) NSInteger follow;
@property(nonatomic,assign) NSInteger goods;
@property(nonatomic,assign) NSInteger newNoticeCount;
@property(nonatomic,assign) NSInteger sold;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface ThirdPartyAccountInfo : JSONModel<NSCoding>
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,copy) NSString *platform;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *icon_url;
@property (nonatomic, copy) NSString *xuid;
@end

//"third_party": {
//    "user_id": 1569,
//    "platform": "wx",
//    "uid": "123123112",
//    "username": "adsf",
//    "icon_url": "wwww.baidu.com",
//    "status": 1
//},


