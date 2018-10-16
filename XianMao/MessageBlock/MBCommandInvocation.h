//
//  MBCommandInvocation.h
//  XianMao
//
//  Created by simon on 12/29/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBNotification;

@protocol MBCommandInvocation <NSObject>

- (Class)commandClass;

- (void)setCommandClass:(Class)commandClass;

- (id <MBNotification>)notification;

- (void)setNotification:(id <MBNotification>)notification;

//真正执行一个Command
- (id)invoke;

@end

