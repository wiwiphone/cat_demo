//
//  DeliveryExplainCell.h
//  XianMao
//
//  Created by 阿杜 on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsGuarantee.h"
#import "TTTAttributedLabel.h"
#import "RTLabel.h"

@interface DeliveryExplainCell : BaseTableViewCell

@property (nonatomic, strong) TTTAttributedLabel * expectedDeliveryLbl;
@property (nonatomic, copy) void(^handleWashBlock)(NSString * url);

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict;
+ (NSMutableDictionary*)buildGoodsGuaranteeCellDict:(GoodsGuarantee *)goodsGuarantee;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
