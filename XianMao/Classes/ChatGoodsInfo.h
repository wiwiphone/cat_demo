//
//  ChatGoodsInfo.h
//  XianMao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface ChatGoodsInfo : JSONModel

@property (nonatomic, copy) NSString *goodsSn;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, assign) NSInteger shopPrice;

@end
