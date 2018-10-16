//
//  SettingAdviserTableViewCell.h
//  XianMao
//
//  Created by WJH on 16/12/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SettingAdviserTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(NSString*)title;

- (void)updateCellWithDict:(NSDictionary*)dict;
@end
