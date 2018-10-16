//
//  FenQiLePayViewController.m
//  XianMao
//
//  Created by simon cai on 7/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "FenQiLePayViewController.h"
#import "WCAlertView.h"
#import "URLScheme.h"
#import "PayManager.h"
#import "WebViewJavascriptBridge.h"

@interface FenQiLePayViewController ()
@property(nonatomic,strong) NSArray *orderIds;
@end

@implementation FenQiLePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//switch (resp.errCode) {
//    case WXSuccess:
//        // strMsg = @"支付结果：成功！";
//        NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//        SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
//        MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
//        break;
//    case WXErrCodeUserCancel:
//        NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//        selector = @selector($$handlePayResultCancelNotification:orderIds:);
//        MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
//        break;
//    default:
//        NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//        selector = @selector($$handlePayResultFailureNotification:orderIds:);
//        MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
//        break;
//}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender {
    WEAKSELF;
    [WCAlertView showAlertWithTitle:@""
                            message:@"是否放弃付款?"
                 customizationBlock:^(WCAlertView *alertView) {
                     alertView.style = WCAlertViewStyleWhite;
                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 0) {
                         
                     } else {
                         [weakSelf dismiss];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             SEL selector = @selector($$handlePayResultCancelNotification:orderIds:);
                             MBGlobalSendNotificationForSELWithBody(selector, self.orderIds);
                         });
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)$$handlePayResultCompletionNotificationFenQiPay:(id<MBNotification>)notifi {
    WEAKSELF;
    void(^notifiBlock)() = ^(){
        SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
        MBGlobalSendNotificationForSELWithBody(selector, weakSelf.orderIds);
    };
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                notifiBlock();
            }];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
            notifiBlock();
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            notifiBlock();
        }];
    }
}

- (void)$$handlePayResultFailureNotificationFenQiPay:(id<MBNotification>)notifi {
    WEAKSELF;
    void(^notifiBlock)() = ^(){
        SEL selector = @selector($$handlePayResultFailureNotification:orderIds:);
        MBGlobalSendNotificationForSELWithBody(selector, weakSelf.orderIds);
    };
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                notifiBlock();
            }];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
            notifiBlock();
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            notifiBlock();
        }];
    }
}

+ (void)presentFenQiLePay:(NSString*)url orderIds:(NSArray*)orderIds {
    FenQiLePayViewController *presenedViewController = [[FenQiLePayViewController alloc] init];
    presenedViewController.url = url;
    presenedViewController.orderIds = orderIds;
    UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
    UIViewController *visibleController = [CoordinatingController sharedInstance].visibleController;
    [visibleController presentViewController:navController animated:YES completion:nil];
}

+ (BOOL)locateWithRedirectUri:(NSString*)redirectUri {
    NSLog(@"%@", @"locateWithRedirectUri:(NSString*)redirectUri");
    BOOL handled = NO;
    if ([redirectUri hasPrefix:kURLSchemeAidingmao]) {
        NSURL *url = [NSURL URLWithString:redirectUri];
        NSString *query = url.query;
        NSString *locatorUrl = [NSString stringWithFormat:@"%@://%@%@",url.scheme,url.host,url.path];
        if ([locatorUrl isEqualToString:@"aidingmao://fqlpay/"]) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            NSInteger result = [[params objectForKey:@"result"] integerValue];
            if (result==0) {
                SEL selector = @selector($$handlePayResultFailureNotificationFenQiPay:);
                MBGlobalSendNotificationForSEL(selector);
            } else {
                SEL selector = @selector($$handlePayResultCompletionNotificationFenQiPay:);
                MBGlobalSendNotificationForSEL(selector);
            }
            return YES;
        }
    }
    return handled;
}

@end

//aidingmao://fqlpay/?result=1 或者 0


