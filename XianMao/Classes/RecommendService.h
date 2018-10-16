//
//  RecommendService.h
//  XianMao
//
//  Created by simon cai on 14/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"
#import "RedirectInfo.h"
#import "RecommendInfo.h"

@interface RecommendService : BaseService

+ (void)launch_list:(void (^)(NSArray *list))completion
             failure:(void (^)(XMError *error))failure;

+ (void)publish_info:(void (^)(NSArray *list))completion
            failure:(void (^)(XMError *error))failure;

@end



