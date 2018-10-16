//
//  ForumService.h
//  XianMao
//
//  Created by simon cai on 21/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"
#import "ForumTopicVO.h"

@interface ForumService : BaseService


//+ (void)getHomePost:(NSInteger)user_id completion:(void (^)(NSMutableArray *home))completion failure:(void (^)(XMError *error))failure;

+ (void)getPostTagData:(NSString *)tag completion:(void (^)(NSMutableArray *topic))completion failure:(void (^)(XMError *error))failure;

+ (void)post:(NSInteger)post_id like:(NSInteger)isLike completion:(void (^)(ForumTopicIsLike *likeArr))completion failure:(void (^)(XMError *error))failure;

+ (void)getTopicTopData:(void (^)(NSMutableArray *topic))completion failure:(void (^)(XMError *error))failure;

+ (void)getTopiccompletion:(void (^)(NSMutableArray *topic, NSString *avatarUrl))completion failure:(void (^)(XMError *error))failure;

+ (void)getTopic:(NSInteger)topic_id
      completion:(void (^)(ForumTopicVO *topic))completion
         failure:(void (^)(XMError *error))failure;

+ (void)publish_post:(NSInteger)topic_id
             content:(NSString*)content
         attachments:(NSArray*)attachments tags:(NSArray *)tags
          completion:(void (^)(ForumPostVO *postVO))completion
             failure:(void (^)(XMError *error))failure;

+ (void)complete_post:(NSInteger)post_id
           completion:(void (^)(ForumPostVO *postVO))completion
              failure:(void (^)(XMError *error))failure;

+ (void)delete_post:(NSInteger)post_id
         completion:(void (^)(NSInteger post_id))completion
            failure:(void (^)(XMError *error))failure;

+ (void)reply_post:(NSInteger)post_id
     reply_user_id:(NSInteger)reply_user_id
           content:(NSString*)content
      attachments:(NSArray*)attachments
        completion:(void (^)(ForumPostReplyVO *replyVO))completion
           failure:(void (^)(XMError *error))failure;

+ (void)delete_reply:(NSInteger)reply_id
          completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure;

+ (void)post:(NSInteger)post_id
          completion:(void (^)(ForumPostVO *postVO))completion
             failure:(void (^)(XMError *error))failure;


+ (void)quote:(NSInteger)post_id
    priceCent:(NSInteger)priceCent
  completion:(void (^)(NSInteger quote_num))completion
     failure:(void (^)(XMError *error))failure;

+ (void)getTopicButtons:(NSInteger)topic_id completion:(void (^)(NSDictionary *quote_num))completion failure:(void (^)(XMError *error))failure;
//forum/quote

@end

//forum/topic[GET]{topic_id(i)}
// 获取话题信息 {topic_id(i), title(s), filter_list[](topic_filter_vo)}  topic_filter_vo(qk(s), qv(s), display(s) );  @白骁

///forum/topic get topic_id
///forum/post_list get topic_id params
///forum/post_reply_list get post_id

///forum/publish_post post topic_id, title
///forum/complete_post post post_id
///forum/delete_post post post_id
///forum/reply_post post post_id, content, reply_user_id(#)
///forum/delete_reply post reply_id

//forum/post[GET]{post_id} 获取帖子{postVo:(post_id, content, user_id, status, reply_num, is_myself, timestmap, topReplies[], attachment)}


//forum/quote

///chat/shield[POST]{user_id, other_user_id} 屏蔽聊天


//forum/post_list[GET]分页{topic_id{i), params(s)要encode, keywords(s)需要encode } 获取帖子列表 {PostVo[]( post_id, content, user_id, status, reply_num, is_myself, timestmap, topReplies[], attachment)}   加入keywords可选参数
//
//
//String subscribe_url;
//
//int is_have_quote;
//


    


