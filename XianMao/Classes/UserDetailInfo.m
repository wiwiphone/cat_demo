//
//  UserDetailInfo.m
//  XianMao
//
//  Created by simon cai on 30/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "UserDetailInfo.h"

@implementation UserDetailInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        self.userInfo = [User createWithDict:[dict dictionaryValueForKey:@"user_info"]];
        NSArray *galleryItemsDict = [dict arrayValueForKey:@"gallary"];
        NSMutableArray *gallery = [[NSMutableArray alloc] initWithCapacity:galleryItemsDict.count];
        for (NSDictionary *itemDict in galleryItemsDict) {
            if ([itemDict isKindOfClass:[NSDictionary class]]) {
                [gallery addObject:[PictureItem createWithDict:itemDict]];
            }
        }
        self.contactType = [dict integerValueForKey:@"contactType"];
        self.gallary = gallery;
    }
    return self;
}

@end



