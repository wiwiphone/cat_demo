//
//  CateBrandCateCell.h
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CateNewInfo.h"

@interface CateBrandCateCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(CateNewInfo*)cateInfo andBCateNewInfo2:(CateNewInfo *)cateInfo2;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
