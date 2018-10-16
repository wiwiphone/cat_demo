//
//  OrderTableViewCell.h
//  XianMao
//
//  Created by simon on 1/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SwipeTableViewCell.h"
#import "Command.h"
#import "GoodsInfo.h"

#define kDoUpdateOrderInfoNotification @"kDoUpdateOrderInfoNotification"
#define kDoUpdateOrderInfoInDetailNotification @"kDoUpdateOrderInfoInDetailNotification"
@class OrderInfo;
@class OrderActionsView;
@interface OrderTableViewCell : SwipeTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(OrderInfo*)orderInfo;
+ (NSString*)cellDictKeyForOrderInfo;
+ (NSString*)cellDictKeyForSeleted;

- (void)updateCellWithDict:(NSDictionary*)dict;

@property(nonatomic,strong) OrderActionsView *actionsView;
@property(nonatomic,copy) void(^handleOrderActionTryDelayBlock)(NSString *orderId);
@property(nonatomic,copy) void(^handleOrderActionLogisticsBlock)(OrderInfo *orderInfo);
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

@property(nonatomic,copy) void(^handleOrderActionShowPayTipBlock)(OrderInfo *orderInfo);
@property(nonatomic,copy) void(^handleOrderActionSeriviceBlock)(OrderInfo *orderInfo);
@property (nonatomic, copy) void(^handleOrderActionDeleteOrderBlock)(OrderInfo * orderInfo);
//@property(nonatomic,copy) void(^handleOrderActionApplyRefundBlock)(OrderInfo *orderInfo);

///sold
@property(nonatomic,copy) void(^handleOrderGoodsModifyPriceBlock)(NSString *orderId,GoodsInfo *goodsInfo);
@property(nonatomic,copy) void(^handleOrderActionOfflineConfirmPaymentBlock)(NSString *orderId); //确认收款
@property(nonatomic,copy) void(^handleOrderActionOfflineSendBlock)(OrderInfo *orderInfo); //线下发货
@property(nonatomic,copy) void(^handleOrderActionSendBlock)(OrderInfo *orderInfo); //发货

@property(nonatomic,copy) void(^handleOrderActionRenewGoodsBlock)(NSString *goodsId); //重新上架

@property(nonatomic,copy) void(^handleOrderActionAgreeRefundBlock)(OrderInfo *orderInfo, BOOL isAgree);
@property(nonatomic,copy) void(^handleOrderActionResellGoodsBlock)(NSString *goodsId); //一键转卖
@end


//@class GoodsInfo;
@interface OrderGoodsView : TapDetectingView

@property(nonatomic,weak) OrderTableViewCell *orderTableViewCell;

+ (CGFloat)heightForOrientationPortrait;

- (void)prepareForReuse;
- (void)updateWithOrderInfo:(GoodsInfo*)goodsInfo orderInfo:(OrderInfo*)orderInfo;

@end

@protocol OrderActionsViewDelegate <NSObject>

-(void)handleOrderActionResellGoods:(NSString *)goodsId order:(NSString *)orderId;

@end

@interface OrderActionsView : UIView

@property(nonatomic,weak) OrderTableViewCell *orderTableViewCell;
@property (nonatomic, weak) id<OrderActionsViewDelegate> delegate;
@property (nonatomic, strong) GoodsInfo * goodsInfo;
+ (CGFloat)heightForOrientationPortrait:(OrderInfo*)orderInfo;

- (void)prepareForReuse;
- (void)updateWithOrderInfo:(OrderInfo*)orderInfo;


@end


@interface OrderActionsViewSold : OrderActionsView

@end


@interface OrderTableViewCellSold : OrderTableViewCell

@end



