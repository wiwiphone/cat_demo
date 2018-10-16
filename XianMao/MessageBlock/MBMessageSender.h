//
//  MBMessageSender.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBNotification.h"

@protocol MBMessageSender
//发送通知
- (void)sendNotification:(NSString *)notificationName;

//发送通知
- (void)sendNotification:(NSString *)notificationName body:(id)body;

//发送通知
- (void)sendMBNotification:(id <MBNotification>)notification;

//发送通知
- (void)sendNotificationForSEL:(SEL)selector;

//发送通知
- (void)sendNotificationForSEL:(SEL)selector body:(id)body;

//发送通知
//- (void)sendNotificationForPaySEL:(SEL)selector body:(id)body;

@end