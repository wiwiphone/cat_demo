//
//  FeedsItem.m
//  XianMao
//
//  Created by simon cai on 11/9/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "FeedsItem.h"
#import "NSDictionary+Additions.h"
#import "GoodsInfo.h"

@implementation FeedsItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.feedsId = [dict integerValueForKey:@"id" defaultValue:0];
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


