//
//  RedirectInfo.h
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedirectInfo : NSObject<NSCoding>

@property(nonatomic,copy) NSString *imageUrl;
@property(nonatomic,copy) NSString *redirectUri;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subTitle;
@property(nonatomic,copy) NSString *source;
@property(nonatomic,copy) NSString *url;

@property (nonatomic, assign) NSInteger viewCode;
@property (nonatomic, assign) NSInteger regionCode;
@property (nonatomic, assign) NSInteger referPageCode;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (NSDictionary*)toDictionary;
- (void)redirect;

- (CGFloat)scaledWidth;
- (CGFloat)scaledHeight;

+ (CGFloat)width:(RedirectInfo*)redirectInfo;
+ (CGFloat)height:(RedirectInfo*)redirectInfo;

-(BOOL)isNewComposition;
@end
