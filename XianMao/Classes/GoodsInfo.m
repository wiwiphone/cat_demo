//
//  GoodsInfo.m
//  XianMao
//
//  Created by simon on 12/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsInfo.h"
#import "NSDictionary+Additions.h"
#import "User.h"

#import "DataSources.h"
#import "ActivityInfo.h"
#import "PictureItem.h"
#import "GoodsDetailInfo.h"
#import "GoodsFittings.h"
#import "GoodsGuarantee.h"
#import "GradeItemVo.h"

const NSInteger GOODS_STATUS_NOT_SALE = 0;
const NSInteger GOODS_STATUS_ON_SALE = 1;
const NSInteger GOODS_STATUS_LOCKED = 2;
const NSInteger GOODS_STATUS_SOLD = 3;

@implementation GoodsInfo

-(NSString *)gradeText{
    NSString *text = [[NSString alloc] init];
    switch (self.grade) {
        case 1:
            text = @"N1";
            break;
        case 5:
            text = @"N2";
            break;
        case 2:
            text = @"N3";
            break;
        case 7:
            text = @"S1";
            break;
        case 3:
            text = @"S2";
            break;
        case 6:
            text = @"B1";
            break;
        case 4:
            text = @"B2";
            break;
        default:
            break;
    }
    return text;
}

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)marketPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_marketPriceCent);
}

- (double)shopPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_shopPriceCent);
}

- (double)dealPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_dealPriceCent);
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && dict && [dict isKindOfClass:[NSDictionary class]]) {
        self.isRefresh = [dict intValueForKey:@"is_refresh"];
        self.surplusDay = [dict intValueForKey:@"surplus_day"];
        self.goodsId = [dict stringValueForKey:@"goods_id"];
        self.goodsName = [dict stringValueForKey:@"goods_name" defaultValue:@""];
        self.seller = [User createWithDict:[dict dictionaryValueForKey:@"seller_info"]];
        self.mainPicUrl = [dict stringValueForKey:@"main_pic_url"];
        self.thumbUrl = [dict stringValueForKey:@"thumb_url"];
        self.summary = [dict stringValueForKey:@"summary" defaultValue:@""];
        self.marketPrice = [[dict decimalNumberKey:@"market_price"] doubleValue];
        //[dict doubleValueForKey:@"market_price" defaultValue:0.f];
        self.shopPrice = [[dict decimalNumberKey:@"shop_price"] doubleValue];
        //[dict doubleValueForKey:@"shop_price" defaultValue:0.f];
        self.stat = [GoodsStat createWithDict:[dict dictionaryValueForKey:@"goods_stat"]];
        //self.likes = [GoodsLikedUsers createWithDict:[dict dictionaryValueForKey:@"likes"]];
        self.createTime = [dict longLongValueForKey:@"createTime"];
        self.marketPriceCent = [dict integerValueForKey:@"market_price_cent"];
        self.shopPriceCent = [dict integerValueForKey:@"shop_price_cent"];
        self.goodsType = [dict integerValueForKey:@"goods_type"];
        _fitPeople = [dict integerValueForKey:@"fit_people" defaultValue:0];
        self.hasVoucher = [dict integerValueForKey:@"hasVoucher"];
        self.activityDesc = [dict stringValueForKey:@"activityDesc"];
        self.marketDesc = [dict stringValueForKey:@"marketDesc"];
        
        NSMutableArray *gallaryItems = [[NSMutableArray alloc] init];
        NSArray *detailPicItemDicts = [dict arrayValueForKey:@"gallary"];
        if ([detailPicItemDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in detailPicItemDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [gallaryItems addObject:[GoodsGallaryItem createWithDict:dict]];
                }
            }
        }
        self.gallaryItems = gallaryItems;
        
        NSMutableArray *goodsFittings = [[NSMutableArray alloc] init];
        NSArray *arr = [dict arrayValueForKey:@"goodsFittingsList"];
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in arr) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [goodsFittings addObject:[[GoodsFittings alloc] initWithJSONDictionary:dict]];
                }
            }
        }
        self.goodsFittings = goodsFittings;
        
        NSMutableArray * goodsGuarantee = [[NSMutableArray alloc] init];
        NSArray * array = [dict arrayValueForKey:@"goods_guarantee"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary * dict in array) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [goodsGuarantee addObject:[GoodsGuarantee createWithDict:dict]];
                }
            }
        }
        self.goods_guarantee = goodsGuarantee;
        
        NSMutableArray * goodsBenefitInfo = [[NSMutableArray alloc] init];
        NSArray * BenefitInfoArr = [dict arrayValueForKey:@"goods_benefit_info"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary * dict in BenefitInfoArr) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [goodsBenefitInfo addObject:[GoodsGuarantee createWithDict:dict]];
                }
            }
        }
        self.goodsBenefitInfo = goodsBenefitInfo;
        
