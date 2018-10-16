//
//  FeedsCell.h
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsTableViewCell.h"

@class FeedsItem;
@interface FeedsTableViewCell : GoodsTableViewCell

+ (NSString*)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict:(FeedsItem*)info;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
