//
//  RecoveryGoodsPublish.h
//  XianMao
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface RecoveryGoodsPublish : JSONModel

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *desc;

@end
