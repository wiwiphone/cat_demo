//
//  ConsignOrderTableViewCell.h
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SwipeTableViewCell.h"

@class ConsignOrder;

@interface ConsignOrderTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(ConsignOrder*)order;
- (void)updateCellWithDict:(NSDictionary *)dict;

+ (NSString*)cellDictKeyForConsignOrder;

@end
