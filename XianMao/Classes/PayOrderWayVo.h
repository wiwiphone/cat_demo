//
//  PayOrderWayVo.h
//  XianMao
//
//  Created by WJH on 16/10/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayOrderWayVo : NSObject

@property (nonatomic ,copy) NSString * name;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *priceStr;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)createWithDict:(NSDictionary *)dict;

@end
