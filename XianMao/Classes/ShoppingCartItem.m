//
//  ShoppingCartGoodsInfo.m
//  XianMao
//
//  Created by simon on 12/8/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ShoppingCartItem.h"
#import "NSDictionary+Additions.h"
#import "GoodsInfo.h"
#import "GoodsFittings.h"

@implementation ShoppingCartItem

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
        self.goodsId = [dict stringValueForKey:@"goods_id"];
        self.goodsName = [dict stringValueForKey:@"goods_name"];
        self.thumbUrl = [dict stringValueForKey:@"thumb_url"];
        self.grade = [dict integerValueForKey:@"grade" defaultValue:0]; //0:未定级
        self.gradeTag = [GoodsGradeTag createWithDict:[dict dictionaryValueForKey:@"grade_tag"]];
        self.isDeleted = [dict integerValueForKey:@"is_delete" defaultValue:0]>0?YES:NO;
        self.isValid = [dict integerValueForKey:@"is_valid" defaultValue:0]>0?YES:NO;
        self.shopPrice = [[dict decimalNumberKey:@"shop_price"] doubleValue];
        //[dict doubleValueForKey:@"shop_price" defaultValue:0.f];
        self.marketPrice =  [[dict decimalNumberKey:@"market_price"] doubleValue];
        self.last_shop_price = [dict doubleValueForKey:@"last_shop_price" defaultValue:0];
        self.shopPriceCent = [dict integerValueForKey:@"shop_price_cent"];
        self.marketPriceCent = [dict integerValueForKey:@"market_price_cent"];
        self.service_type = [dict integerValueForKey:@"service_type"];
        //[dict doubleValueForKey:@"market_price" defaultValue:0.f];
        self.status = [dict integerValueForKey:@"status" defaultValue:0]; //未知
        self.supportType = [dict integerValueForKey:@"support_type" defaultValue:0];
        self.buyBackInfo = [dict stringValueForKey:@"buyBackInfo"];
        NSMutableArray *goodsFittings = [[NSMutableArray alloc] init];
        NSArray *arr = [dict arrayValueForKey:@"goodsFittingsList"];
        self.serviceGiftList = [dict arrayValueForKey:@"serviceGiftList"];
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in arr) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [goodsFittings addObject:[[GoodsFittings alloc] initWithJSONDictionary:dict]];
                }
            }
        }
        self.goodsFittings = goodsFittings;
        self.sellerInfo = [User createWithDict:[dict dictionaryValueForKey:@"seller_info"]];
        self.guarantee = [GoodsGuarantee createWithDict:[dict dictionaryValueForKey:@"cartGuarantee"]];
        
        self.is_use_meow = 1;
        self.is_use_jdvo = 1;
    }
    return self;
}

+ (instancetype)createWithGoodsInfo:(GoodsInfo*)goodsInfo {
    ShoppingCartItem *item = [[ShoppingCartItem alloc] init];
    item.goodsId = goodsInfo.goodsId;
    item.goodsName = goodsInfo.goodsName;
    item.thumbUrl = goodsInfo.thumbUrl;
    item.grade = goodsInfo.grade;
    item.gradeTag = goodsInfo.gradeTag;
    item.isDeleted = goodsInfo.isDeleted;
    item.isValid = goodsInfo.isValid;
    item.shopPrice = goodsInfo.shopPrice;
    item.marketPrice = goodsInfo.marketPrice;
    item.shopPriceCent = goodsInfo.shopPriceCent;
    item.marketPriceCent = goodsInfo.marketPriceCent;
    item.status = goodsInfo.status;
    item.service_type = goodsInfo.serviceType;
    item.sellerInfo = goodsInfo.seller;
    item.guarantee = goodsInfo.guarantee;
    return item;
}

- (BOOL)isOnSale {
    return [GoodsInfo goodsStatusIsOnSale:self.status];
}

- (NSString*)statusDescription {
    return [GoodsInfo goodsStatusDescription:self.status];
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.goodsId = [decoder decodeObjectForKey:@"goodsId"];
        self.goodsName = [decoder decodeObjectForKey:@"goodsName"];
        self.thumbUrl = [decoder decodeObjectForKey:@"thumbUrl"];
        self.grade = [[decoder decodeObjectForKey:@"grade"] integerValue];
        self.gradeTag = [decoder decodeObjectForKey:@"gradeTag"];
        self.isDeleted = [[decoder decodeObjectForKey:@"isDeleted"] integerValue]>0?YES:NO;
        self.isValid = [[decoder decodeObjectForKey:@"isValid"] integerValue]>0?YES:NO;
        self.shopPrice = [[decoder decodeObjectForKey:@"shopPrice"] doubleValue];
        self.marketPrice = [[decoder decodeObjectForKey:@"marketPrice"] doubleValue];
        self.shopPriceCent = [[decoder decodeObjectForKey:@"shopPriceCent"] integerValue];
        self.marketPriceCent = [[decoder decodeObjectForKey:@"marketPriceCent"] integerValue];
        self.status = [[decoder decodeObjectForKey:@"status"] integerValue];
        self.service_type = [[decoder decodeObjectForKey:@"service_type"] integerValue];
        self.last_shop_price = [[decoder decodeObjectForKey:@"last_shop_price"] doubleValue];
        self.guarantee = [decoder decodeObjectForKey:@"guarantee"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.goodsId forKey:@"goodsId"];
    [encoder encodeObject:self.goodsName forKey:@"goodsName"];
    [encoder encodeObject:self.thumbUrl forKey:@"thumbUrl"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.grade] forKey:@"grade"];
    [encoder encodeObject:self.gradeTag forKey:@"gradeTag"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.isDeleted?1:0] forKey:@"isDeleted"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.isValid?1:0] forKey:@"isValid"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.shopPrice] forKey:@"shopPrice"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.marketPrice] forKey:@"marketPrice"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.status] forKey:@"status"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.shopPriceCent] forKey:@"shopPriceCent"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.marketPriceCent] forKey:@"marketPriceCent"];
    [encoder encodeObject:[NSNumber numberWithInt:self.service_type] forKey:@"service_type"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.last_shop_price] forKey:@"last_shop_price"];
    [encoder encodeObject:self.guarantee forKey:@"guarantee"];
}

@end


