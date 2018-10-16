//
//  getLogsModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/7.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface getLogsModel : NSObject

@property (nonatomic,copy) NSString * actionUser;
@property (nonatomic,copy) NSString * brief;
@property (nonatomic,copy) NSString * createtime;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * orderId;
@property (nonatomic,copy) NSString * primaryKey;
@property (nonatomic,copy) NSString * repurchaseId;
@property (nonatomic,copy) NSString * repurchaseStatus;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * remark;


+(getLogsModel *)modelWithDict:(NSDictionary *)dict;
@end
