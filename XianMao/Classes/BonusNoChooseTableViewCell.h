//
//  BonusNoChooseTableViewCell.h
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BonusNoChooseTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)title selected:(BOOL)isYesSelect;
- (void)updateCellWithDict:(NSDictionary *)dict;


@end