//        self.buyBackTags = [dict arrayValueForKey:@"promiseTags"];
        
        if ([dict arrayValueForKey:@"promiseTags"]) {
            self.buyBackTags = [GoodsPromiseTag createWithDictArray:[dict arrayValueForKey:@"promiseTags"]];
        }
        
        if ([dict arrayValueForKey:@"payment_tags"])
            self.paymentTags = [GoodsPaymentTag createWithDictArray:[dict arrayValueForKey:@"payment_tags"]];
        
        self.serviceType = [dict integerValueForKey:@"service_type" defaultValue:0];
        
        if ([dict dictionaryValueForKey:@"service_tag"])
            self.serviceTag = [GoodsServiceTag createWithDict:[dict dictionaryValueForKey:@"service_tag"]];
        
        if ([dict arrayValueForKey:@"promise_tags"])
            self.promiseTags = [GoodsPromiseTag createWithDictArray:[dict arrayValueForKey:@"promise_tags"]];
        
        self.grade = [dict integerValueForKey:@"grade" defaultValue:0];
        if ([dict dictionaryValueForKey:@"grade_tag"])
            self.gradeTag = [GoodsGradeTag createWithDict:[dict dictionaryValueForKey:@"grade_tag"]];
        
        if ([dict arrayValueForKey:@"cert_tags"])
            self.certTags = [GoodsCertTag createWithDictArray:[dict arrayValueForKey:@"cert_tags"]];
        
        self.status = [dict integerValueForKey:@"status" defaultValue:0];
        self.isValid = [dict integerValueForKey:@"is_valid" defaultValue:0]>0?YES:NO;
        self.isDeleted = [dict integerValueForKey:@"is_delete" defaultValue:0]>0?YES:NO;
        self.onsaleTime = [dict longLongValueForKey:@"onsale_time" defaultValue:0];
        self.modifyTime = [dict longLongValueForKey:@"modify_time" defaultValue:0];
        self.meowReduceTitle = [dict stringValueForKey:@"meowReduceTitle"];
        self.isLiked = [dict integerValueForKey:@"is_liked" defaultValue:0]>0?YES:NO;
        
        NSArray *userDictArray = [dict arrayValueForKey:@"liked_users"];
        NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:[userDictArray count]];
        for (int i=0;i<[userDictArray count];i++) {
            [users addObject:[User createWithDict:[userDictArray objectAtIndex:i]]];
        }
        self.likedUsers = users;
        
        _dealPrice = [[dict decimalNumberKey:@"deal_price"] doubleValue];
        _dealPriceCent = [dict integerValueForKey:@"deal_price_cent"];
        
        self.isLimitActivity = [dict integerValueForKey:@"is_limit_activity" defaultValue:0]>0?YES:NO;
        NSDictionary *activityBaseInfoDict = [dict dictionaryValueForKey:@"activity_base_info"];
        if (activityBaseInfoDict) {
            self.activityBaseInfo = [ActivityBaseInfo createWithDict:activityBaseInfoDict];
        }
        
        self.isSupportReturn = [dict integerValueForKey:@"is_support_return" defaultValue:0]>0?YES:NO;
        if ([dict dictionaryValueForKey:@"support_return_tag"]) {
            self.supportReturnTag = [GoodsSupportReturnTag createWithDict:[dict dictionaryValueForKey:@"support_return_tag"]];
        }
        
        self.auditStatus = [dict integerValueForKey:@"audit_status" defaultValue:0];
        
        self.admComment = [dict stringValueForKey:@"adm_comment"];
        if ([dict dictionaryValueForKey:@"cover"]) {
            self.coverItem = [PictureItem createWithDict:[dict dictionaryValueForKey:@"cover"]];
        }
        
        if ([dict dictionaryValueForKey:@"evaluate_stat"]) {
            self.evaluateStat = [EvaluateStatVo createWithDict:[dict dictionaryValueForKey:@"evaluate_stat"]];
        }
        
        _expected_delivery_type = [dict integerValueForKey:@"expected_delivery_type"];
        _buyBackInfo = [dict stringValueForKey:@"buyBackInfo"];
        _supportType = [dict integerValueForKey:@"support_type"];
        
        _serviceIcon = [dict arrayValueForKey:@"serviceIcon"];
        
        _guarantee = [GoodsGuarantee createWithDict:[dict dictionaryValueForKey:@"cartGuarantee"]];
        
        _recommendInfo = [[RecommendVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"recommendVo"]];
        _listType = [dict integerValueForKey:@"listType"];

        _gradeVoList = [GradeVoList createWithDict:[dict dictionaryValueForKey:@"grade_desc_list"]];
    
    }
    return self;
}

