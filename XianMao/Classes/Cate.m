//
//  Cate.m
//  XianMao
//
//  Created by simon on 12/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "Cate.h"
#import "NSDictionary+Additions.h"

@implementation Cate

+ (instancetype)createWithDict:(NSDictionary*)dict {
     return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.cateId = [dict integerValueForKey:@"cate_id" defaultValue:0];
        self.name = [dict stringValueForKey:@"cate_name"];
        self.iconUrl = [dict stringValueForKey:@"icon_url"];
        self.parentId = [dict integerValueForKey:@"parent_id" defaultValue:0];
        
        NSArray *childrenDicts = [dict arrayValueForKey:@"children"];
        if ([childrenDicts count]>0) {
            NSMutableArray *children = [[NSMutableArray alloc] initWithCapacity:[childrenDicts count]];
            for (NSDictionary *dict in childrenDicts) {
                Cate *cate = [Cate createWithDict:dict];
                [children addObject:cate];
            }
            _children = children;
        }
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.cateId = [[decoder decodeObjectForKey:@"cateId"] integerValue];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
        self.parentId = [[decoder decodeObjectForKey:@"parentId"] integerValue];
        self.children = [decoder decodeObjectForKey:@"children"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.cateId]  forKey:@"cateId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.parentId] forKey:@"parentId"];
    [encoder encodeObject:self.children forKey:@"children"];
}

@end
