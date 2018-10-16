//
//  BrandNewCell.h
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BrandVO.h"

@interface BrandNewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(BrandVO*)brandVO andBrandVO2:(BrandVO *)BrandVO2;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
