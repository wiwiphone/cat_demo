//
//  EMSession.m
//  XianMao
//
//  Created by simon on 1/17/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "EMSession.h"
#import "SynthesizeSingleton.h"
//#import "EaseMob.h"
#import "MsgCountManager.h"

#import "NetworkAPI.h"
#import "User.h"

#import "AppDirs.h"

#import "Error.h"
#import "Session.h"

@interface EMSession ()

@end

@implementation EMSession

SYNTHESIZE_SINGLETON_FOR_CLASS(EMSession, sharedInstance);

- (void)initialize
{
    
}

- (BOOL)isLoggedIn
{
    return [[EMClient sharedClient] isLoggedIn];//[[EaseMob sharedInstance].chatManager isLoggedIn];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)())completion
                  failure:(void (^)(XMError *error))failure {
    
    [[EMClient sharedClient] asyncLoginWithUsername:username password:password success:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//        [weakSelf saveLoginInfo:loginInfo];

        //通知显示消息详情
//        [[EMClient sharedClient] setApnsNickname:[Session sharedInstance].currentUser.userName];
        [[EMClient sharedClient] setApnsNickname:username];
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.noDisturbStatus = EMPushNoDisturbStatusClose;
        EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
        NSLog(@"%@", error);
        if (completion) completion();
    } failure:^(EMError *aError) {
        XMError *xmError = nil;
        switch (aError.code) {
            case EMErrorServerNotReachable:
                //TTAlertNoTitle(@"连接服务器失败!");
                xmError = [XMError errorWithCode:EMErrorServerNotReachable errorMsg:@"连接聊天服务器失败!"];
                break;
//            case EMErrorServerAuthenticationFailure:
//                //TTAlertNoTitle(@"用户名或密码错误");
//                xmError = [XMError errorWithCode:EMErrorServerAuthenticationFailure errorMsg:@"聊天服务器用户名或密码错误"];
//                break;
            case EMErrorServerTimeout:
                //TTAlertNoTitle(@"连接服务器超时!");
                xmError = [XMError errorWithCode:EMErrorServerTimeout errorMsg:@"连接聊天服务器超时!"];
                break;
//            case EMErrorServerTooManyOperations:
//                //短时间内多次发起同一操作(Ex. 频繁刷新群组列表, 会返回的error)
//                break;
            default:
                //TTAlertNoTitle(@"登录失败");
                xmError = [XMError errorWithCode:EMErrorServerNotReachable errorMsg:@"登录聊天服务器失败"];
                break;
        }
        if (xmError) {
            if (failure) failure(xmError);
        }
    }];
    
}

- (void)logout
{
//    [[EaseMob sharedInstance].chatManager asyncLogoff];
    [[EMClient sharedClient] logout:YES];
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//        
//    } onQueue:nil];
}

- (void)logout:(void (^)())completion
       failure:(void (^)(XMError *error))failure
{
    
    [[EMClient sharedClient] asyncLogout:YES success:^{
        
    } failure:^(EMError *aError) {
        if (failure)failure([XMError errorWithCode:EMErrorServerNotReachable errorMsg:@"注销聊天服务器失败"]);
    }];
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//        if (info && !error) {
//            if (completion)completion();
//        } else {
//            if (failure)failure([XMError errorWithCode:EMErrorServerNotReachable errorMsg:@"注销聊天服务器失败"]);
//        }
//    } onQueue:nil];
}

- (void)saveLoginInfo:(NSDictionary*)dict
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"loginInfo"];
    [archiver finishEncoding];
    [data writeToFile:[AppDirs emLoginInfoCacheFile] atomically:YES];
}

- (NSDictionary*)loadFromCacheFile
{
    NSString *cacheFile = [AppDirs currentAccountCacheFile];
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:cacheFile isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dict = [unarchiver decodeObjectForKey:@"loginInfo"];
        [unarchiver finishDecoding];
        return dict;
    }
    return nil;
}

- (void)saveToCacheFile:(NSString *)key cacheFile:(NSString*)cacheFile dict:(NSDictionary*)dict
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:key];
    [archiver finishEncoding];
    [data writeToFile:cacheFile atomically:YES];
}


//#pragma mark - push
//- (void)didBindDeviceWithError:(EMError *)error
//{
//    
//}
//
//#pragma mark - IChatManagerDelegate
//// 将要开始自动登录
//- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//    
//}
//
//// 自动登录结束
//- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//    if (!error) {
//        NSLog(@"登录成功");
//        [[MsgCountManager sharedInstance] syncChatMsgCount];
//    }
//}
//
//// 将要开始自动重连
//-(void)willAutoReconnect{
//    
//}
//
//// 自动重连结束
//-(void)didAutoReconnectFinishedWithError:(NSError *)error{
//    if (!error) {
//        NSLog(@"重连成功");
//        [[MsgCountManager sharedInstance] syncChatMsgCount];
//    }
//}
//
//
//// 向sdk中注册回调
//- (void)registerEaseMobDelegate{
//    // 此处先取消一次，是为了保证只将self注册过一次回调。
//    [self unRegisterEaseMobDelegate];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//}
//
//// 取消sdk中注册的回调
//- (void)unRegisterEaseMobDelegate{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//}
//
///*!
// @method
// @brief 会话列表信息更新时的回调
// @discussion 1. 当会话列表有更改时(新添加,删除), 2. 登陆成功时, 以上两种情况都会触发此回调
// @param conversationList 会话列表
// @result
// */
//- (void)didUpdateConversationList:(NSArray *)conversationList
//{
//    
//}
//
///*!
// @method
// @brief 未读消息数改变时的回调
// @discussion 当EMConversation对象的enableUnreadMessagesCountEvent为YES时,会触发此回调
// @result
// */
//- (void)didUnreadMessagesCountChanged
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kEMSessionDidUnreadMessagesCountChanged object:nil];
//}
//
- (NSInteger)unreadChatMsgCount
{
    NSInteger unreadMessagesCount = 0;
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];//[[EaseMob sharedInstance].chatManager conversations];
    for (EMConversation *conv in conversations) {
        if ([conv isKindOfClass:[EMConversation class]]) {
            unreadMessagesCount += conv.unreadMessagesCount;
        }
    }
    return unreadMessagesCount;
}

@end

