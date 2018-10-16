//
//  BonusInfo.m
//  XianMao
//
//  Created by simon on 2/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BonusInfo.h"

@implementation BonusInfo


+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)amount {
    return CENT_INTEGER_TO_FLOAT_YUAN(_amountCent);
}

- (double)minPayAmount {
    return CENT_INTEGER_TO_FLOAT_YUAN(_minPayAmountCent);
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _bonusId = [dict stringValueForKey:@"bonus_id"];
        _type = [dict integerValueForKey:@"type" defaultValue:-1];
        _bonusDesc = [dict stringValueForKey:@"description"];
        _senderId = [dict integerValueForKey:@"sender_id" defaultValue:0];
        _amount = [[dict decimalNumberKey:@"amount"] doubleValue];
        _minPayAmount = [[dict decimalNumberKey:@"min_pay_amount"] doubleValue];
        
        _amountCent = [dict integerValueForKey:@"amount_cent"];
        _minPayAmountCent = [dict integerValueForKey:@"min_pay_amount_cent"];
        
        _sendStartTime = [dict longLongValueForKey:@"send_start_time" defaultValue:0];
        _sendEndTime = [dict longLongValueForKey:@"send_end_time" defaultValue:0];
        _useStartTime = [dict longLongValueForKey:@"use_start_time" defaultValue:0];
        _useEndTime = [dict longLongValueForKey:@"use_end_time" defaultValue:0];
        
        _status = [dict integerValueForKey:@"status" defaultValue:0];
        _canUse = [dict intValueForKey:@"can_use" defaultValue:0];
        _bonusName = [dict stringValueForKey:@"bonus_name"];
    }
    return self;
}

- (NSString*)strUseStartTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_useStartTime/1000];//[NSDate date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];//日期的年月日
}

- (NSString*)strUseEndTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_useEndTime/1000];//[NSDate date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];// HH:mm:ss
    
    return [dateFormatter stringFromDate:date];//日期的年月日
}

- (BOOL)isUsed {
    return _status==1?YES:NO;
}

- (BOOL)isExpired {
    return _status==2?YES:NO;
}

@end


//private String bonus_id;
//
//private String description;
//
//private int seller_id;
//
//private BigDecimal amount;
//
//private BigDecimal min_pay_amount;
//
//private long send_start_time;
//
//private long send_end_time;
//
//private long use_start_time;
//
//private long use_end_time;
//
// status










