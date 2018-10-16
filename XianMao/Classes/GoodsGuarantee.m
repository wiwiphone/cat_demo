//
//  GoodsGuarantee.m
//  XianMao
//
//  Created by WJH on 16/10/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsGuarantee.h"

@implementation GoodsGuarantee


+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = [dict stringValueForKey:@"name"];
        self.url = [dict stringValueForKey:@"url"];
        self.title = [dict stringValueForKey:@"title"];
        self.iconUrl = [dict stringValueForKey:@"iconUrl"];
        self.extend = [dict doubleValueForKey:@"extend" defaultValue:0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
        self.extend = [[decoder decodeObjectForKey:@"extend"] doubleValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.extend] forKey:@"extend"];
}
@end
