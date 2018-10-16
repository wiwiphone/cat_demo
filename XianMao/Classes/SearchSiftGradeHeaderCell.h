//
//  SearchSiftGradeHeaderCell.h
//  XianMao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SearchSiftGradeVo.h"

@interface SearchSiftGradeHeaderCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(SearchSiftGradeVo *)gradeVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
