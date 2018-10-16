//
//  MBSimpleStaticCommand+MBProxy.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBSimpleStaticCommand.h"

@interface MBSimpleStaticCommand (MBProxy)
//创建它的代理对象,使调用直接消息化
+ (id)proxyObject;
@end