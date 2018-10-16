//
//  AccountLogVo.h
//  XianMao
//
//  Created by simon cai on 25/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "JSONModel.h"

//public static final int WITHDRAWAL = 1;
//public static final int INCOME = 2;
//public static final int REFUND = 3;
//public static final int CONSUME = 4;
//

@interface AccountLogVo : JSONModel

@property(nonatomic,assign) long long createtime;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign) NSInteger amount_cent;
@property(nonatomic,copy) NSString *amount_text;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property(nonatomic,copy) NSString *icon_url;

@end
