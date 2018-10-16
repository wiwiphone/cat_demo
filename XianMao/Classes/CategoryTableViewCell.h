//
//  CategoryCell.h
//  XianMao
//
//  Created by simon cai on 11/12/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CategoryTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;

+ (NSMutableDictionary*)buildCellDict:(NSString*)imageName title:(NSString*)title;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
