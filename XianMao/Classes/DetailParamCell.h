//
//  DetailParamCell.h
//  yuncangcat
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DetailParamCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)data;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
