//
//  UserHomeAlSelaCataCell.h
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface UserHomeAlSelaCataCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;

@end
