//
//  ApplyGoodsDetailCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BuybackOrderModel.h"


@interface ApplyGoodsDetailCell : BaseTableViewCell

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel * goodsNameLbl;
@property (nonatomic, strong) UILabel * priceLbl;
@property (nonatomic, strong) UILabel * goodsCountsLbl;
@property (nonatomic, strong) UILabel * netPayLbl;

@property (nonatomic, strong) UIImageView * deterMine;


+(NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
+ (NSMutableDictionary*)buildCellDict:(BuybackOrderModel *)BuybackOrderModel;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
