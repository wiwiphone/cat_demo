//
//  ReplyDetailVo.h
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReplyVo.h"

@interface ReplyDetailVo : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString * tabTitle;
@property (nonatomic, assign) NSInteger adviserId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray * replyList;



+ (instancetype)createWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
