//
//  NetworkAPI.m
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "NetworkAPI.h"
#import "SynthesizeSingleton.h"
#import "NSDictionary+Additions.h"
#import "NetworkManager.h"
#import "PayTipVo.h"
#import "Session.h"
#import "User.h"
#import "UserDetailInfo.h"
#import "AddressInfo.h"
#import "GoodsInfo.h"
#import "GoodsDetailInfo.h"
#import "ShoppingCartItem.h"

#import "AddressInfo.h"

#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "NSString+AES.h"
#import "NSData+AES.h"
#import "Wallet.h"

#import "GoodsEditableInfo.h"

#import "AppDirs.h"
#import "SkinVo.h"
#import "ZipArchive.h"

@interface NetworkAPI()

@property (nonatomic, copy) NSString *zipPath;
@property (nonatomic, copy) NSString *path;

@end

@implementation NetworkAPI  {
    
}

SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkAPI, sharedInstance);



- (void)initialize
{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadView" object:nil];
}

-(void)downloadSkinIconCompletion:(void (^)(NSMutableArray *data))completion failure:(void (^)(XMError *error))failure{
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"platform" path:@"get_change_shin" parameters:nil completionBlock:^(NSDictionary *data) {
        if ([data objectForKey:@"change_shin"] != [NSNull null]) {
            NSDictionary *changeSkin = [data dictionaryValueForKey:@"change_shin"];
            SkinVo *skin = [SkinVo createWithDict:changeSkin];
            NSArray *arr = [skin.iosUrl componentsSeparatedByString:@"/"];
            NSString *testName = [arr lastObject];
            NSArray *testArr = [testName componentsSeparatedByString:@"."];
            NSString *name = [testArr firstObject];
            
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (skin.endTime < interval) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], name] error:nil];
                [AppDirs removeFile:[AppDirs currentSkinIconCacheFile]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:nil];
                return ;
            }
            
            NSString *downloadUrl = skin.iosUrl;
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/Skin.plist",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], name]] == NO) {
                NSLog(@"不存在");
                [AppDirs removeFile:[AppDirs currentSkinIconCacheFile]];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    NSURL *url = [NSURL URLWithString:downloadUrl];
                    NSError *error = nil;
                    // 2
                    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
                    if(!error){
                        // 3
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                        NSString *path = [paths objectAtIndex:0];
                        NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
                        self.path = path;
                        self.zipPath = zipPath;
                        [data writeToFile:zipPath options:0 error:&error];
                        ZipArchive *zip = [[ZipArchive alloc]init];
                        
                        //1.在内存中解压缩文件,
                        if([zip UnzipOpenFile:self.zipPath]) {
                            //2.将解压缩的内容写到缓存目录中
                            BOOL ret = [zip UnzipFileTo:self.path overWrite:YES];
                            if(NO== ret) {
                                [zip UnzipCloseFile];
                            }
                            //3.使用解压缩后的文件
                            NSString*plistFilePath = [self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Skin.plist", name]];
                            //4.更新UI
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                NSMutableArray *dataArr = [[NSMutableArray alloc] init];
                                if ([fileManager fileExistsAtPath:plistFilePath] == NO) {
                                    NSLog(@"不存在");
                                } else {
                                    NSLog(@"存在");
                                    dataArr = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
                                    if (data) {
                                        NSLog(@"%@", dataArr);
                                        if (completion)completion(dataArr);
                                    } else {
                                        NSLog(@"plist文件为空");
                                    }
                                }
                            });
                        }
                        if(!error){
                            // TODO: Unzip
                        }else{
                            NSLog(@"Error saving file %@",error);
                        }
                    }else{
                        NSLog(@"Error downloading zip file: %@", error);
                    }
                });
            } else {
                NSLog(@"存在");
                dataArr = [[NSMutableArray alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/Skin.plist",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], name]];
                if (dataArr) {
                    NSLog(@"%@", dataArr);
                    if (completion)completion(dataArr);
                } else {
                    NSLog(@"plist文件为空");
                }
            }
            
            [[SkinIconManager manager] setPath:name];
        } else {
            [AppDirs removeFile:[AppDirs currentSkinIconCacheFile]];
        }
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
    
}

- (HTTPRequest*)getCaptchaCode:(NSString *)phoneNumber
                          type:(CaptchaType)type
                    completion:(void (^)())completion
                       failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"phone":phoneNumber, @"type":[NSNumber numberWithInteger:type]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"auth" path:@"get_auth_code" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)addAndupdateBank:(NSDictionary *)parameters
                      completion:(void (^)())completion
                         failure:(void (^)(XMError *error))failure
{
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"bank" path:@"add_or_update" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)addPpdateAlipay:(NSDictionary *)parameters
                     completion:(void (^)())completion
                        failure:(void (^)(XMError *error))failure
{
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"bank" path:@"add_update_alipay" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

//sms_type（0短信1语音
- (HTTPRequest*)getCaptchaCodeEncrypt:(NSString *)phoneNumber
                                 type:(CaptchaType)type
                             sms_type:(NSInteger)sms_type
                           completion:(void (^)())completion
                              failure:(void (^)(XMError *error))failure
{
    NSString *encryPhoneNumber = [phoneNumber AES128EncryptWithKey:KEY_VALUE];
    
    NSDictionary *parameters = @{@"phone":encryPhoneNumber, @"type":[NSNumber numberWithInteger:type],@"sms_type":[NSNumber numberWithInteger:sms_type]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"send_auth_code" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (error.errorCode == 41000) {
            if (completion)completion();
        } else {
            if (failure)failure(error);
        }
    } queue:nil];
}

- (HTTPRequest*)verifyCaptchaCode:(NSString *)phoneNumber
                      captchaCode:(NSString *)captchaCode
                             type:(NSInteger)type
                       completion:(void (^)())completion
                          failure:(void (^)(XMError *error))failure {
    
    NSDictionary *parameters = @{@"phone":phoneNumber,@"auth_code":captchaCode,@"type":[NSNumber numberWithInteger:type]};
    
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"validate_auth_code" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)registerNewAccount:(NSString *)phoneNumber
                       captchaCode:(NSString *)captchaCode
                          userName:(NSString*)userName
                          password:(NSString *)password
                        completion:(void (^)(NSDictionary *data))completion
                           failure:(void (^)(XMError *error))failure {
//    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
//    
//    NSDictionary *parameters = @{@"username":userName?[userName URLEncodedString]:@"",@"phone":phoneNumber,@"auth_code":captchaCode,@"password":encryPwd};
//    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"registration" parameters:parameters completionBlock:^(NSDictionary *data) {
//        if (completion)completion(data);
//    } failure:^(XMError *error) {
//        if (failure)failure(error);
//    } queue:nil];
    
    return [self registerNewAccount:phoneNumber captchaCode:captchaCode userName:userName password:password avatarFilePath:nil invitationCode:nil completion:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }];
}

