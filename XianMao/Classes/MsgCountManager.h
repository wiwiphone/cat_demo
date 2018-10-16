//
//  MsgCountManager.h
//  XianMao
//
//  Created by simon on 1/28/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgCountManager : MBDefaultMessageReceiver

@property(nonatomic,readonly) NSInteger noticeCount;
@property(nonatomic,readonly) NSInteger chatMsgCount;

+ (MsgCountManager*)sharedInstance;

- (void)initialize;

- (void)restartMsgCountTimer;
- (void)stopMsgCountTimer;
- (void)syncMsgCount;
- (void)syncNoticeCount;

- (void)clearNoticeCount;

- (void)resetChatMsgCount:(NSInteger)count;
- (void)removeChatMsgCount:(NSInteger)count;
- (void)clearChatMsgCount;
- (void)syncChatMsgCount;

// add code
- (void)clearNotice:(NSInteger)number;
@end

@protocol MsgCountChangedReceiver <NSObject>
@optional
- (void)$$handleNoticeCountDidFinishNotification:(id<MBNotification>)notifi noticeCount:(NSNumber*)noticeCount;
- (void)$$handleChatMsgCountDidFinishNotification:(id<MBNotification>)notifi chatMsgCount:(NSNumber*)chatMsgCount;
@end


//bought = 66;
//consign = 6;
//enjoy = 7;
//fans = 2;
//follow = 5;
//goods = 1;
//"new_notice_count" = 2;
//sold = 1;
//"user_id" = 57;
