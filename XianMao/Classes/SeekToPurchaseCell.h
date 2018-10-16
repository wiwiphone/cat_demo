//
//  SeekToPurchaseCell.h
//  XianMao
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SeekToPurchaseCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
