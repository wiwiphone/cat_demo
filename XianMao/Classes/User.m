//
//  User.m
//  XianMao
//
//  Created by simon on 11/24/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "User.h"
#import "Session.h"
#import "RedirectInfo.h"

@implementation User

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (BOOL)updateWithItem:(id<CachableItem>)item {
    BOOL dataChanged = NO;
    if ([item isKindOfClass:[User class]]) {
        //User *other = (User*)item;
    }
    return dataChanged;
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.realName = [dict stringValueForKey:@"realName"];
        self.userId = [dict integerValueForKey:@"user_id" defaultValue:0];
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
        self.userName = [dict stringValueForKey:@"username" defaultValue:@""];
        self.gender = [dict integerValueForKey:@"gender" defaultValue:0];
        self.birthday = [dict longLongValueForKey:@"birthday" defaultValue:0];
        self.phoneNumber = [dict stringValueForKey:@"phone" defaultValue:@""];
        self.avatarUrl = [dict stringValueForKey:@"avatar_url" defaultValue:@""];
        self.frontUrl = [dict stringValueForKey:@"front_url" defaultValue:@""];
        self.boughtNum = [dict integerValueForKey:@"bought_num" defaultValue:0];
        self.soldNum = [dict integerValueForKey:@"sold_num" defaultValue:0];
        self.goodsNum = [dict integerValueForKey:@"goods_num" defaultValue:0];
        self.likesNum = [dict integerValueForKey:@"like_num" defaultValue:0];
        self.bonusNum = [dict intValueForKey:@"bonus_num" defaultValue:0];
        self.followingsNum = [dict integerValueForKey:@"follow_num" defaultValue:0];
        self.fansNum = [dict integerValueForKey:@"fans_num" defaultValue:0];
        self.isfollowing = [dict integerValueForKey:@"isfollowing" defaultValue:0]>0?YES:NO;
        self.isfans = [dict integerValueForKey:@"isfans" defaultValue:0]>0?YES:NO;
        self.authType = [dict integerValueForKey:@"auth_type" defaultValue:0];
        self.isSupportReturn = [dict integerValueForKey:@"is_support_return" defaultValue:0]>0?YES:NO;
        self.hasStore = [dict integerValueForKey:@"has_store" defaultValue:0]>0?YES:NO;
        self.sellerRank = [dict integerValueForKey:@"seller_rank" defaultValue:0];
        self.summary = [dict stringValueForKey:@"summary"];
        self.weixinId = [dict stringValueForKey:@"weixinId"];
        self.autotrophyGoodsVo = [[AutotrophyVo alloc] initWithJSONDictionary:[dict objectForKey:@"autotrophyGoodsVo"]];
        self.score = [dict integerValueForKey:@"score"];
        
        self.authTypes = [dict objectForKey:@"authTypes"];
        
        NSMutableArray *adBannerList = [[NSMutableArray alloc] init];
        NSArray *arr = dict[@"adBanner"];
        for (int i = 0; i < arr.count; i++) {
            RecommendVo *recommendInfo = [[RecommendVo alloc] initWithJSONDictionary:arr[i]];
            [adBannerList addObject:recommendInfo];
        }
        self.adBanner = adBannerList;
        
        if ([dict dictionaryValueForKey:@"orderGoodsInfoVo"]) {
            self.orderGoodsInfoVo = [[OrderGoodsInfoVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"orderGoodsInfoVo"]];
        }
        
        if ([dict dictionaryValueForKey:@"third_party"]) {
            self.thirdPartyAccountInfo = [[ThirdPartyAccountInfo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"third_party"]];
        }
        
        self.storeType = [dict integerValueForKey:@"storeType" defaultValue:0];
        self.adBanner = [[RecommendVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"adBanner"]];
        NSMutableArray * sellerBanners = [[NSMutableArray alloc] init];
        if ([dict arrayValueForKey:@"sellerBanners"]) {
            NSArray * array = [dict arrayValueForKey:@"sellerBanners"];
            for (NSDictionary * sellerBannerDict in array) {
                [sellerBanners addObject:[RedirectInfo createWithDict:sellerBannerDict]];
            }
            self.sellerBanners = sellerBanners;
        }
        self.thirdPart = [NSMutableArray arrayWithArray:[dict arrayValueForKey:@"thirdPart"]];
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.userId = [[decoder decodeObjectForKey:@"userId"] integerValue];
        self.type = [[decoder decodeObjectForKey:@"type"] integerValue];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.gender = [[decoder decodeObjectForKey:@"gender"] integerValue];
        self.birthday = [[decoder decodeObjectForKey:@"birthday"] longLongValue];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        self.frontUrl = [decoder decodeObjectForKey:@"frontUrl"];
        self.boughtNum = [[decoder decodeObjectForKey:@"boughtNum"] integerValue];
        self.soldNum = [[decoder decodeObjectForKey:@"soldNum"] integerValue];
        self.goodsNum = [[decoder decodeObjectForKey:@"goodsNum"] integerValue];
        self.likesNum = [[decoder decodeObjectForKey:@"likesNum"] integerValue];
        self.followingsNum = [[decoder decodeObjectForKey:@"followingsNum"] integerValue];
        self.fansNum = [[decoder decodeObjectForKey:@"fansNum"] integerValue];
        self.isfollowing = [[decoder decodeObjectForKey:@"isfollowing"] integerValue]>0?YES:NO;
        self.isfans = [[decoder decodeObjectForKey:@"isfans"] integerValue]>0?YES:NO;
        self.authType = [[decoder decodeObjectForKey:@"authType"] integerValue];
        self.isSupportReturn = [[decoder decodeObjectForKey:@"isSupportReturn"] integerValue]>0?YES:NO;
        self.hasStore = [[decoder decodeObjectForKey:@"hasStore"] integerValue]>0?YES:NO;
        self.sellerRank = [[decoder decodeObjectForKey:@"sellerRank"] integerValue];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.storeType = [[decoder decodeObjectForKey:@"storeType"] integerValue];
        self.score = [[decoder decodeObjectForKey:@"score"] integerValue];
        self.bonusNum = [[decoder decodeObjectForKey:@"bonusNum"] integerValue];
        self.thirdPartyAccountInfo = [decoder decodeObjectForKey:@"third_party"];
        self.orderGoodsInfoVo = [decoder decodeObjectForKey:@"orderGoodsInfoVo"];
        self.sellerBanners = [decoder decodeObjectForKey:@"sellerBanners"];
        self.authTypes = [decoder decodeObjectForKey:@"authTypes"];
        self.thirdPart = [decoder decodeObjectForKey:@"thirdPart"];
        self.weixinId = [decoder decodeObjectForKey:@"weixinId"];
        self.adBanner = [decoder decodeObjectForKey:@"adBanner"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.weixinId forKey:@"weixinId"];
    [encoder encodeObject:self.sellerBanners forKey:@"sellerBanners"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.birthday] forKey:@"birthday"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [encoder encodeObject:self.frontUrl forKey:@"frontUrl"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.boughtNum]  forKey:@"boughtNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.soldNum]  forKey:@"soldNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.goodsNum]  forKey:@"goodsNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.likesNum]  forKey:@"likesNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.followingsNum]  forKey:@"followingsNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.fansNum]  forKey:@"fansNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.bonusNum] forKey:@"bonusNum"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.isfollowing?1:0]  forKey:@"isfollowing"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.isfans?1:0]  forKey:@"isfans"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.authType] forKey:@"authType"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.isSupportReturn?1:0]  forKey:@"isSupportReturn"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.hasStore?1:0]  forKey:@"hasStore"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.sellerRank]  forKey:@"sellerRank"];
    [encoder encodeObject:self.summary?self.summary:@"" forKey:@"summary"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.score] forKey:@"score"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.storeType] forKey:@"storeType"];
    [encoder encodeObject:self.authTypes forKey:@"authTypes"];
    [encoder encodeObject:self.orderGoodsInfoVo forKey:@"orderGoodsInfoVo"];
    [encoder encodeObject:self.thirdPart forKey:@"thirdPart"];
    [encoder encodeObject:self.adBanner forKey:@"adBanner"];
}

