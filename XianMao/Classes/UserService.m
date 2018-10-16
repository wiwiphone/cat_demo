//
//  UserService.m
//  XianMao
//
//  Created by simon cai on 25/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "UserService.h"
#import "Session.h"

@implementation UserService

+ (void)getRewardMoney:(void (^)(float reward_money))completion
             failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"get_reward_money" parameters:parameters completionBlock:^(NSDictionary *data) {
        float reward_money = [[data decimalNumberKey:@"reward_money"] floatValue];
        if (completion)completion(reward_money);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)get_account:(void (^)(NSInteger reward_money_cent, NSInteger available_money_cent))completion
            failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"user" path:@"get_account" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSInteger reward_money_cent = [data integerValueForKey:@"reward_money_cent"];
        NSInteger available_money_cent = [data integerValueForKey:@"available_money_cent"];
        if (completion)completion(reward_money_cent,available_money_cent);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


+ (void)shield:(NSInteger)other_user_id
    completion:(void (^)())completion
       failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"other_user_id":[NSNumber numberWithInteger:other_user_id]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"chat" path:@"shield" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}
//user/get_reward_money[GET] 返回 {reward_money} 获取 获奖总额

@end
