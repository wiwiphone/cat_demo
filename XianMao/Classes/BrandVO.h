//
//  BrandVO.h
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface BrandVO : JSONModel

@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandEnName;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *mainPic;
@property (nonatomic, copy) NSString *brandDesc;
@property (nonatomic, copy) NSString *siteUrl;
@property (nonatomic, assign) NSInteger sortOrder;
@property (nonatomic, assign) NSInteger isShow;
@property (nonatomic, assign) NSInteger logoPicWidth;
@property (nonatomic, assign) NSInteger logoPicHeight;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger hot;
@property (nonatomic, copy) NSString *brandBgPic;
@property (nonatomic, copy) NSString *redirect_uri;

@end
