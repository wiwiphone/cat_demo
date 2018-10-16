//
//  RefundDetailCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "orderReturnItemListModel.h"

@interface RefundDetailCell : BaseTableViewCell

@property (nonatomic,strong) UIButton * ADMRefundState; //爱丁猫退款进度
@property (nonatomic,strong) UIButton * handleState ; //处理方退款进去
@property (nonatomic,strong) UIButton * refundSucState; //退款成功

@property (nonatomic,strong) UILabel * ADMRefundLbl; //爱丁猫
@property (nonatomic,strong) UILabel * handleLbl; //处理方
@property (nonatomic,strong) UILabel * refundSucLbl; //退款成功

//退款时间日期进度
@property (nonatomic,strong) UILabel * ADMDate;
@property (nonatomic,strong) UILabel * handleDate;
@property (nonatomic,strong) UILabel * refundSucDate;

//退款具体时间进度
@property (nonatomic,strong) UILabel * ADMTime;
@property (nonatomic,strong) UILabel * handleTime;
@property (nonatomic,strong) UILabel * refundSucTime;

@property (nonatomic,strong) UIView * connectedLine;

@property (nonatomic,assign) NSInteger status;

+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(orderReturnItemListModel *)orderReturnItemListModel;

@end
