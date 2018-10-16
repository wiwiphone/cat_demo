//
//  PayMiaozuanDeductCell.h
//  XianMao
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ShoppingCartItem.h"
#import "MeowReduceVo.h"

typedef void(^MiaozuandikouSelected)(ShoppingCartItem *item);

@interface PayMiaozuanDeductCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem *)item meowReduceVo:(MeowReduceVo *)meowReduceVo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@property (nonatomic, copy) MiaozuandikouSelected miaozuandikouSelected;
@end
