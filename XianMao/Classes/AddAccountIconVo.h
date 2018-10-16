//
//  AddAccountIconVo.h
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddAccountIconVo : NSObject

@property (nonatomic, assign) NSInteger type; //0，支付宝；1，银行卡
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * caption;


+(instancetype)creatWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
