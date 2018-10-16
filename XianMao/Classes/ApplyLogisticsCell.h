//
//  ApplyLogisticsCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^logistics)(NSString *name);

@interface ApplyLogisticsCell : BaseTableViewCell


@property (nonatomic,strong) UILabel * LogisticsCompany;
@property (nonatomic, copy) logistics logistics;


//判断快递选择按钮状态
@property (nonatomic,assign) BOOL LogisticsBtnisTouch;
@property (nonatomic,assign) int LogisticsBtnTouchID;


+ (CGFloat)rowHeightForPortrait;
+ (NSString *)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
