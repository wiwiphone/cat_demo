//
//  OrderDetailInfo.h
//  XianMao
//
//  Created by simon on 1/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressInfo.h"
#import "OrderInfo.h"
#import "MailInfo.h"

@interface OrderDetailInfo : NSObject

@property(nonatomic,strong) AddressInfo *addressInfo;
@property(nonatomic,strong) OrderInfo *orderInfo;
@property(nonatomic,strong) MailInfo *mailInfo;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end