- (NSInteger)approveTagsCount {
    NSInteger count = 0;
    if ([self.certTags count]>0) {
        count += [self.certTags count];
    }
    if ([self.promiseTags count]>0) {
        count += [self.promiseTags count];
    }
    if (self.serviceTag) {
        count += 1;
    }
    if (self.gradeTag) {
        count += 1;
    }
    if ([self.paymentTags count]>0) {
        count += [self.paymentTags count];
    }
    return count;
}

- (NSArray*)approveTags {
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    //正品保证 权威鉴定
    if ([self.certTags count]>0) {
        [tags addObjectsFromArray:self.certTags];
    }
    if (self.supportReturnTag && self.isSupportReturn) {
        [tags addObject:self.supportReturnTag];
    }
    // 全场包邮
    if ([self.promiseTags count]>0) {
        [tags addObjectsFromArray:self.promiseTags];
    }
    
    if (self.buyBackTags.count > 0) {
        [tags addObjectsFromArray:self.buyBackTags];
    }
//    if (self.serviceTag) {
//        [tags addObject:self.serviceTag];
//    }
//    if ([self.paymentTags count]>0) {
//        [tags addObjectsFromArray:self.paymentTags];
//    }
    NSLog(@"%ld", tags.count);
    return tags;
}

- (BOOL)isConsignGoods {
    return self.serviceType==1?YES:NO;
}

- (BOOL)isOnSale {
    return _status==GOODS_STATUS_ON_SALE;;
}

- (BOOL)isNotOnSale {
    return _status == GOODS_STATUS_NOT_SALE;

}

- (BOOL)isLocked {
    return _status == GOODS_STATUS_LOCKED;
}
- (BOOL)B2CGoodsDetailOrC2CGoodsDetail
{
    return self.goodsType == 1 ? YES : NO; //goodsType = 1 B2C商品详情页
}
- (BOOL)isInAuditStatus {
    return _auditStatus!=1?YES:NO;
}
- (NSString*)auditStatusDescription {
    //0未审核1通过2拒绝
    if (_auditStatus==1) {
        return @"审核通过";
    } else if (_auditStatus==2) {
        return @"审核未通过";
    }
    return @"待审核";
}

