//
//  KeywordMapdetail.h
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordMapdetail : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString * showText;
@property (nonatomic, copy) NSString * mapText;
@property (nonatomic, copy) NSString * picUrl;
@property (nonatomic, copy) NSString * redirectUrl;
@property (nonatomic, assign) NSInteger isValid;
@property (nonatomic, copy) NSString * beginTime;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * createtime;
@property (nonatomic, copy) NSString * updatetime;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;

@end