- (void)updateWithUserInfo:(User*)userInfo
{
    self.type = userInfo.type;
    self.userName = userInfo.userName;
    self.gender = userInfo.gender;
    self.birthday = userInfo.birthday;
    self.avatarUrl = userInfo.avatarUrl;
    self.frontUrl = userInfo.frontUrl;
    self.boughtNum = userInfo.boughtNum;
    self.soldNum = userInfo.soldNum;
    self.goodsNum = userInfo.goodsNum;
    self.likesNum = userInfo.likesNum;
    self.followingsNum = userInfo.followingsNum;
    self.fansNum = userInfo.fansNum;
    self.bonusNum = userInfo.bonusNum;
    
    self.authType = userInfo.authType;
    self.isSupportReturn = userInfo.isSupportReturn;
    self.sellerRank = userInfo.sellerRank;
    self.hasStore = userInfo.hasStore;
    self.summary = userInfo.summary;
    
    self.authTypes = userInfo.authTypes;
    self.orderGoodsInfoVo = userInfo.orderGoodsInfoVo;
    self.thirdPart = userInfo.thirdPart;
}

- (BOOL)updateByMsgCount:(MsgCount*)msgCount
{
    BOOL isDataChanged = NO;
    if (self.boughtNum != msgCount.bought) {
        self.boughtNum = msgCount.bought;
        isDataChanged = YES;
    }
    if (self.likesNum != msgCount.enjoy) {
        self.likesNum = msgCount.enjoy;
        isDataChanged = YES;
    }
    if (self.fansNum != msgCount.fans) {
        self.fansNum = msgCount.fans;
        isDataChanged = YES;
    }
    if (self.followingsNum != msgCount.follow) {
        self.followingsNum = msgCount.follow;
        isDataChanged = YES;
    }
    if (self.goodsNum != msgCount.goods) {
        self.goodsNum = msgCount.goods;
        isDataChanged = YES;
    }
    if (self.soldNum != msgCount.sold) {
        self.soldNum = msgCount.sold;
        isDataChanged = YES;
    }
    return isDataChanged;
}

