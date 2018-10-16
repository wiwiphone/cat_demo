//
//  ChooseTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
@class AttrEditableInfo;
@interface ChooseTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(AttrEditableInfo *)attrInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
