//
//  MBDefaultFacade.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBFacade.h"

#define MB_NOTIFICATION_KEY @"MB_NOTIFICATION_KEY"

@interface MBDefaultFacade : NSObject <MBFacade>
//设置分发消息的执行队列
+ (void)setDispatchQueue:(NSOperationQueue *)queue;

//设置Command的执行队列
+ (void)setCommandQueue:(dispatch_queue_t)queue;

//设置自定义的 NotificationCenter
+ (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter;

+ (MBDefaultFacade *)instance;

@end
