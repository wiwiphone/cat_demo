//
//  ConversationCell.h
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class Conversation;
@interface ConversationTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(Conversation*)item;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