- (HTTPRequest*)registerNewAccount:(NSString *)phoneNumber
                       captchaCode:(NSString *)captchaCode
                          userName:(NSString*)userName
                          password:(NSString *)password
                    avatarFilePath:(NSString*)avatarFilePath
                    invitationCode:(NSString *)invitationCode
                        completion:(void (^)(NSDictionary *data))completion
                           failure:(void (^)(XMError *error))failure {
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    
    //去掉用户名，都不传了
    NSDictionary *parameters = @{@"phone":phoneNumber,@"auth_code":captchaCode,@"password":encryPwd,@"invitation_code":invitationCode, @"blackBox":[[Session sharedInstance] getFMDeviceBlackBox]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"registration" parameters:parameters fileName:@"avatar" filePath:avatarFilePath completionBlock:^(NSDictionary *data) {
        
        if (completion)completion(data);
        
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)login:(NSString *)phoneNumber
             password:(NSString *)password
           completion:(void (^)(NSDictionary *data))completion
              failure:(void (^)(XMError *error))failure {
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    
    NSDictionary *parameters = @{@"phone":phoneNumber, @"password":encryPwd, @"blackBox":[[Session sharedInstance] getFMDeviceBlackBox]};
    
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"login" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
        
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)resetPassword:(NSString *)phoneNumber
                     password:(NSString *)password
                     authcode:(NSString *)authCode
                   completion:(void (^)())completion
                      failure:(void (^)(XMError *error))failure {
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"phone":phoneNumber, @"password":encryPwd,@"auth_code":authCode};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"reset_password" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        if (completion) completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)WithdrawPasswrd:(NSString *)password
                     completion:(void (^)(NSDictionary* data))completion
                        failure:(void (^)(XMError *error))failure
{
    NSString *encryPwd = [password AES128EncryptWithKey:KEY_VALUE];
    NSDictionary * parameters = @{@"password":encryPwd};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"validate_password" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)withdrawDeposit:(NSDictionary *)parameters
                     completion:(void (^)())completion
                        failure:(void (^)(XMError *error))failure
{
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"user" path:@"withdraw" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)logout:(void (^)())completion
               failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"auth" path:@"logout" parameters:parameters completionBlock:^(NSDictionary *data) {
        [[Session sharedInstance] setLogoutState];
        if (completion) completion();
    } failure:^(XMError *error) {
        [[Session sharedInstance] setLogoutState];
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getEMAccounts:(NSArray*)userIds
                   completion:(void (^)(NSArray* accountDicts))completion
                      failure:(void (^)(XMError *error))failure {
    NSMutableString *strUserIds = [[NSMutableString alloc] initWithCapacity:[userIds count]];
    for (NSNumber *userId in userIds) {
        if ([strUserIds length]>0) {
            [strUserIds appendString:@"|"];
        }
        [strUserIds appendFormat:@"%ld",(long)[userId integerValue]];
    }
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId],@"uids":strUserIds};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"get_emaccount" parameters:parameters completionBlock:^(NSDictionary *data) {
         if (completion) completion([data arrayValueForKey:@"emusers"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
    return nil;
}

- (HTTPRequest*)chatBalance:(NSString*)goodsId
                 completion:(void (^)(NSDictionary* accountDict))completion
                    failure:(void (^)(XMError *error))failure {
    if ([goodsId length]>0) {
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId],@"goods_id":goodsId};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"chat_balance" parameters:parameters completionBlock:^(NSDictionary *data) {
            if (completion) completion([data dictionaryValueForKey:@"emuser"]);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)getchatTabReplylist:(NSInteger)adviserid
                         completion:(void (^)(NSArray* replyTablist))completion
                            failure:(void (^)(XMError *error))failure{
    NSDictionary *parameters = @{@"adviser_id":@(adviserid)};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"get_tab_reply_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion([data arrayValueForKey:@"reply_tab_list"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getchatReplydetail:(NSInteger)tabid
                        completion:(void (^)(NSDictionary* data))completion
                           failure:(void (^)(XMError *error))failure{
    NSDictionary *parameters = @{@"tab_id":@(tabid)};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"get_reply_detail" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getUserInfo:(NSInteger)userId
                 completion:(void (^)(User *user))completion
                    failure:(void (^)(XMError *error))failure
{
    if (userId>0) {
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"get_userinfo" parameters:parameters completionBlock:^(NSDictionary *data) {
            User *user = [User createWithDict:[data dictionaryValueForKey:@"user"]];
            if (completion) completion(user);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    } else {
        return nil;
    }
}

- (HTTPRequest*)getUserDetail:(NSInteger)userId
                   completion:(void (^)(UserDetailInfo *userDetailInfo))completion
                      failure:(void (^)(XMError *error))failure
{
    if (userId>0) {
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"get_userdetail" parameters:parameters completionBlock:^(NSDictionary *data) {
            UserDetailInfo *userDetailInfo = [UserDetailInfo createWithDict:[data dictionaryValueForKey:@"userdetail_info"]];
            if (completion) completion(userDetailInfo);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    } else {
        return nil;
    }
}

- (HTTPRequest*)setAvatar:(NSString*)filePath
               completion:(void (^)(NSString *avatarUrl))completion
                  failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"user" path:@"set_avatar" parameters:parameters fileName:@"avatar" filePath:filePath completionBlock:^(NSDictionary *data) {
        if (completion)completion([data stringValueForKey:@"avatar_url"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)setFrontImage:(NSString*)filePath
                   completion:(void (^)(NSString *frontUrl))completion
                      failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"user" path:@"set_front" parameters:parameters fileName:@"front" filePath:filePath completionBlock:^(NSDictionary *data) {
        if (completion)completion([data stringValueForKey:@"front_url"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

//user edit_profile[post] {user_id, user_name, gender, birthday}

- (HTTPRequest*)setProfile:(NSDictionary*)parameters
                completion:(void (^)(NSDictionary* dict))completion
                   failure:(void (^)(XMError *error))failure
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    [dict setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"user" path:@"edit_profile" parameters:dict completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}
- (HTTPRequest*)setUserName:(NSString*)newUserName
                 completion:(void (^)())completion
                    failure:(void (^)(XMError *error))failure {
    if ([newUserName length]>0) {
        NSDictionary *parameters = @{@"username":newUserName};
        return [self setProfile:parameters completion:completion failure:failure];
    }
    return nil;
}

- (HTTPRequest*)bindingWecat:(NSString*)wecatId
                 completion:(void (^)(NSDictionary* dict))completion
                    failure:(void (^)(XMError *error))failure{
    if ([wecatId length]>0) {
        NSDictionary *parameters = @{@"weinxin_id":wecatId};
        return [self setProfile:parameters completion:completion failure:failure];
    }
    return nil;
}

- (HTTPRequest*)setGender:(NSInteger)gender
               completion:(void (^)(NSDictionary *dict))completion
                  failure:(void (^)(XMError *error))failure {
    //1 男 2女 0未知
    NSDictionary *parameters = @{@"gender":[NSNumber numberWithInteger:gender]};
    return [self setProfile:parameters completion:completion failure:failure];
}

- (HTTPRequest*)setSummary:(NSString*)summary
               completion:(void (^)(NSDictionary *dict))completion
                  failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"summary":[summary length]>0?summary:@""};
    return [self setProfile:parameters completion:completion failure:failure];
}

- (HTTPRequest*)setBirthday:(long long)birthday
                 completion:(void (^)(NSDictionary *dict))completion
                    failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"birthday":[NSNumber numberWithLongLong:birthday]};
    return [self setProfile:parameters completion:completion failure:failure];
}

- (void)setGallery:(NSArray*)gallery
                completion:(void (^)())completion
                   failure:(void (^)(XMError *error))failure
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:gallery.count];
    for (PictureItem *item in gallery) {
        if ([item isKindOfClass:[PictureItem class]]) {
            if (item.picId != kPictureItemLocalPicId) {
                [array addObject:[item toDictionary]];
            }
        }
    }
    NSDictionary *parameters = @{@"gallary":array};
    [[NetworkManager sharedInstance] addRequest:[self setProfile:parameters completion:completion failure:failure]];
}

- (HTTPRequest*)getWallet:(void (^)(Wallet *wallet))completion
                  failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"get_wallet" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([Wallet createWithDict:data]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)withdraw:(NSString*)account
             accountName:(NSString*)accountName
                    type:(NSInteger)type
                  amount:(NSString*)amount
                authCode:(NSString*)authCode
              completion:(void (^)(NSInteger result, NSString *message,Wallet *wallet))completion
                 failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSString *encryAccount = [account AES128EncryptWithKey:KEY_VALUE];
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"account":encryAccount?encryAccount:@"",@"account_name":accountName?accountName:@"",@"type":[NSNumber numberWithInteger:type],@"amount":amount?amount:@"",@"auth_code":authCode?authCode:@""};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"user" path:@"withdraw" parameters:parameters completionBlock:^(NSDictionary *data) {
        Wallet *wallet = [Wallet createWithDict:data];
        if (completion)completion([data integerValueForKey:@"result" defaultValue:0],[data stringValueForKey:@"message"],wallet);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

//16.4.12 add by adu
- (HTTPRequest*)getNoticeCount:(void (^)(NSDictionary* data))completion
                    failure:(void (^)(XMError *error))failure
                      queue:(dispatch_queue_t)queue {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"notification" path:@"get_notice_count" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:queue];
}

- (HTTPRequest*)getMsgCount:(void (^)(NSDictionary* data))completion
                    failure:(void (^)(XMError *error))failure
                      queue:(dispatch_queue_t)queue
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"get_msgcount" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:queue];
    //add code
//    return [[NetworkManager sharedInstance] requestWithMethodGET:@"notification" path:@"get_notice_count" parameters:parameters completionBlock:^(NSDictionary *data) {
//        if (completion)completion(data);
//    } failure:^(XMError *error) {
//        if (failure)failure(error);
//    } queue:queue];
}


- (HTTPRequest*)getUserAddressList:(NSInteger)userId
                        completion:(void (^)(NSArray *addressDictList))completion
                           failure:(void (^)(XMError *error))failure {
    return [self getUserAddressList:userId type:0 completion:completion failure:failure];
}
- (HTTPRequest*)getUserAddressList:(NSInteger)userId
                              type:(NSInteger)type
                        completion:(void (^)(NSArray *addressDictList))completion
                           failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"type":[NSNumber numberWithInteger:type]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"address" path:@"list" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSArray *addressDictList = [data arrayValueForKey:@"address_list"];
        if (completion) completion(addressDictList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)addUserAddress:(NSInteger)userId
                   addressInfo:(AddressInfo*)addressInfo
                    completion:(void (^)(NSInteger totalNum, AddressInfo *addedAddressInfo))completion
                       failure:(void (^)(XMError *error))failure {
    return [self addUserAddress:userId type:0 addressInfo:addressInfo completion:completion failure:failure];
}
- (HTTPRequest*)addUserAddress:(NSInteger)userId
                          type:(NSInteger)type
                   addressInfo:(AddressInfo*)addressInfo
                    completion:(void (^)(NSInteger totalNum, AddressInfo *addedAddressInfo))completion
                       failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"address_info":[addressInfo toDict],
                                 @"type":[NSNumber numberWithInteger:type]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"address" path:@"add" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSDictionary *dict = [data dictionaryValueForKey:@"address"];
        NSInteger totalNum = [data integerValueForKey:@"total_num" defaultValue:0];
        AddressInfo *addedAddressInfo = [AddressInfo createWithDict:dict];
        if (completion) completion(totalNum, addedAddressInfo);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)modifyUserAddress:(NSInteger)userId
                      addressInfo:(AddressInfo*)addressInfo
                       completion:(void (^)())completion
                          failure:(void (^)(XMError *error))failure {
    return [self modifyUserAddress:userId type:0 addressInfo:addressInfo completion:completion failure:failure];
}

- (HTTPRequest*)modifyUserAddress:(NSInteger)userId
                             type:(NSInteger)type
                      addressInfo:(AddressInfo*)addressInfo
                       completion:(void (^)())completion
                          failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"address_info":[addressInfo toDict],
                                 @"type":[NSNumber numberWithInteger:type]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"address" path:@"modify" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)delUserAddress:(NSInteger)userId
                     addressId:(NSInteger)addressId
                    completion:(void (^)())completion
                       failure:(void (^)(XMError *error))failure {
    return [self delUserAddress:userId type:0 addressId:addressId completion:completion failure:failure];
}

- (HTTPRequest*)delUserAddress:(NSInteger)userId
                          type:(NSInteger)type
                     addressId:(NSInteger)addressId
                    completion:(void (^)())completion
                       failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"address_id_list":[NSArray arrayWithObjects:[NSNumber numberWithInteger:addressId], nil],
                                 @"type":[NSNumber numberWithInteger:type]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"address" path:@"remove" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)applyOrder:(NSArray*)fullPathArray
                completion:(void (^)(NSInteger totalNum))completion
                   failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"consignment" path:@"apply_order" parameters:parameters fileName:@"pics" filePathArray:fullPathArray completionBlock:^(NSDictionary *data) {
        NSInteger num = [data integerValueForKey:@"num" defaultValue:0];
        //[[Session sharedInstance] setShoppingCartGoodsNum:num];
        if (completion) completion(num);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
    return nil;
}

