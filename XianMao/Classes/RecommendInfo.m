//
//  RecommendInfo.m
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RecommendInfo.h"
#import "RecommendTableViewCell.h"

#import "SearchResultSellerItem.h"

@implementation RecommendInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _title = [dict stringValueForKey:@"title"];
        _iconUrl = [dict stringValueForKey:@"icon_url"];
        _type = [dict integerValueForKey:@"type" defaultValue:0];
        if ([dict dictionaryValueForKey:@"more"]) {
            _moreInfo = [RedirectInfo createWithDict:[dict dictionaryValueForKey:@"more"]];
        }
        _createTime = [dict longLongValueForKey:@"createtime" defaultValue:0];
        _list = [self createListWithDictArray:_type ditctArray:[dict arrayValueForKey:@"list"]];
    }
    return self;
}

- (NSMutableArray*)createListWithDictArray:(NSInteger)type ditctArray:(NSArray*)dictArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSLog(@"_type = %ld",(long)_type);
    if (type == kRecommendTypeCategory
        || type == kRecommendTypeBrand
        || type == kRecommendTypeHotRank
        || type == kRecommendTypeBannerVolHeight
        || type == kRecommendTypeBanner
        || type == kRecommendTypeAds
        || type == kRecommendTypeTitle
        || type == kRecommendTypeWaterFollow
        || type == kRecommendTypeTopic
        || type == kRecommendTypeTouTiao
        || type == kRecommendTypeSideSlip
        || type == kRecommendTypeFloatBox
        || type == kRecommendTypeSegCell
        || type == kRecommendTypeDayNew
        || type == kRecommendTypeFindGoodGoods
        || type == kRecommendTypeTopCell) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[RedirectInfo createWithDict:dict]];
            }
        }
    }
    else if (type == kRecommendTypeGoods) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[RecommendGoodsInfo createWithDict:dict]];
            }
        }
    }
    else if (type == kRecommendTypeActivityLimitPrice) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[ActivityGoodsInfo createWithDict:dict]];
            }
        }
    }
    else if (type == kRecommendTypeSep) {
        
    }
    else if (type == kRecommendActivityCover) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[ActivityBaseInfo createWithDict:dict]];
            }
        }
    }
    else if (type == kRecommendActivityCoverWithRedirect) {
        for (NSInteger i=0;i<[dictArray count];i++) {
            if (i==0) {
                NSDictionary *dict = [dictArray objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [array addObject:[ActivityBaseInfo createWithDict:dict]];
                }
            } else {
                NSDictionary *dict = [dictArray objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [array addObject:[RedirectInfo createWithDict:dict]];
                }
            }
        }
    }
    else if (type == kRecommendLimitActivity) {
        for (NSInteger i=0;i<[dictArray count];i++) {
            if (i==0) {
                NSDictionary *dict = [dictArray objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [array addObject:[ActivityBaseInfo createWithDict:dict]];
                }
            } else {
                NSDictionary *dict = [dictArray objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [array addObject:[RedirectInfo createWithDict:dict]];
                }
            }
        }
    }
    else if (type == kRecommendTypeGoodsWithCover) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[GoodsInfo createWithDict:dict]];
            }
        }
    }
    else if (type == kRecommendTypeSeller) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[RecommendSellerInfo createWithDict:dict]];
            }
        }
    }
    else if (type == kRecommendTypeSegCell) {
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[RecommendInfo createWithDict:dict]];
            }
        }
    }else if (type == kRecommendTypeLimitRushCell){
        for (NSDictionary *dict in dictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[GoodsInfo createWithDict:dict]];
            }
        }
    }
    return array;
}

- (UIImage*)localTitleIcon {
    UIImage *icon = nil;
    NSInteger type = _type;
    if (type == kRecommendTypeCategory) {
        icon = [UIImage imageNamed:@"recommend_icon_category.png"];
    }
    else if (type == kRecommendTypeBrand) {
        icon = [UIImage imageNamed:@"recommend_icon_brand.png"];
    }
    else if (type == kRecommendTypeActivityLimitPrice) {
        icon = [UIImage imageNamed:@"recommend_icon_limited.png"];
    }
    else if (type == kRecommendTypeHotRank) {
        icon = [UIImage imageNamed:@"recommend_icon_rank.png"];
    }
    return icon;
}

- (BOOL)isValid
{
    BOOL isValid = YES;
    
    NSInteger type = _type;
    if (type == kRecommendTypeCategory
        || type == kRecommendTypeBrand
        || type == kRecommendTypeHotRank
        || type == kRecommendTypeBannerVolHeight
        || type == kRecommendTypeBanner
        || type == kRecommendTypeAds
        || type == kRecommendTypeTopic
        || type == kRecommendTypeWaterFollow
        || type == kRecommendTypeTouTiao
        || type == kRecommendTypeSideSlip
        || type == kRecommendTypeFloatBox
        || type == kRecommendTypeSegCell
        || type == kRecommendTypeDayNew
        || type == kRecommendTypeFindGoodGoods
        || type == kRecommendTypeLimitRushCell) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeGoods) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeActivityLimitPrice) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeSep) {
        
    }
    else if (type == kRecommendActivityCover) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendActivityCoverWithRedirect) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendLimitActivity) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeGoodsWithCover) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeSeller) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeSegCell) {
        isValid = [_list count]>0?YES:NO;
    }
    else if (type == kRecommendTypeTopCell) {
        
    }else if (type == kRecommendTypeLimitRushCell){
        isValid = [_list count]>0?YES:NO;
    }
    return isValid;
}

