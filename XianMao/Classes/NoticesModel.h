//
//  NoticesModel.h
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class New_noticeModel;

@interface NoticesModel : NSObject

@property (nonatomic,copy) NSString * icon_url;
@property (nonatomic,assign) NSInteger  user_id;
@property (nonatomic,strong) New_noticeModel * NEWNotice;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger noticecountl;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSString*)formattedDateDescription;

@end

@interface New_noticeModel : NSObject
@property (nonatomic,copy) NSString * create_time;
@property (nonatomic,assign) NSInteger notice_id;
@property (nonatomic,assign) NSInteger  casttype;
@property (nonatomic,copy) NSString * brief;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger is_send;
@property (nonatomic,copy) NSString * sendtime;
@property (nonatomic,copy) NSString * redirect_uri;
@property (nonatomic,assign) NSInteger msg_type;
@property (nonatomic,copy) NSString * title;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
