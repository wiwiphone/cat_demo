//
//  HotWord.m
//  XianMao
//
//  Created by simon cai on 7/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "HotWord.h"

@implementation HotWord

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _keyword = [dict stringValueForKey:@"word"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.keyword = [decoder decodeObjectForKey:@"keyword"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.keyword?self.keyword:@""  forKey:@"keyword"];
}

@end
