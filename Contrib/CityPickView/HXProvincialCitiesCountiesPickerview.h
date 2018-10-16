//
//  MineIncomeViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/7/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXProvincialCitiesCountiesPickerview : UIView

@property (nonatomic,copy) void (^completion)(NSString *provinceName,NSString *cityName,NSString *countyName);

- (void)showPickerWithProvinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName;//显示 省 市 县名

@end
