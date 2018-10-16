//
//  RechargeRule.h
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeRule : NSObject
@property (nonatomic, assign) double min;
@property (nonatomic, assign) double max;
@property (nonatomic, assign) double give;
@property (nonatomic, copy) NSString * desc;


-(instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)createWithDict:(NSDictionary *)dict;
@end
