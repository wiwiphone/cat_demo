//
//  GlobalSeekBannerVo.h
//  XianMao
//
//  Created by Marvin on 17/3/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendVo.h"

@interface GlobalSeekBannerVo : NSObject

@property (nonatomic, strong) RecommendVo * banner;
@property (nonatomic, copy) NSString * desc;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)createWithDict:(NSDictionary *)dict;
@end
