//
//  RewardService.h
//  XianMao
//
//  Created by simon cai on 24/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"

@interface RewardService : BaseService

+ (void)getInputInfo:(void (^)(BOOL is_receive, float reward_money, NSString *redirect_uri, NSString *invite_text,NSString *reward_desc))completion
           failure:(void (^)(XMError *error))failure;

+ (void)submitInputCode:(NSString*)code
             completion:(void (^)(BOOL is_receive, float reward_money, NSString *redirect_uri))completion
                failure:(void (^)(XMError *error))failure;

+ (void)getinvitationCode:(void (^)(NSString *invitation_code, float reward_money, NSString *redirect_uri, float gain_reward_money, NSString *share_text,NSString *share_url, NSString *invite_text))completion
                  failure:(void (^)(XMError *error))failure;

@end


