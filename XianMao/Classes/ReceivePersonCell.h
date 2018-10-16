//
//  ReceivePersonCell.h
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InvitationUserVo.h"

@interface ReceivePersonCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(InvitationUserVo*)invUserVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
