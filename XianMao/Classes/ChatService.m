//
//  ChatService.m
//  XianMao
//
//  Created by simon cai on 14/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ChatService.h"
#import "Session.h"

#import "AppDirs.h"
#import "NSDate+Category.h"

@interface ChatNoticeDO : NSObject<NSCoding>
@property(nonatomic,assign) NSInteger userId;
@property(nonatomic,assign) NSInteger expire;
@property(nonatomic,assign) long long addTime;
+ (ChatNoticeDO*)allocWithUserId:(NSInteger)userId expire:(NSInteger)expire;
@end

@implementation ChatNoticeDO
+ (ChatNoticeDO*)allocWithUserId:(NSInteger)userId expire:(NSInteger)expire {
    ChatNoticeDO *notice = [[ChatNoticeDO alloc] init];
    notice.userId = userId;
    notice.expire = expire;
    notice.addTime = [[NSDate date] timeIntervalSince1970InMilliSecond];
    return notice;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.userId = [[decoder decodeObjectForKey:@"userId"] integerValue];
        self.expire = [[decoder decodeObjectForKey:@"expire"] integerValue];
        self.addTime = [[decoder decodeObjectForKey:@"addTime"] longLongValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.expire] forKey:@"expire"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.addTime] forKey:@"addTime"];
}
@end

@interface ChatService ()
@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,strong) NSMutableDictionary *noticeData;
@end

@implementation ChatService

+ (void)chatNotice:(NSInteger)userId isAdd:(BOOL)isAdd
{
//    ChatService *service = (ChatService*)[ChatService instance];
//    typeof(ChatService*) __weak weakService = service;
//    
//    BOOL isNeedSendNotice = [weakService isNeedSendNotice:userId isAdd:isAdd];
//    if (isNeedSendNotice)
//    {
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"is_add":[NSNumber numberWithInteger:isAdd>0?1:0]};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"chat" path:@"chat_notice" parameters:parameters completionBlock:^(NSDictionary *data) {
            //NSInteger expire = [data integerValueForKey:@"expire" defaultValue:2*60];
//            if (isAdd) {
//                [weakService saveNoticeData:[ChatNoticeDO allocWithUserId:userId expire:expire]];
//            } else {
//                [weakService removeNoticeData:userId];
//            }
        } failure:^(XMError *error) {
            
        } queue:nil]];
 //   }
}

- (BOOL)isNeedSendNotice:(NSInteger)userId isAdd:(BOOL)isAdd {
    if (!_noticeData)
        _noticeData = [self loadNoticeDataFromCache];   
    
    BOOL ret = NO;
    if (isAdd) {
        ChatNoticeDO *notice = [_noticeData objectForKey:[NSNumber numberWithInteger:userId]];
        if (notice) {
            NSInteger milliSecond = [[NSDate date] timeIntervalSince1970InMilliSecond]-notice.addTime;
            if (milliSecond > notice.expire*1000) {
                ret = YES;
            }
        } else {
            ret = YES;
        }
    } else {
        //删除notice
        ChatNoticeDO *notice = [_noticeData objectForKey:[NSNumber numberWithInteger:userId]];
        if (notice) {
            ret = YES;
        }
    }
    return ret;
}

- (void)saveNoticeData:(ChatNoticeDO*)notice
{
    if (notice) {
        if (!_noticeData)
            _noticeData = [self loadNoticeDataFromCache];
        if ([_noticeData count]>=50) {
            //最多保存50个
            long long lastAddTime = 0;
            NSObject *lastKey = nil;
            NSArray *allKeys = [_noticeData allKeys];
            for (NSObject *key in allKeys) {
                ChatNoticeDO *tempNoticeDO = [_noticeData objectForKey:key];
                if (lastAddTime == 0) {
                    lastAddTime = tempNoticeDO.addTime;
                    lastKey = key;
                } else {
                    if (tempNoticeDO.addTime<lastAddTime) {
                        lastAddTime = tempNoticeDO.addTime;
                        lastKey = key;
                    }
                }
            }
            if (lastKey) {
                [_noticeData removeObjectForKey:lastKey];
            }
        }
        [_noticeData setObject:notice forKey:[NSNumber numberWithInteger:notice.userId]];
        [self saveNoticeDataToCache];
    }
}

- (void)removeNoticeData:(NSInteger)userId
{
    if ([_noticeData objectForKey:[NSNumber numberWithInteger:userId]]) {
        [_noticeData removeObjectForKey:[NSNumber numberWithInteger:userId]];
        [self saveNoticeDataToCache];
    }
}

- (NSMutableDictionary*)loadNoticeDataFromCache
{
    NSString *cacheFile = [AppDirs chatNoticeCacheFilePath];
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:cacheFile isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[unarchiver decodeObjectForKey:@"notice"]];
        [unarchiver finishDecoding];
        return dict;
    }
    return [[NSMutableDictionary alloc] init];
}

- (void)saveNoticeDataToCache
{
    if (_noticeData) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:_noticeData forKey:@"notice"];
        [archiver finishEncoding];
        [data writeToFile:[AppDirs chatNoticeCacheFilePath] atomically:YES];
    }
}

@end