- (NSString*)statusDescription {
    return [[self class] goodsStatusDescription:self.status];
}

- (void)addLikedUser:(User*)user {
    if (!_likedUsers) {
        _likedUsers = [[NSMutableArray alloc] init];
    }
    if (user) {
        for (User *tmpUser in _likedUsers) {
            if (tmpUser.userId == user.userId) {
                [_likedUsers removeObject:tmpUser];
                break;
            }
        }
        [_likedUsers insertObject:user atIndex:0];
    }
}

- (void)removeUser:(NSInteger)userId {
    for (User *user in _likedUsers) {
        if ([user isKindOfClass:[User class]]) {
            if (user.userId == userId) {
                [_likedUsers removeObject:user];
                break;
            }
        }
    }
}

- (BOOL)updateWithStatusInfo:(GoodsStatusDO*)statusInfo
{
    BOOL dataChanged = NO;
    if ([statusInfo.goodsId isEqualToString:self.goodsId]) {
        if (_status != statusInfo.status) {
            _status = statusInfo.status;
            dataChanged = YES;
        }
        if (_shopPrice != statusInfo.shopPrice) {
            _shopPrice = statusInfo.shopPrice;
            dataChanged = YES;
        }
        if (_shopPriceCent!=statusInfo.shopPriceCent) {
            _shopPriceCent =statusInfo.shopPriceCent;
            dataChanged = YES;
        }
        
    }
    return dataChanged;
}

- (void)udpateWithEditableInfo:(GoodsEditableInfo*)editableInfo
{
    _mainPicUrl = editableInfo.mainPicItem.picUrl;
    _gallaryItems = editableInfo.gallary;
    _thumbUrl = editableInfo.mainPicItem.picUrl;
    _goodsName = editableInfo.goodsName;
    _shopPrice = editableInfo.shopPrice;
    _marketPrice = editableInfo.marketPrice;
    _shopPriceCent = editableInfo.shopPriceCent;
    _marketPriceCent = editableInfo.marketPriceCent;
    _grade = editableInfo.grade;
    
    GradeInfo *gradeInfo = [GradeInfo gradeInfoByGrade:editableInfo.grade];
    GoodsGradeTag *tag = [[GoodsGradeTag alloc] init];
    tag.tagId = gradeInfo.grade;
    tag.name = gradeInfo.gradeDesc;
    tag.value = gradeInfo.gradeName;
    _gradeTag = tag;
    
    _isSupportReturn = editableInfo.isSupportReturn;
    _summary = editableInfo.summary;
}

