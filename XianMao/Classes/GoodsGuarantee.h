//
//  GoodsGuarantee.h
//  XianMao
//
//  Created by WJH on 16/10/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsGuarantee : NSObject <NSCoding>

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * iconUrl;
@property (nonatomic, assign) double extend;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;


@end
