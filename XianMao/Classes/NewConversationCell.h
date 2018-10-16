//
//  NewConversationCell.h
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "EMConversation.h"

@interface NewConversationCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *unreadLabel;
@property (nonatomic) NSInteger unreadCount;

- (void)updateCellWithDict:(NSDictionary *)dict;
+ (NSString *)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict:(EMConversation *)conversation userId:(NSInteger)userId;
+ (CGFloat)rowHeightForPortrait:(NSString *)title;
+ (NSString *)cellForConversationkey;

@end