- (BOOL)updateWithItem:(id<CachableItem>)item {
    BOOL dataChanged = NO;
    if ([item isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *other = (GoodsInfo*)item;
        if ([self.goodsId isEqualToString:other.goodsId]) {
            
            if (![_goodsName isEqualToString:other.goodsName]) {
                _goodsName = other.goodsName;
                dataChanged = YES;
            }
            if (_marketPrice != other.marketPrice) {
                _marketPrice = other.marketPrice;
                dataChanged = YES;
            }
            if (_shopPrice != other.shopPrice) {
                _shopPrice = other.shopPrice;
                dataChanged = YES;
            }
            if (_marketPriceCent != other.marketPriceCent) {
                _marketPriceCent = other.marketPriceCent;
                dataChanged = YES;
            }
            if (_shopPriceCent != other.shopPriceCent) {
                _shopPriceCent = other.shopPriceCent;
                dataChanged = YES;
            }
            
            if ([_stat updateWithOther:other.stat]) {
                dataChanged = YES;
            }
            
            _likedUsers = [[NSMutableArray alloc] initWithArray:other.likedUsers];
            
            if (_grade != other.grade) {
                _grade = other.grade;
                _gradeTag = other.gradeTag;
                dataChanged = YES;
            }
            
            if (_serviceType!=other.serviceType) {
                _serviceType = other.serviceType;
                dataChanged = YES;
            }
            
            _paymentTags = [[NSArray alloc] initWithArray:other.paymentTags];
            _serviceTag = other.serviceTag;
            _promiseTags = [[NSArray alloc] initWithArray:other.promiseTags];
            _certTags = [[NSArray alloc] initWithArray:other.certTags];
            
            if (_onsaleTime != other.onsaleTime) {
                _onsaleTime = other.onsaleTime;
                dataChanged = YES;
            }
            
            if (_isLiked != other.isLiked) {
                _isLiked = other.isLiked;
                dataChanged = YES;
            }
            
            if (_status != other.status) {
                _status = other.status;
                dataChanged = YES;
            }
            
            if (_isDeleted != other.isDeleted) {
                _isDeleted = other.isDeleted;
                dataChanged = YES;
            }
            
            if (_modifyTime!=other.modifyTime) {
                _modifyTime = other.modifyTime;
                dataChanged = YES;
            }
            
            if (_onsaleTime != other.onsaleTime) {
                _onsaleTime = other.onsaleTime;
                dataChanged = YES;
            }
            
            _seller = other.seller;
            _gallaryItems = other.gallaryItems;
        }
    }
    return dataChanged;
}

- (NSUInteger)getRetainCount {
    return CFGetRetainCount((__bridge CFTypeRef)self);
}

+ (BOOL)goodsStatusIsOnSale:(NSInteger)status {
    return status==GOODS_STATUS_ON_SALE;
}

+ (NSString*)goodsStatusDescription:(NSInteger)status {
    NSString *description = @"已失效";
    switch (status) {
        case GOODS_STATUS_NOT_SALE:
            description = @"已下架";
            break;
        case GOODS_STATUS_ON_SALE:
            description = @"在售";
            break;
        case GOODS_STATUS_LOCKED:
            description = @"付款中";//@"已锁定"; 已售罄 已被抢 已
            break;
        case GOODS_STATUS_SOLD:
            description = @"已售罄";
            break;
    }
//    if (status!=GOODS_STATUS_NOT_SALE) {
//        description = @"已失效";
//    }
    return description;
}

+ (NSString*)formatLikesNum:(GoodsInfo*)goodsInfo withTitleAndNum:(BOOL)withTitleAndNum {
    if (goodsInfo
        && goodsInfo.stat
        && goodsInfo.stat.likeNum>0) {
        
        if (withTitleAndNum) {
            return [NSString stringWithFormat:@"想要  %ld",(long)goodsInfo.stat.likeNum];
        } else {
            return [NSString stringWithFormat:@"%ld",(long)goodsInfo.stat.likeNum];
        }
    }
    return @"想要";
}

+ (NSString*)formatShareNum:(GoodsInfo*)goodsInfo withTitleAndNum:(BOOL)withTitleAndNum {
    if (goodsInfo
        && goodsInfo.stat
        && goodsInfo.stat.shareNum>0) {
        if (withTitleAndNum) {
            return [NSString stringWithFormat:@"分享  %ld",(long)goodsInfo.stat.shareNum];
        } else {
            return [NSString stringWithFormat:@"%ld",(long)goodsInfo.stat.shareNum];
        }
    }
    return @"分享";
}

/*格式化日期描述*/
+ (NSString *)formattedDateDescription:(long long)createdTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdTime/1000];//[NSDate date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟前";
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%ld分钟前", (long)timeInterval / 60];
    } else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:@"%ld小时前", (long)timeInterval / 3600];
    } else if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:date]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:date]];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}


