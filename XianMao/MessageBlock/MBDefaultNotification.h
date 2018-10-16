//
//  MBDefaultNotification.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNotification.h"

@interface MBDefaultNotification : NSObject <MBNotification>

@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, assign) NSUInteger key;
@property(nonatomic, strong) id body;
@property(nonatomic, assign) NSTimeInterval delay;
@property(nonatomic, assign) NSUInteger retryCount;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) id <MBNotification> lastNotification;

- (id)initWithName:(NSString *)name;

+ (id)objectWithName:(NSString *)name;

- (id)initWithName:(NSString *)name body:(id)body;

+ (id)objectWithName:(NSString *)name body:(id)body;

- (id)initWithName:(NSString *)name key:(NSUInteger)key;

+ (id)objectWithName:(NSString *)name key:(NSUInteger)key;

- (id)initWithName:(NSString *)name key:(NSUInteger)key body:(id)body;

+ (id)objectWithName:(NSString *)name key:(NSUInteger)key body:(id)body;

- (id)initWithSEL:(SEL)SEL;

+ (id)objectWithSEL:(SEL)SEL;

- (id)initWithSEL:(SEL)SEL body:(id)body;

+ (id)objectWithSEL:(SEL)SEL body:(id)body;

- (id)initWithSEL:(SEL)SEL key:(NSUInteger)key body:(id)body;

+ (id)objectWithSEL:(SEL)SEL key:(NSUInteger)key body:(id)body;


@end




