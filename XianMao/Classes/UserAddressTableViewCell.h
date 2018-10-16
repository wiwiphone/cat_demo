//
//  UserAddressTableViewCell.h
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SwipeTableViewCell.h"

@class AddressInfo;
@interface UserAddressTableViewCell : SwipeTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(AddressInfo*)addressInfo;

+ (NSString*)cellDictKeyForAddressInfo;
+ (NSString*)cellDictKeyForSelected;

- (void)updateCellWithDict:(NSDictionary*)dict;

@property(nonatomic,assign) BOOL isForSelectAddress;

@end
