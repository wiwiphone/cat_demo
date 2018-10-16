//
//  MsgCountManager.m
//  XianMao
//
//  Created by simon on 1/28/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "MsgCountManager.h"
#import "SynthesizeSingleton.h"
#import "Session.h"
#import "EMSession.h"

#import "NetworkAPI.h"
#import "User.h"
#import "AppDirs.h"

#import "NSDate+Category.h"

@interface MsgCountManager () <AuthorizeChangedReceiver>

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,readwrite) NSInteger noticeCount;
@property(nonatomic,readwrite) NSInteger chatMsgCount;

@end

@implementation MsgCountManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)initialize
{
    [[MBGlobalFacade instance] unsubscribeNotification:self];
    [[MBGlobalFacade instance] subscribeNotification:self];
    
    _noticeCount = 0;
    _chatMsgCount = [EMSession sharedInstance].unreadChatMsgCount;
    [self loadFromCacheFile];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUnreadMessagesCountChanged:) name:kEMSessionDidUnreadMessagesCountChanged object:nil];
    
    if ([Session sharedInstance].isLoggedIn) {
        [[MsgCountManager sharedInstance] restartMsgCountTimer];
        [[MsgCountManager sharedInstance] syncChatMsgCount];
//        [[CoordinatingController sharedInstance].mainViewController restMsgButtonCount:[MsgCountManager sharedInstance].noticeCount+[EMSession sharedInstance].unreadChatMsgCount];
    }
}

- (void)didEnterBackgroundNotification:(NSNotification *)notifi
{
    [self stopMsgCountTimer];
}

- (void)didBecomeActiveNotification:(NSNotification *)notifi
{
    [self syncChatMsgCount];
    if ([Session sharedInstance].isLoggedIn) {
        [self restartMsgCountTimer];
    }
}

- (void)didUnreadMessagesCountChanged:(NSNotification *)notifi
{
    NSInteger chatMsgCount = [EMSession sharedInstance].unreadChatMsgCount;
    if (chatMsgCount != _chatMsgCount) {
        _chatMsgCount = chatMsgCount;
        if (_chatMsgCount<0) {
            _chatMsgCount = 0;
        }
        SEL selector = @selector($$handleChatMsgCountDidFinishNotification:chatMsgCount:);
        MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:_chatMsgCount]);
    }
}

// add code
- (void)clearNotice:(NSInteger)number
{
    if (_noticeCount!=0)
    {
        WEAKSELF;
        double delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            weakSelf.noticeCount = (weakSelf.noticeCount - number) > 0 ? (weakSelf.noticeCount - number) : 0;
            [self saveToCacheFile];
            SEL selector = @selector($$handleNoticeCountDidFinishNotification:noticeCount:);
            MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:number]);
        });
    }
}

- (void)clearNoticeCount
{
    if (_noticeCount!=0)
    {
        WEAKSELF;
        double delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            weakSelf.noticeCount = 0;
            [self saveToCacheFile];
            SEL selector = @selector($$handleNoticeCountDidFinishNotification:noticeCount:);
            MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:weakSelf.noticeCount]);
        });
    }
}

- (void)resetChatMsgCount:(NSInteger)count
{
    _chatMsgCount = count;
    if (_chatMsgCount<0) {
        _chatMsgCount = 0;
    }
}

- (void)removeChatMsgCount:(NSInteger)count
{
    _chatMsgCount -= count;
    if (_chatMsgCount<0) {
        _chatMsgCount = 0;
    }
    WEAKSELF;
    double delayInSeconds = 1.f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.chatMsgCount = 0;
        [weakSelf saveToCacheFile];
        SEL selector = @selector($$handleChatMsgCountDidFinishNotification:chatMsgCount:);
        MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:weakSelf.chatMsgCount]);
    });
}

- (void)clearChatMsgCount
{
    
}

///
- (void)restartMsgCountTimer
{
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.timer invalidate];
        //修改调用时间  2016.3.15 Feng   2016.3.31 Feng
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(onMsgCountTimer:) userInfo:nil repeats:YES];
    });
}

- (void)stopMsgCountTimer {
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
    });
}

- (void)onMsgCountTimer:(NSTimer*)theTimer
{
    [self syncMsgCount];
    [self syncNoticeCount];
}

