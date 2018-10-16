//
//  AuthService.h
//  XianMao
//
//  Created by simon cai on 17/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"
#import "NetworkManager.h"

@class ThirdPartyAccountInfo;

@interface AuthService : BaseService

+ (void)validatePassword:(NSString*)password
              completion:(void (^)())completion
                 failure:(void (^)(XMError *error))failure;


+ (void)checkPhone:(NSString*)phoneNumber
        completion:(void (^)(BOOL isExist))completion
           failure:(void (^)(XMError *error))failure;

+ (void)bind_third:(ThirdPartyAccountInfo*)accountInfo
              type:(NSNumber *)type
              completion:(void (^)(NSDictionary *data))completion
                 failure:(void (^)(XMError *error))failure;

+ (void)third_party_login:(ThirdPartyAccountInfo*)accountInfo
               completion:(void (^)(NSDictionary *data))completion
                  failure:(void (^)(XMError *error))failure;


+ (void)binding:(NSString*)phone
       password:(NSString*)password
      auth_code:(NSString*)auth_code
 invitationCode:(NSString *)invitationCode
     completion:(void (^)(NSDictionary *data))completion
        failure:(void (^)(XMError *error))failure;

+ (void)authUnbindthird:(NSString *)platform
           unbindUserId:(NSInteger)unbindUserId
             completion:(void (^)(NSDictionary *data))completion
                failure:(void (^)(XMError *error))failure;


+ (void)renewPhoneNum:(NSString*)phone
             password:(NSString*)password
            auth_code:(NSString*)auth_code
           completion:(void (^)(NSDictionary *data))completion
              failure:(void (^)(XMError *error))failure;

+(void)surePhoneNum:(NSString *)phone auth_code:(NSString *)auth_code completion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure;
@end


//auth/validate_password [POST] {user_id, password(加密)} 验证密码， @卢云 @白骁


//auth/binding[POST] 绑定手机号和密码｛user_id, auth_code, phone, password(加密)｝
//auth/send_auth_code 增加 type=4 绑定用户手机和密码时发送的验证码


//auth/send_auth_code[GET]{phone, type, sms_type（0短信1语音）} 发送验证码




