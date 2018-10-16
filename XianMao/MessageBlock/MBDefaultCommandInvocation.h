//
//  MBDefaultCommandInvocation.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBCommand.h"
#import "MBCommandInvocation.h"

@interface MBDefaultCommandInvocation : NSObject <MBCommandInvocation>

@property(nonatomic) Class commandClass;
@property(nonatomic, retain) id <MBNotification> notification;

- (id)invoke;

- (id)initWithCommandClass:(Class)commandClass
              notification:(id <MBNotification>)notification
              interceptors:(NSArray *)interceptors;

+ (id)objectWithCommandClass:(Class)commandClass
                notification:(id <MBNotification>)notification
                interceptors:(NSArray *)interceptors;


@end
