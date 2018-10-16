//
//  MyWebView.m
//  XianMao
//
//  Created by simon on 1/15/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "MyWebView.h"
#import "LocalURLCache.h"
#import "NetworkManager.h"
#import "AppDirs.h"
#import "Session.h"
#import "Version.h"
#import "NSHTTPCookieStorage+Extension.h"
#import "NetworkAPI.h"
#import "LoginViewController.h"
#import "MBGlobalFacade.h"
#import "MBDefaultNotification.h"
#import "MBUtil.h"
#import "UIImage+Addtions.h"
#import <cmbkeyboard/CMBWebKeyboard.h>
#import <cmbkeyboard/NSString+Additions.h>

@interface MyWebView () <UIGestureRecognizerDelegate,MyWebViewImagePickerReciever>

//@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) LocalURLCache *urlCache;
@property(nonatomic,strong) NSString *requestUrl ;
@property(nonatomic,assign) CGFloat contentMarginTop;
@property(nonatomic,strong) NSURLRequest *urlRequest;

@end

@implementation MyWebView {
@private
    id <MBFacade> _$MBFacade;
    NSMutableSet *_$MBObserver;
}

#pragma mark - Notification init

- (const NSUInteger)notificationKey {
    return MBGetDefaultNotificationKey(self);
}

- (id <MBFacade>)MBFacade {
    return _$MBFacade ? : [MBGlobalFacade instance];
}

- (void)setMBFacade:(id <MBFacade>)MBFacade {
    if (self.MBFacade != MBFacade) {
        [self.MBFacade unsubscribeNotification:self];
        _$MBFacade = MBFacade;
        [self.MBFacade subscribeNotification:self];
    }
}
- (id)initWithMBFacade:(id <MBFacade>)MBFacade {
    self = [super init];
    if (self) {
        self.MBFacade = MBFacade;
    }
    return self;
}

+ (id)objectWithMBFacade:(id <MBFacade>)MBFacade {
    return [[MBDefaultViewController alloc] initWithMBFacade:MBFacade];
}


#pragma mark  - receiver ,need Overwrite

//默认自动匹配方法
- (void)handlerNotification:(id <MBNotification>)notification {
    MBAutoHandlerReceiverNotification(self, notification);
}

- (NSSet *)listReceiveNotifications {
    return MBListAllReceiverHandlerName(self, [MBDefaultViewController class]);
}

- (NSSet *)_$listObserver {
    return _$MBObserver;
}

- (void)_$addObserver:(id)observer {
    _$MBObserver = _$MBObserver ? : [NSMutableSet setWithCapacity:1];
    [_$MBObserver addObject:observer];
}

- (void)_$removeObserver:(id)observer {
    [_$MBObserver removeObject:observer];
}

#pragma mark  - sender
- (void)sendNotification:(NSString *)notificationName {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:notificationName
                                                                        key:self.notificationKey]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:notificationName
                                                                        key:self.notificationKey
                                                                       body:body]];
}

- (void)sendMBNotification:(id <MBNotification>)notification {
    notification.key = self.notificationKey;
    [self.MBFacade sendMBNotification:notification];
}

- (void)sendNotificationForSEL:(SEL)selector {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:NSStringFromSelector(selector)
                                                                        key:self.notificationKey]];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [self.MBFacade sendMBNotification:[MBDefaultNotification objectWithName:NSStringFromSelector(selector)
                                                                        key:self.notificationKey body:body]];
}

//自动扫描keyBinding
- (void)autoBindingKeyPath {
    MBAutoBindingKeyPath(self);
}

#pragma mark - WebView method

- (void)dealloc
{
    [self.MBFacade unsubscribeNotification:self];
    _webViewShouldStartLoadWithRequestBlock = nil;
    _webViewDidStartLoadBlock = nil;
    _webViewDidFinishLoadBlock = nil;
    _webViewDidFailWithErrorBlock = nil;
    _bridge = nil;
    _responseCallback = nil;
    [self cancel];
    self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.MBFacade unsubscribeNotification:self];
        [self.MBFacade subscribeNotification:self];
//        [self autoBindingKeyPath];
//        [WebViewJavascriptBridge enableLogging];
        
        _responseCallback = nil;
        
        _useCached = NO;
        [self setOpaque:NO];
        
        self.scalesPageToFit = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        
        UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        webViewTapped.numberOfTapsRequired = 1;
        webViewTapped.delegate = self;
        [self addGestureRecognizer:webViewTapped];
        
        _urlRequest = nil;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)firstLoadURLString:(NSString*)urlString {
    
//    [self stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
//    [self stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
//    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    
    _requestUrl = urlString;
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieForURL:[NSURL URLWithString:_requestUrl]];
    
    
    if (_useCached) {
        //NSURLRequestReturnCacheDataElseLoad
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:20];
        [self loadRequest:request];
        _urlRequest = request;
        
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [self loadRequest:request];
        _urlRequest = request;
    }
}

