//
//  MBDefaultMessageReceiver+MBProxy.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultMessageReceiver+MBProxy.h"
#import "MBMessageProxy.h"

@implementation MBDefaultMessageReceiver (MBProxy)
- (id)proxyObject {
    return [[MBMessageProxy alloc] initWithClass:[self class] andKey:self.notificationKey];
}
@end


