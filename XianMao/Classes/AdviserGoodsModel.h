//
//  AdviserGoodsModel.h
//  XianMao
//
//  Created by 阿杜 on 16/9/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@class goods_stat;

@interface AdviserGoodsModel : JSONModel

@property (nonatomic,strong) NSString * goods_id;
@property (nonatomic,strong) NSString * goods_name;
@property (nonatomic,assign) NSInteger seller_id;
@property (nonatomic,strong) NSString * thumb_url;
@property (nonatomic,strong) goods_stat * goodsStat;
@property (nonatomic,assign) double market_price;
@property (nonatomic,assign) double shop_price;
@property (nonatomic,assign) double diaohuo_price;
@property (nonatomic,assign) double market_price_cent;
@property (nonatomic,assign) double shop_price_cent;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger is_limit_activity;
@property (nonatomic,assign) double original_price;
@property (nonatomic,assign) double original_price_cent;
@property (nonatomic,assign) NSInteger grade;
@property (nonatomic,assign) NSInteger goods_type;
@property (nonatomic,assign) NSInteger support_type;

@end


@interface goods_stat : JSONModel
@property (nonatomic,assign) NSInteger share_num;
@property (nonatomic,assign) NSInteger visit_num;
@property (nonatomic,assign) NSInteger like_num;

@end
