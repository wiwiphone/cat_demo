//
//  VerifyModel.h
//  XianMao
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface VerifyModel : JSONModel

@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) long long createtime;
@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsSn;
@property (nonatomic, assign) NSInteger goodsStatus;
@property (nonatomic, assign) NSInteger gradeLevel;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *sellerPhone;
@property (nonatomic, assign) NSInteger systemStatus;
@property (nonatomic, assign) long long updatetime;
@property (nonatomic, assign) NSInteger userHopePrice;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *warnMessage;
@property (nonatomic, copy) NSString *statusMessage;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *mailSn;
@property (nonatomic, copy) NSString *mailType;
@property (nonatomic, assign) double estimationPrice;
@property (nonatomic, assign) double sellPrice;

@end
