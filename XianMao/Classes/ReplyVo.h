//
//  ReplyVo.h
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyVo : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * redirectUrl;
@property (nonatomic, strong) NSArray * data;


+ (instancetype)createWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
