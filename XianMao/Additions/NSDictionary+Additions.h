//
//  NSDictionary+Additions.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (QiMiaoAdditions)

- (BOOL)boolValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSInteger)integerValueForKey:(NSString *)key;
- (NSInteger)integerValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (int)intValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)timeValueForKey:(NSString *)key;
- (time_t)timeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)longLongValueForKey:(NSString *)key;
- (long long)longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)stringValueForKey:(NSString *)key;
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDictionary *)dictionaryValueForKey:(NSString *)key;
- (NSArray *)arrayValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;
- (float)floatValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (NSDate*)dateValueForKey:(NSString*)key;

- (NSDecimalNumber*)decimalNumberKey:(NSString*)key;
- (NSDecimalNumber*)decimalNumberKey:(NSString*)key defaultValue:(float)defaultValue;

@end


