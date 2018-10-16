//
//  BlankTableViewCell.h
//  XianMao
//
//  Created by simon on 1/24/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BlankTableViewCell : BaseTableViewCell

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(UITableView*)tableView title:(NSString*)title;
+ (NSMutableDictionary*)buildCellDict:(UITableView*)tableView title:(NSString*)title isLoading:(BOOL)isLoading;
+ (NSString*)cellKeyForTableView;
+ (NSString*)cellKeyForBlankTitle;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
