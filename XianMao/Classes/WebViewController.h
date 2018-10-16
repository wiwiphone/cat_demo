//
//  WebViewController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "MyWebView.h"

@interface WebViewController : BaseViewController

@property(nonatomic,copy) NSString *url;

@property(nonatomic,assign) BOOL isShare;

@property (nonatomic,weak) MyWebView *webView;

@end
