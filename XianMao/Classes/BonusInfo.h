//
//  BonusInfo.h
//  XianMao
//
//  Created by simon on 2/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BonusInfo : NSObject

@property(nonatomic,copy) NSString *bonusId;
@property(nonatomic,assign) NSInteger type;
@property (nonatomic, copy) NSString *bonusName;
@property(nonatomic,copy) NSString *bonusDesc;
@property(nonatomic,assign) NSInteger senderId;
@property(nonatomic,assign) double amount;
@property(nonatomic,assign) double minPayAmount;
@property(nonatomic,assign) NSInteger amountCent;
@property(nonatomic,assign) NSInteger minPayAmountCent;
@property(nonatomic,assign) long long sendStartTime;
@property(nonatomic,assign) long long sendEndTime;
@property(nonatomic,assign) long long useStartTime;
@property(nonatomic,assign) long long useEndTime;
@property(nonatomic,assign) NSInteger status;
@property (nonatomic , assign) NSInteger canUse;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (NSString*)strUseStartTime;
- (NSString*)strUseEndTime;

- (BOOL)isUsed;
- (BOOL)isExpired;

@end