- (void)cancel
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_urlRequest];
    
    _urlRequest = nil;
    
    [self loadHTMLString:@"" baseURL:nil];
    [self loadRequest:nil];
    [self stopLoading];
    self.delegate = nil;
    [self removeFromSuperview];
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    NSDictionary *userInfo = @{@"avatar":[Session sharedInstance].currentUser.avatarUrl?[Session sharedInstance].currentUser.avatarUrl:@"",
                               @"token":[Session sharedInstance].token?[Session sharedInstance].token:@"",
                               @"user_name":[Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"",
                               @"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
    
    if (_responseCallback) {
        _responseCallback(userInfo);
        _responseCallback = nil;
    }
    
}

- (void)$$imagePickerFinishNotification:(id<MBNotification>)noti image:(UIImage *)image
{
    NSDictionary *imageDict = [NSDictionary dictionary];
    if (image != nil) {
        NSData *imgData = UIImageJPEGRepresentation(image, 1);
        NSLog(@"Size of Image(bytes):%d",[imgData length]);

        NSString *imageString = [image encodeToBase64String];
        imageDict = @{@"image":imageString,
                      @"width":[NSNumber numberWithFloat:image.size.width],
                      @"height":[NSNumber numberWithFloat:image.size.height],
                      @"bytes":[NSNumber numberWithInt:[imgData length]]};
    }
    
    if (_responseCallback) {
        _responseCallback(imageDict);
        _responseCallback = nil;
    }
}


#pragma mark -
#pragma mark UIWebViewDelegate Delegate Methods

//- (void)setDelegate:(id<UIWebViewDelegate>)delegate
//{
//    if ([delegate isKindOfClass:[WebViewJavascriptBridge class]]) {
//       super.delegate = delegate;
//    }
//}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]){
        if (_webViewShouldStartLoadWithRequestBlock) {
            return _webViewShouldStartLoadWithRequestBlock(self,request,navigationType);
        }
        return YES;
    } else {
        if ([[self class] isAppURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        }
        if (_webViewShouldStartLoadWithRequestBlock) {
            return _webViewShouldStartLoadWithRequestBlock(self,request,navigationType);
        }
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (_webViewDidStartLoadBlock) {
        _webViewDidStartLoadBlock(self);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
//    // new for memory cleaning
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    // new for memory cleanup
//    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_webViewDidFinishLoadBlock) {
        _webViewDidFinishLoadBlock(self);
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
    //此时可能已经加载完成，则忽略此error，继续进行加载。
    if([error code] == NSURLErrorCancelled)  {
        return;
    }
    if (error.userInfo) {
        NSDictionary *userInfo = error.userInfo;
        NSObject *obj = [userInfo objectForKey:@"NSErrorFailingURLKey"];
        if ([obj isKindOfClass:[NSURL class]]) {
            NSString *requestUrlString = ((NSURL*)obj).absoluteString;
            if ([requestUrlString isEqualToString:_requestUrl]) {
                if (_webViewDidFailWithErrorBlock) {
                    _webViewDidFailWithErrorBlock(self,error);
                }
            }
        }
        else if (obj == nil) {
            if (_webViewDidFailWithErrorBlock) {
                _webViewDidFailWithErrorBlock(self,error);
            }
        }
    }
}

- (UIScrollView*)scrollView {
    if ([[self subviews] count]>0) {
        UIScrollView *scrollView = (UIScrollView *)[[self subviews] objectAtIndex:0];
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
        }
        return scrollView;
    }
    return nil;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self endEditing:YES];
}


//http://blog.sina.com.cn/s/blog_9693f61a01016t4w.html

#pragma mark - 跳转的判断

+ (BOOL)isWebURL:(NSURL*)URL {
    NSString *scheme = URL.scheme;
    if (!URL || !scheme) {
        return NO;
    }
    BOOL isWebURL = [scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
    || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame
    || [scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame
    || [scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame
    || [scheme caseInsensitiveCompare:@"data"] == NSOrderedSame
    || [scheme caseInsensitiveCompare:@"file"] == NSOrderedSame;
    return isWebURL;
}

+ (BOOL)isExternalURL:(NSURL*)URL {
    if ([URL.host isEqualToString:@"maps.google.com"]
        || [URL.host isEqualToString:@"itunes.apple.com"]
        || [URL.host isEqualToString:@"phobos.apple.com"]) {
        return YES;
        
    } else {
        return NO;
    }
}

+ (BOOL)isAppURL:(NSURL*)URL {
    return [self isExternalURL:URL]
    || ([[UIApplication sharedApplication] canOpenURL:URL]
        && ![self isWebURL:URL]);
}

@end

@implementation MyWebView (WebViewAdditions)

- (NSString *)documentTitle {
   	return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end





