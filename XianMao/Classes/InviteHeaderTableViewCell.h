//
//  InviteHeaderTableViewCell.h
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "User.h"

@interface InviteHeaderTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(User*)user;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
