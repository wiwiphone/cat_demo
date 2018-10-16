//
//  SearchFilterInfo.m
//  XianMao
//
//  Created by simon on 2/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "SearchFilterInfo.h"
#import "URLScheme.h"
#import "NSString+URLEncoding.h"

@implementation SearchFilterInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _name = [dict stringValueForKey:@"name"];
        _type = [dict integerValueForKey:@"type" defaultValue:-1];
        _isMultiSelected = [dict integerValueForKey:@"multi_selected" defaultValue:0]>0?YES:NO;
        _queryKey = [dict stringValueForKey:@"query_key"];
        _items = [self createItemsWithDictArray:[dict arrayValueForKey:@"items"] type:_type];
    }
    return self;
}

- (instancetype)clone {
    SearchFilterInfo *newFilterInfo = [[SearchFilterInfo alloc] init];
    newFilterInfo.name = self.name;
    newFilterInfo.type = self.type;
    newFilterInfo.isMultiSelected = self.isMultiSelected;
    newFilterInfo.queryKey = self.queryKey;
    newFilterInfo.items = [[NSMutableArray alloc] initWithArray:self.items];
    return newFilterInfo;
}

- (NSArray*)createItemsWithDictArray:(NSArray*)dictArray type:(NSInteger)type {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (type == 0) {
        for (NSDictionary *dict in dictArray) {
            [array addObject:[SearchFilterItem createWithDict:dict]];
        }
    }
    else if (type == 1) {
        for (NSDictionary *dict in dictArray) {
            [array addObject:[SearchFilterInfo createWithDict:dict]];
        }
    }
    else if (type == 2) {
        for (NSDictionary *dict in dictArray) {
            [array addObject:[SearchFilterItem createWithDict:dict]];
        }
    }
    return array;
}

- (BOOL)isCompatible {
    return _type==0||_type==1||_type==2?YES:NO;
}

@end

@implementation SearchFilterItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

-(void)setIsYesSelected:(BOOL)isYesSelected{
    if (_isYesSelected != isYesSelected) {
        _isYesSelected = isYesSelected;
    }
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _title = [dict stringValueForKey:@"title"];
        _queryValue = [dict stringValueForKey:@"query_value"];
        
        _isYesSelected = NO;
    }
    return self;
}

- (NSString*)toRedirectUri:(NSString*)queryKey {
    return kURLSchemeSearch(self.title,queryKey,self.queryValue);
}

- (NSString*)fromRedirectUri:(NSString*)redirectUri {
    
    NSURL *url = [NSURL URLWithString:redirectUri];
    NSString *query = url.query;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    _title = [[params stringValueForKey:@"title"] URLDecodedString];
    _queryValue = [[params stringValueForKey:@"query_value"] URLDecodedString];
    return [params objectForKey:@"query_key"];
}

@end

//{query_value, title, subtitle, icon_url}

@implementation SearchFilterKV

@end



