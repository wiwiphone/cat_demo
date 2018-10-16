//
//  NSHTTPCookieStorage+Factory.m
//  XianMao
//
//  Created by darren on 15/3/22.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "NSHTTPCookie+Factory.h"
#import "Session.h"
#import "Version.h"
@implementation NSHTTPCookie (Factory)


+(NSHTTPCookie *)accessTokenCookieForHost:(NSDictionary *)host{
    NSString *accessToken=   [Session sharedInstance].token;
    NSString *domain =[host allValues][0];
    NSString *url=[host allKeys][0] ;
    
    if(!accessToken) return nil;
    if(!domain) return nil;
    if(!url) return nil;
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setValue:@"token" forKey:NSHTTPCookieName];
    [cookieProperties setValue:accessToken forKey:NSHTTPCookieValue];
    [cookieProperties setValue:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setValue:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setValue:url forKey:NSHTTPCookieOriginURL];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return cookie;
}


+(NSHTTPCookie *)accessTokenCookieForURL:(NSURL *)url{
    NSString *accessToken=   [Session sharedInstance].token;
    NSString *absoluteString=[url absoluteString] ;
    NSString *host=[url host];
    
    if(!accessToken) return nil;
    if(!host) return nil;
    if(!absoluteString) return nil;
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setValue:@"token" forKey:NSHTTPCookieName];
    [cookieProperties setValue:accessToken forKey:NSHTTPCookieValue];
    //底层判断，防止意外
    [cookieProperties setValue:host forKey:NSHTTPCookieDomain];
    [cookieProperties setValue:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setValue: absoluteString forKey:NSHTTPCookieOriginURL];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return cookie;
}

+(NSHTTPCookie *)clientVersionCookieForHost:(NSDictionary *)host{
    NSString *currentVersion=  APP_VERSION;
    currentVersion= [NSString stringWithFormat:@"iOS_%@",currentVersion ];
    
    NSString *domain =[host allValues][0];
    NSString *url=[host allKeys][0] ;
    
    if(!currentVersion) return nil;
    if(!domain) return nil;
    if(!url) return nil;
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setValue:@"appversion" forKey:NSHTTPCookieName];
    [cookieProperties setValue:currentVersion forKey:NSHTTPCookieValue];
    [cookieProperties setValue:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setValue:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setValue:url forKey:NSHTTPCookieOriginURL];
    [cookieProperties setValue:[NSNumber numberWithBool:NO] forKey:NSHTTPCookieDiscard];
    //    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *clientCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return clientCookie;
}

+(NSHTTPCookie *)clientVersionCookieForURL:(NSURL *)url{
    NSString *currentVersion=  APP_VERSION; //[[LWSettings sharedInstance] currentVersion] ;
    currentVersion= [NSString stringWithFormat:@"iOS_%@",currentVersion ];
    
    NSString *absoluteString=[url absoluteString] ;
    NSString *host=[url host];
    
    if(!currentVersion) return nil;
    if(!host) return nil;
    if(!absoluteString) return nil;
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setValue:@"appverion" forKey:NSHTTPCookieName];
    [cookieProperties setValue:currentVersion forKey:NSHTTPCookieValue];
    [cookieProperties setValue:host forKey:NSHTTPCookieDomain];
    [cookieProperties setValue:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setValue:absoluteString forKey:NSHTTPCookieOriginURL];
    [cookieProperties setValue:[NSNumber numberWithBool:NO] forKey:NSHTTPCookieDiscard];
    NSHTTPCookie *clientCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return clientCookie;
}



@end
