//
//  MeowUserSignVo.h
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeowUserSignVo : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger meowNumber;
@property (nonatomic, assign) NSInteger awardType;
@property (nonatomic, copy) NSString * signTime;
@property (nonatomic, copy) NSString * createtime;
@property (nonatomic, copy) NSString * updatetime;
@property (nonatomic, assign) NSInteger signType;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;

@end
