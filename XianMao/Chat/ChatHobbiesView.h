//
//  ChatHobbiesView.h
//  XianMao
//
//  Created by Marvin on 17/3/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTabReplyVo.h"

@interface ChatHobbiesView : UIView

@property (nonatomic, copy) void(^handleChatTabReplyBlock)(ChatTabReplyVo * chatTapReplyVo);

- (void)getchatTabReplyData:(NSArray *)data;
@end





@interface ChatTabReplyButton : UIButton
@property (nonatomic, strong) ChatTabReplyVo *chatTapReplyVo;
@end
