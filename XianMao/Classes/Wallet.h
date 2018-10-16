//
//  Wallet.h
//  XianMao
//
//  Created by simon on 1/16/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaymentAccount;
@class MoneyInfo;

@interface Wallet : NSObject

@property(nonatomic,strong) NSArray *paymentList;
@property(nonatomic,strong) MoneyInfo *moneyInfo;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface PaymentAccount : NSObject

@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *accountName;
@property(nonatomic,assign) NSInteger type;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface MoneyInfo : NSObject

@property(nonatomic,assign) CGFloat totalMoney;
@property(nonatomic,assign) CGFloat availableMoney;
@property(nonatomic,assign) CGFloat totalMoneyCent;
@property(nonatomic,assign) CGFloat availableMoneyCent;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface WithdrawalInfo : NSObject

@property(nonatomic,assign) long long createtime;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *messsage;
@property(nonatomic,assign) double amount;
@property(nonatomic,assign) NSInteger amount_cent;
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,assign) NSInteger userId;


+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;


//- (float)toalMoneyF;
//- (float)availableMoneyF;

@end


