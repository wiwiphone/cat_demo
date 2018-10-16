//
//  MBUtil.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "MBNotification.h"

#ifdef MB_DEBUG
#define MB_LOG(msg, args...) NSLog(@"MB " msg, ##args)
#else
#define MB_LOG(msg, args...)
#endif

#define MB_PROXY_PREFIX @"__##__ProxyHandler"

#define MB_KEY_PATH_CHANGE_PREFIX @"__$$keyPathChange_"

@class MBDefaultMessageReceiver;
@protocol MBMessageReceiver;

extern BOOL MBClassHasProtocol(Class clazz, Protocol *protocol);

extern NSString *MBProxyHandlerName(unsigned long key, Class clazz);

extern NSMutableSet *MBGetAllReceiverHandlerName(Class currentClass, Class rootClass, NSString *prefix);

extern NSSet *MBInternalListAllReceiverHandlerName(id handler, id <MBMessageReceiver> receiver,
                                                            Class rootClass);

extern NSSet *MBListAllReceiverHandlerName(id <MBMessageReceiver> handler, Class rootClass);

extern NSMutableSet *MBGetAllCommandHandlerName(Class commandClass, NSString *prefix);

extern id MBAutoHandlerNotification(id handler, id <MBNotification> notification);

extern void MBInternalAutoHandlerReceiverNotification(id handler, id <MBMessageReceiver> receiver,
                                                               id <MBNotification> notification);

extern void MBAutoHandlerReceiverNotification(id <MBMessageReceiver> handler, id <MBNotification> notification);

extern const unsigned long MBGetDefaultNotificationKey(id o);

extern BOOL MBIsNotificationProxy(id <MBNotification> notification);

extern void MBAutoBindingKeyPath(id bindable);












