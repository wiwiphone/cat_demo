//
//  InvitationPersonNumCell.h
//  XianMao
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InvitationVo.h"

@interface InvitationPersonNumCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(InvitationVo*)invationVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
