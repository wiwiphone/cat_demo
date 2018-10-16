//
//  MBNotification.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBNotification
//消息内容
- (id)body;

- (NSTimeInterval)delay;

- (void)setDelay:(NSTimeInterval)delay;

//消息名
- (NSString *)name;

//消息的key 一般是 receiver的key在createNextNotification的时候会把key带过去用来判断发送源
- (NSUInteger)key;

//设置key
- (void)setKey:(NSUInteger)key;

//设置消息内容
- (void)setBody:(id)body;

//用户自定义的信息,在createNextNotification的时候会带过去
- (NSDictionary *)userInfo;

//设置用户信息
- (void)setUserInfo:(NSDictionary *)value;

//被重放的次数
- (NSUInteger)retryCount;

//设置被重放的次数
- (void)setRetryCount:(NSUInteger)value;

//当createNextNotification时,源消息被放到这个lastNotification中,以便形成调用链
- (id <MBNotification>)lastNotification;

//设置 lastNotification
- (void)setLastNotification:(id <MBNotification>)notification;

//以当前消息 创建 下一个消息
- (id <MBNotification>)createNextNotification:(NSString *)name;

//以当前消息 创建 下一个消息
- (id <MBNotification>)createNextNotification:(NSString *)name withBody:(id)body;

//以当前消息 创建 下一个消息
- (id <MBNotification>)createNextNotificationForSEL:(SEL)selector;

//以当前消息 创建 下一个消息
- (id <MBNotification>)createNextNotificationForSEL:(SEL)selector withBody:(id)body;

@end





