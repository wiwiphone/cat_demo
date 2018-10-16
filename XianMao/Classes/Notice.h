//
//  Notice.h
//  XianMao
//
//  Created by simon cai on 11/16/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger noticeId;
@property(nonatomic,assign) NSInteger castType;
@property(nonatomic,copy) NSString *brief;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign) BOOL isSend;
@property(nonatomic,assign) long long sendTime;
@property(nonatomic,assign) long long createTime;
@property(nonatomic,assign) BOOL isRead; //local
@property(nonatomic,copy) NSString *redirectUri;
@property (nonatomic, copy) NSString *title;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (NSString*)formattedDateDescription;

@end
