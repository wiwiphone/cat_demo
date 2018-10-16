//
//  BuyBackCell.h
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BuyBackCell : BaseTableViewCell
//@property(nonatomic,copy) void(^handleOrderActionrefundGoodsProgress)(OrderInfo *orderInfo);//查看进货进度

@property (nonatomic,copy) void(^rtLabelSelect)(NSURL *url);
+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellTitle:(NSString *)title;

- (void)updateCellWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary*)buildCellTitle:(NSString *)title withColor:(UIColor *)color;
@end
