//
//  SearchResultItem.h
//  XianMao
//
//  Created by simon on 1/17/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultItem : NSObject

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSObject *item;

@end
