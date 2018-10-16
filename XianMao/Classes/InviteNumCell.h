//
//  InviteNumCell.h
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InvitationVo.h"

@interface InviteNumCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleQQshareBlock)();
@property (nonatomic, copy) void(^handlewecatShareBlock)();
@property (nonatomic, copy) void(^handlemoreShareBlock)();

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(InvitationVo*)invationVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
