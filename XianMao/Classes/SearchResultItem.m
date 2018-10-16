//
//  SearchResultItem.m
//  XianMao
//
//  Created by simon on 1/17/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "SearchResultItem.h"
#import "GoodsInfo.h"

@implementation SearchResultItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
        self.item = [GoodsInfo createWithDict:[dict objectForKey:@"item"]];
    }
    return self;
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

