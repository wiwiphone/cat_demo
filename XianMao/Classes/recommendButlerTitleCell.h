//
//  recommendButlerTitleCell.h
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface recommendButlerTitleCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;

@end
