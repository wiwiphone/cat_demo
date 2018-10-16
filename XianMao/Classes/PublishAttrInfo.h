//
//  PublishAttrInfo.h
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface PublishAttrInfo : NSObject

@property (nonatomic, assign) NSInteger attr_id;
@property (nonatomic, copy) NSString *attr_name;
@property (nonatomic, assign) NSInteger is_multi_choice;
@property (nonatomic, assign) NSInteger is_must;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger type;

+ (instancetype)createWithDict:(NSDictionary*)dict;
@end
