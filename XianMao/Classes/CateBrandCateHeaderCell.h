//
//  CateBrandCateHeaderCell.h
//  XianMao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CateNewInfo.h"

@interface CateBrandCateHeaderCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(CateNewInfo*)cateInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
