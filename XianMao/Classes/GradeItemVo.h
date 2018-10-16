//
//  GradeItemVo.h
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeItemVo : NSObject

@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSArray * gradeItemList;

+ (instancetype)createWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
