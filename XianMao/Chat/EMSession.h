//
//  EMSession.h
//  XianMao
//
//  Created by simon on 1/17/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMChatDefine.h"

@class XMError;
@interface EMSession : NSObject<EMChatManagerDelegate>

+ (EMSession*)sharedInstance;

- (BOOL)isLoggedIn;


- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)())completion
                  failure:(void (^)(XMError *error))failure;

- (void)logout;

- (void)logout:(void (^)())completion
       failure:(void (^)(XMError *error))failure;

- (NSInteger)unreadChatMsgCount;

-(NSDictionary *) loadFromCacheFile;

@end

