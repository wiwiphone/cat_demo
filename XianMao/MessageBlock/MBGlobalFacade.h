//
//  MBGlobalFacade.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBFacade.h"

@interface MBGlobalFacade : NSObject <MBFacade>
+ (BOOL)setDefaultFacade:(Class)facadeClass;

+ (MBGlobalFacade *)instance;
@end

//封装好的 发送Notification接口
extern void MBGlobalSendNotification(NSString *notificationName);

//封装好的 发送Notification接口
extern void MBGlobalSendNotificationWithBody(NSString *notificationName, id body);

//封装好的 发送Notification接口
extern void MBGlobalSendNotificationForSEL(SEL selector);

//封装好的 发送Notification接口
extern void MBGlobalSendNotificationForSELWithBody(SEL selector, id body);

//封装好的 发送Notification接口
extern void MBGlobalSendMBNotification(id <MBNotification> notification);

////封装好的 发送Notification接口
//extern void MBGlobalSendNotificationForSELWithForBody(SEL selector, id body);


