//
//  ShoppingCartDelCell.h
//  XianMao
//
//  Created by Marvin on 2017/5/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ShoppingCartDelCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleShoppingCartDeleteBlcok)();

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
