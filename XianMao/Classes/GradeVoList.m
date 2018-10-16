//
//  gradeVoList.m
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GradeVoList.h"
#import "GradeItemVo.h"

@implementation GradeVoList

+ (instancetype)createWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.title = [dict stringValueForKey:@"title"];
        
        if ([dict arrayValueForKey:@"gradeVoList"]) {
            NSArray * gradeVoList = [dict arrayValueForKey:@"gradeVoList"];
            NSMutableArray * gradeDescList= [[NSMutableArray alloc] init];
            for (int i = 0; i < gradeVoList.count; i++) {
                GradeItemVo * greadeItem = [GradeItemVo createWithDict:gradeVoList[i]];
                [gradeDescList addObject:greadeItem];
            }
            _gradeItemList = gradeDescList;
        }
    }
    self.title = [dict stringValueForKey:@"title"];
    return self;
}

@end
