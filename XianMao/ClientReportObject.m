//
//  ClientReportObject.m
//  XianMao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ClientReportObject.h"
#import "RedirectInfo.h"
#import "Session.h"

@implementation ClientReportObject

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)clientReportObjectWithViewCode:(NSInteger)viewCode regionCode:(NSInteger)regionCode referPageCode:(NSInteger)referPageCode andData:(NSDictionary *)data{
    RedirectInfo *redirectInfo = [[RedirectInfo alloc] init];
    redirectInfo.viewCode = viewCode;
    redirectInfo.regionCode = regionCode;
    redirectInfo.referPageCode = referPageCode;
    [[Session sharedInstance] clientReport:redirectInfo data:data];
}

@end
