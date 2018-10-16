//
//  SearchSiftGradeDescVo.h
//  XianMao
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@protocol SearchSiftGradeDescVo;

@interface SearchSiftGradeDescVo : JSONModel

@property (nonatomic, copy) NSString *detailDesc;
@property (nonatomic, assign) NSInteger gradeValue;
@property (nonatomic, copy) NSString *gradeValueDesc;

@end
