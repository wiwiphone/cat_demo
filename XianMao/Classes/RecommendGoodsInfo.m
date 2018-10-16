//
//  GoodsRecommendInfo.m
//  XianMao
//
//  Created by simon on 2/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RecommendGoodsInfo.h"

@implementation RecommendGoodsInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)shopPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_shopPriceCent);
}

- (double)marketPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_marketPriceCent);
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            _goodsId = [dict stringValueForKey:@"goods_id"];
            _goodsName = [dict stringValueForKey:@"goods_name"];
            _goodsStat = [GoodsStat createWithDict:[dict dictionaryValueForKey:@"goods_stat"]];
            _isLiked = [dict integerValueForKey:@"is_liked" defaultValue:0]>0?YES:NO;
            _shopPrice = [[dict decimalNumberKey:@"shop_price"] doubleValue];
            _marketPrice = [[dict decimalNumberKey:@"market_price"] doubleValue];
            _shopPriceCent = [dict integerValueForKey:@"shop_price_cent"];
            _marketPriceCent = [dict integerValueForKey:@"market_price_cent"];
            _marketDesc = [dict stringValueForKey:@"marketDesc"];
            _goodsBrief = [dict stringValueForKey:@"goods_brief"];
            
            _thumbUrl = [dict stringValueForKey:@"thumb_url"];
            
            _status = [dict integerValueForKey:@"status" defaultValue:0];
            _isDeleted = [dict integerValueForKey:@"is_delete" defaultValue:0]>0?YES:NO;
            _isLimitActivity = [dict integerValueForKey:@"is_limit_activity" defaultValue:0]>0?YES:NO;
            _supportType = [dict integerValueForKey:@"support_type" defaultValue:0];
            
            self.admComment = [dict stringValueForKey:@"adm_comment"];
            self.goods_type = [dict integerValueForKey:@"goods_type"];
            if ([dict dictionaryValueForKey:@"cover"]) {
                self.coverItem = [PictureItem createWithDict:[dict dictionaryValueForKey:@"cover"]];
            }
            
            if ([dict dictionaryValueForKey:@"seller_info"]) {
                self.seller = [User createWithDict:[dict dictionaryValueForKey:@"seller_info"]];
            }
            
            _grade = [dict integerValueForKey:@"grade" defaultValue:0];
            _serviceIcon = [dict arrayValueForKey:@"serviceIcon"];
            _listType = [dict integerValueForKey:@"listType"];
            if (_listType == 1) {
                _recommendVo = [[RecommendVo alloc] initWithJSONDictionary:[dict objectForKey:@"recommendVo"]];
            }
        }
    }
    return self;
}

- (BOOL)isOnSale {
    return [GoodsInfo goodsStatusIsOnSale:self.status];
}

- (NSString*)statusDescription {
    return [GoodsInfo goodsStatusDescription:self.status];
}

- (NSString*)shopPriceString {
    return [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:self.shopPrice]];
}

- (NSString*)marketPriceString {
    return [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:self.marketPrice]];
}

- (BOOL)updateWithStatusInfo:(GoodsStatusDO*)statusInfo
{
    BOOL dataChanged = NO;
    if ([statusInfo.goodsId isEqualToString:self.goodsId]) {
        if (self.status != statusInfo.status) {
            self.status = statusInfo.status;
            dataChanged = YES;
        }
        if (_shopPrice != statusInfo.shopPrice) {
            _shopPrice = statusInfo.shopPrice;
            dataChanged = YES;
        }
        if (_shopPriceCent != statusInfo.shopPriceCent) {
            _shopPriceCent = statusInfo.shopPriceCent;
            dataChanged = YES;
        }
    }
    return dataChanged;
}

- (BOOL)updateWithGoodsInfo:(GoodsInfo*)goodsInfo
{
    BOOL dataChanged = NO;
    if ([goodsInfo.goodsId isEqualToString:self.goodsId]) {
        if (self.status != goodsInfo.status) {
            self.status = goodsInfo.status;
            dataChanged = YES;
        }
        if (_shopPrice != goodsInfo.shopPrice) {
            _shopPrice = goodsInfo.shopPrice;
            dataChanged = YES;
        }
        if (_shopPriceCent != goodsInfo.shopPriceCent) {
            _shopPriceCent = goodsInfo.shopPriceCent;
            dataChanged = YES;
        }
        if (![self.goodsName isEqualToString:goodsInfo.goodsName]) {
            self.goodsName = goodsInfo.goodsName;
            dataChanged = YES;
        }
        if ([self.goodsStat updateWithOther:goodsInfo.stat]) {
            dataChanged = YES;
        }
    }
    return dataChanged;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
}

@end
