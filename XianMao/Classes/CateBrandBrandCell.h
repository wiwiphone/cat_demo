//
//  CateBrandBrandCell.h
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BrandInfo.h"

@interface CateBrandBrandCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(BrandInfo*)brandInfo;

@end
