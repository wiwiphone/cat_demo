//
//  GradeItemVo.m
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GradeItemVo.h"
#import "GradeDescInfo.h"

@implementation GradeItemVo

+ (instancetype)createWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.title = [dict stringValueForKey:@"title"];
        self.subtitle = [dict stringValueForKey:@"dict"];
        
        NSMutableArray * gradeItemList = [[NSMutableArray alloc] init];
        NSArray * array = [dict arrayValueForKey:@"gradeItemList"];
        for (NSDictionary * dict in array) {
            GradeDescInfo *descInfo = [[GradeDescInfo alloc] initWithJSONDictionary:dict];
            [gradeItemList addObject:descInfo];
        }
        self.gradeItemList = gradeItemList;
    }
    return self;
}

@end
