//
//  ClientReport.h
//  XianMao
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientReport : NSObject

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, assign) NSInteger referPageCode;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, assign) NSInteger regionCode;
@property (nonatomic, assign) NSInteger viewCode;
@property (nonatomic, assign) long long clickTimestamp;
@property (nonatomic, copy) NSString *clientVersion;
@property (nonatomic, assign) NSInteger userId;

@end
