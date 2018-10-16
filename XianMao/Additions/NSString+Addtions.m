//
//  NSString+Addtions.m
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "NSString+Addtions.h"
#import <CommonCrypto/CommonDigest.h>

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation NSString (Addtions)

- (NSString *)urlFriendlyFileNameWithExtension:(NSString *)extension prefixID:(int)prefixID
{
    if (self.length == 0) return @"";
    
    NSString *umlaut = [self stringByReplacingOccurrencesOfString:@"ß" withString:@"ss"];
    umlaut = [umlaut stringByReplacingOccurrencesOfString:@"ä" withString:@"ae"];
    umlaut = [umlaut stringByReplacingOccurrencesOfString:@"ö" withString:@"oe"];
    umlaut = [umlaut stringByReplacingOccurrencesOfString:@"ü" withString:@"ue"];
    umlaut = [umlaut stringByReplacingOccurrencesOfString:@"Ä" withString:@"Ae"];
    umlaut = [umlaut stringByReplacingOccurrencesOfString:@"Ö" withString:@"Oe"];
    umlaut = [umlaut stringByReplacingOccurrencesOfString:@"Ü" withString:@"Ue"];
    
    NSMutableCharacterSet *charactersToRemove = [[[ NSCharacterSet alphanumericCharacterSet ] invertedSet ] mutableCopy];
    [charactersToRemove removeCharactersInString:@"-+"];
    NSString *cleanTitle = [[umlaut componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@"_"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"__+" options:NSRegularExpressionCaseInsensitive error:nil];
    cleanTitle = [regex stringByReplacingMatchesInString:cleanTitle options:0 range:NSMakeRange(0, [cleanTitle length]) withTemplate:@"_"];
    
    if ([[cleanTitle substringWithRange:NSMakeRange([cleanTitle length]-1, 1)] isEqualToString:@"_"])
    {
        cleanTitle = [cleanTitle substringWithRange:NSMakeRange(0, [cleanTitle length]-1)];
    }
    
    if (!prefixID)
    {
        return [cleanTitle stringByAppendingPathExtension:extension];
    }
    
    return [[[NSString stringWithFormat:@"%i-%@",prefixID, cleanTitle] lowercaseString] stringByAppendingPathExtension:extension];
}

- (NSString *)urlFriendlyFileName
{
    NSString *fileExtension = [self pathExtension];
    return [[self stringByReplacingOccurrencesOfString:fileExtension withString:@""] urlFriendlyFileNameWithExtension:fileExtension prefixID:0];
}

- (NSString *)stringByAppendingURLPathComponent:(NSString *)pathComponent
{
    NSString *protocol = ([self hasPrefix:@"https://"]) ? @"https://" : @"http://";
    NSString *cleanedStr = [self stringByReplacingOccurrencesOfString:protocol withString:@""];
    return [NSString stringWithFormat:@"%@%@",protocol, [cleanedStr stringByAppendingPathComponent:pathComponent]];
}

- (NSString *)stringByDeletingLastURLPathComponent
{
    NSString *protocol = ([self hasPrefix:@"https://"]) ? @"https://" : @"http://";
    NSString *cleanedStr = [self stringByReplacingOccurrencesOfString:protocol withString:@""];
    return [NSString stringWithFormat:@"%@%@",protocol, [cleanedStr stringByDeletingLastPathComponent]];
}

- (NSString *)sha512
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (int)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)base64Encode
{
    NSData *objData = [self dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = (int)[objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Create result NSString object
    NSString *base64String = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    
    // Free memory
    free(strResult);
    
    return base64String;
}

- (NSString *)base64Decode
{
    const char *objPointer = [self cStringUsingEncoding:NSASCIIStringEncoding];
    size_t intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char *objResult = calloc(intLength, sizeof(unsigned char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
        if (intCurrent == '=') {
            if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1) {
            // we're at a whitespace -- simply skip over
            continue;
        } else if (intCurrent == -2) {
            // we're at an invalid character
            free(objResult);
            return nil;
        }
        
        switch (i % 4) {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    k = j;
    if (intCurrent == '=') {
        switch (i % 4) {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
    free(objResult);
    return [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding];
}

- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

- (NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)localCachePath
{
    NSString *filename = [self sha512];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/%@.%@",[paths objectAtIndex:0],filename,self.pathExtension];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isNumeric
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)containsString:(NSString *)needle
{
    if (!self.length) return NO;
    return ([self rangeOfString:needle].location == NSNotFound) ? NO : YES;
}

__attribute__((overloadable))
NSString *substr(NSString *str, int start)
{
    return substr(str, start, 0);
}

__attribute__((overloadable))
NSString *substr(NSString *str, int start, int length)
{
    NSInteger str_len = str.length;
    if (!str_len) return @"";
    if (str_len < length) return str;
    if (start < 0 && length == 0)
    {
        return [str substringFromIndex:str_len+start];
    }
    if (start == 0 && length > 0)
    {
        return [str substringToIndex:length];
    }
    if (start < 0 && length > 0)
    {
        return [[str substringFromIndex:str_len+start] substringToIndex:length];
    }
    if (start > 0 && length > 0)
    {
        return [[str substringFromIndex:start] substringToIndex:length];
    }
    if (start > 0 && length == 0)
    {
        return [str substringFromIndex:start];
    }
    if (length < 0)
    {
        NSString *tmp_str;
        if (start < 0)
        {
            tmp_str = [str substringFromIndex:str_len+start];
        }
        else
        {
            tmp_str = [str substringFromIndex:start];
        }
        NSInteger tmp_str_len = tmp_str.length;
        if (tmp_str_len + length <= 0) return @"";
        return [tmp_str substringToIndex:tmp_str_len+length];
    }
    
    return str;
}

- (BOOL)isChinese {
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChineseMobileNumber
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [regextestmobile evaluateWithObject:self];
    
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d)\\\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNumber] == YES)
//        || ([regextestcm evaluateWithObject:mobileNumber] == YES)
//        || ([regextestct evaluateWithObject:mobileNumber] == YES)
//        || ([regextestcu evaluateWithObject:mobileNumber] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

+ (NSString*)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

+(BOOL)isContainsEmoji:(NSString *)string {
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x278a && hs != 0x263b) {
                 isEomji = YES;
             } else
                 if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
             if (!isEomji && substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 if (ls == 0x20e3) {
                     isEomji = YES;
                 }
             }
         }
     }];
    
//         const unichar hs = [substring characterAtIndex:0];
//         
//         // surrogate pair
//         
//         if (0xd800 <= hs && hs <= 0xdbff) {
//             
//             if (substring.length > 1) {
//                 
//                 const unichar ls = [substring characterAtIndex:1];
//                 
//                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                 
//                 if (0x1d000 <= uc && uc <= 0x1f77f) {
//                     
//                     isEomji = YES;
//                 }
//             }
//             
//         } else if (substring.length > 1) {
//             
//             const unichar ls = [substring characterAtIndex:1];
//             
//             if (ls == 0x20e3) {
//                 
//                 isEomji = YES;
//                 
//             }
//         } else {
//             
//             // non surrogate
//             
//             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
//                 
//                 isEomji = YES;
//                 
//             } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                 
//                 isEomji = YES;
//                 
//             } else if (0x2934 <= hs && hs <= 0x2935) {
//                 
//                 isEomji = YES;
//                 
//             } else if (0x3297 <= hs && hs <= 0x3299) {
//                 
//                 isEomji = YES;
//                 
//             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
//                 
//                 isEomji = YES;
//                 
//             }
//             
//         }
//     }];
    return isEomji;
    
}

@end


@implementation NSObject (isEmpty)

- (BOOL)mag_isEmpty
{
    return self == nil || ([self respondsToSelector:@selector(length)] && [(NSData *)self length] == 0) || ([self respondsToSelector:@selector(count)] && [(NSArray *)self count] == 0);
}
@end

