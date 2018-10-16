//
//  Wallet.m
//  XianMao
//
//  Created by simon on 1/16/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "Wallet.h"

@implementation Wallet

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.moneyInfo = [MoneyInfo createWithDict:[dict dictionaryValueForKey:@"money_info"]];
        
        NSArray *paymentListDict = [dict arrayValueForKey:@"payment_list"];
        if ([paymentListDict isKindOfClass:[NSArray class]]) {
            NSMutableArray *paymentList = [[NSMutableArray alloc] initWithCapacity:[paymentListDict count]];
            for (NSInteger i=0;i<[paymentListDict count];i++) {
                NSDictionary *dict = [paymentListDict objectAtIndex:i];
                [paymentList addObject:[PaymentAccount createWithDict:dict]];
            }
            self.paymentList = paymentList;
        }
    }
    return self;
}

@end


@implementation PaymentAccount

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.account = [dict stringValueForKey:@"account"];
        self.accountName = [dict stringValueForKey:@"account_name"];
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
    }
    return self;
}

@end


@implementation MoneyInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)totalMoney {
    return CENT_INTEGER_TO_FLOAT_YUAN(_totalMoneyCent);
}

- (double)availableMoney {
    return CENT_INTEGER_TO_FLOAT_YUAN(_availableMoneyCent);//_availableMoney!=0?_availableMoney:
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _totalMoney = [[dict decimalNumberKey:@"money"] doubleValue];
        _availableMoney = [[dict decimalNumberKey:@"available_money"] doubleValue];
        _totalMoneyCent = [dict integerValueForKey:@"money_cent"];
        _availableMoneyCent = [dict integerValueForKey:@"available_money_cent"];
    }
    return self;
}

@end


@implementation WithdrawalInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)amount {
    return CENT_INTEGER_TO_FLOAT_YUAN(_amount_cent);
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _createtime = [dict longLongValueForKey:@"create_time" defaultValue:0];
        _userId = [dict integerValueForKey:@"user_id" defaultValue:0];
        _amount = [[dict decimalNumberKey:@"amount"] doubleValue];
        _amount_cent = [dict integerValueForKey:@"amount_cent"];
        //[dict doubleValueForKey:@"amount" defaultValue:0];
        _messsage = [dict stringValueForKey:@"message" defaultValue:@""];
        _result = [dict integerValueForKey:@"result" defaultValue:0];
        _type = [dict integerValueForKey:@"type" defaultValue:0];
        
    }
    return self;
}

@end
