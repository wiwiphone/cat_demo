//
//  NSHTTPCookieStorage+Extension.h
//  XianMao
//
//  Created by darren on 15/3/22.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPCookieStorage (Extension)

-(void)setAccessTokenCookieForURL:(NSURL *)url;
- (void)setClientVersionCookieForURL:(NSURL *)url;

-(void)setCookieForURL:(NSURL *)linkURL;

+ (NSDictionary*) describeCookies;
+ (NSDictionary *) describeCookie:(NSHTTPCookie *)cookie;

@end

