//
//  ClientReportObject.h
//  XianMao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientReportObject : NSObject

+(void)clientReportObjectWithViewCode:(NSInteger)viewCode regionCode:(NSInteger)regionCode referPageCode:(NSInteger)referPageCode andData:(NSDictionary *)data;

@end
