//
//  DeviceUtil.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtil : NSObject

#pragma mark - enumerator
typedef NS_ENUM(NSUInteger, deviceId) {
    IPHONE3      = 0,
    IPHONE4      = 1,
    IPHONE5      = 2,
    IPHONE6      = 3,
    IPHONE6_PLUS = 4,
    IPAD         = 5,
    IPAD_RETINA  = 6,
    UNKNOWN      = 7
};

#pragma mark - public method
+ (NSUInteger)deviceId;
+ (BOOL)      isIphone3;
+ (BOOL)      isIphone4;
+ (BOOL)      isIphone5;
+ (BOOL)      isIphone6;
+ (BOOL)      isIphone6Plus;
+ (BOOL)      isIpad;
+ (BOOL)      isIpadRetina;
+ (BOOL)      isRetina;
+ (BOOL)      isLegacy;
+ (BOOL)      is3_5inch;
+ (BOOL)      is4inch;
+ (BOOL)      is4_7inch;
+ (BOOL)      is5_5inch;
+ (BOOL)      over4inch;
+ (BOOL)      isIOS6;
+ (BOOL)      isIOS7;
+ (BOOL)      isIOS8;
+ (CGFloat)   iOSVersion;
+ (CGFloat)   screenWidth;
+ (CGFloat)   screenHeight;
+ (CGRect)    screenRect;
+ (BOOL)      isJapaneseLanguage;
+ (BOOL)      isFrenchLanguage;
+ (BOOL)      isRussianLanguage;
+ (BOOL)      isChineseLanguage;
+ (BOOL)      isKoreanLanguage;
+ (BOOL)      isThaiLanguage;
+ (BOOL)      isMultiByteLanguage;
+ (BOOL)      isVideoCameraAvailable;
+ (NSString *)getOsAndVersion;
+ (NSString *)getDeviceModelName;
+ (NSString *)getCurrentDeviceModel;

@end