- (void)syncChatMsgCount {
    NSInteger chatMsgCount = [EMSession sharedInstance].unreadChatMsgCount;
    if (chatMsgCount != _chatMsgCount) {
        _chatMsgCount = chatMsgCount;
        if (_chatMsgCount<0) {
            _chatMsgCount = 0;
        }
        SEL selector = @selector($$handleChatMsgCountDidFinishNotification:chatMsgCount:);
        MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:_chatMsgCount]);
    }
}
//16.4.12 add by adu
- (void)syncNoticeCount {
    WEAKSELF;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    _request = [[NetworkAPI sharedInstance] getNoticeCount:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _noticeCount = [data integerValueForKey:@"get_notice_count" defaultValue:0];
            
            [weakSelf saveToCacheFile];
            SEL selector = @selector($$handleNoticeCountDidFinishNotification:noticeCount:);
            MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:_noticeCount]);
            
            [weakSelf checkRemoteType];
        });
    } failure:^(XMError *error) {
        
    } queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)syncMsgCount {
    WEAKSELF;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _request = [[NetworkAPI sharedInstance] getMsgCount:^(NSDictionary *data) {
        NSDictionary *dict = [data dictionaryValueForKey:@"msg_count"];
        MsgCount *msgCount = [MsgCount createWithDict:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Session sharedInstance] setUserCount:msgCount];
            if (msgCount.newNoticeCount>=0) {
//                _noticeCount += msgCount.newNoticeCount;
                //add code
//                NSLog(@"msgCount.newNoticeCount:%ld", msgCount.newNoticeCount);
//                _noticeCount = msgCount.newNoticeCount;

                [weakSelf saveToCacheFile];
//                SEL selector = @selector($$handleNoticeCountDidFinishNotification:noticeCount:);
//                MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:_noticeCount]);
                
               [weakSelf checkRemoteType];
            }
        });
    } failure:^(XMError *error) {
        
    } queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)handleReachabilityChanged:(NSNotification*)notifi
{
    if ([[NetworkManager sharedInstance] isReachable])  {
        
    } else {
        [self stopMsgCountTimer];
    }
}

- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    [self loadFromCacheFile];
    [self syncMsgCount];
    [self restartMsgCountTimer];
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self loadFromCacheFile];
    [self syncMsgCount];
    [self restartMsgCountTimer];
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    [self stopMsgCountTimer];
    
    _noticeCount = 0;
    _chatMsgCount = 0;
    
    SEL selector = @selector($$handleChatMsgCountDidFinishNotification:chatMsgCount:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:_chatMsgCount]);
    
    selector = @selector($$handleNoticeCountDidFinishNotification:noticeCount:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:_noticeCount]);
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    [self $$handleLogoutDidFinishNotification:nil];
}

- (void)saveToCacheFile {
    NSString *cacheFile = [AppDirs noticeListCacheFile];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:_noticeCount] forKey:@"noticeCount"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"notice"];
    [archiver finishEncoding];
    [data writeToFile:cacheFile atomically:YES];
}

- (void)loadFromCacheFile {
    NSString *cacheFile = [AppDirs noticeListCacheFile];
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:cacheFile isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dict = [unarchiver decodeObjectForKey:@"notice"];
        [unarchiver finishDecoding];
        _noticeCount = [dict integerValueForKey:@"noticeCount" defaultValue:0];
    }
}

- (void)checkRemoteType
{
    BOOL isNeedCheck = NO;
    NSNumber *checkRemoteTypeTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"checkRemoteTypeTime"];
    if (checkRemoteTypeTime) {
        if ([[NSDate date] timeIntervalSince1970InMilliSecond]-[checkRemoteTypeTime longLongValue]>7*24*60*60*1000) {
            isNeedCheck = YES;
        }
    } else {
        isNeedCheck = YES;
    }
    
    if (isNeedCheck) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970InMilliSecond]] forKey:@"checkRemoteTypeTime"];
        
        BOOL isEnabledRemoteNotifi = YES;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            isEnabledRemoteNotifi = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        } else {
            UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            if (types == UIRemoteNotificationTypeNone) {
                isEnabledRemoteNotifi = NO;
            }
        }
        
        if (!isEnabledRemoteNotifi) {
            //#if !TARGET_IPHONE_SIMULATOR
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
            NSString *bundleName = [dict objectForKey:@"CFBundleDisplayName"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"你现在无法收到新消息通知。请到系统\"设置\"-\"通知\"-\"%@\"中开启", bundleName]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            //#endif
        }
    }
}

@end

