//
//  GradeItemTitleCell.h
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GradeItemTitleCell : BaseTableViewCell


+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)title;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
