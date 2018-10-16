//
//  InvitationVo.h
//  XianMao
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "Share.h"

@interface InvitationVo : JSONModel

@property (nonatomic, assign) NSInteger totalRewardMoney;
@property (nonatomic, assign) NSInteger hasReceived;
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, assign) NSInteger invite_num;
@property (nonatomic, assign) NSInteger bonus_num;
@property (nonatomic, strong) Share * share;

@end



