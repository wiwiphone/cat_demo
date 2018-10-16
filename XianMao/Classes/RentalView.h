//
//  RentalView.h
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderInfo;

@interface RentalView : UIView

@property (nonatomic, copy) void(^sumOfConsumption)(NSString * money);
@property (nonatomic, strong) UITextField * tf;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;



- (void)getOrderPrice:(OrderInfo *)orderInfo;
- (void)getreWardMoneyPay:(OrderInfo *)orderInfo;

@end
