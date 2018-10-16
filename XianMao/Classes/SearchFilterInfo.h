//
//  SearchFilterInfo.h
//  XianMao
//
//  Created by simon on 2/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SearchFilterInfo : NSObject

@property(nonatomic,copy) NSString *name; //显示的名字
@property(nonatomic,assign) NSInteger type;//类型 0：单项目 1：多项目, 2.radio
@property(nonatomic,assign) NSInteger isMultiSelected; //该类目下的元素是否允许多选是否允许多选
@property(nonatomic,copy) NSString *queryKey;
@property(nonatomic,strong) NSArray *items; // SearchFilterItems

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (instancetype)clone;
- (BOOL)isCompatible;

@end


@interface SearchFilterItem : NSObject

@property(nonatomic,copy) NSString *title; //显示的名字
@property(nonatomic,copy) NSString *queryValue;//query value

@property(nonatomic,assign) BOOL isYesSelected;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (NSString*)toRedirectUri:(NSString*)queryKey;
- (NSString*)fromRedirectUri:(NSString*)redirectUri;

@end

@interface SearchFilterKV : JSONModel
@property(nonatomic,copy) NSString *qk;
@property(nonatomic,copy) NSString *qv;
@end

