//
//  pulishSourceModel.h
//  XianMao
//
//  Created by 阿杜 on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface pulishSourceModel : JSONModel

@property (nonatomic, assign) NSInteger attr_id;
@property (nonatomic, copy) NSString *attr_name;
@property (nonatomic, assign) NSInteger is_multi_choice;
@property (nonatomic, assign) NSInteger is_must;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger type;

@end
