//
//  FqParamsModel.h
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"


@interface FqParamsModel : JSONModel

@property (nonatomic, copy) NSString * qk;
@property (nonatomic, copy) NSString * qv;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;
@end
