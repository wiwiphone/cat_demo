//
//  meowRecordDetailVo.h
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeowRecordDetailVo : NSObject

@property (nonatomic, assign) NSInteger dayMeowNumber;
@property (nonatomic, assign) NSInteger signType;
@property (nonatomic, copy) NSString * timeName;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;

@end
