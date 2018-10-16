//
//  MBDefaultMessageReceiver.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMessageReceiver.h"

@protocol MBFacade;


@interface MBDefaultMessageReceiver : NSObject <MBMessageReceiver>
@property(nonatomic, strong) id <MBFacade> MBFacade;

- (NSUInteger const)notificationKey;

- (id)initWithMBFacade:(id <MBFacade>)MBFacade;

+ (id)objectWithMBFacade:(id <MBFacade>)MBFacade;
@end