- (HTTPRequest*)getConsignOrders:(NSUInteger)userId
                      completion:(void (^)(NSArray *orderDictList))completion
                         failure:(void (^)(XMError *error))failure {
    if (userId>0) {
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"consignment" path:@"get_orders" parameters:parameters completionBlock:^(NSDictionary *data) {
            //NSInteger num = [data integerValueForKey:@"num" defaultValue:0];
            NSArray *orderDictList = [data arrayValueForKey:@"consign_info_list"];
            //[[Session sharedInstance] setConsignOrdersNum:num];
            if (completion) completion(orderDictList);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    } else {
        return nil;
    }
}

- (HTTPRequest*)requestConsignment:(NSUInteger)userId
                           cateIds:(NSArray*)cateIds
                       addressInfo:(AddressInfo*)addressInfo
                        completion:(void (^)(NSInteger totalOrdersNum))completion
                           failure:(void (^)(XMError *error))failure {
    if (userId>0) {
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"address":[addressInfo toDict],@"consign_type":cateIds};
        return [[NetworkManager sharedInstance] requestWithMethodPOST:@"consignment" path:@"add_order" parameters:parameters completionBlock:^(NSDictionary *data) {
            NSInteger num = [data integerValueForKey:@"num" defaultValue:0];
            //[[Session sharedInstance] setConsignOrdersNum:num];
            if (completion) completion(num);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    } else {
        return nil;
    }
}


- (HTTPRequest*)addToShoppingCart:(NSString*)goodsId
                       completion:(void (^)(NSInteger totalNum, ShoppingCartItem* addedItem))completion
                          failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"goods_id":goodsId};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"shopping_cart" path:@"add_goods" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSInteger totalNum = [data integerValueForKey:@"total_num" defaultValue:0];
        ShoppingCartItem *addedItem = nil;
        if ([[data objectForKey:@"added_item"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [data dictionaryValueForKey:@"added_item"];
            addedItem = [ShoppingCartItem createWithDict:dict];
        }
        if (completion) completion(totalNum,addedItem);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getShoppingCartGoods:(void (^)(NSArray* itemList))completion
                             failure:(void (^)(XMError *error))failure{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"shopping_cart" path:@"get_goods_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSArray *itemList = [data arrayValueForKey:@"list"];
        if (completion) completion(itemList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)removeFromShoppingCart:(NSArray*)goodsIds
                            completion:(void (^)(NSInteger totalNum))completion
                               failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"goods_id_list":goodsIds};
    return userId>0?[[NetworkManager sharedInstance] requestWithMethodPOST:@"shopping_cart" path:@"remove_goods_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSInteger num = [data integerValueForKey:@"num" defaultValue:0];
       // [[Session sharedInstance] setShoppingCartGoodsNum:num];
        if (completion) completion(num);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]:nil;
}


- (HTTPRequest*)followUsers:(NSInteger)followingUserId
                  isFollow:(BOOL)isFollow
                completion:(void (^)(User *user))completion
                   failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"following_user_id":[NSNumber numberWithInteger:followingUserId], @"user_id":[NSNumber numberWithInteger:userId], @"isfollow":[NSNumber numberWithInteger:isFollow?1:0]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"follow" path:@"follow_user" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSLog(@"----------------data%@", data);
        
//        User *user =  = [user setValuesForKeysWithDictionary:data defaultValue:0];
        if (completion)completion(nil);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}



- (HTTPRequest*)followUser:(NSInteger)followingUserId
                  isFollow:(BOOL)isFollow
                completion:(void (^)(NSInteger totalNum))completion
                   failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"following_user_id":[NSNumber numberWithInteger:followingUserId], @"user_id":[NSNumber numberWithInteger:userId], @"isfollow":[NSNumber numberWithInteger:isFollow?1:0]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"follow" path:@"follow_user" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSInteger totalNum = [data integerValueForKey:@"total_num" defaultValue:0];
        if (completion)completion(totalNum);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getBrandRedirectList:(void (^)(NSDictionary *data))completion
                             failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"brand" path:@"list" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getBrandList:(NSInteger)cateId
                  completion:(void (^)(NSDictionary *data))completion
                     failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"cate_id":[NSNumber numberWithInteger:cateId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"brand" path:@"get_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getRecoverGoodsDetail:(NSString *)goods_sn
                  completion:(void (^)(NSDictionary *data))completion
                     failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"goods_sn":goods_sn};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_recovery_goods_detail" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSDictionary *dict = data[@"get_recovery_goods_detail"];
        NSLog(@"%@", dict);
        if (completion) completion(dict);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getRecommenUser:(NSString *)goods_sn
                           completion:(void (^)(NSDictionary *data))completion
                              failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"goods_sn":goods_sn};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_recommend_user" parameters:parameters completionBlock:^(NSDictionary *data) {
