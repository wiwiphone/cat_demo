//
//  ReplyVo.m
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ReplyVo.h"
#import "RedirectInfo.h"

@implementation ReplyVo

+ (instancetype)createWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.type = [dict integerValueForKey:@"type"];
        self.title = [dict stringValueForKey:@"title"];
        self.redirectUrl = [dict stringValueForKey:@"redirectUrl"];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSArray * array = [dict arrayValueForKey:@"data"];
        if (array && array.count > 0) {
            for (NSDictionary * dict in array) {
                RedirectInfo * info = [[RedirectInfo alloc] initWithDict:dict];
                [data addObject:info];
            }
            _data = data;
        }
    }
    return self;
}

@end
