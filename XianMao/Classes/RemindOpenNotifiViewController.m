//
//  RemindOpenNotifiViewController.m
//  XianMao
//
//  Created by simon cai on 11/9/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RemindOpenNotifiViewController.h"
#import "Command.h"
#import "WCAlertView.h"
#import "AppDelegate.h"

@interface RemindOpenNotifiViewController ()

@end

@implementation RemindOpenNotifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"222222"];
    
    CGFloat marginTop = 0;
    
    marginTop = kScreenHeight/6;
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redmind_open_notifi_logo"]];
    logoView.frame = CGRectMake((kScreenWidth-logoView.width)/2, marginTop, logoView.width, logoView.height);
    [self.view addSubview:logoView];
    
    marginTop += logoView.height;
    marginTop += 80;
    
    UIImageView *textView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redmind_open_notifi_text"]];
    textView.frame = CGRectMake((kScreenWidth-textView.width)/2, marginTop, textView.width, textView.height);
    [self.view addSubview:textView];
    
    marginTop += textView.height;
    marginTop += 88;
    
    
    UIImage *img = [UIImage imageNamed:@"redmind_open_notifi_button"];
    CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake((kScreenWidth-img.size.width)/2, marginTop, img.size.width, img.size.height)];
    [btn setImage:img forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    WEAKSELF;
    btn.handleClickBlock = ^(CommandButton *sender) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate registerRemoteNotification];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
            if (&UIApplicationOpenSettingsURLString != NULL) {
                NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:appSettings];
            }
            [weakSelf dismiss];
        } else {
            
            [WCAlertView showAlertWithTitle:@"开启通知" message:@"请在iPhone的“设置”-‘通知’功能中，找到应用程序“爱丁猫”选择开启通知即可。" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                [weakSelf dismiss];
            } cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        }
    };
    
    
    [[self class] saveHasRemindSysNotifi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)hasRemindOpenAdmSysNotifi
{
    NSString *result =  [[NSUserDefaults standardUserDefaults] objectForKey:@"hasRemindOpenAdmSysNotifi"];
    if ([result isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)saveHasRemindSysNotifi {
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hasRemindOpenAdmSysNotifi"];
}

@end
