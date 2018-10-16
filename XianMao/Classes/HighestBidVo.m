//
//  HighestBidVo.m
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HighestBidVo.h"

@implementation HighestBidVo

+(JSONModelKeyMapper *)keyMapper{
    return [[JSONModelKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}

@end
