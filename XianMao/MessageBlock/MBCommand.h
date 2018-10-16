//
//  MBCommand.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNotification.h"

//============================================================================
@class MBNotification;

//Command 用来接受消息并执行
@protocol MBCommand
//列出所有能处理的消息名,会以次消息名进行订阅
+ (NSSet */*NSString*/)listReceiveNotifications;

@end

//============================================================================

@protocol MBStaticCommand <MBCommand>
//静态类型的Command
+ (id)execute:(id <MBNotification>)notification;

@end

//============================================================================

@protocol MBInstanceCommand <MBCommand>
//执行收到的消息
- (id)execute:(id <MBNotification>)notification;

@end

//============================================================================

@protocol MBSingletonCommand <MBInstanceCommand>
//单例的Command
+ (id <MBSingletonCommand>)instance;

@end






