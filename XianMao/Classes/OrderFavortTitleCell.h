//
//  OrderFavortTitleCell.h
//  XianMao
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderFavortTitleCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellTitle:(NSString *)title;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
