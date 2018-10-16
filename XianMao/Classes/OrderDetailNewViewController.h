//
//  OrderDetailNewViewController.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "ParyialDo.h"

@interface OrderDetailNewViewController : BaseViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) BOOL isMysold;

@property (nonatomic, assign) NSInteger is_partial_pay;
@property (nonatomic, strong) NSArray *payWays;
@property (nonatomic, strong) ParyialDo *partialDo;
@property (nonatomic, assign) CGFloat payPrice;
@property (nonatomic, assign) CGFloat available_money_cent;

@property (nonatomic, strong) NSArray *mailTypeList;
@end