//        NSDictionary *dict = data[@"get_recovery_goods_detail"];
//        NSLog(@"%@", dict);
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getBidPage:(NSString *)goods_sn
                     completion:(void (^)(NSDictionary *data))completion
                        failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"goods_sn":goods_sn};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_bid_page" parameters:parameters completionBlock:^(NSDictionary *data) {
        //        NSDictionary *dict = data[@"get_recovery_goods_detail"];
        //        NSLog(@"%@", dict);
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getBidDetail:(NSString *)goods_sn
                completion:(void (^)(NSDictionary *data))completion
                   failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"goods_sn":goods_sn};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_bid_detail" parameters:parameters completionBlock:^(NSDictionary *data) {
        //        NSDictionary *dict = data[@"get_recovery_goods_detail"];
        //        NSLog(@"%@", dict);
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getBid:(NSString *)goods_sn andbid_price:(CGFloat)bid_price
                  completion:(void (^)(NSDictionary *data))completion
                     failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"goods_sn":goods_sn, @"bid_price":[NSNumber numberWithFloat:bid_price]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"bid" parameters:parameters completionBlock:^(NSDictionary *data) {
        //        NSDictionary *dict = data[@"get_recovery_goods_detail"];
        //        NSLog(@"%@", dict);
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getAuthBid:(NSString *)goods_sn andUserID:(NSInteger)userid
            completion:(void (^)(NSDictionary *data))completion
               failure:(void (^)(XMError *error))failure {
    
//    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userid],@"goods_sn":goods_sn};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"auth_bid" parameters:parameters completionBlock:^(NSDictionary *data) {
        //        NSDictionary *dict = data[@"get_recovery_goods_detail"];
        //        NSLog(@"%@", dict);
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getGoodsDetail:(NSString*)goodsId
                    completion:(void (^)(GoodsDetailInfo *goodsInfo))completion
                       failure:(void (^)(XMError *error))failure {
    if (goodsId!=nil) {
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"goods_id":goodsId,@"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_detail" parameters:parameters completionBlock:^(NSDictionary *data) {
            NSLog(@"%@", data);
            if (completion)completion([GoodsDetailInfo createWithDict:[data objectForKey:@"goods_detail"]]);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    } else {
        return nil;
    }
}

- (HTTPRequest*)likeGoods:(NSString*)goodsId
                   isLike:(BOOL)isLike
               completion:(void (^)(NSInteger likeNum, User *likedUser))completion
                  failure:(void (^)(XMError *error))failure {
    if (goodsId!=nil) {
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"goods_id":goodsId,@"user_id":[NSNumber numberWithInteger:userId],@"islike":[NSNumber numberWithInteger:isLike?1:0]};
        return [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"like" parameters:parameters completionBlock:^(NSDictionary *data) {
            NSInteger likeNum = [data integerValueForKey:@"likes_num" defaultValue:0];
            User *likedUser = nil;
            if ([data dictionaryValueForKey:@"liked_user"])
                likedUser = [User createWithDict:[data dictionaryValueForKey:@"liked_user"]];
            if (completion) completion(likeNum,likedUser);
        } failure:^(XMError *error) {
            if (failure) failure(error);
        } queue:nil];
    } else {
        return nil;
    }
}

- (HTTPRequest*)reportGoodsShared:(NSString*)goodsId
                       completion:(void (^)(NSInteger shareNum))completion
                          failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"goods_id":goodsId?goodsId:@"",@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"share" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"share_num" defaultValue:0]);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)tryOffsale:(NSString*)goodsId
                completion:(void (^)(NSInteger result, NSString *message))completion
                   failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"goods_id":goodsId?goodsId:@"",@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"try_offsale" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"result" defaultValue:0],[data stringValueForKey:@"message"]);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)apllyOffsale:(NSString*)goodsId
             completion:(void (^)())completion
                failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"goods_id":goodsId?goodsId:@"",@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"apply_offsale" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)queryGoodsStatus:(NSArray*)goodsIds
                      completion:(void (^)(NSArray *goodsStatusArray))completion
                         failure:(void (^)(XMError *error))failure {
    
    NSMutableString *strGoodsIds = [[NSMutableString alloc] init];
    for (NSString *goodsId in goodsIds) {
        if ([strGoodsIds length]>0) {
            [strGoodsIds appendString:@"|"];
        }
        [strGoodsIds appendString:goodsId];
    }
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"goods_ids":strGoodsIds?strGoodsIds:@"",@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"query_status" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data arrayValueForKey:@"goods_status"]);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)publishGoods:(GoodsEditableInfo*)editableInfo
                publish_type:(NSInteger )publish_type
                  completion:(void (^)(GoodsPublishResultInfo *resultInfo))completion
                     failure:(void (^)(XMError *error))failure {
    
    NSNumber *num = [NSNumber numberWithInteger:publish_type];
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"goods_editable_info":editableInfo?[editableInfo toDictionary]:@"", @"publish_type" : num};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"publish" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) {
            completion([GoodsPublishResultInfo createWithDict:data]);
        }
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

