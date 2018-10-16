//
//  RecoveryUserVo.h
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface RecoveryUserVo : JSONModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger recoveryNum;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger categoryId;

@end
