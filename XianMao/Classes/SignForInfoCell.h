//
//  SignForInfoCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "getLogsModel.h"

@interface SignForInfoCell : BaseTableViewCell

@property (nonatomic,strong) UIView * containerView;  //背景图
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UILabel * signForInfoLbl;//卖家签收通知
@property (nonatomic,strong) UILabel * signForLbl; //签收通知
//@property (nonatomic,strong) UILabel * infoLbl;//具体签收通知信息
@property (nonatomic,strong) UIView * triangleView;//对话框三角形

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict;
+ (NSMutableDictionary*)buildCellDict:(getLogsModel *)getLogsModel;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
