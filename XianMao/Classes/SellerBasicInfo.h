//
//  SellerBasicInfo.h
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface SellerBasicInfo : JSONModel

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger birthday;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *front_url;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger auth_type;
@property (nonatomic, assign) NSInteger is_support_return;
@property (nonatomic, assign) NSInteger has_store;
@property (nonatomic, assign) NSInteger seller_rank;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) NSInteger score;

@end
