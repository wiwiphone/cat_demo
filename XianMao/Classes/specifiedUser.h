//
//  specifiedUser.h
//  XianMao
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface specifiedUser : JSONModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger recoveryNum;
@property (nonatomic, assign) NSInteger isCanPush;
@property (nonatomic, assign) NSInteger isCanEvenPush;
@property (nonatomic, assign) NSInteger pushMaxNum;

@end
