//
//  MineIncomeViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/7/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HXAddressManager.h"

@interface HXAddressManager ()

@end

@implementation HXAddressManager

+ (instancetype)shareInstance {
    static HXAddressManager *_addressManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _addressManager = [[self alloc] init];
    });
    return _addressManager;
}

- (NSArray *)provinceDicAry {
    if (!_provinceDicAry) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        _provinceDicAry = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _provinceDicAry;
}

@end
