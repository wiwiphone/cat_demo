//
//  CommentVo.h
//  XianMao
//
//  Created by simon cai on 13/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "ForumTopicVO.h"

@interface CommentVo : JSONModel
@property(nonatomic,assign) NSInteger comment_id;
@property(nonatomic,assign) long long create_time;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *avatar_url;
@property(nonatomic,assign) NSInteger reply_user_id;
@property(nonatomic,copy) NSString *reply_username;
@property(nonatomic,strong) NSArray *attachments;
@end

//private long create_time;
//
//private int comment_id;
//
//private int user_id;
//
//private String username;
//
//private String avatar_url;
//
//private String content;
//
//private int reply_user_id;
//
//private String reply_username;
//
//private String attachment;
