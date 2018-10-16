//
//  MBDefaultMediator+MBProxy.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBDefaultMediator.h"


@interface MBDefaultMediator (MBProxy)
//创建它的代理对象,使调用直接消息化
@property(nonatomic, readonly) id proxyObject;
@end