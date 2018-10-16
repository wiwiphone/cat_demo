//
//  NeedModel.h
//  XianMao
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeedModel : NSObject

@property (nonatomic, strong) NSMutableArray *attachment;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long long createtime;
@property (nonatomic, copy) NSString *needId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *statusDesc;
@property (nonatomic, copy) NSString * goodsSn;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
