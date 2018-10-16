//
//  WebViewController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "WebViewController.h"
#import "MyWebView.h"
#import "URLScheme.h"
#import "NSString+Addtions.h"

#import "NetworkManager.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "IQKeyboardManager.h"

#import "Session.h"
#import "LoginViewController.h"
#import "AppDirs.h"
#import "UIImage+Resize.h"

#import "NSString+URLEncoding.h"

#import "FenQiLePayViewController.h"
#import <cmbkeyboard/CMBWebKeyboard.h>
#import <cmbkeyboard/NSString+Additions.h>

#import "BoughtCollectionViewController.h"
#import "SearchViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface WebViewController () <NJKWebViewProgressDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>


@property (nonatomic,weak) NJKWebViewProgressView *progressView;
@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;

@property (nonatomic, copy) NSString *shareImageUrl;

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@end

@implementation WebViewController {
    CLLocationManager *_locationManager;
    NSString *_currentCity;//当前城市
    NSString *_strlatitude;//经度
    NSString *_strlongitude;//纬度
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpAlert" object:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    _progressProxy.progressDelegate = nil;
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy.progressBlock = nil;
    _progressProxy = nil;
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
    //if ([self.webView isLoading]) {
    // [self.webView stopLoading];
    // self.webView.delegate = nil;
    //}
    
    [_progressView removeFromSuperview];
    _progressView = nil;
    
    //    [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView.bridge = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView loadRequest:nil];
    [_webView stopLoading];
    _webView.delegate = nil;
    //    for (UIView *view in [_webView subviews]) {
    //        [view removeFromSuperview];
    //    }
    [_webView removeFromSuperview];
    _webView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.url = @"http://www.dajie.com/app/phone/download?id=3&f=aidingmao";
    
    [super setupTopBar];
    [super setupTopBarTitle:self.title&&[self.title length]>0?self.title:@""];
    if (self.navigationController.viewControllers.count == 1) {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close.png"] imgPressed:nil];
    } else {
        [super setupTopBarBackButton];
    }
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, super.topBarHeight-progressBarHeight, super.topBar.width, progressBarHeight);
    NJKWebViewProgressView *progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView = progressView;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;
    [super.topBar addSubview:_progressView];
    
    if (_isShare) {
        //        [super setupTopBarRightButton];
        [super setupTopBarRightButton:[UIImage imageNamed:@"Share_New_MF_T"] imgPressed:[UIImage imageNamed:@"Share_New_MF_T"]];
        //        [self.topBarRightButton setTitle:@"分享" forState:UIControlStateNormal];
        //        //        [self.topBarRightButton setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        //        [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"ac7e33"] forState:UIControlStateNormal];
        [self.topBarRightButton setBackgroundColor:[UIColor clearColor ]];
        //        [self.topBarRightButton setImage:[UIImage imageNamed:@"Share_New_MF_T"] forState:UIControlStateNormal];
        
    }
    
    self.topBarRightButton.hidden = YES;
    
    // new for memory cleaning
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    // new for memory cleanup
    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
}

-(void)locatemap{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingUrl];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    //    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    self.latitude = currentLocation.coordinate.latitude;
    self.longitude = currentLocation.coordinate.longitude;
    //    NSLog(@"%f------%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat progressBarHeight = 3.f;
    CGRect barFrame = CGRectMake(0, self.topBar.height, super.topBar.width, progressBarHeight);
    _progressView.frame = barFrame;
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
    //这里在页面出现的时候就会重新加载页面
    //    [self reloadWebView];
}

- (BOOL)needBackItem
{
    return YES;
}

