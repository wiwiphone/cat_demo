//
//  CateNewInfo.h
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface CateNewInfo : JSONModel

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger isRecommend;
@property (nonatomic, copy) NSString *categoryBackImage;
@property (nonatomic, copy) NSString *redirect_uri;
@property (nonatomic, strong) NSArray *subCategoryList;

@end
