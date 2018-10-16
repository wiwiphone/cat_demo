//
//  ChatRecordItem.m
//  XianMao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ChatRecordItem.h"

/**
 * 消息内容类型 0：聊天文本 1：商品 2：图片 3 语音
 */

static NSInteger text = 0;
static NSInteger goods = 1;
static NSInteger picture = 2;
static NSInteger voice = 3;
@implementation ChatRecordItem

-(NSInteger)getContentType:(EMMessage *)message{
    
    if (message.ext[@"goods"]) {
        return goods;
    } else {
        switch (message.body.type) {
            case EMMessageBodyTypeText:
                return text;
                break;
            case EMMessageBodyTypeImage:
                self.chatImgUrl = ((EMFileMessageBody *)message.body).remotePath;
                return picture;
                break;
            case EMMessageBodyTypeVoice:
                return voice;
                break;
            default:
                break;
        }
    }
    return 10000;
}

@end
