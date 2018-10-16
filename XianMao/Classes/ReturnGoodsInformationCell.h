//
//  ReturnGoodsInformationCell.h
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ReturnGoodsInformationCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSString*)title;
+ (NSMutableDictionary*)buildCellTitle:(NSString *)title;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
