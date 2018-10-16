//
//  AppDelegate+EaseMob.h
//  XianMao
//
//  Created by darren on 6/27/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "AppDelegate.h"
#import "EMChatDefine.h"

typedef enum {
    EMMessageType = 1, //聊天
} NotificationType;
static NSString *kNotificationType = @"NotificationType";

@interface AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
