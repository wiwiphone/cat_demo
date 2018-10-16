//
//  ConsignCateTableViewCell.h
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class Cate;
@interface ConsignCateTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(Cate*)cate selected:(BOOL)selected;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
