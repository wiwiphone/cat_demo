//
//  ShoppingCartTableViewCell.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SwipeTableViewCell.h"

@class ShoppingCartTableViewCell;
typedef void(^ShoppingCartSelectedHandlerBlock)(ShoppingCartTableViewCell *cell, NSInteger index);
typedef void(^ShoppingCartDelGoodsBlock)(ShoppingCartTableViewCell * cell, NSInteger index);

@class ShoppingCartItem;
@interface ShoppingCartTableViewCell : SwipeTableViewCell

@property(nonatomic,copy) ShoppingCartSelectedHandlerBlock selectedHandlerBlock;
@property(nonatomic,copy) ShoppingCartDelGoodsBlock delGoodsBlock;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem*)item;
+ (NSString*)cellDictKeyForShoppingCartItem;
+ (NSString*)cellDictKeyForSeleted;
+ (NSString*)cellDictKeyForSeletedInEditMode;
+ (NSString *)cellDictKeyForInEdit;
- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index;

@end

@interface ShoppingCartSegCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem*)item;
+ (NSString*)cellDictKeyForShoppingCartItem;
+ (NSString*)cellDictKeyForSeleted;
//- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index;

@end
