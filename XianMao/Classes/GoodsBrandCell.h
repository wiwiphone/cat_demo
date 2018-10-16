//
//  GoodsBrandCell.h
//  XianMao
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BrandInfo.h"

@interface GoodsBrandCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(BrandInfo*)brandInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