- (HTTPRequest*)getEditableInfo:(NSString*)goodsId
                           type:(NSInteger)type
                     completion:(void (^)(NSDictionary *editableInfoDict))completion
                        failure:(void (^)(XMError *error))failure {
    
    if ([goodsId length]>0) {
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"goods_id":goodsId, @"type":[NSNumber numberWithInteger:type]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_editable_info" parameters:parameters completionBlock:^(NSDictionary *data) {
            if (completion)completion([data dictionaryValueForKey:@"goods_editable_info"]);
        } failure:^(XMError *error) {
            if (failure) failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)getCateList:(void (^)(NSDictionary *data))completion
                    failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"get_tree" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil];
}

+ (NSDictionary*) addOrderGoodsListItemTwo:(NSString*)goodsId
                                     price:(float)price
                                 priceCent:(NSInteger)priceCent{
    return @{@"goods_id":goodsId,
             @"price":[NSNumber numberWithFloat:price],
             @"price_cent":[NSNumber numberWithInteger:priceCent]};
}

+ (NSDictionary*) addOrderGoodsListItem:(NSString*)goodsId
                                  price:(float)price
                              priceCent:(NSInteger)priceCent
                   receive_service_gift:(NSInteger)receive_service_gift
                       shoppingCartItem:(ShoppingCartItem *)item{
    if (item.meowReduceVo == nil) {
        item.is_use_meow = 0;
    }
    if (item.serviceVo == nil) {
        item.is_use_jdvo = 0;
    }
    return @{@"goods_id":goodsId,
             @"price":[NSNumber numberWithFloat:price],
             @"price_cent":[NSNumber numberWithInteger:priceCent],
             @"receive_service_gift":[NSNumber numberWithInteger:receive_service_gift],
             @"is_use_meow":@(item.is_use_meow),
             @"is_need_appraisal":@(item.is_use_jdvo),
             @"message":item.message?item.message:@""};
}

