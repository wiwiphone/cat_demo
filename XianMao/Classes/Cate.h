//
//  Cate.h
//  XianMao
//
//  Created by simon on 12/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cate : NSObject <NSCoding>

@property(nonatomic,assign) NSInteger cateId;
@property(nonatomic,copy)   NSString *name;
@property(nonatomic,copy)   NSString *iconUrl;
@property(nonatomic,assign) NSInteger parentId;
@property(nonatomic,strong) NSArray *children;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end



//