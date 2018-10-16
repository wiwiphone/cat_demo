//
//  ReceiveCell.h
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InvitationVo.h"

typedef void(^handleReceiveBtn)(NSDictionary *dict);

@interface ReceiveCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(InvitationVo*)invitationVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) handleReceiveBtn handleRecriveBtn;

@end
