//
//  TagVo.m
//  XianMao
//
//  Created by simon cai on 8/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "TagVo.h"

@implementation TagVo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.tagId = [dict integerValueForKey:@"tag_id"];
        self.tagName = [dict stringValueForKey:@"tag_name"];
        self.redirectUri = [dict stringValueForKey:@"redirect_uri"];
        self.isSelected = NO;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.tagId] forKey:@"tagId"];
    [aCoder encodeObject:self.tagName forKey:@"tagName"];
    [aCoder encodeObject:self.redirectUri forKey:@"redirectUri"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isSelected] forKey:@"isSelected"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.tagId = [[aDecoder decodeObjectForKey:@"tagId"] integerValue];
        self.tagName = [aDecoder decodeObjectForKey:@"tagName"];
        self.redirectUri = [aDecoder decodeObjectForKey:@"redirectUri"];
        self.isSelected = [[aDecoder decodeObjectForKey:@"isSelected"] boolValue]>0?YES:NO;
    }
    return self;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (dict) {
        [dict setObject:[NSNumber numberWithInteger:self.tagId] forKey:@"tag_id"];
        if (self.tagName) [dict setObject:self.tagName forKey:@"tag_name"];
    }
    return dict;
}

@end

@implementation TagGroupVo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.groupId = [dict integerValueForKey:@"group_id" defaultValue:0];
        self.groupName = [dict stringValueForKey:@"group_name"];
        self.iconUrl = [dict stringValueForKey:@"icon_url"];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *tagDictArray = [dict arrayValueForKey:@"tag_list"];
        for (NSDictionary *tagDict in tagDictArray) {
            if ([tagDict isKindOfClass:[NSDictionary class]]) {
                TagVo *tag = [TagVo createWithDict:tagDict];
                [array addObject:tag];
            }
        }
        self.tagList = array;
    }
    return self;
}

@end

