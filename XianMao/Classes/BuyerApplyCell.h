//
//  BuyerApplyCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "getLogsModel.h"

@interface BuyerApplyCell : BaseTableViewCell

@property (nonatomic,strong) UIView * containerView;  //背景图
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UILabel * buyerApplyLbl;
@property (nonatomic,strong) UILabel * timeOutLbl;  //使用时长

@property (nonatomic,strong) UIImageView * triangleView;//对话框三角形

-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSString *)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict:(getLogsModel *)getLogsModel;
@end
