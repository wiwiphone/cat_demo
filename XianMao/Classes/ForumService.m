//
//  ForumService.m
//  XianMao
//
//  Created by simon cai on 21/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumService.h"
#import "Session.h"
#import "JSONKit.h"
#import "JSONModel.h"
#import "JSONModelProperty.h"
#import "NSString+URLEncoding.h"

#define MODULE @"forum"
#define TOPICBUTTONS @"get_forum_tags"
@implementation ForumService

//+ (void)getHomePost:(NSInteger)user_id completion:(void (^)(NSMutableArray *home))completion failure:(void (^)(XMError *error))failure{
//    NSDictionary *parameters = @{@"user_id" : [NSNumber numberWithInteger:user_id]};
//    NSMutableArray *array = [NSMutableArray array];
//    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"forum_home" parameters:parameters completionBlock:^(NSDictionary *data) {
//        
//        NSMutableArray *arr = [data objectForKey:@"list"];
//        
//        for (NSDictionary *dict in arr) {
//            ForumPostList *homeData = [[ForumPostList alloc] initWithJSONDictionary:dict];
//            [array addObject:homeData];
//        }
//        
//        if (completion)completion(array);
//    } failure:^(XMError *error) {
//        if (failure)failure(error);
//    } queue:nil]];
//    
//}

+ (void)getPostTagData:(NSString *)tag completion:(void (^)(NSMutableArray *topic))completion failure:(void (^)(XMError *error))failure{
    NSString *tagJSON = [[tag JSONString] URLEncodedString];
    NSDictionary *parameters = @{@"label": tagJSON};
    NSMutableArray *array = [NSMutableArray array];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"post_list_by_label" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *arr = [data objectForKey:@"list"];
        for (NSDictionary *dict in arr) {
            ForumPostVO *tagVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
            [array addObject:tagVO];
        }
        
        if (completion)completion(array);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+(void)post:(NSInteger)post_id like:(NSInteger)isLike completion:(void (^)(ForumTopicIsLike *likeArr))completion failure:(void (^)(XMError *))failure{
    
//    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *parameters = @{@"post_id":[NSNumber numberWithInteger:post_id], @"is_like" : [NSNumber numberWithInteger:isLike]};
    
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"is_like" parameters:parameters completionBlock:^(NSDictionary *data) {
//        NSMutableArray *arr = [data objectForKey:@"postLike"];
//        for (ForumTopicIsLike *topData in arr) {
////            ForumTopicIsLike *topData = [[ForumTopicIsLike alloc] initWithJSONDictionary:dict];
//            [array addObject:topData];
//        }
        NSLog(@"%@", data);
//        if (completion)completion(array);
        
        if (completion)completion([[ForumTopicIsLike alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"post"]]);
        

    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
    
}


+ (void)getTopicTopData:(void (^)(NSMutableArray *topic))completion failure:(void (^)(XMError *error))failure {
    NSMutableArray *array = [NSMutableArray array];
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"publishtopic" parameters:nil completionBlock:^(NSDictionary *data) {
        
        
        NSMutableArray *arr = [data objectForKey:@"publishtopic"];
        for (NSDictionary *dict in arr) {
            ForumCatHouseTopData *topData = [[ForumCatHouseTopData alloc] initWithJSONDictionary:dict];
            [array addObject:topData];
        }
        
        if (completion)completion(array);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)getTopiccompletion:(void (^)(NSMutableArray *topic, NSString *avatarUrl))completion failure:(void (^)(XMError *error))failure {
    NSMutableArray *arrM = [NSMutableArray array];
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"topicgroup" parameters:nil completionBlock:^(NSDictionary *data) {
        
        NSLog(@"%@", data);
        NSMutableArray * arr = [data objectForKey:@"topicgroup"];
        for (NSDictionary *dict in arr) {
            ForumTopicVO *topicVO = [[ForumTopicVO alloc] initWithJSONDictionary:dict];
            [arrM addObject:topicVO];
        }
        NSString *avatarUrl = [data stringValueForKey:@"avatar"];
        if (completion)completion(arrM,avatarUrl);
    
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


+ (void)getTopic:(NSInteger)topic_id completion:(void (^)(ForumTopicVO *topic))completion failure:(void (^)(XMError *error))failure {
    NSDictionary *parameters = @{@"topic_id":[NSNumber numberWithInteger:topic_id]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"topic" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([[ForumTopicVO alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"topic"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)publish_post:(NSInteger)topic_id
             content:(NSString*)content
         attachments:(NSArray*)attachments tags:(NSArray *)tags
          completion:(void (^)(ForumPostVO *postVO))completion
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
    NSString *jsonA = [[tags toJSONArray] JSONString];
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"topic_id":[NSNumber numberWithInteger:topic_id],@"content":content?content:@"",@"user_id":[NSNumber numberWithInteger:userId],@"attachment":jsonString, @"forum_tags":jsonA};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"publish_post" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([[ForumPostVO alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"post"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}


+ (void)complete_post:(NSInteger)post_id
           completion:(void (^)(ForumPostVO *postVO))completion
              failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"post_id":[NSNumber numberWithInteger:post_id],@"user_id":[NSNumber numberWithInteger:userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"complete_post" parameters:parameters completionBlock:^(NSDictionary *data) {
        NSDictionary *post = [data dictionaryValueForKey:@"post"];
        if (completion)completion([[ForumPostVO alloc] initWithJSONDictionary:post]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)delete_post:(NSInteger)post_id
         completion:(void (^)(NSInteger post_id))completion
            failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"post_id":[NSNumber numberWithInteger:post_id],@"user_id":[NSNumber numberWithInteger:userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"delete_post" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"post_id"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)reply_post:(NSInteger)post_id
     reply_user_id:(NSInteger)reply_user_id
           content:(NSString*)content
      attachments:(NSArray*)attachments
        completion:(void (^)(ForumPostReplyVO *replyVO))completion
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
    NSDictionary *parameters = @{@"post_id":[NSNumber numberWithInteger:post_id],@"user_id":[NSNumber numberWithInteger:userId],@"reply_user_id":[NSNumber numberWithInteger:reply_user_id],@"content":content?content:@"",@"attachment":jsonString};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"reply_post" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([[ForumPostReplyVO alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"post_reply"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)delete_reply:(NSInteger)reply_id
          completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"reply_id":[NSNumber numberWithInteger:reply_id],@"user_id":[NSNumber numberWithInteger:userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"delete_reply" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion();
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
}

+ (void)post:(NSInteger)post_id
  completion:(void (^)(ForumPostVO *postVO))completion
     failure:(void (^)(XMError *error))failure {
    
    NSDictionary *parameters = @{@"post_id":[NSNumber numberWithInteger:post_id]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"post" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([[ForumPostVO alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"post"]]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
    
}

+ (void)quote:(NSInteger)post_id
    priceCent:(NSInteger)priceCent
   completion:(void (^)(NSInteger quote_num))completion
      failure:(void (^)(XMError *error))failure {
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"post_id":[NSNumber numberWithInteger:post_id],@"user_id":[NSNumber numberWithInteger:userId], @"price":[NSNumber numberWithDouble:(double)priceCent/100.f]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"forum" path:@"quote" parameters:parameters completionBlock:^(NSDictionary *data) {
        if (completion)completion([data integerValueForKey:@"quote_num"]);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil]];
    
}

+ (void)getTopicButtons:(NSInteger)topic_id completion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"forum" path:@"get_forum_tags" parameters:@{@"topic_id":@(topic_id)} completionBlock:completion failure:failure queue:nil]];
}

@end


