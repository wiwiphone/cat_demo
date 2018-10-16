//
//  NSDictionary+Additions.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSDictionary+Additions.h"


@implementation NSDictionary (QiMiaoAdditions)

- (BOOL)boolValueForKey:(NSString *)key {
    return [self boolValueForKey:key defaultValue:NO];
}

- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id obj = [self objectForKey:key];
    return (obj == [NSNull null]||obj==nil) ? defaultValue
						: [obj boolValue];
}

- (NSInteger)integerValueForKey:(NSString *)key {
    return [self integerValueForKey:key defaultValue:0];
}

- (NSInteger)integerValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    id obj = [self objectForKey:key];
    return (obj == [NSNull null]||obj==nil) ? defaultValue : [obj integerValue];
}

- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key
{
    return [self unsignedIntegerValueForKey:key defaultValue:0];
}

- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
    id obj = [self objectForKey:key];
    return (obj == [NSNull null]||obj==nil)
    ? defaultValue : [obj unsignedIntegerValue];
}

- (int)intValueForKey:(NSString *)key {
    return [self intValueForKey:key defaultValue:0];
}

- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    id obj = [self objectForKey:key];
	return (obj == [NSNull null] || obj == nil)
				? defaultValue : [obj intValue];
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj == [NSNull null] || obj == nil)
        return nil;
    else if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }
    return nil;
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj == [NSNull null] || obj == nil)
        return nil;
    else if (obj && [obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    }
    return nil; 
}

- (time_t)timeValueForKey:(NSString *)key {
    return [self timeValueForKey:key defaultValue:0];
}

- (time_t)timeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	id timeObject = [self objectForKey:key];
    if ([timeObject isKindOfClass:[NSNumber class]]) {
        NSNumber *n = (NSNumber *)timeObject;
        CFNumberType numberType = CFNumberGetType((CFNumberRef)n);
        NSTimeInterval t;
        if (numberType == kCFNumberLongLongType) {
            t = [n longLongValue] / 1000;
        }
        else {
            t = [n longValue];
        }
        return t;
    }
    else if ([timeObject isKindOfClass:[NSString class]]) {
        NSString *stringTime   = timeObject;
        if (stringTime.length == 13) {
            long long llt = [stringTime longLongValue];
            NSTimeInterval t = llt / 1000;
            return t;
        }
        else if (stringTime.length == 10) {
            long long lt = [stringTime longLongValue];
            NSTimeInterval t = lt;
            return t;
        }
        else {
            if (!stringTime || (id)stringTime == [NSNull null]) {
                stringTime = @"";
            }
            struct tm created;
            time_t now;
            time(&now);
            
            if (stringTime) {
                if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
                    strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
                }
                return mktime(&created);
            }
        }
    }
	return defaultValue;
}

- (long long)longLongValueForKey:(NSString *)key {
    return [self longLongValueForKey:key defaultValue:0];
}

- (long long)longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id obj = [self objectForKey:key];
	return obj == [NSNull null] || obj == nil
		? defaultValue : [obj longLongValue];
}

- (NSDecimalNumber*)decimalNumberKey:(NSString*)key {
    return [self decimalNumberKey:key defaultValue:0.f];
}

- (NSDecimalNumber*)decimalNumberKey:(NSString*)key defaultValue:(float)defaultValue {
    id obj = [self objectForKey:key];
    return obj == [NSNull null] || obj == nil || ![obj isKindOfClass:[NSNumber class]]
    ? [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",defaultValue]] : [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",(NSNumber*)obj]];
}

- (double)doubleValueForKey:(NSString *)key {
    return [self doubleValueForKey:key defaultValue:0];
}

- (double)doubleValueForKey:(NSString *)key defaultValue:(double)defaultValue {
    id obj = [self objectForKey:key];
	return obj == [NSNull null] || obj == nil || ![obj isKindOfClass:[NSNumber class]]
    ? defaultValue : [obj doubleValue];
}

- (float)floatValueForKey:(NSString *)key
{
    return [self floatValueForKey:key defaultValue:0];
}

- (float)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue
{
    id obj = [self objectForKey:key];
    return (obj == [NSNull null] ||obj==nil|| ![obj isKindOfClass:[NSNumber class]])
    ? defaultValue : [obj floatValue];
}

- (NSString *)stringValueForKey:(NSString *)key {
    return [self stringValueForKey:key defaultValue:@""];
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id obj = [self objectForKey:key];
    return (obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSString class]])
                                                    ?defaultValue:obj;
}

- (NSDate*)dateValueForKey:(NSString*)key {
    id obj = [self objectForKey:key];
    if (obj == nil || obj == [NSNull null]) {
        return nil;
    }
    if ([obj isKindOfClass:[NSDate class]]) {
        return (NSDate*)obj;
    }
    return nil;
}

- (NSArray *)arrayObjectForKey:(NSString *)key 
                   defaultValue:(NSArray *)defaultValue {
    id obj = [self objectForKey:key];
	return (obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSArray class]])
    ? defaultValue : obj;   
}

- (NSArray *)arrayObjectForKey:(NSString *)key  {
    return [self arrayObjectForKey:key defaultValue:nil];
}

- (NSDictionary *)dictionaryObjectForKey:(NSString *)key  
                             defaultValue:(NSDictionary *)defaultValue {
    id obj = [self objectForKey:key];
	return (obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSDictionary class]])
    ? defaultValue : obj;   
}

- (NSDictionary *)dictionaryObjectForKey:(NSString *)key {
    return [self dictionaryObjectForKey:key defaultValue:nil];
}

@end
