//
//  MBDefaultViewController+MBProxy.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBDefaultViewController+MBProxy.h"
#import "MBMessageProxy.h"


@implementation MBDefaultViewController (MBProxy)

- (id)proxyObject {
    return [[MBMessageProxy alloc] initWithClass:[self class] andKey:self.notificationKey];
}

@end