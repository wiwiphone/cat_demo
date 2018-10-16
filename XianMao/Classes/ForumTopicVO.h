//
//  ForumTopicVO.h
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "JSONModel.h"

//@interface ForumPostList : JSONModel
//
////@property (nonatomic, copy) NSString *createtime;
////@property (nonatomic, copy) NSString *updatetime;
////@property (nonatomic, assign) NSInteger postId;
////@property (nonatomic, assign) NSInteger topicId;
////@property (nonatomic, copy) NSString *content;
////@property (nonatomic, assign) NSInteger userId;
////@property (nonatomic, assign) NSInteger status;
////@property (nonatomic, assign) NSInteger isDelete;
////@property (nonatomic, assign) NSInteger replyNum;
////@property (nonatomic, strong) NSString *topReplies;
////@property (nonatomic, strong) NSString *attachment;
////@property (nonatomic, assign) NSInteger quoteNum;
//
//@property (nonatomic, copy) NSString *is_like;
//@property (nonatomic, strong) NSArray *topicStatusVos;
//@property (nonatomic, assign) NSInteger is_myself;
//@property (nonatomic, assign) NSInteger timestamp;
//@property (nonatomic, copy) NSString *topic_name;
////
//@property (nonatomic, assign) NSInteger topic_id;
//@property (nonatomic, assign) NSInteger is_following;
//
//@property (nonatomic, strong) NSArray *topReplies;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString *avatar;
//@property (nonatomic, assign) NSInteger post_id;
//@property (nonatomic, assign) NSInteger user_id;
//@property (nonatomic, assign) NSInteger reply_num;
//@property (nonatomic, assign) NSInteger like_num;
//@property (nonatomic, assign) NSInteger quote_num;
//@property (nonatomic, copy) NSString *username;
//@property (nonatomic, assign) NSInteger status;
//@property (nonatomic, copy) NSString *content;
//
//
//@end
//
//@interface ForumPostHome : JSONModel
//
////@property (nonatomic, copy) NSString *username;
////@property (nonatomic, strong) NSString *avatar;
////@property (nonatomic, assign) NSInteger *fans_num;
////@property (nonatomic, assign) NSInteger *sold_num;
////@property (nonatomic, assign) NSInteger *isfollowing;
////@property (nonatomic, strong) NSArray *forumPostList;
//
//@property (nonatomic, copy) NSString *hasNextPage;
//@property (nonatomic, copy) NSString *timestamp;
//@property (nonatomic, strong) NSArray *list;
//@property (nonatomic, copy) NSString *reload;
//
//@end

@interface ForumTopicIsLike : JSONModel

@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger like_num;

@end

@interface ForumCatHouseTopData : JSONModel

@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *enter_tip;
@property (nonatomic, strong) NSString *bottom_tips;

@end

@interface ForumTopicGroup : JSONModel

@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *filter_list;
@property (nonatomic, copy) NSString *publish_title;
@property (nonatomic, copy) NSString *head_text;
@property (nonatomic, strong) NSArray *statusVos;
@property (nonatomic, assign) NSInteger is_have_quote;

@end

@class ForumTopicVO;
@interface ForumTopicAvatar : JSONModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) ForumTopicVO *topicVO;

@end

@class ForumTopicFilterVO;
@interface ForumTopicVO : JSONModel
@property(nonatomic,assign) NSInteger topic_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,strong) NSArray *filterList;
@property(nonatomic,strong) NSArray *statusVoList;
@property(nonatomic,copy) NSString *publish_title; //发布求购
@property(nonatomic,copy) NSString *head_text;
@property(nonatomic,copy) NSString *subscribe_url;
@property(nonatomic,assign) NSInteger is_have_quote;

@end

// 获取话题信息 {topic_id(i), title(s), filter_list[](topic_filter_vo)}  topic_filter_vo(qk(s), qv(s), display(s) );  @白骁

@interface ForumTopicFilterVO : JSONModel
@property(nonatomic,copy) NSString *qk;
@property(nonatomic,copy) NSString *qv;
@property(nonatomic,copy) NSString *display;
@end

@interface ForumPostVO : JSONModel
@property(nonatomic,assign) NSInteger post_id;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) NSInteger reply_num;
@property(nonatomic,assign) NSInteger is_myself;
@property(nonatomic,assign) long long timestamp;
@property(nonatomic,copy) NSMutableArray *topReplies;
@property(nonatomic,strong) NSArray *attachments;
@property (nonatomic, strong) NSArray *topicStatusVos;
@property(nonatomic,assign) NSInteger topic_id;
@property(nonatomic,assign) NSInteger quote_num;
@property (nonatomic, assign) NSInteger like_num;
@property (nonatomic, assign) NSInteger is_like;
@property (nonatomic, assign) NSInteger is_following;
@property (nonatomic, copy) NSString *topic_name;
//新增字段 标签
@property (nonatomic, copy) NSString *forum_tag;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;

- (BOOL)isFinshed;
- (void)assignWithOther:(ForumPostVO*)postVO;
@end


@interface ForumPostReplyVO : JSONModel
@property(nonatomic,assign) long long create_time;
@property(nonatomic,assign) NSInteger reply_id;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,assign) NSInteger reply_user_id; //被回复的人
@property(nonatomic,copy) NSString *reply_username;
@property(nonatomic,strong) NSArray *attachments;
@end

@interface ForumPostStatusVo : JSONModel
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,copy) NSString *display;
- (BOOL)isFinsh;
@end

enum {
    ForumAttachTypeNeedRemindUpgrade = -1,
    ForumAttachTypeGoods = 1,
    ForumAttachTypePics = 2,
};


@class ForumAttachItemVO;
@interface ForumAttachmentVO : JSONModel
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) ForumAttachItemVO *item;

- (BOOL)isNeedRemindUpgrade;

+ (NSMutableArray*)createAttachmentsWithDictArray:(NSArray*)dictArray;

@end


@interface ForumAttachItemVO : JSONModel

@end

@interface ForumAttachItemGoodsVO : ForumAttachItemVO
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@end

@interface ForumAttachItemRemindUpgradeVO : ForumAttachItemVO

@end

@interface ForumAttachItemPicsVO : ForumAttachItemVO
@property(nonatomic,copy) NSString *pic_url;
@property(nonatomic,copy) NSString *pic_desc;
@property(nonatomic,assign) NSInteger width;
@property(nonatomic,assign) NSInteger height;
@end


@interface ForumAttachRedirectInfo : JSONModel
@property(nonatomic,assign) NSRange range;
@property(nonatomic,copy) NSString *redirectUri;

+ (ForumAttachRedirectInfo*)allocWithData:(NSRange)range redirectUri:(NSString*)redirectUri;
@end



//[｛type: item:{goods_id,goods_name}｝,｛type: item:{goods_id,goods_name}｝]






