//
//  AdviserPage.h
//  XianMao
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface AdviserPage : JSONModel

@property (nonatomic, assign) NSInteger adviserId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *weixinId;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger labourId;
@property (nonatomic, copy) NSString *greetings;

@property (nonatomic, copy) NSString *nickname;
@end
