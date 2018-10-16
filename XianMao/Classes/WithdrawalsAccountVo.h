//
//  WithdrawalsAccountVo.h
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawalsAccountVo : NSObject

@property (nonatomic, assign) NSInteger type;//提现账户类型 0，支付宝  ； 1，是银行卡
@property (nonatomic, copy) NSString * account;//账户
@property (nonatomic, copy) NSString * breviaryAccount;//账号缩略显示
@property (nonatomic, copy) NSString * bankName; //所属银行
@property (nonatomic, copy) NSString * belong;//所属者真实姓名
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * identityCard;//身份证号
@property (nonatomic, assign) double  available; //额度
@property (nonatomic, copy) NSString * usedAvailable; //已用额度
@property (nonatomic, assign) double  surplusAvailable; // 剩余额度
@property (nonatomic, copy) NSString * withdrawalsEexplain;
@property (nonatomic, copy) NSString * region; //地区
@property (nonatomic, copy) NSString * bankDeposit; //支行
@property (nonatomic, assign) NSInteger bankid;
@property (nonatomic, assign) NSInteger idd;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)creatWithDict:(NSDictionary *)dict;

@end
