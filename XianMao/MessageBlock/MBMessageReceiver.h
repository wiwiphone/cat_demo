//
//  MBMessageReceiver.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//
#import "MBNotification.h"

#define MB_DEFAULT_RECEIVE_HANDLER_NAME  (@"$$")

@protocol MBMessageReceiver <NSObject>
//默认的key 用于回调判断用
- (const NSUInteger)notificationKey;

//处理通知的函数
- (void)handlerNotification:(id <MBNotification>)notification;

//列出需要监听的通知名
- (NSSet */*NSString*/)listReceiveNotifications;

//列出所有的Observer 需要释放
- (NSSet *)_$listObserver;

//加入被加到NotificationCenter的Observer
- (void)_$addObserver:(id)observer;

//移除被加到NotificationCenter的Observer
- (void)_$removeObserver:(id)observer;
@end