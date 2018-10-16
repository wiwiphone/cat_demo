//
//  CategoryService.m
//  XianMao
//
//  Created by simon cai on 17/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "CategoryService.h"
#import "Session.h"
#import "GoodsEditableInfo.h"
#import "BrandInfo.h"

@implementation CategoryService

+ (void)getArecoveryAttrInfoList:(NSInteger)cateId
             completion:(void (^)(NSArray *attrInfoList))completion
                failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"cate_id":[NSNumber numberWithInteger:cateId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"recovery_attr_info_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSArray *array = [data arrayValueForKey:@"recovery_info_list"];
        NSMutableArray *attrInfoList = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            AttrEditableInfo *info = [AttrEditableInfo createWithDict:dict];
            [attrInfoList addObject:info];
        }
        if (completion)completion(attrInfoList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)getAttrInfoList:(NSInteger)cateId
             completion:(void (^)(NSArray *attrInfoList))completion
                failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"cate_id":[NSNumber numberWithInteger:cateId]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"attr_info_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSArray *array = [data arrayValueForKey:@"attr_info_list"];
        NSMutableArray *attrInfoList = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            AttrEditableInfo *info = [AttrEditableInfo createWithDict:dict];
            [attrInfoList addObject:info];
        }
        if (completion)completion(attrInfoList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)getCateList:(void (^)(NSDictionary *data))completion
            failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"get_tree" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil]];
}

+ (void)getCateSample:(NSInteger)cateId
           completion:(void (^)(NSArray *sampleList))completion
              failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"cate_id":[NSNumber numberWithInteger:cateId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"sample" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *sampleList = [[NSMutableArray alloc] init];
        NSArray *array = [data arrayValueForKey:@"pic_list"];
        for (NSDictionary *dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [sampleList addObject:[CateSampleVo createWithDict:dict]];
            }
        }
        if (completion)completion(sampleList);
    } failure:^(XMError *error) {
        if (failure) failure(error);
    } queue:nil]];
}

@end



@implementation BrandService

+ (void)getBrandList:(NSInteger)cateId
                  completion:(void (^)(NSArray *brandList))completion
                     failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSLog(@"----------------------->%ld", cateId);
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"cate_id":[NSNumber numberWithInteger:cateId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"brand" path:@"get_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSArray *brandListDicts = [data arrayValueForKey:@"list"];
        NSMutableArray *brandList = [[NSMutableArray alloc] initWithCapacity:brandListDicts.count];
        for (NSDictionary *dict in brandListDicts) {
            BrandInfo *brandInfo = [BrandInfo createWithDict:dict];
            [brandList addObject:brandInfo];
        }
        if (completion) completion(brandList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


@end



@implementation CateSampleVo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _explain = [dict stringValueForKey:@"explain"];
        _picUrl = [dict stringValueForKey:@"pic_url"];
    }
    return self;
}

@end

