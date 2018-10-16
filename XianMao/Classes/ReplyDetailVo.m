//
//  ReplyDetailVo.m
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ReplyDetailVo.h"

@implementation ReplyDetailVo

@synthesize id;

+ (instancetype)createWithDict:(NSDictionary *)dict{
    return  [[self alloc] initWithDict:dict];
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.id = [dict integerValueForKey:@"id"];
        self.tabTitle = [dict stringValueForKey:@"tabTitle"];
        self.status = [dict integerValueForKey:@"status"];
        self.adviserId = [dict integerValueForKey:@"adviserId"];
        
        NSMutableArray * replyList= [[NSMutableArray alloc] init];
        NSArray * arr = [dict arrayValueForKey:@"replyList"];
        if (arr && arr.count > 0) {
            for (NSDictionary * dict in arr) {
                ReplyVo * replyVo = [ReplyVo createWithDict:dict];
                [replyList addObject:replyVo];
            }
            _replyList = replyList;
        }
    }
    return self;
}

@end
