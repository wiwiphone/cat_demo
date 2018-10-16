//
//  MineIncomeViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/7/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXAddressManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,strong) NSArray *provinceDicAry;//省字典数组

#define kAddressManager [HXAddressManager shareInstance]

@end
