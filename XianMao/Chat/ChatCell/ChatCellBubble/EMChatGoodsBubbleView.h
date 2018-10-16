//
//  EMChatGoodsBubbleView.h
//  XianMao
//
//  Created by darren on 15/4/8.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "EMChatBaseBubbleView.h"

#define MAX_SIZE 120 //　图片最大显示大小

@interface EMChatGoodsBubbleView : EMChatBaseBubbleView


extern NSString *const kRouterEventGoodsBubbleTapEventName;

@property (nonatomic, strong) UIImageView *imageView;
@end
