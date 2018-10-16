//
//  MineTableViewCell.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MineTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;

+ (NSMutableDictionary*)buildCellDict:(NSString*)title;
+ (NSMutableDictionary*)buildCellDict:(NSString*)title icon:(NSString*)icon bottomLinePaddingLeft:(CGFloat)paddingLeft;

- (void)updateCellWithDict:(NSDictionary*)dict;

@end
