//
//  NoticesModel.m
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "NoticesModel.h"

@implementation NoticesModel

+ (instancetype)createWithDict:(NSDictionary*)dict
{
    return [[self alloc] initWithDict:dict];;
}

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        self.icon_url = dict[@"icon_url"];
        self.user_id = [dict integerValueForKey:@"user_id" defaultValue:0];
        
        if (![dict[@"new_notice"] isEqual:[NSNull null]]) {
            self.NEWNotice = [New_noticeModel createWithDict:dict[@"new_notice"]];
        }
        self.name = dict[@"name"];
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
        self.noticecountl = [dict integerValueForKey:@"new_notice_count" defaultValue:0];
    }
    return self;
    
}

- (NSString*)formattedDateDescription
{
    long long createdTime = [self.NEWNotice.sendtime longLongValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdTime/1000];//[NSDate date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟前";
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%ld分钟前", timeInterval / 60];
    } else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:@"%ld小时前", timeInterval / 3600];
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


@implementation New_noticeModel

+(instancetype)createWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if(self = [super init]){
        self.create_time = dict[@"create_time"];
        self.notice_id = [dict integerValueForKey:@"notice_id" defaultValue:0];
        self.casttype = [dict integerValueForKey:@"casttype" defaultValue:0];
        self.brief = dict[@"brief"];
        self.message = dict[@"message"];
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
        self.is_send = [dict integerValueForKey:@"is_send" defaultValue:0];
        self.sendtime = dict[@"sendtime"];
        self.redirect_uri = dict[@"redirect_uri"];
        self.msg_type = [dict integerValueForKey:@"msg_type" defaultValue:0];
        self.title = dict[@"title"];
    }
    return self;
}

@end
