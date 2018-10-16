//
//  gradeVoList.h
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeVoList : NSObject

@property (nonatomic, strong) NSArray * gradeItemList;
@property (nonatomic, copy) NSString * title;


+ (instancetype)createWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
