//
//  NSString+Addtions.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addtions)

- (NSString *)urlFriendlyFileNameWithExtension:(NSString *)extension prefixID:(int)prefixID;
- (NSString *)urlFriendlyFileName;
- (NSString *)stringByAppendingURLPathComponent:(NSString *)pathComponent;
- (NSString *)stringByDeletingLastURLPathComponent;

- (NSString *)sha512;
- (NSString *)base64Encode;
- (NSString *)base64Decode;

- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end;

- (NSString *)stringByStrippingHTML;
- (NSString *)localCachePath;

- (NSString *)trim;
- (BOOL)isNumeric;
- (BOOL)isPureFloat;
- (BOOL)containsString:(NSString *)needle;

__attribute__((overloadable))
NSString *substr(NSString *str, int start);
__attribute__((overloadable))
NSString *substr(NSString *str, int start, int length);


- (BOOL)isChinese;
- (BOOL)isChineseMobileNumber;

+ (NSString*)disable_emoji:(NSString *)text;
+(BOOL)isContainsEmoji:(NSString *)string;

@end

@interface NSObject (isEmpty)

- (BOOL)mag_isEmpty;

@end

