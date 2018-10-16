//
//  LineTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LineTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict;

@end


@interface LineSmallTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict;

@end