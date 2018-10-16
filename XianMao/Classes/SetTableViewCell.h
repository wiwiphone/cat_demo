//
//  SetTableViewCell.h
//  XianMao
//
//  Created by apple on 16/2/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SetTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;

+ (NSMutableDictionary*)buildCellDict:(NSString*)title;
+ (NSMutableDictionary*)buildCellDict:(NSString*)title icon:(NSString*)icon bottomLinePaddingLeft:(CGFloat)paddingLeft;

- (void)updateCellWithDict:(NSDictionary*)dict;

@end
