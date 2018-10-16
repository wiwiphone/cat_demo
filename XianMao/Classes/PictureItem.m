//
//  PictureItem.m
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PictureItem.h"

@implementation PictureItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (id)init {
    self = [super init];
    if (self) {
        _picUrl = @"";
        _picDescription = @"";
        _picId = 0;
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
//        self.isCer = [dict boolValueForKey:@"isCer" defaultValue:NO];
        self.picId = [dict integerValueForKey:@"pic_id" defaultValue:0];
        self.picUrl = [dict stringValueForKey:@"pic_url"];
        self.picDescription = [dict stringValueForKey:@"pic_desc"];
        self.width = [dict integerValueForKey:@"width" defaultValue:0];
        self.height = [dict integerValueForKey:@"height" defaultValue:0];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.picId] forKey:@"picId"];
    [aCoder encodeObject:self.picUrl forKey:@"picUrl"];
    [aCoder encodeObject:self.picDescription forKey:@"picDescription"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.width] forKey:@"width"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.height] forKey:@"height"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isCer] forKey:@"isCer"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.picId = [[aDecoder decodeObjectForKey:@"picId"] integerValue];
        self.picUrl = [aDecoder decodeObjectForKey:@"picUrl"];
        self.picDescription = [aDecoder decodeObjectForKey:@"picDescription"];
        self.width = [[aDecoder decodeObjectForKey:@"width"] integerValue];
        self.height = [[aDecoder decodeObjectForKey:@"height"] integerValue];
        self.isCer = [[aDecoder decodeObjectForKey:@"isCer"] boolValue]>0?YES:NO;
    }
    return self;
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (dict) {
        [dict setObject:[NSNumber numberWithInteger:_picId] forKey:@"pic_id"];
        [dict setObject:_picUrl?_picUrl:@"" forKey:@"pic_url"];
        [dict setObject:_picDescription?_picDescription:@"" forKey:@"pic_desc"];
        [dict setObject:[NSNumber numberWithInteger:_width] forKey:@"width"];
        [dict setObject:[NSNumber numberWithInteger:_height] forKey:@"height"];
//        [dict setObject:[NSNumber numberWithBool:_isCer] forKey:@"isCer"];
    }
    return dict;
}

@end
