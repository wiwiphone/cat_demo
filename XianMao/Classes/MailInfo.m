//
//  MailInfo.m
//  XianMao
//
//  Created by WJH on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MailInfo.h"

@implementation MailInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _mailCOM = [dict stringValueForKey:@"mail_com"];
        _mailSN = [dict stringValueForKey:@"mail_sn"];
    }
    return self;
}


@end
