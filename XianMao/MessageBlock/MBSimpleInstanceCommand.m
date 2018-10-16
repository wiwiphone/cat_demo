//
//  MBSimpleInstanceCommand.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBSimpleInstanceCommand.h"
#import "MBUtil.h"
#import "MBMessageReceiver.h"
#import "MBOnlyProxy.h"

@implementation MBSimpleInstanceCommand {
    
}
- (id)execute:(id <MBNotification>)notification {
    if ([notification.name isEqualToString:MBProxyHandlerName(0, [self class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:self];
        char const *returnType = invocation.methodSignature.methodReturnType;
        if (strcmp("@", returnType) == 0) {
            id ret;
            [invocation getReturnValue:&ret];
            return ret;
        }
        return nil;
    }
    return MBAutoHandlerNotification(self, notification);
}

+ (NSSet *)listReceiveNotifications {
    if (MBClassHasProtocol(self, @protocol(MBOnlyProxy))) {
        return [NSSet setWithObject:MBProxyHandlerName(0, self)];
    }
    NSMutableSet *handlerNames = MBGetAllCommandHandlerName(self, MB_DEFAULT_RECEIVE_HANDLER_NAME);
    [handlerNames addObject:MBProxyHandlerName(0, self)];
    return handlerNames;
}

@end

