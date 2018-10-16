//
//  ConsignmentPriceCell.h
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ConsignmentPriceCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleConsignmentPriceBlcok)(double price);

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
