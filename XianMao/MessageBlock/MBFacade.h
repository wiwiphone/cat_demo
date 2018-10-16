//
//  MBFacade.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBMessageReceiver.h"
#import "MBMessageSender.h"
#import "MBCommand.h"

@protocol MBFacade <MBMessageSender>
//Facade 是单例
+ (id <MBFacade>)instance;

- (void)setInterceptors:(NSArray *)interceptors;

//订阅receiver
- (void)subscribeNotification:(id <MBMessageReceiver>)receiver;

//注销订阅
- (void)unsubscribeNotification:(id <MBMessageReceiver>)receiver;

//订阅Command
- (void)registerCommand:(Class)commandClass;

//自动订阅Command 会扫描所有的Class 并将 MBCommand 进行订阅
- (void)registerCommandAuto;

//异步自动订阅Command 会扫描所有的Class 并将 MBCommand 进行订阅
- (void)registerCommandAutoAsync;

@end



