//
//  NeedModel.m
//  XianMao
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "NeedModel.h"
#import "NeedsAttachmentVo.h"

@implementation NeedModel

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        self.content = [dict stringValueForKey:@"content"];
        self.createtime = [dict longLongValueForKey:@"createtime"];
        self.needId = [dict stringValueForKey:@"needId"];
        self.status = [dict integerValueForKey:@"status"];
        self.statusDesc = [dict stringValueForKey:@"statusDesc"];
        self.goodsSn = [dict stringValueForKey:@"goodsSn"];
        NSArray *arr = [dict arrayValueForKey:@"attachment"];
        NSMutableArray *attArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            NeedsAttachmentVo *needsVo = [[NeedsAttachmentVo alloc] initWithJSONDictionary:arr[i]];
            [attArr addObject:needsVo];
        }
        self.attachment = attArr;
    }
    return self;
}

@end
