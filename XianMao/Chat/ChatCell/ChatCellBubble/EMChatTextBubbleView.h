/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "EMChatBaseBubbleView.h"
#import "MLEmojiLabel.h"


extern NSString *const kRouterEventChatCellBubbleTapEventName;

#define BUBBLE_LEFT_IMAGE_NAME @"chat_receiver_bg_New" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"chat_sender_bg_New"
#define BUBBLE_ARROW_WIDTH 5 // bubbleView中，箭头的宽度
#define BUBBLE_VIEW_PADDING 6 // bubbleView 与 在其中的控件内边距

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 15 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 20 // 文字在右侧时,bubble用于拉伸点的Y坐标             //格局需求修改聊天背景图片  拉伸位置  2016.4.19 Feng

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 24 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 20 // 文字在左侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_PROGRESSVIEW_HEIGHT 10 // progressView 高度

#define KMESSAGEKEY @"message"

#define TEXTLABEL_MAX_WIDTH ((float)[[UIScreen mainScreen] bounds].size.width)/375*247 //　textLaebl 最大宽度
#define LABEL_FONT_SIZE 14

extern NSString *const kRouterEventTextURLTapEventName;
extern NSString *const kRouterEventTextPhoneTapEventName;

@interface EMChatTextBubbleView : EMChatBaseBubbleView <MLEmojiLabelDelegate>

@property (nonatomic, strong) MLEmojiLabel *emojiLabel;

+ (UIFont *)textLabelFont;
+ (NSLineBreakMode)textLabelLineBreakModel;

@end
