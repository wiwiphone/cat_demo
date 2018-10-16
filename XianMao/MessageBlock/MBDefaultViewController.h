//
//  MBDefaultViewController.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBFacade.h"

@interface MBDefaultViewController : UIViewController <MBMessageReceiver, MBMessageSender>

@property(nonatomic, strong) id <MBFacade> MBFacade;

- (NSUInteger const)notificationKey;

//属性的初始化在这里做比较好,可以防止AutoBind被过早执行
- (void)propertyInit;

- (id)initWithMBFacade:(id <MBFacade>)mbFacade;

+ (id)objectWithMBFacade:(id <MBFacade>)mbFacade;

@end

