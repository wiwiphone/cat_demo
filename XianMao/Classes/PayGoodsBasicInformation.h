//
//  PayGoodsBasicInformation.h
//  XianMao
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ShoppingCartItem.h"

@interface PayGoodsBasicInformation : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellItem:(ShoppingCartItem *)item;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