+ (NSString*)formatPriceString:(double)priceDouble {
    NSInteger price = [NSNumber numberWithDouble:priceDouble].integerValue;
    NSInteger X = price/1000;
    
    //小数字部分 .xx
    NSString *priceDecimalString = @"";
    if (priceDouble-price>0) {
        NSMutableString *strTmp = [NSMutableString stringWithFormat:@"%.2f",priceDouble-price];
        [strTmp deleteCharactersInRange:NSMakeRange(0, 1)];
        priceDecimalString = strTmp;
    }
    
    if (X>0) {
        if (X>=1000) {
            NSString *formatedPrice = [self formatPriceString:X];
            NSMutableString *priceIntegerString = [NSMutableString stringWithFormat:@"%d",price-X*1000];
            while (priceIntegerString.length<3) {
                [priceIntegerString insertString:@"0" atIndex:0];
            }
            return [NSString stringWithFormat:@"%@,%@%@",formatedPrice,priceIntegerString,priceDecimalString];
        } else {
            NSMutableString *priceIntegerString = [NSMutableString stringWithFormat:@"%d",price-X*1000];
            while (priceIntegerString.length<3) {
                [priceIntegerString insertString:@"0" atIndex:0];
            }
            return [NSString stringWithFormat:@"%d,%@%@",X,priceIntegerString,priceDecimalString];
        }
    } else {
        //0.xx
        return [NSString stringWithFormat:@"%d%@",price%1000,priceDecimalString];
    }
    
    return [NSString stringWithFormat:@"%.2f",priceDouble];
}

+ (NSString*)formatLikeNumString:(NSInteger)likeNum {
    if (likeNum<1000) {
        return [NSString stringWithFormat:@"%ld",(long)likeNum];
    } else {
        return @"999+";
    }
//    else if (likeNum<10000) {
//        return [NSString stringWithFormat:@"%.1fk",(CGFloat)likeNum/1000];
//    } else {
//        return [NSString stringWithFormat:@"%.1f万",(CGFloat)likeNum/10000];
//    }
}

+ (NSString*)formatVisitNumString:(NSInteger)visitNum {
    if (visitNum<100000) {
        return [NSString stringWithFormat:@"%ld",(long)visitNum];
    } else {
        return @"99999+";
    }
}

+ (NSString*)expected_delivery_desc:(NSInteger)expected_delivery_type {
    NSString *text = @"未知";
    switch (expected_delivery_type) {
        case 1:
            text = @"立即";
            break;
        case 2:
            text = @"1～3天";
            break;
        case 3:
            text = @"3～5天";
            break;
        case 4:
            text = @"5～10天";
            break;
        case 5:
            text = @"10天以上";
            break;
        default:
            break;
    }
//     0）未知 1）立即 2）1～3天 3）3～5天 4）5～10天 5）10天以上   goodsinfoVo和goodsEditableInfo都加了 @白骁 @卢云
    return text;
}

+ (NSString*)expected_delivery_desc_for_detail:(NSInteger)expected_delivery_type {
    NSString *text = @"未知";
    switch (expected_delivery_type) {
        case 0:
            text = @"未知";
            break;
        case 1:
            text = @"立即发货";
            break;
        case 2:
            text = @"1～3天内发货";
            break;
        case 3:
            text = @"3～5天内发货";
            break;
        case 4:
            text = @"5～10天内发货";
            break;
        case 5:
            text = @"需10天以上发货";
            break;
        default:
            break;
    }
    //     0）未知 1）立即 2）1～3天 3）3～5天 4）5～10天 5）10天以上   goodsinfoVo和goodsEditableInfo都加了 @白骁 @卢云
    return text;
}
@end

//=========================================================================

@implementation GoodsPaymentTag

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (UIImage*)localTagIcon {
    if (self.tagId==1) {
//        return [UIImage imageNamed:@"goods_tag_payment_alipay_big"];
        return [UIImage imageNamed:@"goods_New_appove_tag_common"];
        //return [DataSources goodsTagPaymentIconAlipay];
    }
    return nil;
}
@end

@implementation GoodsServiceTag

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (UIImage*)localTagIcon {
    if (self.tagId==1) {
        //约定：寄售 1
        return [DataSources goodsTagConsignIcon];
    } else if (self.tagId==2) {
        //约定：商家 2
        return [DataSources goodsTagDanIcon];
    }
    return nil;
}
@end

