//
//  orderReturnItemListModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@protocol orderReturnItemListModel;

@interface orderReturnItemListModel : JSONModel

@property (nonatomic,copy) NSString *admMoney;
@property (nonatomic,copy) NSString *alipayBatchNo;
@property (nonatomic,copy) NSString *alipayRefundUrl;
@property (nonatomic,copy) NSString *bonusId;
@property (nonatomic,copy) NSString *buyerId;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *payType;//支付方式 0 支付宝 1 微信支付 2 银联 3 一网通 10 爱丁猫余额 50 分期乐 100 线下支付

@property (nonatomic,copy) NSString *paymentId;
@property (nonatomic,copy) NSString *reason;
@property (nonatomic,copy) NSString *refundMoney;
@property (nonatomic,copy) NSString *refundPaymentId;
@property (nonatomic,copy) NSString *refundPaymentStatus;//退款支付状态：0初始 1打款中 2成功 3失败
@property (nonatomic,copy) NSString *refundStatus;//退款处理状态 0初始 1同意申请 2退款完成 3拒绝 4取消 5系统关闭
@property (nonatomic,copy) NSString *refundTime;//退款到账时间
@property (nonatomic,copy) NSString *returnId;
@property (nonatomic,copy) NSString *rewardMoney;
@property (nonatomic,copy) NSString *sellerId;
@property (nonatomic,copy) NSString *status;//退款记录状态 0初始， 1退款、退货结束
@property (nonatomic,copy) NSString *totalPrice;//单项退款总金额
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *totalPriceStr;

@end
