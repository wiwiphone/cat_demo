//
//  OrderGoodsInfoVo.h
//  XianMao
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface OrderGoodsInfoVo : JSONModel<NSCoding>


/**
 发布的商品
 */
@property (nonatomic, assign) NSInteger myGoodsUp;//售卖中
@property (nonatomic, assign) NSInteger myGoodsDown;//已下架
@property (nonatomic, assign) NSInteger myGoodsValid;//待审核

/**
 我卖出的
 */
@property (nonatomic, assign) NSInteger mySellNotSend;//我卖出的
@property (nonatomic, assign) NSInteger mySellFinish;//已成交
@property (nonatomic, assign) NSInteger mySellReceiving;//待收货
@property (nonatomic, assign) NSInteger mySellCancel;//已关闭
@property (nonatomic, assign) NSInteger mySellAppraise;//待鉴定

/**
 我的订单(我买的)
 */
@property (nonatomic, assign) NSInteger myOrderNotPayed;//待付款
@property (nonatomic, assign) NSInteger myOrderNotSend;////待发货
@property (nonatomic, assign) NSInteger myOrderSend;
@property (nonatomic, assign) NSInteger myOrderFinish;//已成交
@property (nonatomic, assign) NSInteger myOrderReceiving; //待收货
@property (nonatomic, assign) NSInteger myOrderCancel;//已关闭
@property (nonatomic, assign) NSInteger myOrderAppraise;

@end
