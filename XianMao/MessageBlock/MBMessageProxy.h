//
//  MBMessageProxy.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

//代理对象
@interface MBMessageProxy : NSProxy
- (id)initWithClass:(Class)proxyClass andKey:(NSUInteger)key;
@end
