//
//  InvitationUserVo.h
//  XianMao
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface InvitationUserVo : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger refUserId;
@property (nonatomic, copy) NSString *refUsername;
@property (nonatomic, copy) NSString *refUserAvatar;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) long long time;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger rewardMoney;
@property (nonatomic, copy) NSString *info;

@end