- (void)reloadWebView
{
    
    if ([self.url hasPrefix:@"www."]) {
        [self.webView firstLoadURLString:[NSString stringWithFormat:@"http://%@",self.url]];
    } else {
        [self.webView firstLoadURLString:self.url];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    //[_progressView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF;
    
    CGFloat topBarHeight = 0;;//self.topBarHeight;
    if (!_webView) {
        
        MyWebView *webView = [[MyWebView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
        _webView = webView;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.useCached = NO;
        
        CGFloat contentMarginTop = self.topBarHeight;
        [_webView.scrollView setContentInset:UIEdgeInsetsMake(contentMarginTop, 0.0f, 0.0f, 0.0f)];
        [_webView.scrollView setContentOffset:CGPointMake(0, -contentMarginTop) animated:NO];
        [_webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(contentMarginTop, 0.0f, 0.0f, 0.0f)];
        
        [self.view addSubview:_webView];
        [super bringTopBarToTop];
        
        if (!_progressProxy) {
            NJKWebViewProgress *progressProxy = [[NJKWebViewProgress alloc] init];
            _progressProxy = progressProxy;
        }
        
        typeof(MyWebView*) __weak weakWebView = weakSelf.webView;
        typeof(NJKWebViewProgress*) __weak weakProgressProxy = weakSelf.progressProxy;
        
        weakProgressProxy.progressDelegate = weakSelf;
        
        
        _webView.bridge = [WebViewJavascriptBridge bridgeForWebView:weakWebView
                                                    webViewDelegate:weakWebView
                                                            handler:^(id data, WVJBResponseCallback responseCallback) {}];
        
        
        [_webView.bridge registerHandler:@"back" handler:^(id data, WVJBResponseCallback responseCallback) {
            [weakSelf popoverPresentationController];
        }];
        
        [_webView.bridge registerHandler:@"setCopyText" handler:^(id data, WVJBResponseCallback responseCallback) {
            weakSelf.webView.responseCallback = responseCallback;
            NSDictionary *recievedData = (NSDictionary *)data;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:recievedData[@"copyStr"]];
            
            if (weakSelf.webView.responseCallback) {
                weakSelf.webView.responseCallback(recievedData[@"copyStr"]);
            }
        }];
        
        [_webView.bridge registerHandler:@"pushSearchController" handler:^(id data, WVJBResponseCallback responseCallback) {
            weakSelf.webView.responseCallback = responseCallback;
            NSDictionary *recievedData = (NSDictionary *)data;
            NSInteger sellerId = [recievedData integerValueForKey:@"sellerId"];
            
            SearchViewController *searchController = [[SearchViewController alloc] init];
            searchController.sellerId = sellerId;
            [[CoordinatingController sharedInstance] pushViewController:searchController animated:YES];
            
            //            if (weakSelf.webView.responseCallback) {
            //                weakSelf.webView.responseCallback(recievedData[@"copyStr"]);
            //            }
        }];
        
        [_webView.bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
            weakSelf.webView.responseCallback = responseCallback;
            if ([Session sharedInstance].isLoggedIn) {
                
                //寄卖聊天VC
                NSDictionary *userInfo = @{@"avatar":[Session sharedInstance].currentUser.avatarUrl?[Session sharedInstance].currentUser.avatarUrl:@"",
                                           @"token":[Session sharedInstance].token?[Session sharedInstance].token:@"",
                                           @"user_name":[Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"",
                                           @"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]};
                if (weakSelf.webView.responseCallback) {
                    weakSelf.webView.responseCallback(userInfo);
                }
                
            } else {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                //                CheckPhoneViewController *loginVC = [[CheckPhoneViewController alloc] init];
                UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:loginVC];
                [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
                    
                }];
            }
            
        }];
        
        [_webView.bridge registerHandler:@"selectPicture" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            weakSelf.webView.responseCallback = responseCallback;
            NSDictionary *recievedData = (NSDictionary *)data;
            weakSelf.imageHeight = [recievedData integerValueForKey:@"height"];
            weakSelf.imageWidth = [recievedData integerValueForKey:@"width"];
            [[CoordinatingController sharedInstance] startCameraControllerEdit:NO deletegate:weakSelf];
        }];
        
        //        [_webView.bridge registerHandler:@"hideShareButton" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        //            weakSelf.webView.responseCallback = responseCallback;
        //            NSDictionary *recievedData = (NSDictionary *)data;
        //            weakSelf.isShare = [recievedData boolValueForKey:@"hide"];
        //
        //        }];
        
        //获取经纬度
        [_webView.bridge registerHandler:@"getSpot" handler:^(id data, WVJBResponseCallback responseCallback) {
            [self locatemap];
            weakSelf.webView.responseCallback = responseCallback;
            NSDictionary *dict = @{@"latitude":@(self.latitude),@"longitude":@(self.longitude)};
            if (weakSelf.webView.responseCallback) {
                weakSelf.webView.responseCallback(dict);
            }
        }];
        
        [_webView.bridge registerHandler:@"finishWebSession" handler:^(id data, WVJBResponseCallback responseCallback) {
            weakSelf.webView.responseCallback = responseCallback;
            [weakSelf dismiss];
        }];
        
        [_webView.bridge registerHandler:@"startWebInstance" handler:^(id data, WVJBResponseCallback responseCallback) {
            weakSelf.webView.responseCallback = responseCallback;
            WebViewController *newWebView = [[WebViewController alloc] init];
            NSDictionary *recievedData = (NSDictionary *)data;
            NSString *url = [recievedData objectForKey:@"url"];
            newWebView.url = url;
            [weakSelf pushViewController:newWebView animated:YES];
        }];
        
        [_webView.bridge registerHandler:@"shareNative" handler:^(id data, WVJBResponseCallback responseCallback) {
            weakSelf.webView.responseCallback = responseCallback;
            NSDictionary *shareData = (NSDictionary *)data;
            NSString *title = [shareData stringValueForKey:@"title"];
            NSString *iconImageName = [shareData stringValueForKey:@"web_Url"];
            NSString *url = [shareData stringValueForKey:@"picture_Url"];
            NSString *content = [shareData stringValueForKey:@"content"];
            [[CoordinatingController sharedInstance] shareWithTitle:title
                                                              image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconImageName]]]
                                                                url:url
                                                            content:content];
        }];
        if ([weakSelf.url hasPrefix:@"www."]) {
            [weakSelf.webView firstLoadURLString:[NSString stringWithFormat:@"http://%@",weakSelf.url]];
        } else {
            [weakSelf.webView firstLoadURLString:weakSelf.url];
        }
        LoadingView *view = [weakSelf showLoadingView];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        
        _webView.webViewShouldStartLoadWithRequestBlock = ^(MyWebView *webView, NSURLRequest *request,UIWebViewNavigationType navigationType) {
            
            if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]) {//此处开始调用键盘
                CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
                [secKeyboard showKeyboardWithRequest:request];
                secKeyboard.webView = _webView;
                //以下是实现点击键盘外地方，自动隐藏键盘
                UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                [self.view addGestureRecognizer:myTap]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
                myTap.delegate = self;
                myTap.cancelsTouchesInView = NO;
                
                return NO;
            } else if ([request.URL.description isEqualToString:@"http://activity.aidingmao.com/share/page/869"]) {
                
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    //                    MainViewController *mainViewControlelr = [[MainViewController alloc] init];
                    //                    [UIApplication sharedApplication].keyWindow.rootViewController = mainViewControlelr;
                    //                    [mainViewControlelr setSelectedAtIndex:0];
                    UIViewController *currentVC = [CoordinatingController sharedInstance].visibleController;
                    if ([currentVC isKindOfClass:[BoughtCollectionViewController class]]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpAlert" object:nil];
                    } else {
                        BoughtCollectionViewController *bought = [[BoughtCollectionViewController alloc] init];
                        [[CoordinatingController sharedInstance] pushViewController:bought animated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpAlert" object:nil];
                    }
                }];
                return NO;
            } else {
                [weakSelf.progressProxy webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
                if (navigationType == UIWebViewNavigationTypeLinkClicked && ![weakSelf.url isEqualToString:request.URL.absoluteString]) {
                    BOOL handled = [URLScheme locateWithRedirectUri:request.URL.absoluteString andIsShare:NO];
                    
                    return NO;
                }
                return YES;
            }
        };
        _webView.webViewDidStartLoadBlock = ^(MyWebView *webView) {
            [weakSelf.progressProxy webViewDidStartLoad:webView];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        };
        _webView.webViewDidFinishLoadBlock = ^(MyWebView *webView) {
            [weakSelf.progressProxy webViewDidFinishLoad:webView];
            
            if (weakSelf.isShare) {
                weakSelf.topBarRightButton.hidden = NO;
            }
            
            // 提前缓存分享图片
            NSString *shareImageUrl = [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_image')[0].getAttribute('content')"];
            weakSelf.shareImageUrl = shareImageUrl;
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:shareImageUrl]
                                                            options:SDWebImageCacheMemoryOnly
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               
                                                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                               NSLog(@"%@",[imageURL absoluteString]);
                                                           }];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakSelf hideLoadingView];
            [weakSelf setupTopBarTitle:weakSelf.title&&[weakSelf.title length]>0?weakSelf.title:[weakSelf.webView documentTitle]];
        };
        _webView.webViewDidFailWithErrorBlock = ^(MyWebView *webView,NSError *error) {
            
            NSLog(@"Load webView error:%@", [error localizedDescription]);
            
            //一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
            //此时可能已经加载完成，则忽略此error，继续进行加载。
            if([error code] == NSURLErrorCancelled)  {
                return;
            }
            
            [weakSelf.progressProxy webView:webView didFailLoadWithError:error];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [weakSelf hideLoadingView];
            
            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf.webView firstLoadURLString:weakSelf.url];
            };
            
            [weakSelf showHUD:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
            
            //            if (error.userInfo) {
            //                NSDictionary *userInfo = error.userInfo;
            //                NSObject *obj = [userInfo objectForKey:@"NSErrorFailingURLKey"];
            //                if ([obj isKindOfClass:[NSURL class]]) {
            //                    NSString *requestUrlString = ((NSURL*)obj).absoluteString;
            //                    if ([requestUrlString isEqualToString:webView.request.URL.absoluteString]) {
            //
            //                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            //
            //                        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
            //                            [weakSelf.webView firstLoadURLString:weakSelf.url];
            //                        };
            //
            //                        [weakSelf showHUD:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
            //                    }
            //
            //                }
            //            }
        };
    }
}



