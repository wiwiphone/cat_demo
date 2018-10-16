//
//  ChatRecordItem.h
//  XianMao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "ChatGoodsInfo.h"

@interface ChatRecordItem : JSONModel

@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *hxMsgId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *chatType;
@property (nonatomic, assign) NSInteger fromUserId;
@property (nonatomic, copy) NSString *fromNickname;
@property (nonatomic, assign) NSInteger toUserId;
@property (nonatomic, copy) NSString *toNickname;
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, strong) NSString *chatImgUrl;
@property (nonatomic, strong) NSString *bodyType;
@property (nonatomic, strong) NSString *bodyMsg;
@property (nonatomic, assign) long long hxSendTime;
@property (nonatomic, assign) long long hxReceiveTime;
@property (nonatomic, strong) ChatGoodsInfo *goodsInfo;

-(NSInteger)getContentType:(EMMessage *)message;
@end
