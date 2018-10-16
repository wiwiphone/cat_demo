//
//  MBUtil.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "MBUtil.h"
#import "MBCommand.h"
#import "MBMessageReceiver.h"
#import "MBOnlyProxy.h"
#import "MBBind.h"

inline BOOL MBClassHasProtocol(Class clazz, Protocol *protocol) {
    Class currentClass = clazz;
    while (!class_conformsToProtocol(currentClass, protocol)) {
        currentClass = class_getSuperclass(currentClass);
        if (currentClass == nil || currentClass == [NSObject class]) {
            return NO;
        }
    }
    return YES;
}

inline NSString *MBProxyHandlerName(unsigned long key, Class clazz) {
    return [NSString stringWithFormat:(@"%@_%ld_%@"),
            MB_PROXY_PREFIX,
           (unsigned long)key,
            clazz];
}

static inline NSSet *MBGetAllHandlerNameWithClass(Class clazz, BOOL isClassMethod, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:2];
    unsigned int methodCount;
    Method *methods = isClassMethod ?
    class_copyMethodList(object_getClass(clazz), &methodCount) :
    class_copyMethodList(clazz, &methodCount);
    if (methods && methodCount > 0) {
        for (unsigned int i = 0; i < methodCount; i++) {
            SEL selector = method_getName(methods[i]);
            NSString *selectorName = NSStringFromSelector(selector);
            if ([selectorName hasPrefix:prefix]) {
                [names addObject:selectorName];
            }
        }
    }
    if (methods) {
        free(methods);
    }
    return names;
}

inline NSMutableSet *MBGetAllReceiverHandlerName(Class currentClass, Class rootClass, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    rootClass = rootClass ? : [NSObject class];
    Class clazz = currentClass;
    while (clazz != nil && clazz != rootClass) {
        NSSet *nameWithClass = MBGetAllHandlerNameWithClass(clazz, NO, prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}


inline NSSet *MBInternalListAllReceiverHandlerName(id handler, id <MBMessageReceiver> receiver, Class rootClass) {
    if (MBClassHasProtocol([handler class], @protocol(MBOnlyProxy))) {
        return [NSSet setWithObject:MBProxyHandlerName(receiver.notificationKey, [handler class])];
    }
    NSMutableSet *handlerNames = MBGetAllReceiverHandlerName([handler class], rootClass,
                                                               MB_DEFAULT_RECEIVE_HANDLER_NAME
                                                               );
    [handlerNames addObject:MBProxyHandlerName(receiver.notificationKey, [handler class])];
    return handlerNames;
}


inline NSSet *MBListAllReceiverHandlerName(id <MBMessageReceiver> handler, Class rootClass) {
    return MBInternalListAllReceiverHandlerName(handler, handler, rootClass);
}

inline NSMutableSet *MBGetAllCommandHandlerName(Class commandClass, NSString *prefix) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class clazz = commandClass;
    while (clazz != nil && clazz != [NSObject class]) {
        NSSet *nameWithClass = MBGetAllHandlerNameWithClass(clazz, MBClassHasProtocol(commandClass, @protocol(MBStaticCommand)), prefix);
        [names unionSet:nameWithClass];
        clazz = class_getSuperclass(clazz);
    }
    return names;
}

inline id MBAutoHandlerNotification(id handler, id <MBNotification> notification) {
    SEL notifyHandler = NSSelectorFromString(notification.name);
    id ret = nil;
    if ([handler respondsToSelector:notifyHandler]) {
        BOOL hasIdReturn = NO;
        Class clazz = object_getClass(handler);
        Method method;
        if (class_isMetaClass(clazz)) {
            //handler本身是类
            method = class_getClassMethod(handler, notifyHandler);
        } else {
            //handler是一个实例
            method = class_getInstanceMethod(clazz, notifyHandler);
        }
        if (method) {
            char *type = method_copyReturnType(method);
            if (type) {
                if (type[0] == @encode(id)[0]) {
                    hasIdReturn = YES;
                }
                free(type);
            }
        }
        if (hasIdReturn) {
            //64位有BUG
            //ret = objc_msgSend(handler, notifyHandler, notification, notification.body, notification.userInfo);
            ret= ((id(*)(id, SEL,id <MBNotification>,id,NSDictionary*))objc_msgSend)(handler, notifyHandler, notification, notification.body, notification.userInfo);
        } else {
            //64位有BUG
            //objc_msgSend(handler, notifyHandler, notification, notification.body, notification.userInfo);
            ((void(*)(id, SEL,id <MBNotification>,id,NSDictionary*))objc_msgSend)(handler, notifyHandler, notification, notification.body, notification.userInfo);
        }
    }
    return ret;
}

inline void MBInternalAutoHandlerReceiverNotification(id handler, id <MBMessageReceiver> receiver,
                                                        id <MBNotification> notification) {
    if ([notification.name isEqualToString:MBProxyHandlerName(receiver.notificationKey, [handler class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:handler];
        return;
    }
    MBAutoHandlerNotification(handler, notification);
}

inline void MBAutoHandlerReceiverNotification(id <MBMessageReceiver> handler, id <MBNotification> notification) {
    MBInternalAutoHandlerReceiverNotification(handler, handler, notification);
}

inline const unsigned long MBGetDefaultNotificationKey(id o) {
    const void *ptr = (__bridge const void *) o;
    return (const unsigned long) ptr;
}


inline BOOL MBIsNotificationProxy(id <MBNotification> notification) {
    return notification && [notification.name hasPrefix:MB_PROXY_PREFIX] && [notification.body
                                                                               isKindOfClass:[NSInvocation class]];
}

inline void MBAutoBindingKeyPath(id bindable) {
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class rootClass = [NSObject class];
    Class clazzUIViewController = [UIViewController class];
    Class clazz = [bindable class];
    while (clazz != nil && clazz != rootClass && clazz != clazzUIViewController) {
        unsigned int methodCount;
        Method *methods = class_copyMethodList(clazz, &methodCount);
        if (methods && methodCount > 0) {
            for (unsigned int i = 0; i < methodCount; i++) {
                SEL selector = method_getName(methods[i]);
                NSString *selectorName = NSStringFromSelector(selector);
                if ([selectorName hasPrefix:MB_KEY_PATH_CHANGE_PREFIX]) {
                    [names addObject:selectorName];      //为了去重
                }
            }
        }
        if (methods) {
            free(methods);
        }
        clazz = class_getSuperclass(clazz);
    }
    
    if (names.count > 0) {
        for (NSString *name in names) {
            SEL selector = NSSelectorFromString(name);
            NSString *keyPath = [name substringFromIndex:[MB_KEY_PATH_CHANGE_PREFIX length]];
            keyPath = [[keyPath componentsSeparatedByString:@":"] objectAtIndex:0];
            keyPath = [[keyPath componentsSeparatedByString:__MBAutoKeyPathChangeMethodNameSEP_STR]
                       componentsJoinedByString:@"."];
            __block __unsafe_unretained id _bindable = bindable;
            MBBindObject(bindable, keyPath, ^(id old, id new) {
                //objc_msgSend(_bindable, selector, [MBBindInitValue value] == old, old, new);
                //64位有BUG
                ((void(*)(id, SEL,BOOL,id,id))objc_msgSend)(_bindable, selector, [MBBindInitValue value] == old, old, new);
                
            }
                           );
        }
    }
}


//http://www.iloss.me/post/kai-fa/2014-12-09-objc_msgsend







