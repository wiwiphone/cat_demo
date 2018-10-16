//
//  SellerInfoTableViewCell.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class User;

@interface SellerInfoTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSString*)cellDictKeyForSellerInfo;
+ (NSMutableDictionary*)buildCellDict:(User*)sellerInfo;

@end
