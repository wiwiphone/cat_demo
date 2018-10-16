//
//  PublishAttrInfo.m
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishAttrInfo.h"
#import "AttrListInfo.h"

@implementation PublishAttrInfo

//-(instancetype)initWithDictionary:(NSDictionary *)dict
//{
//    self = [super initWithJSONDictionary:dict];
//    if (self) {
//        
//        NSMutableArray *detailPicItems = [[NSMutableArray alloc] init];
//        NSArray *gallaryItemDicts = [dict arrayValueForKey:@"list"];
//        if ([gallaryItemDicts isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dict in gallaryItemDicts) {
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    [detailPicItems addObject:[[AttrListInfo alloc] initWithJSONDictionary:dict]];
//                }
//            }
//        }
//        self.list = detailPicItems;
//        
//    }
//    return self;
//}

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.attr_id = [dict integerValueForKey:@"attr_id"];
        self.is_must = [dict integerValueForKey:@"is_must"];
        self.is_multi_choice = [dict integerValueForKey:@"is_multi_choice"];
        self.type = [dict integerValueForKey:@"type"];
        if ([dict stringValueForKey:@"attr_name"]) {
            self.attr_name = [dict stringValueForKey:@"attr_name"];
        }
        if ([dict stringValueForKey:@"placeholder"]) {
            self.placeholder = [dict stringValueForKey:@"placeholder"];
        }
        
        if ([dict arrayValueForKey:@"list"]) {
//            NSMutableArray *detailPicItems = [[NSMutableArray alloc] init];
//            NSArray *gallaryItemDicts = [dict arrayValueForKey:@"list"];
//            if ([gallaryItemDicts isKindOfClass:[NSArray class]]) {
//                for (NSDictionary *dict in gallaryItemDicts) {
//                    if ([dict isKindOfClass:[NSDictionary class]]) {
//                        [detailPicItems addObject:[[AttrListInfo alloc] initWithJSONDictionary:dict]];
//                    }
//                }
//            }
            self.list = [dict arrayValueForKey:@"list"];
        }
        
    }
    return self;
}

@end
