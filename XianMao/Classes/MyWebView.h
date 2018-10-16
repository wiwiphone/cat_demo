//
//  MyWebView.h
//  XianMao
//
//  Created by simon on 1/15/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

extern const float NJKInitialProgressValue;
extern const float NJKInteractiveProgressValue;
extern const float NJKFinalProgressValue;

@interface MyWebView : UIWebView<UIWebViewDelegate,MBMessageReceiver, MBMessageSender>

@property (copy, nonatomic) BOOL (^webViewShouldStartLoadWithRequestBlock)(MyWebView *webView, NSURLRequest *request,UIWebViewNavigationType navigationType);
@property (copy, nonatomic) void (^webViewDidStartLoadBlock)(MyWebView *webView);
@property (copy, nonatomic) void (^webViewDidFinishLoadBlock)(MyWebView *webView);
@property (copy, nonatomic) void (^webViewDidFailWithErrorBlock)(MyWebView *webView,NSError *error);
@property (nonatomic, copy) void (^webViewProgressBlock)(MyWebView *webView);;
@property (nonatomic, readonly) float progress; // 0.0..1.0
@property (nonatomic, assign) BOOL useCached;


@property(nonatomic,strong) WebViewJavascriptBridge *bridge;
@property(nonatomic, copy) WVJBResponseCallback responseCallback;

@property(nonatomic, strong) id <MBFacade> MBFacade;

- (NSUInteger const)notificationKey;


- (id)initWithMBFacade:(id <MBFacade>)mbFacade;

+ (id)objectWithMBFacade:(id <MBFacade>)mbFacade;

- (void)firstLoadURLString:(NSString*)urlString;

- (UIScrollView*)scrollView;

+ (BOOL)isWebURL:(NSURL*)URL;
+ (BOOL)isExternalURL:(NSURL*)URL;
+ (BOOL)isAppURL:(NSURL*)URL;

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi;
@end


@interface MyWebView (WebViewAdditions)

- (NSString *)documentTitle;

@end




