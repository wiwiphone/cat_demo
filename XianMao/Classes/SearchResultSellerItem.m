//
//  SearchResultSellerItem.m
//  XianMao
//
//  Created by simon cai on 8/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "SearchResultSellerItem.h"

@implementation SearchResultSellerItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        //redirectUri = "http://www.baidu.com";
        //        _picItem = [PictureItem createWithDict:[dict dictionaryValueForKey:@"picture_item"]];
        
        _sellerInfo = [User createWithDict:[dict dictionaryValueForKey:@"user_info"]];
        
        NSMutableArray *redirectList = [[NSMutableArray alloc] init];
        NSArray *list = [dict arrayValueForKey:@"list"];
        if ([list isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in list) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [redirectList addObject:[RedirectInfo createWithDict:dict]];
                }
            }
        }
        _redirectList = redirectList;
    }
    return self;
}


@end


@implementation RecommendSellerInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

@end

