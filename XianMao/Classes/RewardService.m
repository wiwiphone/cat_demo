//
//  RewardService.m
//  XianMao
//
//  Created by simon cai on 24/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RewardService.h"
#import "Session.h"

@implementation RewardService

+ (void)getInputInfo:(void (^)(BOOL is_receive, float reward_money, NSString *redirect_uri, NSString *invite_text,NSString *reward_desc))completion
             failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"reward" path:@"get_input_info" parameters:parameters completionBlock:^(NSDictionary *data) {
        BOOL is_receive = [data integerValueForKey:@"is_receive" defaultValue:0]>0?YES:NO;
        float reward_money = [[data decimalNumberKey:@"reward_money"] floatValue];
        NSString *redirect_uri = [data stringValueForKey:@"redirect_uri"];
        NSString *invite_text = [data stringValueForKey:@"invite_text"];
        NSString *reward_desc = [data stringValueForKey:@"reward_desc"];
        if (completion)completion(is_receive,reward_money,redirect_uri,invite_text,reward_desc);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];

}

+ (void)submitInputCode:(NSString*)code
             completion:(void (^)(BOOL is_receive, float reward_money, NSString *redirect_uri))completion
                failure:(void (^)(XMError *error))failure {
    if ([code length]>0) {
        NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"code":code};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"reward" path:@"input_code" parameters:parameters completionBlock:^(NSDictionary *data) {
            BOOL is_receive = [data integerValueForKey:@"is_receive" defaultValue:0]>0?YES:NO;
            float reward_money = [[data decimalNumberKey:@"reward_money"] floatValue];
            NSString *redirect_uri = [data stringValueForKey:@"redirect_uri"];
            if (completion)completion(is_receive,reward_money,redirect_uri);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil]];
    }
}

+ (void)getinvitationCode:(void (^)(NSString *invitation_code, float reward_money, NSString *redirect_uri, float gain_reward_money, NSString *share_text,NSString *share_url, NSString *invite_text))completion
                  failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"reward" path:@"get_invitation_code" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSString *invitation_code = [data stringValueForKey:@"invitation_code"];
        float gain_reward_money = [[data decimalNumberKey:@"gain_reward_money"] floatValue];;
        float reward_money = [[data decimalNumberKey:@"reward_money"] floatValue];
        NSString *redirect_uri = [data stringValueForKey:@"redirect_uri"];
        NSString *share_text = [data stringValueForKey:@"share_text"];
        NSString *share_url = [data stringValueForKey:@"share_url"];
        NSString *invite_text = [data stringValueForKey:@"invite_text"];
        if (completion)completion(invitation_code,reward_money,redirect_uri,gain_reward_money,share_text,share_url,invite_text);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
    
}




//user/get_reward_money[GET] 返回 {reward_money} 获取 获奖总额


//reward/get_input_info【GET】 返回｛is_receive, reward_money, redirect_uri｝ 输入邀请码 点击接口

//reward/input_code[POST] {code} 返回 ｛is_receive, reward_money, redirect_uri｝

//reward/get_invitation_code[GET]  返回｛invitation_code（邀请码）， reward_money，redirect_uri， gain_reward_money（已获）｝

@end


