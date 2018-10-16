//
//  SearchSiftGradeCell.h
//  XianMao
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SearchSiftGradeDescVo.h"

@interface SearchSiftGradeCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(SearchSiftGradeDescVo *)gradeDescVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
