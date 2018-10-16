//
//  NSHTTPCookieStorage+Factory.h
//  XianMao
//
//  Created by darren on 15/3/22.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPCookie (Factory)

+(NSHTTPCookie *)accessTokenCookieForHost:(NSDictionary *)host;
+(NSHTTPCookie *)clientVersionCookieForHost:(NSDictionary *)host;

+(NSHTTPCookie *)accessTokenCookieForURL:(NSURL *)url;
+(NSHTTPCookie *)clientVersionCookieForURL:(NSURL *)url;


@end
