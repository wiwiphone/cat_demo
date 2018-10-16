//
//  AppDelegate+EaseMob.m
//  XianMao
//
//  Created by darren on 6/27/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "Constants.h"
#import "EMCDDeviceManager.h"
#import "MsgCountManager.h"
#import "ChatService.h"
#import "Session.h"
#import "NetworkAPI.h"
#import "EMSession.h"
#import "EaseSDKHelper.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";

@interface AppDelegate ()<EMChatManagerDelegate, EMClientDelegate>

@end

@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (launchOptions) {
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        
        if(userInfo)
        {
            [self didReceiveRemoteNotification:userInfo];
        } 
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
//    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMobAppKey
//                                   apnsCertName:EaseMobApnsCerName
//                                    otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
    options.apnsCertName = EaseMobApnsCerName;
    //通知显示消息详情-推送设置
    [EMClient sharedClient].pushOptions.displayStyle = EMPushDisplayStyleSimpleBanner;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound |
//        UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//    else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
    
    [[MsgCountManager sharedInstance] syncChatMsgCount];
    [self reLoginToEaseMob];
    
    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
//    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 注册环信监听
    [self registerEaseMobNotification];
//    [[EaseMob sharedInstance] application:application
//            didFinishLaunchingWithOptions:launchOptions];
    
    [self setupNotifiersEMob];
    [[MsgCountManager sharedInstance] initialize];
}

-(void)dealloc{
    [[EMClient sharedClient] removeDelegate:self];
}

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiersEMob{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers

- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
//    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
//    [[EMClient sharedClient] applicationProtectedDataDidBecomeAvailable:notif.object];
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EMClient sharedClient] logout:NO];
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 100;
//        [alertView show];
        
//    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EMClient sharedClient] logout:NO];
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 101;
//        [alertView show];
//    } onQueue:nil];
}

// 开始自动登录回调
//-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
//{
//    if (error) {
//        //发送自动登陆状态通知
//    }
//    else{
//        
//        //将旧版的coredata数据导入新的数据库
//        EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
//        if (!error) {
//            error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
//            
//            EMPushNotificationOptions *options = [[EMPushNotificationOptions alloc] init];
//            options.displayStyle = ePushNotificationDisplayStyle_simpleBanner;
////            options.noDisturbStatus = ePushNotificationNoDisturbStatusClose;
//            [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
//            
//        }
//        
//    }
//}

// 结束自动登录回调

-(void)didAutoLoginWithError:(EMError *)aError{
    if (aError) {
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } else {
        NSLog(@"环信自动登录成功");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL flag = [[EMClient sharedClient] dataMigrationTo3];
            if (flag) {
                [self asyncGroupFromServer];
                [self asyncConversationFromDB];
            }
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [MBProgressHUD hideAllHUDsForView:view animated:YES];
            //            });
        });
    }
}

//-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
//{
//
//    
//}



- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];//[[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    if (ret) {
        
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        
        do {
            if (options.noDisturbStatus) {
                NSDate *now = [NSDate date];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                                               fromDate:now];
                
                NSInteger hour = [components hour];
                NSUInteger startH = options.noDisturbingStartH;
                NSUInteger endH = options.noDisturbingEndH;
                if (startH>endH) {
                    endH += 24;
                }
                
                if (hour>=startH && hour<=endH) {
                    ret = NO;
                    break;
                }
            }
        } while (0);
    }
    
    return ret;
}

//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BOOL isAutoLogin = [[EMClient sharedClient] isAutoLogin];//[[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];

    BOOL loginSuccess = [notification.object boolValue];
    
    if ((isAutoLogin && [[EMClient sharedClient] isLoggedIn]) || loginSuccess) {//登陆成功//[[[EaseMob sharedInstance] chatManager] isLoggedIn]
        NSLog(@"登录环信成功");
        
        
    }else{//登陆失败重新登录
        [self reLoginToEaseMob];
    }
}


#pragma mark - EMChatManagerChatDelegate

- (void)didUnreadMessagesCountChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMSessionDidUnreadMessagesCountChanged object:nil];
}

// 收到消息回调
-(void)didReceiveMessages:(NSArray *)aMessages{
    for (EMMessage *message in aMessages) {
        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self needShowNotification:message.conversationId] : YES;
        if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
            
            BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
            if (!isAppActivity) {
                [self showNotificationWithMessage:message];
            }else {
                [self playSoundAndVibration];
            }
#endif
        }
        
        NSInteger fromUserId = [message.ext integerValueForKey:@"fromUserId" defaultValue:0];
        if (fromUserId > 0) {
//            [ChatService chatNotice:fromUserId isAdd:NO];
        }
    }
}

//-(void)didReceiveMessage:(EMMessage *)message
//{
//    
//}

//离线消息
-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages{

}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = [message.ext objectForKey:@"fromNickname"];//message.from;
        if (message.chatType != EMChatTypeChat) {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];//[[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationId]) {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                    title = [NSString stringWithFormat:@"%@(%@)", [message.ext objectForKey:@"fromNickname"], group.subject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"你有一条聊天消息", @"you have a new message");
    }
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    [userInfo setObject:@(EMMessageType) forKey:kNotificationType];
    notification.userInfo = userInfo;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
}

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSLog(@"%@",str);
    
}

- (void)asyncGroupFromServer
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager loadAllMyGroupsFromDB];
        EMError *error = nil;
        [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
//        if (!error) {
//            if (weakself.contactViewVC) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakself.contactViewVC reloadGroupView];
//                });
//            }
//        }
    });
}

- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:NO];
            }
        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakself.conversationListVC) {
//                [weakself.conversationListVC refreshDataSource];
//            }
//            
//            if (weakself.mainVC) {
//                [weakself.mainVC setupUnreadMessageCount];
//            }
//        });
    });
}

@end
