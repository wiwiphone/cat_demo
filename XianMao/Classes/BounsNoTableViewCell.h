//
//  BounsNoTableViewCell.h
//  XianMao
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BounsNoTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
