//
//  HighestBidVo.h
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "RecoveryUserVo.h"

@interface HighestBidVo : JSONModel

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *goodsSn;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *payId;
@property (nonatomic, assign)long long orderExpTime;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger isAuth;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger order;

@property (nonatomic, assign) long long authExpTime;

@property (nonatomic, strong) RecoveryUserVo *recoveryUserVo;



@end