//所有付款接口加了  is_used_reward_money （是否使用 奖励金额） 若奖励金额能完成支付的，返回的pay_url为null,  @卢云 @白骁
//新增参数：is_need_appraisal（0、不需要爱丁猫鉴定；1、需要。可不传，默认为1）
- (HTTPRequest*)payGoods:(NSArray*)goodsList
                 address:(NSInteger)addressId
                 message:(NSString*)message
                  payWay:(PayWayType)payWay
                   bonus:(NSString*)bonusId
             accountCard:(AccountCard *)accountCard
       is_need_appraisal:(NSInteger)is_need_appraisal
       is_used_adm_money:(BOOL)is_used_adm_money
    is_used_reward_money:(BOOL)is_used_reward_money
          is_partial_pay:(NSInteger)is_partial_pay
      partial_pay_amount:(CGFloat )partial_pay_amount
              completion:(void (^)(NSString *payUrl,PayReq *payReq,NSString *upPayTn,PayZhaoHangReg*payZHReg))completion
                 failure:(void (^)(XMError *error))failure
{
    //"goods_list", "user_id", "address_id", "message"
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{ @"goods_list":goodsList,
                                  @"user_id":[NSNumber numberWithInteger:userId],
                                  @"address_id":[NSNumber numberWithInteger:addressId],
                                  @"pay_way":[NSNumber numberWithInteger:payWay],
//                                 @"message":message?message:@"",
                                  @"bonus_id":bonusId?bonusId:@"",
                                  @"is_used_adm_money":[NSNumber numberWithInteger:is_used_adm_money?1:0],
                                  @"is_used_reward_money":[NSNumber numberWithInteger:is_used_reward_money?1:0],
//                                 @"is_need_appraisal":[NSNumber numberWithInteger:is_need_appraisal],
                                  @"is_partial_pay":[NSNumber numberWithInteger:is_partial_pay],
                                  @"partial_pay_amount":[NSString stringWithFormat:@"%.2f", partial_pay_amount]};
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    if (accountCard) {
        [param setObject:@(accountCard.cardType) forKey:@"pay_card_type"];
    }
    
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"pay_goods" parameters:param completionBlock:^(NSDictionary *data) {
        NSDictionary *payReq = [data objectForKey:@"pay_req"];
        PayReq *request = nil;
        PayZhaoHangReg *payZHReg = [[PayZhaoHangReg alloc] init];
        if (payWay == 3) {
            //http://61.144.248.29:801/netpayment/BaseHttp.dll?PrePayEUserP?BranchID=xxxx&CoNo=xxxxxx&BillNo=xxxxxx&Amount=xxxx.xx&Date=YYYYMMDD&ExpireTimeSpan=xx&MerchantUrl=xxxxxx&MerchantPara=xxxxxx&MerchantCode=xx&MerchantRetUrl=xxxxxx&MerchantRetPara=xxxxxx
            PayZhaoHangReg *payReg = [[PayZhaoHangReg alloc] initWithJSONDictionary:payReq];
            payZHReg = payReg;
        } else {
            if (payReq != nil && [payReq isKindOfClass:[NSDictionary class]]) {
                request = [[PayReq alloc] init];
                request.openID = WXAppId;
                request.partnerId = [payReq stringValueForKey:@"partnerid"];
                request.prepayId= [payReq stringValueForKey:@"prepayid"];
                request.package = [payReq stringValueForKey:@"packagestr"];
                request.nonceStr= [payReq stringValueForKey:@"noncestr"];
                request.timeStamp = [[payReq stringValueForKey:@"timestamp"] intValue];
                request.sign= [payReq stringValueForKey:@"sign"];
            }
        }
        
        if (completion) completion([data stringValueForKey:@"pay_url"],request,[data stringValueForKey:@"upPayTn"], payZHReg);
        
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)payOrder:(NSString*)orderId
                  payWay:(PayWayType)payWay
              completion:(void (^)(NSString *payUrl,PayReq *payReq,NSString *upPayTn))completion
                 failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"order_id":orderId,
                                 @"pay_way":[NSNumber numberWithInteger:payWay],
                                 @"user_id":[NSNumber numberWithInteger:userId]};
    
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"pay_order" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSDictionary *payReq = [data objectForKey:@"pay_req"];
        PayReq *request = nil;
        PayZhaoHangReg *payZHReg = [[PayZhaoHangReg alloc] init];
        
        if (payReq != nil && [payReq isKindOfClass:[NSDictionary class]]) {
            request = [[PayReq alloc] init];
            request.openID = WXAppId;
            request.partnerId = [payReq stringValueForKey:@"partnerid"];
            request.prepayId= [payReq stringValueForKey:@"prepayid"];
            request.package = [payReq stringValueForKey:@"packagestr"];
            request.nonceStr= [payReq stringValueForKey:@"noncestr"];
            request.timeStamp = [[payReq stringValueForKey:@"timestamp"] intValue];
            request.sign= [payReq stringValueForKey:@"sign"];
            
        }
        if (completion) completion([data stringValueForKey:@"pay_url"],request, [data stringValueForKey:@"upPayTn"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)payOrderList:(NSArray*)orderIds
                      payWay:(PayWayType)payWay
                       bonus:(NSString*)bonusId
                 accountCard:(AccountCard *)accountCard
                  deterIndex:(NSInteger)deterIndex
        is_used_reward_money:(BOOL)is_used_reward_money
           is_used_adm_money:(BOOL)is_used_adm_money
              is_partial_pay:(NSInteger)is_partial_pay
          partial_pay_amount:(CGFloat )partial_pay_amount
                  completion:(void (^)(NSString *payUrl,PayReq* payReq,NSString *upPayTn, PayZhaoHangReg *payZHReg))completion
                     failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    if (deterIndex == 2) {
        deterIndex = 0;
    }
    NSDictionary *parameters = @{@"order_ids":orderIds,
                                 @"pay_way":[NSNumber numberWithInteger:payWay],
                                 @"user_id":[NSNumber numberWithInteger:userId],
                                 @"bonus_id":bonusId?bonusId:@"",
                                 @"is_used_reward_money":[NSNumber numberWithInteger:is_used_reward_money?1:0],
                                 @"is_used_adm_money":[NSNumber numberWithInteger:is_used_adm_money?1:0],
                                 @"is_need_appraisal":[NSNumber numberWithInteger:deterIndex],
                                 @"is_partial_pay":[NSNumber numberWithInteger:is_partial_pay],
                                 @"partial_pay_amount":[NSString stringWithFormat:@"%.2f", partial_pay_amount]};
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    if (accountCard) {
//        if (accountCard.cardType == XIAOFEICARD) {
//            [param setObject:@(accountCard.cardCanPayMoney) forKey:@"xf_card_pay_amount"];
//        } else if (accountCard.cardType == JIANDINGCARD) {
//            [param setObject:@(accountCard.cardCanPayMoney) forKey:@"jd_card_pay_amount"];
//        } else if (accountCard.cardType == XIHUCARD) {
//            [param setObject:@(accountCard.cardCanPayMoney) forKey:@"xh_card_pay_amount"];
//        }
        [param setObject:@(accountCard.cardType) forKey:@"pay_card_type"];
    }
    
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"pay_order_list" parameters:param completionBlock:^(NSDictionary *data) {

        NSDictionary *payReq = [data objectForKey:@"pay_req"];
        PayReq *request = nil;
        
        PayZhaoHangReg *payZHReg = [[PayZhaoHangReg alloc] init];
        if (payWay == 3) {
            //http://61.144.248.29:801/netpayment/BaseHttp.dll?PrePayEUserP?BranchID=xxxx&CoNo=xxxxxx&BillNo=xxxxxx&Amount=xxxx.xx&Date=YYYYMMDD&ExpireTimeSpan=xx&MerchantUrl=xxxxxx&MerchantPara=xxxxxx&MerchantCode=xx&MerchantRetUrl=xxxxxx&MerchantRetPara=xxxxxx
            PayZhaoHangReg *payReg = [[PayZhaoHangReg alloc] initWithJSONDictionary:payReq];
            payZHReg = payReg;
        } else {
            if (payReq != nil && [payReq isKindOfClass:[NSDictionary class]]) {
                request = [[PayReq alloc] init];
                request.openID = WXAppId;
                request.partnerId = [payReq stringValueForKey:@"partnerid"];
                request.prepayId= [payReq stringValueForKey:@"prepayid"];
                request.package = [payReq stringValueForKey:@"packagestr"];
                request.nonceStr= [payReq stringValueForKey:@"noncestr"];
                request.timeStamp = [[payReq stringValueForKey:@"timestamp"] intValue];
                request.sign= [payReq stringValueForKey:@"sign"];
                
            }
        }
        
        if (payWay == PayWayTransfer) {
            PayTipVo * payTipVo = [[PayTipVo alloc] initWithJSONDictionary:[data objectForKey:@"pay_tip"]];
            if (completion) completion(payTipVo.showText,request,payTipVo.fuzhiText, payZHReg);
        }else{
            if (completion) completion([data stringValueForKey:@"pay_url"],request,[data stringValueForKey:@"upPayTn"], payZHReg);
        }
 
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getOrderDetail:(NSString*)orderId
                    completion:(void (^)(NSDictionary *orderDetail))completion
                       failure:(void (^)(XMError *error))failure
{
    if (orderId && [orderId length]>0) {
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"order_id":orderId,
                                     @"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"order_detail" parameters:parameters completionBlock:^(NSDictionary *data) {
            if (completion)completion([data dictionaryValueForKey:@"order_detail"]);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)getOrderDetailList:(NSArray*)orderIds
                        completion:(void (^)(NSArray *orderDetails))completion
                           failure:(void (^)(XMError *error))failure
{
    if (orderIds && [orderIds count]>0) {
        
        NSMutableString *strOrderIds = [[NSMutableString alloc] initWithCapacity:[orderIds count]];
        for (NSString *orderId in orderIds) {
            if ([strOrderIds length]>0) {
                [strOrderIds appendString:@"|"];
            }
            [strOrderIds appendString:orderId];
        }
        
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"order_ids":strOrderIds,
                                     @"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"order_detail_list" parameters:parameters completionBlock:^(NSDictionary *data) {
            if (completion)completion([data arrayValueForKey:@"order_detail_list"]);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)tryDelayReceipt:(NSString*)orderId
                     completion:(void (^)(NSInteger result, NSString *message))completion
                        failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"order_id":orderId,
                                 @"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"try_delay" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"result" defaultValue:0],[data stringValueForKey:@"message"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)delayReceipt:(NSString*)orderId
                  completion:(void (^)(NSInteger delayDays))completion
                     failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"order_id":orderId,
                                 @"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"delay" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"delay_days" defaultValue:3]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)confirmReceived:(NSString*)orderId
                     completion:(void (^)(NSDictionary *statusInfo))completion
                        failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"order_id":orderId,
                                 @"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"confirm_received" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data dictionaryValueForKey:@"status_info"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)logistics:(NSString*)orderId
               completion:(void (^)(NSString *html5Url))completion
                  failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"order_id":orderId,
                                 @"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"mail_url" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data stringValueForKey:@"mail_url"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);

    } queue:nil];
}

- (void)updaloadPics:(NSArray*)picFilePaths
          completion:(void (^)(NSArray *picUrlArray))completion
             failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"file" path:@"upload_pics" parameters:parameters fileName:@"pics" filePathArray:picFilePaths constructingBodyWithBlock:nil completionBlock:^(NSDictionary *data) {
        if (completion) {
            completion([data arrayValueForKey:@"url_list"]);
        }
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil]];
}

