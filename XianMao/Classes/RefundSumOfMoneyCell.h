//
//  RefundSumOfMoneyCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "orderReturnItemListModel.h"

@interface RefundSumOfMoneyCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * refundMoneyLbl; //退款金额
@property (nonatomic,strong) UILabel * refundTotal; //

+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary*)buildCellDict:(orderReturnItemListModel *)orderReturnItemListModel;
//+(NSMutableDictionary *)buildCellTitle:(NSString *)money;


@end
