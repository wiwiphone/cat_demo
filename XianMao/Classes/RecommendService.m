//
//  RecommendService.m
//  XianMao
//
//  Created by simon cai on 14/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RecommendService.h"
#import "Session.h"

@implementation RecommendService

+ (void)launch_list:(void (^)(NSArray *list))completion
            failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recommend" path:@"launch_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *list = [data arrayValueForKey:@"list"];
        if ([list isKindOfClass:[NSArray class]] && [list count]>0) {
            for (NSDictionary *dict in list) {
                RedirectInfo *redirectInfo = [RedirectInfo createWithDict:dict];
                [array addObject:redirectInfo];
            }
        }
        if (completion)completion(array);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)publish_info:(void (^)(NSArray *recommendList))completion
             failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recommend" path:@"publish_info" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *recommendList = [[NSMutableArray alloc] init];
        NSArray *list = [data arrayValueForKey:@"list"];
        if ([list isKindOfClass:[NSArray class]] && [list count]>0) {
            for (NSDictionary *dict in list) {
                [recommendList addObject:[RecommendInfo createWithDict:dict]];
            }
        }
        if (completion) completion(recommendList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

@end

///recommend/launch_list[GET] 获取启动配置信息 ｛list｝
///recommend/publish_info[GET] 获取发布配置信息 ｛list｝


