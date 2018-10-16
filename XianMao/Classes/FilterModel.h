//
//  FilterModel.h
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FilterItemModel.h"

@interface FilterModel : NSObject

@property (nonatomic, assign) NSInteger is_spread;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, assign) NSInteger multi_selected; //1多选 0单选
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * query_key;
@property (nonatomic, assign) NSInteger type;


+(instancetype)createWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
