//
//  HotWord.h
//  XianMao
//
//  Created by simon cai on 7/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotWord : NSObject <NSCoding>

@property(nonatomic,copy) NSString *keyword;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
