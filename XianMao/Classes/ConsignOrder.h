//
//  ConsignOrder.h
//  XianMao
//
//  Created by simon on 12/2/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsignOrder : NSObject

@property(nonatomic,copy) NSString *consignId;
@property(nonatomic,assign) long long createTime;
@property(nonatomic,strong) NSArray *picList;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,strong) NSArray *statusIems;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


@interface NSDictionary (ConsignOrderStatus)

- (NSInteger)consignOrderStatus;
- (NSString*)consignOrderSummary;
- (NSString*)consignOrderContent;
@end