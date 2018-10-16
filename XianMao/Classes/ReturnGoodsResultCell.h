//
//  ReturnGoodsResultCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ReturnGoodsResultCell : BaseTableViewCell
@property (nonatomic,strong) UIView * containerView;  //背景图
@property (nonatomic,strong) UIView * triangleView;//对话框三角形

@property (nonatomic,strong) UILabel * chectResultLbl;
@property (nonatomic,strong) UILabel * costLbl;
@property (nonatomic,strong) UILabel * refundMoneyLbl;
@property (nonatomic,strong) UILabel * refundWayLbl;

@property (nonatomic,strong) UILabel * chectResult;
@property (nonatomic,strong) UILabel * cost;
@property (nonatomic,strong) UILabel * refundMoney;
@property (nonatomic,strong) UILabel * refundWay;


+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
