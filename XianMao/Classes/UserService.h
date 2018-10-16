//
//  UserService.h
//  XianMao
//
//  Created by simon cai on 25/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"

@interface UserService : BaseService


+ (void)getRewardMoney:(void (^)(float reward_money))completion
               failure:(void (^)(XMError *error))failure;

+ (void)get_account:(void (^)(NSInteger reward_money_cent, NSInteger available_money_cent))completion
            failure:(void (^)(XMError *error))failure;


+ (void)shield:(NSInteger)other_user_id
    completion:(void (^)())completion
       failure:(void (^)(XMError *error))failure;

///chat/shield[POST]{user_id, other_user_id} 屏蔽聊天


//user/get_account[GET]{user_id} 获取个人资金账户信息 {reward_money_cent（i)奖励金额, available_money_cent(i)可用资金 }     资金到分

//原来的get_reward_money改掉，以后不用了。   以后到分的都是_cent结尾。  @卢云 @白骁

@end
