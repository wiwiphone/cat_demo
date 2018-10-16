//
//  BaseService.m
//  XianMao
//
//  Created by simon on 12/29/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseService.h"
#import "Session.h"
#import "AppDirs.h"
#import "RedirectInfo.h"

#import "NSDate+Additions.h"
#import "AppDirs.h"
#import "JSONKit.h"

@implementation BaseService

@end


@implementation PlatformService

+ (void)launchPage:(void (^)(NSArray *pageInfoList))completion
           failure:(void (^)(XMError *error))failure
{
    NSInteger width = kScreenWidth*kScreenScale;
    NSInteger height = kScreenHeight*kScreenScale;
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"device_type":@"iPhone",
                                 @"display_density":[NSString stringWithFormat:@"%ldx%ld",(long)width,(long)height],
                                 @"access":[self reachTypeString]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"platform" path:@"launch_page" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *launchInfoList = [[NSMutableArray alloc] init];
        NSArray *array = [data arrayValueForKey:@"list"];
        for (NSDictionary *dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [launchInfoList addObject:[LaunchPageInfo createWithDict:dict]];
            }
        }
        [self saveRedirectListToFile:launchInfoList];
        if (completion)completion(launchInfoList);
    } failure:^(XMError *error) {
        
    } queue:nil]];
}

+ (NSString*)reachTypeString
{
    NSString *reachType = @"";
    if([[NetworkManager sharedInstance] isReachable])
    {
        if ([[NetworkManager sharedInstance] isReachableViaWiFi]) {
            reachType = @"WIFI";
        } else {
            reachType = @"3G";
        }
    }
    return reachType;
}

//display_density=640x960
//device_type=iPhone

//“expire_seconds”: 86400,
//“expire_timestamp”: 1430236800,

+ (void)saveRedirectListToFile:(NSArray*)array
{
    if ([array count]>0) {
        NSString *cacheFile = [AppDirs launchPageDataFile];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:array forKey:@"launch_page"];
        [archiver encodeObject:[NSDate date] forKey:@"fetch_timestamp"];
        [archiver finishEncoding];
        [data writeToFile:cacheFile atomically:YES];
    } else {
        NSString *cacheFile = [AppDirs launchPageDataFile];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:cacheFile error:nil];
    }
}

+ (NSArray*)loadRedirectListFromFile {
    NSMutableArray *redirectList = [[NSMutableArray alloc] init];
    NSString *cacheFile = [AppDirs launchPageDataFile];
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:cacheFile isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *array = [unarchiver decodeObjectForKey:@"launch_page"];
//        NSDate *date = [unarchiver decodeObjectForKey:@"fetch_timestamp"];
//        NSTimeInterval timestamp = [date timeIntervalSince1970];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        
        for (LaunchPageInfo *info in array) {
            if ([info isKindOfClass:[LaunchPageInfo class]]) {
                NSTimeInterval expireTimeStamp = [[NSDate dateFromLongLongSince1970:info.expireTimeStamp] timeIntervalSince1970];
                if (now<expireTimeStamp) {
                    [redirectList addObject:info];
                }
            }
        }
        [unarchiver finishDecoding];
    }
    return redirectList;
}

+ (void)post_feedback:(NSString*)content
           completion:(void (^)())completion
              failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"content":content?content:@""};
    
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"platform" path:@"feedback" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)get_sensitivity_words:(void (^)(NSArray *sensitivityWordsArray))completion
                      failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"platform" path:@"get_sensitivity_words" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *sensitivityWordsArray = [[NSMutableArray alloc] init];
        NSArray *array = [data arrayValueForKey:@"sensitive_words"];
        if ([array isKindOfClass:[NSArray class]] && [array count]>0) {
            for (NSDictionary *dict in array) {
                [sensitivityWordsArray addObject:[[SensitivityWords alloc] initWithJSONDictionary:dict]];
            }
        }
        if (completion)completion(sensitivityWordsArray);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)loadSensitivityWords:(void (^)(NSArray *sensitivityWordsArray))completion {
    BOOL isNeedRefreshSensitivityWords = NO;
    NSString *filePath = [AppDirs sensitiveWordsCacheFilePath];
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory] && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:[AppDirs sensitiveWordsCacheFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dict = [unarchiver decodeObjectForKey:@"data"];
        [unarchiver finishDecoding];
        if (completion) {
            completion([dict arrayValueForKey:@"sensitivity_words"]);
        }
        NSDate *date = [dict objectForKey:@"timestamp"];
        if (date) {
            NSTimeInterval timestamp = [date timeIntervalSince1970];
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            if (now-timestamp>8*60*60) {
                isNeedRefreshSensitivityWords = YES;
            }
        } else {
            isNeedRefreshSensitivityWords = YES;
        }
    } else {
        isNeedRefreshSensitivityWords = YES;
        
        NSMutableArray *sensitivityWordsArray = [[NSMutableArray alloc] init];
        NSString* filePath =[[NSBundle mainBundle] pathForResource:@"sensitive_words" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        JSONDecoder *parser = [JSONDecoder decoder];
        id result = [parser mutableObjectWithData:jsonData error:&error];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result;
            NSArray *array = [dict arrayValueForKey:@"sensitive_words"];
            if ([array isKindOfClass:[NSArray class]] && [array count]>0) {
                for (NSDictionary *dict in array) {
                    [sensitivityWordsArray addObject:[[SensitivityWords alloc] initWithJSONDictionary:dict]];
                }
            }
        }
        if (completion) {
            completion(sensitivityWordsArray);
        }
    }
    
    if (isNeedRefreshSensitivityWords) {
        [self get_sensitivity_words:^(NSArray *sensitivityWordsArray) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:sensitivityWordsArray forKey:@"sensitivity_words"];
            [dict setObject:[NSDate date] forKey:@"timestamp"];
            
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:dict forKey:@"data"];
            [archiver finishEncoding];
            [data writeToFile:[AppDirs sensitiveWordsCacheFilePath] atomically:YES];
        } failure:^(XMError *error) {
        }];
    }
}

+ (void)report:(NSInteger)user_id
          type:(NSString*)type
       content:(NSString*)content
    completion:(void (^)())completion
       failure:(void (^)(XMError *error))failure {
    NSInteger report_user_id = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"report_user_id":[NSNumber numberWithInteger:report_user_id],
                                 @"user_id":[NSNumber numberWithInteger:user_id],
                                 @"type_name":type?type:@"",
                                 @"content":content?content:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"chat" path:@"report" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}
//chat/report[post] {user_id（被举报者）, report_user_id（举报者）,  content}举报

@end


//platform/get_sensitivity_words【GET】 获取敏感词

@implementation LaunchPageInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _expireTimeStamp = [dict longLongValueForKey:@"expire_timestamp"];
        _redirectInfo = [RedirectInfo createWithDict:[dict dictionaryValueForKey:@"redirect_info"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithLongLong:self.expireTimeStamp]  forKey:@"expireTimeStamp"];
    [encoder encodeObject:self.redirectInfo forKey:@"redirectInfo"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.expireTimeStamp = [[decoder decodeObjectForKey:@"expireTimeStamp"] longLongValue];
        self.redirectInfo = [decoder decodeObjectForKey:@"redirectInfo"];
    }
    return self;
}

@end


@implementation SensitivityWords

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.words  forKey:@"words"];
    [encoder encodeObject:self.remind?self.remind:@"" forKey:@"remind"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.words = [decoder decodeObjectForKey:@"words"];
        self.remind = [decoder decodeObjectForKey:@"remind"];
    }
    return self;
}

@end


