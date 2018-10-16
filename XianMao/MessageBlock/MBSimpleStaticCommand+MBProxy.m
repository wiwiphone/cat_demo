//
//  MBSimpleStaticCommand+MBProxy.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBSimpleStaticCommand+MBProxy.h"
#import "MBMessageProxy.h"


@implementation MBSimpleStaticCommand (MBProxy)
+ (id)proxyObject {
    return [[MBMessageProxy alloc] initWithClass:self andKey:0];
}

@end