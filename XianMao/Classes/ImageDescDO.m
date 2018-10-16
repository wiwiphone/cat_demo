//
//  ImageDescDO.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ImageDescDO.h"

@implementation ImageDescDO

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        //redirectUri = "http://www.baidu.com";
        _picItem = [PictureItem createWithDict:[dict dictionaryValueForKey:@"picture_item"]];
        _redirectUri = [dict stringValueForKey:@"redirect_uri"];
    }
    return self;
}

@end


@implementation ImageDescGroup

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _title = [dict stringValueForKey:@"title"];
        _iconUrl = [dict stringValueForKey:@"icon_url"];
        _isExpandable = [dict integerValueForKey:@"is_expandable" defaultValue:0]>0?YES:NO;
        _isExpanded = [dict integerValueForKey:@"is_expanded" defaultValue:0]>0?YES:NO;
        
        NSMutableArray *arrayItems = [[NSMutableArray alloc] init];
        NSArray *array = [dict arrayValueForKey:@"items"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [arrayItems addObject:[ImageDescDO createWithDict:dict]];
                }
            }
        }
        _items = arrayItems;
    }
    return self;
}

@end


