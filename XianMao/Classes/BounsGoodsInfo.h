//
//  BounsGoodsInfo.h
//  XianMao
//
//  Created by apple on 16/11/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface BounsGoodsInfo : JSONModel

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger amount_cent;
@property (nonatomic, copy) NSString *bonus_id;
@property (nonatomic, copy) NSString *bonus_name;
@property (nonatomic, assign) NSInteger can_use;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, assign) NSInteger min_pay_amount;
@property (nonatomic, assign) NSInteger min_pay_amount_cent;
@property (nonatomic, copy) NSString *redirect_url;
@property (nonatomic, assign) long long send_end_time;
@property (nonatomic, assign) long long send_start_time;
@property (nonatomic, assign) NSInteger sender_id;
@property (nonatomic, assign) NSInteger service_type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) long long use_end_time;
@property (nonatomic, assign) long long use_start_time;

@end
