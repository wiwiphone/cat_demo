//
//  AccountList.h
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddAccountIconVo.h"
#import "WithdrawalsAccountVo.h"

@interface AccountList : NSObject

@property (nonatomic, strong) NSArray * withdrawalsAccountVo;
@property (nonatomic, strong) NSArray * addAccountIconVo;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)creatWithDict:(NSDictionary *)dict;

@end