- (HTTPRequest*)checkUpdate:(NSString*)version
         completion:(void (^)(NSDictionary *versionInfo))completion
            failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"platform":@"iOS",
                                 @"version":version,
                                 @"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"platform" path:@"checkupdate" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data dictionaryValueForKey:@"latest_version"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (void)statForGoods:(NSString*)goodsId completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure {
    
    if ([goodsId length]>0) {
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"event":[NSNumber numberWithInteger:1],
                                     @"goods_id":goodsId,
                                     @"user_id":[NSNumber numberWithInteger:userId]};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"platform" path:@"add_stat" parameters:parameters completionBlock:^(NSDictionary *data) {
            if (completion)completion();
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil]];
    }
}

- (HTTPRequest *)getFilterInfoList:(NSString*)keywords
                            params:(NSString*)params
                          sellerId:(NSInteger)sellerId
                        completion:(void (^)(NSInteger totalNum, NSString *queryKey, NSString *standardWords, NSArray *filterInfoArray,long long timestamp))completion
                           failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"keywords":keywords?keywords:@"",
                                 @"params":params?params:@"",
                                 @"user_id":[NSNumber numberWithInteger:userId],
                                 @"seller_id":[NSNumber numberWithInteger:sellerId]};
    
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"filter" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSString *standardWords = [data stringValueForKey:@"standard_words"];
        NSString *queryKey = [data stringValueForKey:@"query_key"];
        NSInteger totalNum = [data integerValueForKey:@"total_num" defaultValue:0];
        long long timestamp = [data longLongValueForKey:@"timestamp"];
        if (completion) completion(totalNum,queryKey,standardWords,[data arrayValueForKey:@"list"],timestamp);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)getHotWords:(void (^)(NSDictionary *data))completion
                    failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"hot_words" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)shareGoodsWith:(NSString*)goodsId
                     completion:(void (^)(int statusInfo))completion
                        failure:(void (^)(XMError *error))failure
{
    NSDictionary *parameters = @{@"goods_id":goodsId};
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"share" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data intValueForKey:@"share_num"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)deleteConsignGoods:(NSInteger)consignId
                        completion:(void (^)())completion
                           failure:(void (^)(XMError *error))failure{
    NSDictionary *parameters = @{@"consign_id":@(consignId)};
    return  [[NetworkManager sharedInstance] requestWithMethodPOST:@"consignment" path:@"cancel_consignment" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest*)listAvailableBonusByOrderList:(NSArray*)orderIds
                                   completion:(void (^)(NSArray *itemList))completion
                                      failure:(void (^)(XMError *error))failure {
    if (orderIds!=nil) {
        
        NSMutableString *strOrderIds = [[NSMutableString alloc] initWithCapacity:[orderIds count]];
        for (NSString *orderId in orderIds) {
            if ([strOrderIds length]>0) {
                [strOrderIds appendString:@"|"];
            }
            [strOrderIds appendString:orderId];
        }
        
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"order_ids":strOrderIds,
                                     @"user_id":[NSNumber numberWithInteger:userId]};
        
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"bonus" path:@"list_by_orders" parameters:parameters completionBlock:^(NSDictionary *data) {
            NSArray *list = [data arrayValueForKey:@"list"];
            if (completion)completion(list);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)listXiHuCardByOrderList:(NSArray*)orderIds
                                bonusId:(NSString *)bonusId
                       isUseRewardMoney:(NSInteger)isUseRewardMoney
                                   completion:(void (^)(NSArray *itemList))completion
                                      failure:(void (^)(XMError *error))failure {
    if (orderIds!=nil) {
        
        NSMutableString *strOrderIds = [[NSMutableString alloc] initWithCapacity:[orderIds count]];
        for (NSString *orderId in orderIds) {
            if ([strOrderIds length]>0) {
                [strOrderIds appendString:@"|"];
            }
            [strOrderIds appendString:orderId];
        }
        
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"order_ids":strOrderIds,
                                     @"user_id":[NSNumber numberWithInteger:userId]};
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        if (bonusId && bonusId.length > 0) {
            [param setObject:bonusId forKey:@"bonusId"];
        } else {
            [param setObject:@"" forKey:@"bonusId"];
        }
        [param setObject:@(isUseRewardMoney) forKey:@"isUseRewardMoney"];
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"account_card" path:@"list_by_orders" parameters:param completionBlock:^(NSDictionary *data) {
            NSArray *list = [data arrayValueForKey:@"pay_card_list"];
            if (completion)completion(list);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)listAvailableBonusByGoodsList:(NSArray*)goodsIds
                                   completion:(void (^)(NSArray *itemList))completion
                                      failure:(void (^)(XMError *error))failure {
    if (goodsIds!=nil) {
        NSMutableString *strGoodsIds = [[NSMutableString alloc] initWithCapacity:[goodsIds count]];
        for (NSString *goodsId in goodsIds) {
            if ([strGoodsIds length]>0) {
                [strGoodsIds appendString:@"|"];
            }
            [strGoodsIds appendString:goodsId];
        }
        
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"goods_ids":strGoodsIds,
                                     @"user_id":[NSNumber numberWithInteger:userId]};
        return [[NetworkManager sharedInstance] requestWithMethodGET:@"bonus" path:@"list_by_goods" parameters:parameters completionBlock:^(NSDictionary *data) {
            NSArray *list = [data arrayValueForKey:@"list"];
            if (completion)completion(list);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)listXiHuCardByGoodsList:(NSArray*)goodsIds
                                brandId:(NSString *)bonusId
                       isUseRewardMoney:(NSInteger)isUseRewardMoney
                                   completion:(void (^)(NSArray *itemList))completion
                                      failure:(void (^)(XMError *error))failure {
    if (goodsIds!=nil) {
//        NSMutableString *strGoodsIds = [[NSMutableString alloc] initWithCapacity:[goodsIds count]];
//        for (NSString *goodsId in goodsIds) {
//            if ([strGoodsIds length]>0) {
//                [strGoodsIds appendString:@"|"];
//            }
//            [strGoodsIds appendString:goodsId];
//        }
        
        NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//        [param setObject:strGoodsIds forKey:@"goods_ids"];
        [param setObject:goodsIds forKey:@"goods_list"];
        [param setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
        [param setObject:@(isUseRewardMoney) forKey:@"is_used_reward_money"];
        if (bonusId == nil) {
            [param setObject:@"" forKey:@"bonus_id"];
        } else {
            [param setObject:bonusId forKey:@"bonus_id"];
        }
//        NSDictionary *parameters = @{@"goods_ids":strGoodsIds,
//                                     @"user_id":[NSNumber numberWithInteger:userId],
//                                     @"bonusId":bonusId};
        return [[NetworkManager sharedInstance] requestWithMethodPOST:@"account_card" path:@"list_by_goods_map" parameters:param completionBlock:^(NSDictionary *data) {
            NSArray *list = [data arrayValueForKey:@"pay_card_list"];
            if (completion)completion(list);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil];
    }
    return nil;
}

- (HTTPRequest*)getGoodsPublish:(void (^)(NSDictionary *data))completion
                    failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"is_publish_qhs" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest *)getGlobalSeekDetail:(void (^)(NSDictionary *data))completion
                             failure:(void (^)(XMError *error))failure{
    
    return [[NetworkManager sharedInstance] requestWithMethodGET:@"recommend" path:@"get_seek_global_rvo" parameters:nil completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (HTTPRequest *)getEvaluationPrice:(NSArray *)picUrl
                           category:(NSInteger)category
                         completion:(void(^)(NSDictionary *data))completion
                            failure:(void (^)(XMError *error))failure{
    NSDictionary *parameters = @{@"pic":picUrl};
    NetworkManager *manager = [NetworkManager sharedInstance];
    manager.dynamicServerUrl = @"https://app-server-pic.aidingmao.com:8443";

   return [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"activity" path:@"evaluation_price" parameters:parameters fileName:@"pic" filePathArray:picUrl constructingBodyWithBlock:nil completionBlock:^(NSDictionary *data) {
        if (completion) completion(data);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil]];
 
}


@end



