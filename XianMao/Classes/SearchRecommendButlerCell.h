//
//  SearchRecommendButlerCell.h
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SearchRecommendButlerCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
//- (void)updateCellWithDict:(NSDictionary*)dict;

@end
