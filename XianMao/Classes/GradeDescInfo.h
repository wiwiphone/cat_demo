//
//  GradeDescInfo.h
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@protocol GradeDescInfo;

@interface GradeDescInfo : JSONModel

@property (nonatomic, copy) NSString *detailDesc;
@property (nonatomic, assign) NSInteger gradeValue;
@property (nonatomic, copy) NSString *gradeValueDesc;

@end