- (BOOL)isCompatible
{
    BOOL isCompatible = YES;
    NSInteger type = _type;
    switch (type) {
        case kRecommendTypeCategory:  break;
        case kRecommendTypeBrand: break;
        case kRecommendTypeHotRank: break;
        case kRecommendTypeBannerVolHeight: break;
        case kRecommendTypeBanner: break;
        case kRecommendTypeAds: break;
        case kRecommendTypeTopic: break;
        case kRecommendTypeTitle: break;
        case kRecommendTypeWaterFollow: break;
        case kRecommendTypeGoods: break;
        case kRecommendTypeActivityLimitPrice: break;
        case kRecommendTypeSep: break;
        case kRecommendActivityCover: break;
        case kRecommendActivityCoverWithRedirect: break;
        case kRecommendLimitActivity: break;
        case kRecommendTypeGoodsWithCover: break;
        case kRecommendTypeSeller: break;
        case kRecommendTypeTouTiao: break;
        case kRecommendTypeSideSlip: break;
        case kRecommendTypeSegCell: break;
        case kRecommendTypeDayNew: break;
        case kRecommendTypeFindGoodGoods: break;
        case kRecommendTypeTopCell: break;
        case kRecommendTypeLimitRushCell: break;
        default: isCompatible = NO;
            break;
    }
    return isCompatible;
}

- (BOOL)isRecommendTypeActivityLimitPrice
{
    return self.type == kRecommendTypeActivityLimitPrice;
}

- (BOOL)isRecommendTypeGoods
{
    return self.type == kRecommendTypeGoods;
}

- (BOOL)isRecommendTypeGoodsWithCover {
    return self.type == kRecommendTypeGoodsWithCover;
}

- (Class)recommendCellCls
{
    Class cls = [RecommendTableViewCell class];
    NSInteger type = _type;
    switch (type) {
        case kRecommendTypeFloatBox: cls = [RecommendFloatBoxCell class];break;
        case kRecommendTypeCategory: cls = [RecommendCategoryCell class]; break;
        case kRecommendTypeBrand: cls = [RecommendBrandCell class]; break;
        case kRecommendTypeHotRank: cls = [RecommendHotRankCell class]; break;
        case kRecommendTypeBannerVolHeight: cls = [RecommendBannerCellVolHeight class]; break;
        case kRecommendTypeBanner: cls = [RecommendBannerCell class]; break;
        case kRecommendTypeAds: cls = [RecommendAdsCell class]; break;
        case kRecommendTypeTopic: cls = [RecommendTopicCell class]; break;
        case kRecommendTypeTitle: cls = [RecommendTitleCell class]; break;
        case kRecommendTypeWaterFollow: cls = [RecommendWaterFollowCell class]; break;
        case kRecommendTypeGoods: cls = [RecommendGoodsCell class]; break;
        case kRecommendTypeActivityLimitPrice: cls = [RecommendActivityLimitPriceCell class]; break;
        case kRecommendTypeSep: cls = [RecommendSeperatorCell class]; break;
        case kRecommendActivityCover: cls = [RecommendActivityCoverCell class]; break;
        case kRecommendActivityCoverWithRedirect: cls = [RecommendActivityCoverWithRedirectCell class]; break;
        case kRecommendLimitActivity: cls = [RecommendLimitActivityCoverCell class]; break;
        case kRecommendTypeGoodsWithCover: cls = [RecommendGoodsWithCoverCell class]; break;
        case kRecommendTypeSeller: cls = [RecommendSellerCell class]; break;
        case kRecommendTypeTouTiao: cls = [RecommendTouTiaoCell class]; break;
        case kRecommendTypeSideSlip: cls = [RecommendSideSlipCell class]; break;
        case kRecommendTypeSegCell: cls = [RecommendDiscoverCell class]; break;
        case kRecommendTypeDayNew: cls = [RecommendDayNewCell class]; break;
        case kRecommendTypeFindGoodGoods: cls = [RecommendFindGoodGoodsCell class]; break;
        case kRecommendTypeTopCell: cls = [RecommendTopViewCell class]; break;
        case kRecommendTypeLimitRushCell: cls = [RecommendLimitRushCell class]; break;
    }
    return cls;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
        self.type = [[decoder decodeObjectForKey:@"type"] integerValue];
        self.moreInfo = [decoder decodeObjectForKey:@"moreInfo"];
        self.list = [decoder decodeObjectForKey:@"list"];
        self.createTime = [[decoder decodeObjectForKey:@"createTime"] longLongValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_title?_title:@"" forKey:@"title"];
    [encoder encodeObject:_iconUrl?_iconUrl:@"" forKey:@"iconUrl"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    if (self.moreInfo) {
        [encoder encodeObject:self.moreInfo forKey:@"moreInfo"];
    }
    if (self.list) {
        [encoder encodeObject:self.list forKey:@"list"];
    }
    [encoder encodeObject:[NSNumber numberWithLongLong:self.createTime] forKey:@"createTime"];
}

@end




