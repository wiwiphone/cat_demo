//
//  BrandInfo.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandInfo : NSObject

@property(nonatomic,assign) NSInteger brandId;
@property(nonatomic,copy) NSString *brandName;
@property(nonatomic,copy) NSString *brandEnName;
@property(nonatomic,copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *brandDesc;
@property(nonatomic,copy) NSString *redirect_uri;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (NSString *)getFirstNameEn;
- (NSString *)getFirstName;

@end

