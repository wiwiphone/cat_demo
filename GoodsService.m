//
//  GoodsService.m
//  XianMao
//
//  Created by simon cai on 13/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsService.h"
#import "Session.h"
#import "RecommendGoodsInfo.h"

#import "JSONKit.h"

@interface GoodsService ()
@property(nonatomic,strong) HTTPRequest *request;
@end

@implementation GoodsService

+ (void)getSpecifiedUser:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_specified_user" parameters:nil completionBlock:completion failure:failure queue:nil]];
}

+ (void)setListPreference:(NSDictionary *)params Completion:(void (^)(NSDictionary *dict))completion failure:(void (^)(XMError *error))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recovery" path:@"set_push_preference" parameters:params completionBlock:completion failure:failure queue:nil]];
}

+ (void)setSharePOST:(NSDictionary *)params Completion:(void (^)(NSDictionary *dict))completion failure:(void (^)(XMError *error))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recovery" path:@"set_push_preference" parameters:params completionBlock:completion failure:failure queue:nil]];
}

+ (void)getRecoverUserInfo:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_recovery_user_info" parameters:nil completionBlock:completion failure:failure queue:nil]];
}

+ (void)setPushPreference:(NSDictionary *)params Completion:(void (^)(NSDictionary *dict))completion failure:(void (^)(XMError *error))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recovery" path:@"set_push_preference" parameters:params completionBlock:completion failure:failure queue:nil]];
}

+ (void)setPreference:(NSMutableArray *)params Completion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:params forKey:@"params"];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recovery" path:@"set_recovery_preference" parameters:param completionBlock:completion failure:failure queue:nil]];
}

+ (void)getRecoverPreferenceCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_recovery_preference_in_json" parameters:nil completionBlock:completion failure:failure queue:nil]];
}

+ (void)getRecoverFondCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recovery" path:@"get_recovery_preference" parameters:nil completionBlock:completion failure:failure queue:nil]];
}

+ (void)cancelCurOption {
    GoodsService *service = (GoodsService*)[GoodsService instance];
    [service.request cancel];
    service.request = nil;
}

+ (void)switchOnSale:(NSString*)goodsId onsale:(BOOL)onsale
          completion:(void (^)())completion
       failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"goods_id":goodsId,
                                 @"type":[NSNumber numberWithInteger:onsale?1:2]};
    
    GoodsService *service = (GoodsService*)[GoodsService instance];
    typeof(GoodsService*) __weak weakTradeService = service;
    
    service.request = [[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"switch_sale" parameters:parameters completionBlock:^(NSDictionary *data) {
        weakTradeService.request = nil;
        if (completion)completion();
    } failure:^(XMError *error) {
        weakTradeService.request = nil;
        if (failure)failure(error);
    } queue:nil];
}

+ (void)refreshGoods:(NSString*)goodsId
          completion:(void (^)(long long modifyTime))completion
             failure:(void (^)(XMError *error))failure
{
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"goods_id":goodsId};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"refresh" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data longLongValueForKey:@"modify_time" defaultValue:0]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


+ (void)deleteGoods:(NSString*)goodsId
          completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"goods_id":goodsId};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"delete" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)sale_again:(NSString*)goodsId
        completion:(void (^)())completion
           failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"goods_id":goodsId};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"sale_again" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)recommend_goods:(NSString*)goods_id
             completion:(void (^)(NSArray* goods_list))completion
                failure:(void (^)(XMError *error))failure {
    
    if ([goods_id length]>0) {
        NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                     @"goods_id":goods_id};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recommend" path:@"goods" parameters:parameters completionBlock:^(NSDictionary *data) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSArray *goods_list = [data arrayValueForKey:@"goods_list"];
            for (NSDictionary *dict in goods_list) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [array addObject:[RecommendGoodsInfo createWithDict:dict]];
                }
            }
            if (completion)completion(array);
        } failure:^(XMError *error) {
            if (failure)failure(error);
        } queue:nil]];
    }
}

+ (void)shoppingCartRecommendGoods:(void (^)(NSArray* goods_list))completion
                           failure:(void (^)(XMError *error))failure{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recommend" path:@"adviser_goods" parameters:nil completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *goods_list = [data arrayValueForKey:@"goods_list"];
        for (NSDictionary *dict in goods_list) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [array addObject:[RecommendGoodsInfo createWithDict:dict]];
            }
        }
        if (completion)completion(array);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)comment_publish:(NSString*)goods_id
          reply_user_id:(NSInteger)reply_user_id
                content:(NSString*)content
            attachments:(NSArray*)attachments
             completion:(void (^)(CommentVo *commentVo))completion
                failure:(void (^)(XMError *error))failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (attachments && [attachments count]>0) {
        for (ForumAttachmentVO *attachVO in attachments) {
            [array addObject:[attachVO toJSONDictionary]];
        }
    }
    NSString *jsonString = @"";
    if ([array count]>0) {
        jsonString = [[array toJSONArray] JSONString];
    }
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"goods_id":goods_id,@"user_id":[NSNumber numberWithInteger:userId],@"reply_user_id":[NSNumber numberWithInteger:reply_user_id],@"content":content?content:@"",@"attachment":jsonString};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"comment" path:@"publish" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([[CommentVo alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"comment"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
    
}

+ (void)comment_delete:(NSInteger)comment_id
            completion:(void (^)())completion
               failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"comment_id":[NSNumber numberWithInteger:comment_id],@"user_id":[NSNumber numberWithInteger:userId],};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"comment" path:@"delete" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)comment_list:(NSString*)goods_id
                size:(NSInteger)size
          completion:(void (^)(NSArray* comments))completion
             failure:(void (^)(XMError *error))failure {
    
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"goods_id":goods_id,@"user_id":[NSNumber numberWithInteger:userId],@"reqtype":[NSNumber numberWithInteger:0], @"size":[NSNumber numberWithInteger:size],@"page":[NSNumber numberWithInteger:0]};
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"comment" path:@"list" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        NSArray *array = [data arrayValueForKey:@"list"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                [comments addObject:[[CommentVo alloc] initWithJSONDictionary:dict]];
            }
        }
        if (completion)completion(comments);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}
@end


//trade/get_appraisal_fee[GET] {goods_ids(s)商品ids列表 ‘|’分割}  获取商品手续费 {[AppraisalFeeVo(goods_id, is_can_choose, fee_cent(到分))]}





