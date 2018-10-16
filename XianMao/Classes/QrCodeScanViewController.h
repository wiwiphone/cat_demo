//
//  QrCodeScanViewController.h
//  XianMao
//
//  Created by darren on 15/2/4.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@class QrCodeScanViewController;
@protocol QrCodeScanViewControllerDelegate <NSObject>
@optional
- (void)processScanResults:(QrCodeScanViewController*)viewController url:(NSString*)url;
- (void)processScanResults:(QrCodeScanViewController*)viewController data:(NSString*)data;
@end

@interface QrCodeScanViewController : BaseViewController
@property(nonatomic,assign) id<QrCodeScanViewControllerDelegate> delegate;
@end
