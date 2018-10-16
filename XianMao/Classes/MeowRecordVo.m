//
//  MeowRecordVo.m
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MeowRecordVo.h"
#import "MeowRecordDetailVo.h"

@implementation MeowRecordVo

+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.continueSignedDays = [dict integerValueForKey:@"continueSignedDays"];
        self.meowNumber = [dict integerValueForKey:@"meowNumber"];
        self.todaySignedType = [dict integerValueForKey:@"todySignType"];
        self.userId = [dict integerValueForKey:@"userId"];
        self.isRemind = [dict integerValueForKey:@"isRemind"];
        self.dayMeowNumber = [dict integerValueForKey:@"dayMeowNumber"];
        NSMutableArray * recordDetailList = [[NSMutableArray alloc] init];
        NSArray * detailArray = [dict arrayValueForKey:@"meowRecordDetailList"];
        for (NSDictionary * dict in detailArray) {
            MeowRecordDetailVo * meowDetail = [MeowRecordDetailVo createWithDict:dict];
            [recordDetailList addObject:meowDetail];
        }
        self.meowRecordDetailList = recordDetailList;
    }
    return self;
}

-(BOOL)todaySignedTypeYesOrNo
{
    return self.todaySignedType == 0?YES:NO;
}

-(BOOL)isNeedRemind{
    return self.isRemind == 1?YES:NO;
}

@end
