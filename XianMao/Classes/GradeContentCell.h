//
//  GradeContentCell.h
//  yuncangcat
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GradeDescInfo.h"

@interface GradeContentCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSArray *)arr
                       gradeValueDesc:(NSString *)gradeValueDesc
                                grade:(NSString *)grade
                        gradeDescInfo:(GradeDescInfo *)gradeDescInfo;
+ (NSString *)cellDictKeyForGradeValueDesc;
+ (NSString *)cellDictKeyForGradeDescInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
