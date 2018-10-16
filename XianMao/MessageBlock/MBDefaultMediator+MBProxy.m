//
//  MBDefaultMediator+MBProxy.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultMediator+MBProxy.h"
#import "MBMessageProxy.h"

@implementation MBDefaultMediator (MBProxy)
- (id)proxyObject {
    return [[MBMessageProxy alloc]
            initWithClass:[self.realReceiver class]
            andKey:self.notificationKey];
}

@end