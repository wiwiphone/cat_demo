//
//  AppDelegate.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "UPPayPluginDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UPPayPluginDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) NSDate *lastPlaySoundDate;

- (void)reLoginToEaseMob;
- (void)registerRemoteNotification;
@end

