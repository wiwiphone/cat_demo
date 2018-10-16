//
//  SearchSiftGradeVo.h
//  XianMao
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "SearchSiftGradeDescVo.h"

@interface SearchSiftGradeVo : JSONModel

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSArray<SearchSiftGradeDescVo> *gradeDescVoList;

@end
