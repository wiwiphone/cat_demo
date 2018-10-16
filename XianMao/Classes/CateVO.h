//
//  CateVO.h
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface CateVO : JSONModel

@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryBackImage;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger isRecommend;
@property (nonatomic, copy) NSString *redirect_uri;

@end
