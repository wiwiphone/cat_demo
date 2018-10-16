//
//  PayTableViewCell.h
//  XianMao
//
//  Created by simon on 12/21/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"


@class ShoppingCartItem;
@interface PayTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem*)item;
+ (NSString*)cellDictKeyForShoppingCartItem;
+ (NSString*)cellDictKeyForSeleted;
+ (NSString*)cellDictKeyForSeletedInEditMode;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
