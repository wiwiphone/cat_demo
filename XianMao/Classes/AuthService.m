//
//  AuthService.m
//  XianMao
//
//  Created by simon cai on 17/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "AuthService.h"
#import "Session.h"
#import "NSString+URLEncoding.h"
#import "NSString+AES.h"
#import "NSData+AES.h"
#import "User.h"

#define KEY_VALUE @"AbcdEfgHijkLmnOp"

@implementation AuthService


+ (void)validatePassword:(NSString*)password
              completion:(void (^)())completion
                 failure:(void (^)(XMError *error))failure
{
    if ([password length]>0) {
        NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
        NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"password":encryPwd};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"validate_password" parameters:parameters completionBlock:^(NSDictionary *data) {
            if (completion)completion();
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil]];
    }
}

//auth/check_phone[POST] ｛is_exist是否（1，0）存在｝

+ (void)checkPhone:(NSString*)phoneNumber
        completion:(void (^)(BOOL isExist))completion
           failure:(void (^)(XMError *error))failure {
    if ([phoneNumber length]>0) {

        NSDictionary *parameters = @{@"phone":phoneNumber};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"check_phone" parameters:parameters completionBlock:^(NSDictionary *data) {
            BOOL isExist = [data integerValueForKey:@"is_exist" defaultValue:0]>0?YES:NO;
            if (completion)completion(isExist);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil]];
    }
    
}


//{
//    "platform":"wx", (加密)
//    "uid":"123123112", (加密)
//    "username":"adsf",
//    "icon_url":"wwww.baidu.com",
//    "signature": （值为[platform（原值）+uid（原值）]加密）
//}

+ (void)bind_third:(ThirdPartyAccountInfo*)accountInfo
              type:(NSNumber *)type
               completion:(void (^)(NSDictionary *data))completion
                  failure:(void (^)(XMError *error))failure {
    
    NSString *signature = @"";
    if (type.integerValue == 0) {
        signature = [[NSString stringWithFormat:@"%@%@", accountInfo.platform?accountInfo.platform:@"",accountInfo.uid?accountInfo.uid:@""] AES128EncryptWithKey:KEY_VALUE];
    } else if (type.integerValue == 1) {
        signature = @"";
    }
    NSDictionary *parameters = @{@"platform":accountInfo.platform?[accountInfo.platform AES128EncryptWithKey:KEY_VALUE]:@"",
                                 @"uid":accountInfo.uid?[accountInfo.uid AES128EncryptWithKey:KEY_VALUE]:@"",
                                 @"username":accountInfo.username?accountInfo.username:@"",
                                 @"icon_url":accountInfo.icon_url?accountInfo.icon_url:@"",
                                 @"signature":signature,
                                 @"xuid":accountInfo.xuid?[accountInfo.xuid AES128EncryptWithKey:KEY_VALUE]:@"",
                                 @"userId":@([Session sharedInstance].currentUserId),
                                 @"type":type};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"bind_unbind_third" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)authUnbindthird:(NSString *)platform
           unbindUserId:(NSInteger)unbindUserId
             completion:(void (^)(NSDictionary *data))completion
                failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUserId;
    NSString * username= [Session sharedInstance].currentUser.userName;
    NSString * iconUrl= [Session sharedInstance].currentUser.avatarUrl;
    NSDictionary * parameters = @{@"platform":platform?[platform AES128EncryptWithKey:KEY_VALUE]:@"",
                                  @"userId":[NSNumber numberWithInteger:userId],
                                  @"unbind_userId":[NSNumber numberWithInteger:unbindUserId],
                                  @"username":username,
                                  @"icon_url":iconUrl};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"unbind_third" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)third_party_login:(ThirdPartyAccountInfo*)accountInfo
               completion:(void (^)(NSDictionary *data))completion
                  failure:(void (^)(XMError *error))failure {
    
    NSString *signature = [[NSString stringWithFormat:@"%@%@", accountInfo.platform?accountInfo.platform:@"",accountInfo.uid?accountInfo.uid:@""] AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"platform":accountInfo.platform?[accountInfo.platform AES128EncryptWithKey:KEY_VALUE]:@"",
                                 @"uid":accountInfo.uid?[accountInfo.uid AES128EncryptWithKey:KEY_VALUE]:@"",
                                 @"username":accountInfo.username?accountInfo.username:@"",
                                 @"icon_url":accountInfo.icon_url?accountInfo.icon_url:@"",
                                 @"signature":signature,
                                 @"xuid":accountInfo.xuid?[accountInfo.xuid AES128EncryptWithKey:KEY_VALUE]:@""};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"third_party_login" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


+ (void)binding:(NSString*)phone
       password:(NSString*)password
      auth_code:(NSString*)auth_code
invitationCode:(NSString *)invitationCode
     completion:(void (^)(NSDictionary *data))completion
        failure:(void (^)(XMError *error))failure {
 
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"password":encryPwd,@"phone":phone,@"auth_code":auth_code,@"invitation_code":invitationCode?invitationCode:@""};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"binding" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+(void)renewPhoneNum:(NSString *)phone password:(NSString *)password auth_code:(NSString *)auth_code completion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"password":encryPwd,@"phone":phone,@"auth_code":auth_code};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"reset_phone" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+(void)surePhoneNum:(NSString *)phone auth_code:(NSString *)auth_code completion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSString *signature = [[NSString stringWithFormat:@"%@%@", phone?phone:@"",auth_code?auth_code:@""] AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"phone":phone,@"auth_code":auth_code, @"signature":signature};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"replace_phone" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

@end
