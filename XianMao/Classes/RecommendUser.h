//
//  RecommendUser.h
//  XianMao
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface RecommendUser : JSONModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger recoveryNum;

@end
