//
//  ReturnGoodsAddressCell.h
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderAddressCell.h"
#import "BuybackOrderModel.h"

@interface ReturnGoodsAddressCell : OrderAddressCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(AddressInfo*)addressInfo;
+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo;

+ (NSMutableDictionary*)buildCellModel:(BuybackOrderModel *)model;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
