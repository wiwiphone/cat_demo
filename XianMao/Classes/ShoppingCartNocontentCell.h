//
//  ShoppingCartNocontentCell.h
//  XianMao
//
//  Created by Marvin on 2017/4/1.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ShoppingCartNocontentCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
