//
//  NSString+RMB.m
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "NSString+RMB.h"

#define COMMON_RMB_SYMBOL                       @"¥" //￥¥

@implementation NSString (RMB)

+(id)RMBWithString:(NSString*)string{
    return  [NSString stringWithFormat:@"%@%@",COMMON_RMB_SYMBOL,string];
}

@end