- (BOOL)isAuthSeller {
    return _authType==1?YES:NO;
}

- (BOOL)isChengXinSeller {
    return _authType==2?YES:NO;
}

- (BOOL)isB2CGoods{
    return _storeType == 2?YES:NO;
}

- (BOOL)isC2CGoods{
    return _storeType == 1?YES:NO;
}

- (BOOL)isMeowGoods{
    return _storeType == 3?YES:NO;
}

- (NSArray*)approveTags {
    NSLog(@"%ld", (long)_authType);
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    if ([self isChengXinSeller]) {
        [tags addObject:[UserTagInfo createTagInfo:@"诚信卖家" icon:[UIImage imageNamed:@"userIcon_chengxin"]]];
    }
    if ([self isAuthSeller]) {
        [tags addObject:[UserTagInfo createTagInfo:@"认证用户" icon:[UIImage imageNamed:@"userIcon_verify"]]];
    }
    if (self.goodsNum>0) {
        [tags addObject:[UserTagInfo createTagInfo:@"担保交易" icon:[UIImage imageNamed:@"userIcon_dan"]]];
    }
    if (self.isSupportReturn) {
        [tags addObject:[UserTagInfo createTagInfo:@"7天包退" icon:[UIImage imageNamed:@"userIcon_7"]]];
    }
    if (self.sellerRank==100) {
        [tags addObject:[UserTagInfo createTagInfo:@"皇冠卖家" icon:[UIImage imageNamed:@"userIcon_crown"]]];
    }
    if (self.hasStore) {
        [tags addObject:[UserTagInfo createTagInfo:@"实体店铺" icon:[UIImage imageNamed:@"userIcon_shop"]]];
    }
    return tags;
}

- (NSArray*)authTags {
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    if ([self isAuthSeller]) {
        [tags addObject:[UserTagInfo createTagInfo:@"认证用户" icon:[UIImage imageNamed:@"userIcon_verify"]]];
    }
    if ([self isChengXinSeller]) {
        [tags addObject:[UserTagInfo createTagInfo:@"诚信卖家" icon:[UIImage imageNamed:@"userIcon_chengxin"]]];
    }
    return tags;
}

