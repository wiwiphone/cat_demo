//
//  Notice.m
//  XianMao
//
//  Created by simon cai on 11/16/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "Notice.h"

@implementation Notice

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}


- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.noticeId = [dict integerValueForKey:@"notice_id" defaultValue:0];
        self.castType = [dict integerValueForKey:@"casttype" defaultValue:0];
        self.brief = [dict stringValueForKey:@"brief"];
        self.message = [dict stringValueForKey:@"message"];
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
        self.isSend = [dict integerValueForKey:@"is_send" defaultValue:0]>0;
        self.sendTime = [dict longLongValueForKey:@"sendtime" defaultValue:0];
        self.createTime = [dict longLongValueForKey:@"create_time" defaultValue:0];
        self.redirectUri = [dict stringValueForKey:@"redirect_uri"];
        self.title = [dict stringValueForKey:@"title"];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.noticeId = [[decoder decodeObjectForKey:@"noticeId"] integerValue];
        self.castType = [[decoder decodeObjectForKey:@"casttype"] integerValue];
        self.brief = [decoder decodeObjectForKey:@"brief"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.type = [[decoder decodeObjectForKey:@"type"] integerValue];
        self.isSend = [[decoder decodeObjectForKey:@"isSend"] integerValue]>0;
        self.sendTime = [[decoder decodeObjectForKey:@"sendTime"] longLongValue];
        self.createTime = [[decoder decodeObjectForKey:@"createTime"] longLongValue];
        self.isRead = [[decoder decodeObjectForKey:@"isRead"] boolValue];
        self.redirectUri = [decoder decodeObjectForKey:@"redirectUri"];
        self.title = [decoder decodeObjectForKey:@"title"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.noticeId] forKey:@"noticeId"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.castType] forKey:@"castType"];
    [encoder encodeObject:self.brief forKey:@"brief"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.isSend?1:0] forKey:@"isSend"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.sendTime] forKey:@"sendTime"];
    [encoder encodeObject:[NSNumber numberWithLongLong:self.createTime] forKey:@"createTime"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isRead] forKey:@"isRead"];
    [encoder encodeObject:self.title forKey:@"title"];
    if ([_redirectUri length]>0) {
        [encoder encodeObject:_redirectUri forKey:@"redirectUri"];
    }
}

- (NSString*)formattedDateDescription
{
    long long createdTime = self.createTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdTime/1000];//[NSDate date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟前";
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%d分钟前", timeInterval / 60];
    } else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:@"%d小时前", timeInterval / 3600];
    } else if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:date]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:date]];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}

@end





