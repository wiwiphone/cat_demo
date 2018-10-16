//
//  EvaluateStatVo.h
//  XianMao
//
//  Created by simon cai on 12/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluateStatVo : NSObject

@property(nonatomic,copy) NSString *statDescription;
@property(nonatomic,copy) NSString *redirectUri;
@property(nonatomic,copy) NSString *redirectDesc;
@property(nonatomic,assign) NSInteger status;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


//redirect_desc