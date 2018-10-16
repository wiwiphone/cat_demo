//
//  MBDefaultCommandInvocation.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <objc/message.h>
#import "MBDefaultCommandInvocation.h"
#import "MBCommandInterceptor.h"
#import "MBUtil.h"

@implementation MBDefaultCommandInvocation {
    
@private
    Class _commandClass;
    id <MBNotification> _notification;
    
    NSEnumerator *_interceptors;
}
@synthesize commandClass = _commandClass;
@synthesize notification = _notification;

- (id)initWithCommandClass:(Class)commandClass
              notification:(id <MBNotification>)notification
              interceptors:(NSArray *)interceptors {
    self = [super init];
    if (self) {
        _commandClass = commandClass;
        _notification = notification;
        if (interceptors) {
            _interceptors = [interceptors objectEnumerator];
        } else {
            _interceptors = nil;
        }
    }
    return self;
}

+ (id)objectWithCommandClass:(Class)commandClass
                notification:(id <MBNotification>)notification
                interceptors:(NSArray *)interceptors {
    return [[MBDefaultCommandInvocation alloc]
            initWithCommandClass:commandClass
            notification:notification
            interceptors:interceptors];
}


static inline id executeCommand(Class commandClass, id <MBNotification> notification) {
    id ret = nil;
    if (commandClass == nil || notification == nil) {
        return nil;
    }
    if (MBClassHasProtocol(commandClass, @protocol(MBStaticCommand))) {
        //64位有BUG
        //ret = objc_msgSend(commandClass, @selector(execute:), notification);
        ret= ((id(*)(Class, SEL,id <MBNotification>))objc_msgSend)(commandClass, @selector(execute:), notification);
    } else if (MBClassHasProtocol(commandClass, @protocol(MBSingletonCommand))) {
        id <MBSingletonCommand> commandSingleton = objc_msgSend(commandClass, @selector(instance));
        if (commandSingleton) {
            //64位有BUG
            //ret = objc_msgSend(commandSingleton, @selector(execute:), notification);
            ret= ((id(*)(id, SEL,id <MBNotification>))objc_msgSend)(commandSingleton, @selector(execute:), notification);
        }
    } else if (MBClassHasProtocol(commandClass, @protocol(MBInstanceCommand))) {
        //64位有BUG
        //ret = objc_msgSend([[commandClass alloc] init], @selector(execute:), notification);
        ret= ((id(*)(id, SEL,id <MBNotification>))objc_msgSend)([[commandClass alloc] init], @selector(execute:), notification);
    } else {
        NSCAssert(NO, @"Unknown commandClass[%@] to invoke", commandClass);
    }
    return ret;
}


- (id)invoke {
    id <MBCommandInterceptor> interceptor = nil;
    if (_interceptors && (interceptor = [_interceptors nextObject])) {
        return [interceptor intercept:self];
    } else {
        return executeCommand(_commandClass, _notification);
    }
}

- (void)dealloc {
    MB_LOG(@"dealloc [%@]", self);
}


@end

