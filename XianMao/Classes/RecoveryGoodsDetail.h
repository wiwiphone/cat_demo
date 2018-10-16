//
//  RecoveryGoodsDetail.h
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "RecoveryGoodsVo.h"
#import "HighestBidVo.h"

@interface RecoveryGoodsDetail : JSONModel

@property (nonatomic, strong) RecoveryGoodsVo *recoveryGoodsVo;
@property (nonatomic, strong) HighestBidVo *highestBidVo;
@property (nonatomic, strong) HighestBidVo *authBidVo;
@property (nonatomic, assign) NSInteger total_bid_num;
@property (nonatomic, copy) NSString *desc;

@end
