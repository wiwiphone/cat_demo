//
//  BrandInfo.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BrandInfo.h"
#import "pinyin.h"
@implementation BrandInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        _brandId = [dict integerValueForKey:@"brand_id"];
        _brandEnName = [dict stringValueForKey:@"brand_en_name"];
        _brandName = [dict stringValueForKey:@"brand_name"];
        _iconUrl = [dict stringValueForKey:@"logo_url"];
        _redirect_uri = [dict stringValueForKey:@"redirect_uri"];
        _brandDesc = [dict stringValueForKey:@"brand_desc"];
    }
    return self;
}

- (NSString *)getFirstNameEn
{
    NSString *firstChar = [_brandEnName substringToIndex:1];
    if ([firstChar canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return [firstChar substringToIndex:1];
    } else {
        char firstletter = ' ';
        if ([firstChar isEqualToString:@"重"] || [firstChar isEqualToString:@"长"]) {
            firstletter = 'C';
        } else {
            firstletter = pinyinFirstLetter([firstChar characterAtIndex:0]);
        }
        return [NSString stringWithFormat:@"%c",firstletter];
    }
}

- (NSString *)getFirstName
{
    NSString *firstChar = [_brandName substringToIndex:1];
    if ([firstChar canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return [firstChar substringToIndex:1];
    } else {
        char firstletter = ' ';
        if ([firstChar isEqualToString:@"重"] || [firstChar isEqualToString:@"长"]) {
            firstletter = 'C';
        } else {
            firstletter = pinyinFirstLetter([firstChar characterAtIndex:0]);
        }
        return [NSString stringWithFormat:@"%c",firstletter];
    }
}

@end




