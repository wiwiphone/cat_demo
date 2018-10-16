//
//  ClientVersionService.m
//  XianMao
//
//  Created by darren on 15/1/31.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "ClientVersionService.h"
#import "NetworkAPI.h"
#import "Version.h"
#import "MBProgressHUD.h"

@interface ClientVersionService()

@property(nonatomic,strong) HTTPRequest *requset;

@property (nonatomic, strong) NSString *appUrl;
@property(nonatomic,copy) void(^completionBlock)();

@end

@implementation ClientVersionService

- (id)init
{
    if (self = [super init]) {
        _alertView.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    _alertView = nil;
    _completionBlock = nil;
}

#ifdef XIANMAOPRO

- (void)checkVersionWithCompletionHandler:(void (^)())completion
{
    _completionBlock = completion;
//    WEAKSELF;
//    _appUrl = APPSTORE_URL;
//    _requset = [[NetworkAPI sharedInstance] checkUpdate:APP_VERSION
//                                             completion:^(NSDictionary *versionInfo) {
//                                                 
//                                                 NSInteger updateType = [[versionInfo objectForKey:@"update_type"] integerValue];
//                                                 weakSelf.appUrl = APP_ITUNES_URL;//[versionInfo stringValueForKey:@"downurl"];
//                                                 if (updateType == 1) {
//                                                     weakSelf.alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
//                                                                                                     message:@"有最新版本"
//                                                                                                    delegate:self
//                                                                                           cancelButtonTitle:@"稍后再说"
//                                                                                           otherButtonTitles:@"立即更新", nil];
//                                                     weakSelf.alertView.tag = 0;
//                                                     
//                                                     [weakSelf.alertView show];
//                                                 } else if (updateType == 2) {
//                                                     weakSelf.alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
//                                                                                                     message:@"请升级到最新版本"
//                                                                                                    delegate:self
//                                                                                           cancelButtonTitle:nil
//                                                                                           otherButtonTitles:@"立即更新", nil];
//                                                     weakSelf.alertView.tag = 1;
//                                                     
//                                                     [weakSelf.alertView show];
//                                                 } else {
//                                                     if (weakSelf.original == 1) {
//                                                         [[CoordinatingController sharedInstance] showHUD:@"当前版本已是最新版本" hideAfterDelay:2.0];
//                                                     }
//                                                     
//                                                     if (weakSelf.completionBlock) {
//                                                         weakSelf.completionBlock();
//                                                     }
//                                                 }
//                                             } failure:^(XMError *error) {
//                                                 if (weakSelf.completionBlock) {
//                                                     weakSelf.completionBlock();
//                                                 }
//                                             }];
    
}

#else

- (void)checkVersionWithCompletionHandler:(void (^)())completion
{
    _completionBlock = completion;
    WEAKSELF;
    _appUrl = APPSTORE_URL;
    _requset = [[NetworkAPI sharedInstance] checkUpdate:APP_VERSION
                                             completion:^(NSDictionary *versionInfo) {
                                                 
                                                 NSInteger updateType = [[versionInfo objectForKey:@"update_type"] integerValue];
                                                 weakSelf.appUrl = APP_ITUNES_URL;//[versionInfo stringValueForKey:@"downurl"];
                                                 if (updateType == 1) {
                                                     weakSelf.alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                                                     message:@"有最新版本"
                                                                                                    delegate:self
                                                                                           cancelButtonTitle:@"稍后再说"
                                                                                           otherButtonTitles:@"立即更新", nil];
                                                     weakSelf.alertView.tag = 0;
                                                     
                                                     [weakSelf.alertView show];
                                                 } else if (updateType == 2) {
                                                     weakSelf.alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                                                     message:@"请升级到最新版本"
                                                                                                    delegate:self
                                                                                           cancelButtonTitle:nil
                                                                                           otherButtonTitles:@"立即更新", nil];
                                                     weakSelf.alertView.tag = 1;
                                                     
                                                     [weakSelf.alertView show];
                                                 } else {
                                                     if (weakSelf.original == 1) {
                                                         [[CoordinatingController sharedInstance] showHUD:@"当前版本已是最新版本" hideAfterDelay:2.0];
                                                     }
                                                     
                                                     if (weakSelf.completionBlock) {
                                                         weakSelf.completionBlock();
                                                     }
                                                 }
                                             } failure:^(XMError *error) {
                                                 if (weakSelf.completionBlock) {
                                                     weakSelf.completionBlock();
                                                 }
                                             }];
    
}

#endif

#pragma mark - 更新提示



#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([_appUrl length]>0) {
        if (alertView.tag == 0) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appUrl]];
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appUrl]];
        }
    }
    
    if (self.completionBlock) {
        self.completionBlock();
    }
}

@end

