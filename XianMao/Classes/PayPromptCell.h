//
//  PayPromptCell.h
//  XianMao
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PayPromptCell : BaseTableViewCell
+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary*)dict;
@end
