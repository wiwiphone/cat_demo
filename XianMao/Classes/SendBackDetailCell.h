//
//  SendBackDetailCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BuybackOrderModel.h"

@interface SendBackDetailCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * goodsLbl;
@property (nonatomic,strong) UILabel * goodsSeriesLbl;
@property (nonatomic,strong) UILabel * priceLbl;
@property (nonatomic,strong) UILabel * goodsCount;


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSString *)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict;
+ (NSMutableDictionary*)buildCellDict:(BuybackOrderModel *)model;

@end
