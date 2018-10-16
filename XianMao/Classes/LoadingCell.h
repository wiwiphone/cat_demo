//
//  LoadingCell.h
//  XianMao
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LoadingCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)nickArrCount;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
