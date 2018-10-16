//
//  ApproveTagInfo.m
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ApproveTagInfo.h"

@implementation ApproveTagInfo

+ (NSMutableArray*)createWithDictArray:(NSArray*)dicts {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        [array addObject:[self createWithDict:dict]];
    }
    return array;
}

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.tagId = [dict integerValueForKey:@"tagId" defaultValue:0];
        self.name = [dict stringValueForKey:@"name"];
        self.value = [dict stringValueForKey:@"value"];
        self.iconUrl = [dict stringValueForKey:@"icon_url"];
        self.desc = [dict stringValueForKey:@"desc"];
    }
    return self;
}

- (UIImage*)localTagIcon {
    return nil;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.tagId = [[decoder decodeObjectForKey:@"tagId"] integerValue];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.value = [decoder decodeObjectForKey:@"value"];
        self.iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.tagId] forKey:@"tagId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
}

@end


