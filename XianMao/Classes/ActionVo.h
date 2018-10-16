//
//  ActionVo.h
//  XianMao
//
//  Created by WJH on 17/3/1.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionVo : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString * title;

+ (instancetype)createWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dic;

@end
