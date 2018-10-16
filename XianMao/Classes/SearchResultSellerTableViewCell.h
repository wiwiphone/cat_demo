//
//  SearchResultSellerTableViewCell.h
//  XianMao
//
//  Created by simon cai on 8/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SearchResultSellerItem.h"

@interface SearchResultSellerTableViewCell : BaseTableViewCell

+ (NSString*)cellDictKeyForItem;
+ (NSMutableDictionary*)buildCellDict:(SearchResultSellerItem*)item;

@end
