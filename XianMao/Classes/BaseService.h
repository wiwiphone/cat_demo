//
//  BaseService.h
//  XianMao
//
//  Created by simon on 12/29/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "RedirectInfo.h"
#import "JSONModel.h"

@interface BaseService : MBSimpleSingletonCommand

@end


@interface PlatformService : BaseService

+ (void)launchPage:(void (^)(NSArray *pageInfoList))completion
           failure:(void (^)(XMError *error))failure;

+ (void)post_feedback:(NSString*)content
           completion:(void (^)())completion
              failure:(void (^)(XMError *error))failure;

+ (NSArray*)loadRedirectListFromFile;

+ (void)get_sensitivity_words:(void (^)(NSArray *sensitivityWordsArray))completion
                      failure:(void (^)(XMError *error))failure;

+ (void)loadSensitivityWords:(void (^)(NSArray *sensitivityWordsArray))completion;

+ (void)report:(NSInteger)user_id
          type:(NSString*)type
       content:(NSString*)content
    completion:(void (^)())completion
       failure:(void (^)(XMError *error))failure;

@end

//platform/launch_page[GET]
//platform/feedback[POST] {content} 用户反馈 @卢云 @白骁



@interface LaunchPageInfo : NSObject <NSCoding>

@property(nonatomic,assign) long long expireTimeStamp;
@property(nonatomic,strong) RedirectInfo *redirectInfo;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


@interface SensitivityWords : JSONModel<NSCoding>
@property(nonatomic,strong) NSArray *words;
@property(nonatomic,copy) NSString *remind;
@end


//http://121.43.227.144:8000/brand/get_list



