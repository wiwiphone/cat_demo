//
//  FilterItemModel.h
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterItemModel : NSObject

@property (nonatomic, assign) NSInteger is_spread;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSDictionary * fixed_sfi;
@property (nonatomic, assign) NSInteger multi_selected;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * query_key;
@property (nonatomic, assign) NSInteger type;




-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;
@end