@implementation GoodsPromiseTag

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (UIImage*)localTagIcon {
    if (self.tagId==1) {
//        return [UIImage imageNamed:@"goods_tag_promise_back_big"];
        return [UIImage imageNamed:@"goods_New_appove_tag_common"];
        //return [DataSources goodsTagPromiseIconBack];
    }
    else if (self.tagId==2) {
//        return [UIImage imageNamed:@"goods_tag_promise_freemail_big"];
        return [UIImage imageNamed:@"goods_New_appove_tag_common"];
    }
    return nil;
}
@end

@implementation GoodsGradeTag

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (UIImage*)localTagIcon {
    UIImage *image = nil;
    switch (self.tagId) {
        case 1: image = [DataSources goodsTagGradeIconN]; break;
        case 2: image = [DataSources goodsTagGradeIconS]; break;
        case 3: image = [DataSources goodsTagGradeIconA]; break;
        case 4: image = [DataSources goodsTagGradeIconB]; break;
        case 5: image = [DataSources goodsTagGradeIconC]; break;
        
    }
    return image;
}
@end

@implementation GoodsCertTag

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (UIImage*)localTagIcon {
    if (self.tagId==1) {
//        return [UIImage imageNamed:@"goods_tag_cert_real_big"];
        return [UIImage imageNamed:@"goods_New_appove_tag_common"];
        //return [DataSources goodsTagCertIconReal];
    }
    else if (self.tagId==2) {
//        return [UIImage imageNamed:@"goods_tag_cert_identify_big"];
        return [UIImage imageNamed:@"goods_New_appove_tag_common"];
    }
    return nil;
}
@end

@implementation GoodsSupportReturnTag

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (UIImage*)localTagIcon {
    if (self.tagId==1) {
//        return [UIImage imageNamed:@"goods_tag_promise_back_big"];
        return [UIImage imageNamed:@"goods_New_appove_tag_common"];
        //return [DataSources goodsTagPromiseIconBack];
    }
    return nil;
}

@end

//=========================================================================

@implementation GoodsStat

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.shareNum = [dict integerValueForKey:@"share_num" defaultValue:0];
        self.commentNum = [dict integerValueForKey:@"comment_num" defaultValue:0];
        self.likeNum = [dict integerValueForKey:@"like_num" defaultValue:0];
        self.visitNum = [dict integerValueForKey:@"visit_num" defaultValue:0];
    }
    return self;
}

- (BOOL)updateWithOther:(GoodsStat*)other {
    BOOL isDataChanged = NO;
    if (_shareNum!=other.shareNum) {
        _shareNum = other.shareNum;
        isDataChanged = YES;
    }
    if (_likeNum != other.likeNum) {
        _likeNum = other.likeNum;
        isDataChanged = YES;
    }
    if (_commentNum!=other.commentNum) {
        _commentNum = other.commentNum;
        isDataChanged = YES;
    }
    return isDataChanged;
}

@end

//=========================================================================
@implementation GoodsGallaryItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    return [super initWithDict:dict];
}

@end

@implementation GoodsStatusDO

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)shopPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_shopPriceCent);
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && dict && [dict isKindOfClass:[NSDictionary class]]) {
        self.goodsId = [dict stringValueForKey:@"goods_id"];
        self.shopPrice = [[dict decimalNumberKey:@"shop_price"] doubleValue];
        self.shopPriceCent = [dict integerValueForKey:@"shop_price_cent"];
        self.status = [dict integerValueForKey:@"status" defaultValue:0];
        if ([dict dictionaryValueForKey:@"lock_info"]) {
            _orderLockInfo = [OrderLockInfo createWithDict:[dict dictionaryValueForKey:@"lock_info"]];
        }
    }
    return self;
}

@end




