//
//  AppDelegate+UMeng.h
//  XianMao
//
//  Created by darren on 6/27/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"

@interface AppDelegate (UMeng)

- (void)umengApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)loginWithThridParty:(UIViewController*)presentingController platformName:(NSString*)platformName
       completion:(void (^)(UMSocialAccountEntity *snsAccount))completion;

@end