-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint gesturePoint = [sender locationInView:self.view];
    NSLog(@"handleSingleTap!gesturePoint:%f,y:%f",gesturePoint.x,gesturePoint.y);
    //[_secKeyboard hideKeyboard];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
    //    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    //    NSLog(@"Size of Image(bytes):%ld",[imgData length]);
    
    if (image) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *newImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(_imageWidth, _imageHeight)  interpolationQuality:kCGInterpolationMedium];
            MBGlobalSendImagePickerFinishNotification(newImage);
        });
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    
    NSString *shareContent = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_content')[0].getAttribute('content')"];
    NSString *shareTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_title')[0].getAttribute('content')"];
    NSString *shareImageUrl = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_image')[0].getAttribute('content')"];
    NSString *shareLink = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_link')[0].getAttribute('content')"];
    
    UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                           [SDWebImageManager lw_cacheKeyForURL:[NSURL URLWithString:shareImageUrl ]]];
    
    if (shareImage == nil) {
        shareImage = [UIImage imageNamed:@"AppIcon_120"];
        NSLog(@"111");
    }
    NSString *shareUrl = [_webView.request.URL.absoluteString mag_isEmpty] ? self.url : _webView.request.URL.absoluteString;
    
    /*****************************************修改之前分享图片方式，之前方式第二次分享会没有图片*******************/
    UIImage *shareImage_MF = [[UIImage alloc] init];
    if (self.shareImageUrl) {
        shareImage_MF = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImageUrl]]];
    } else {
        shareImage_MF = [UIImage imageNamed:@"AppIcon_120"];
    }
    
    
    [[CoordinatingController sharedInstance] shareWithTitle:[shareTitle mag_isEmpty] ? @"来自爱丁猫的分享" : shareTitle
                                                      image:shareImage_MF//shareImage
                                                        url:shareLink.length > 0 ? shareLink : shareUrl
                                                    content:shareContent];
    
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        if (self.isViewLoaded && !self.view.window) {
            
            _progressProxy.progressDelegate = nil;
            _progressProxy.webViewProxyDelegate = nil;
            _progressProxy = nil;
            
            [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
            [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
            [_webView loadHTMLString:@"" baseURL:nil];
            [_webView stopLoading];
            _webView.delegate = nil;
            for (UIView *view in [_webView subviews]) {
                [view removeFromSuperview];
            }
            [_webView removeFromSuperview];
            _webView = nil;
            
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            [super hideLoadingView];
            
            [self.progressView removeFromSuperview];
            _progressView = nil;
            
            self.view = nil;
        }
    }
    
    [super didReceiveMemoryWarning];
}

@end


