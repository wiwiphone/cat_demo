//
//  OrderPriceCell.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderInfo.h"
#import "GoodsInfo.h"

@protocol OrderPriceCellDelegate <NSObject>

-(void)seeBuyBackJinDu;

@end

@interface OrderPriceCell : BaseTableViewCell

@property (nonatomic,weak) id<OrderPriceCellDelegate>delegate;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(OrderInfo *)orderInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@property(nonatomic,copy) void(^handleQuestionBlock)(OrderInfo *orderInfo);

@property(nonatomic,copy) void(^handleOrderActionTryDelayBlock)(NSString *orderId);
@property(nonatomic,copy) void(^handleOrderActionLogisticsBlock)(NSString *orderId);
@property(nonatomic,copy) void(^handleOrderActionConfirmReceivingBlock)(NSString *orderId);
@property(nonatomic,copy) void(^handleOrderActionPayBlock)(NSString *orderId, NSInteger payWay, OrderInfo *orderInfo);
@property(nonatomic,copy) void(^handleOrderActionSelectBlock)(NSString *orderId);
@property(nonatomic,copy) void(^handleOrderActionChatBlock)(NSInteger userId,OrderInfo *orderInfo,NSInteger isConsultant);
@property(nonatomic,copy) void(^handleOrderBuyerActionChatBlock)(NSInteger userId,OrderInfo *orderInfo);

@property(nonatomic,copy) void(^handleOrderActionMoreBlock)(OrderInfo *orderInfo, NSInteger type);
@property(nonatomic,copy) void(^handleOrderActionRemindShippingGoodsBlock)(OrderInfo *orderInfo);

@property(nonatomic,copy) void(^handleOrderActionConnectADMBlock)(NSInteger sellerId);

@property(nonatomic,copy) void(^handleOrderActionApplyRefundBlock)(OrderInfo *orderInfo);
@property(nonatomic,copy) void(^handleOrderActionCancelRefundBlock)(OrderInfo *orderInfo);
@property(nonatomic,copy) void(^handleOrderActionServiceBlock)(OrderInfo *orderInfo);


//@property(nonatomic,copy) void(^handleOrderActionApplyRefundBlock)(OrderInfo *orderInfo);

///sold
@property(nonatomic,copy) void(^handleOrderGoodsModifyPriceBlock)(NSString *orderId,GoodsInfo *goodsInfo);
@property(nonatomic,copy) void(^handleOrderActionOfflineConfirmPaymentBlock)(NSString *orderId); //确认收款
@property(nonatomic,copy) void(^handleOrderActionOfflineSendBlock)(NSString *orderId); //线下发货
@property(nonatomic,copy) void(^handleOrderActionSendBlock)(OrderInfo *orderInfo); //发货

@property(nonatomic,copy) void(^handleOrderActionRenewGoodsBlock)(NSString *goodsId); //重新上架

@property(nonatomic,copy) void(^handleOrderActionAgreeRefundBlock)(OrderInfo *orderInfo, BOOL isAgree);


@property(nonatomic,copy) void(^handleOrderActionApplyReturn)(OrderInfo *orderInfo);//申请回购
@property(nonatomic,copy) void(^handleOrderActionApplyProgress)(OrderInfo *orderInfo);//查看回购进度
@property(nonatomic,copy) void(^handleOrderActionrefundGoods)(OrderInfo *orderInfo);//申请退货
@property(nonatomic,copy) void(^handleOrderActionrefundGoodsProgress)(OrderInfo *orderInfo);//查看进货进度

@end