@end


@implementation UserTagInfo

+ (UserTagInfo*)createTagInfo:(NSString*)name icon:(UIImage*)icon
{
    UserTagInfo *tagInfo = [[UserTagInfo alloc] init];
    tagInfo.name = name;
    tagInfo.icon = icon;
    return tagInfo;
}

@end


@implementation EMAccount

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.emUserName = [dict stringValueForKey:@"em_username"];
        self.emPassword = [dict stringValueForKey:@"em_password"];
        self.userId = [dict integerValueForKey:@"user_id" defaultValue:0];
        self.username = [dict stringValueForKey:@"username"];
        self.avatar = [dict stringValueForKey:@"avatar"];
    }
    return self;
}

- (void)updateWithEMAccount:(EMAccount*)emAccount {
    self.username = emAccount.username;
    self.emUserName = emAccount.emUserName;
    self.emPassword = emAccount.emPassword;
    self.userId = emAccount.userId;
    self.avatar = emAccount.avatar;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.username = [decoder decodeObjectForKey:@"username"];
        self.emPassword = [decoder decodeObjectForKey:@"emPassword"];
        self.userId = [[decoder decodeObjectForKey:@"userId"] integerValue];
        self.emUserName = [decoder decodeObjectForKey:@"emUserName"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.userId]  forKey:@"userId"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.emPassword forKey:@"emPassword"];
    [encoder encodeObject:self.emUserName forKey:@"emUserName"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
}

@end


@implementation MsgCount

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        _bought = [dict integerValueForKey:@"bought" defaultValue:0];
        _consign = [dict integerValueForKey:@"consign" defaultValue:0];
        _enjoy = [dict integerValueForKey:@"enjoy" defaultValue:0];
        _fans = [dict integerValueForKey:@"fans" defaultValue:0];
        _follow = [dict integerValueForKey:@"follow" defaultValue:0];
        _goods = [dict integerValueForKey:@"goods" defaultValue:0];
//        _newNoticeCount = [dict integerValueForKey:@"new_notice_count" defaultValue:0];
        //add code
//        _newNoticeCount = [dict integerValueForKey:@"get_notice_count" defaultValue:0];
//        NSLog(@"_newNoticeCount:%ld", (long)[dict integerValueForKey:@"new_notice_count" defaultValue:0]);
        _sold = [dict integerValueForKey:@"sold" defaultValue:0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.bought = [[decoder decodeObjectForKey:@"bought"] integerValue];
        self.consign = [[decoder decodeObjectForKey:@"consign"] integerValue];
        self.fans = [[decoder decodeObjectForKey:@"fans"] integerValue];
        self.goods = [[decoder decodeObjectForKey:@"goods"] integerValue];
        self.newNoticeCount = [[decoder decodeObjectForKey:@"newNoticeCount"] integerValue];
        self.sold = [[decoder decodeObjectForKey:@"sold"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.bought]  forKey:@"bought"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.consign]  forKey:@"consign"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.fans]  forKey:@"fans"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.goods]  forKey:@"goods"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.newNoticeCount]  forKey:@"newNoticeCount"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.sold]  forKey:@"sold"];
}

@end

@implementation ThirdPartyAccountInfo

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.user_id = [[decoder decodeObjectForKey:@"user_id"] integerValue];
        self.platform = [[decoder decodeObjectForKey:@"platform"] stringValue];
        self.uid = [[decoder decodeObjectForKey:@"uid"] stringValue];
        self.username = [[decoder decodeObjectForKey:@"username"] stringValue];
        self.icon_url = [[decoder decodeObjectForKey:@"icon_url"] stringValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.user_id]  forKey:@"user_id"];
    [encoder encodeObject:self.platform?self.platform:@"" forKey:@"platform"];
    [encoder encodeObject:self.uid?self.uid:@"" forKey:@"uid"];
    [encoder encodeObject:self.username?self.username:@"" forKey:@"username"];
    [encoder encodeObject:self.icon_url?self.icon_url:@"" forKey:@"icon_url"];
}

@end



