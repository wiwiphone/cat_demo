//
//  UserDetailInfo.h
//  XianMao
//
//  Created by simon cai on 30/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "PictureItem.h"

@interface UserDetailInfo : NSObject

@property(nonatomic,strong) User *userInfo;
@property(nonatomic,strong) NSArray *gallary;
@property (nonatomic, assign) NSInteger contactType;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end





