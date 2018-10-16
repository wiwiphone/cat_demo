//
//  BankModel.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel
@synthesize id;


//将所有属性变成可选的状态
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
