//
//  LogisticsNumberCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZBarSDK.h"

#import "ScanningViewController.h"

typedef void(^logistics)(NSString *name);

@interface LogisticsNumberCell : BaseTableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UILabel * LogisticsNum;
@property (nonatomic,strong) UITextField * LogisticsNumTf; //物流单号
@property (nonatomic,strong) UIButton * twoDimensionBtn; //二维码扫描
@property (nonatomic,strong) UIView * textViewBg;
@property(nonatomic,copy) void(^ two_dimension_code)(ScanningViewController *scanning);//二维码调用

@property (nonatomic, copy) logistics logistics;


+(NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
