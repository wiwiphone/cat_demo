//
//  getLogsModel.m
//  XianMao
//
//  Created by 阿杜 on 16/7/7.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "getLogsModel.h"

@implementation getLogsModel
@synthesize id;

+(getLogsModel *)modelWithDict:(NSDictionary *)dict
{
    return [[getLogsModel alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.actionUser = dict[@"actionUser"];
        self.brief = dict[@"brief"];
        self.createtime = dict[@"createtime"];
        self.id = dict[@"id"];
        self.message = dict[@"message"];
        self.orderId = dict[@"orderId"];
        self.primaryKey = dict[@"primaryKey"];
        self.repurchaseId = dict[@"repurchaseId"];
        self.repurchaseStatus = dict[@"repurchaseStatus"];
        self.status = dict[@"repurchaseId"];
        self.remark = dict[@"remark"];
    }
    return self;
}
@end
