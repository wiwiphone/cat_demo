//
//  NSHTTPCookieStorage+Extension.m
//  XianMao
//
//  Created by darren on 15/3/22.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "NSHTTPCookieStorage+Extension.h"
#import "NSHTTPCookie+Factory.h"

@implementation NSHTTPCookieStorage (Extension)

-(void)setAccessTokenCookieForURL:(NSURL *)url{
    NSHTTPCookie *cookie =[NSHTTPCookie accessTokenCookieForURL:url];
    if(!cookie) return;
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookie];
}

- (void)setClientVersionCookieForURL:(NSURL *)url {
    NSHTTPCookie *verCookie=[NSHTTPCookie clientVersionCookieForURL:url];
    if (!verCookie) return;
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:verCookie];
}

-(void)setCookieForURL:(NSURL *)linkURL{
    if (!linkURL) {
        return;
    }
    [self setAccessTokenCookieForURL:linkURL];
    [self setClientVersionCookieForURL:linkURL];
}


//-(void)setClientTokenCookieForLW{
//    NSArray *domains= @[
//                        @{ @"http://m.laiwang.com": @".laiwang.com" },
//                        @{ @"http://m.taobao.com": @".taobao.com" },
//                        @{ @"http://m.alipay.com": @".alipay.com" },
//                        @{ @"http://m.1688.com": @".1688.com" },
//                        @{ @"http://m.yunos.com": @".yunos.com" },
//                        @{ @"http://m.aliexpress.com": @".aliexpress.com" },
//                        @{ @"http://m.alimama.com": @".alimama.com" },
//                        @{ @"http://m.etao.com": @".etao.com" },
//                        @{ @"http://m.aliyun.com": @".aliyun.com" },
//                        @{ @"http://m.tmall.com": @".tmall.com" },
//                        @{ @"http://m.alibaba.com": @".alibaba.com" }];
//    for (NSString *host in domains) {
//        [self setClientTokenCookieForHost:host];
//        [self setAccessTokenCookieForHost:host];
//    }
//}


+ (NSMutableArray*) describeCookies {
    NSMutableArray *descriptions = [NSMutableArray new];
    
    [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie* obj, NSUInteger idx, BOOL *stop) {
        [descriptions addObject:@{[[obj name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:[[self class] describeCookie:obj]}];
    }];
    
   // LWLogDebug(@"Cookies:\n\n%@", descriptions);
    return descriptions;
}

+ (NSDictionary *) describeCookie:(NSHTTPCookie *)cookie {
    return @{@"value" : [[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             @"domain" : [cookie domain] ? [cookie domain]  : @"n/a",
             @"path" : [cookie path] ? [cookie path] : @"n/a",
             @"expiresDate" : [cookie expiresDate] ? [cookie expiresDate] : @"n/a",
             @"sessionOnly" : [cookie isSessionOnly] ? @1 : @0,
             @"secure" : [cookie isSecure] ? @1 : @0,
             @"comment" : [cookie comment] ? [cookie comment] : @"n/a",
             @"commentURL" : [cookie commentURL] ? [cookie commentURL] : @"n/a",
             @"version" : @([cookie version]) };
}


@end
