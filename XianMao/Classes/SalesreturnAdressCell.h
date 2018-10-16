//
//  SalesreturnAdressCell.h
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AddressInfo.h"

@interface SalesreturnAdressCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
