//
//  MBDefaultMediator.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMessageReceiver.h"

@protocol MBFacade;

@interface MBDefaultMediator : NSObject <MBMessageReceiver>

@property(nonatomic, strong) id <MBFacade> MBFacade;
@property(nonatomic, assign, readonly) id realReceiver;

- (NSUInteger const)notificationKey;

- (void)close;

- (id)initWithRealReceiver:(id)realReceiver;

- (id)initWithRealReceiver:(id)realReceiver MBFacade:(id <MBFacade>)MBFacade;

+ (id)mediatorWithRealReceiver:(id)realReceiver MBFacade:(id <MBFacade>)MBFacade;

+ (id)mediatorWithRealReceiver:(id)realReceiver;

@end



