//
//  OrderServiceCell.h
//  XianMao
//
//  Created by WJH on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ShoppingCartItem.h"
#import "JDServiceVo.h"

typedef void(^isDeterSelected)(NSInteger isSelected, ShoppingCartItem *item);

@interface OrderServiceCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDictisNeedSelect:(BOOL)isNeedSelect andShoppingCar:(ShoppingCartItem *)item jdServiceVo:(JDServiceVo *)jdServiceVo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@property (nonatomic, copy) isDeterSelected deterSelected;
@end
