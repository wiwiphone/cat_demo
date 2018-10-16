//
//  SkinVo.h
//  XianMao
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinVo : NSObject

@property (nonatomic, copy) NSString *iosUrl;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
