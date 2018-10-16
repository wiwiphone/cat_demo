//
//  FenQiLePayViewController.h
//  XianMao
//
//  Created by simon cai on 7/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewController.h"

@interface FenQiLePayViewController : WebViewController

+ (void)presentFenQiLePay:(NSString*)url orderIds:(NSArray*)orderIds;

+ (BOOL)locateWithRedirectUri:(NSString*)redirectUri;

@end
