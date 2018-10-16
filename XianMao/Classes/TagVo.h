//
//  TagVo.h
//  XianMao
//
//  Created by simon cai on 8/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagVo : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger tagId;
@property(nonatomic,copy) NSString *tagName;
@property(nonatomic,copy) NSString *redirectUri;
@property(nonatomic,assign) BOOL isSelected;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

@end

@interface TagGroupVo : NSObject

@property(nonatomic,assign) NSInteger groupId;
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,strong) NSArray *tagList;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
