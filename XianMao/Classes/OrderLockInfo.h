//
//  OrderLockInfo.h
//  XianMao
//
//  Created by simon cai on 25/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderLockInfo : NSObject

@property(nonatomic,copy) NSString *orderId;
@property(nonatomic,assign) NSInteger buyerId;
@property(nonatomic,assign) NSInteger remainTime;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
