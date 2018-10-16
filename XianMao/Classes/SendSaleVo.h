//
//  SendSaleVo.h
//  XianMao
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailInfo.h"

const NSInteger TO_CONSIGMENT = 0x1;// 标签 发货给寄卖中心
const NSInteger SEE_LOGISTICS = 0x2; //标签 查看物流
const NSInteger CONTACT_APPRAISER = 0x4; //联系估价师
const NSInteger SEE_GOODS_DETAIL = 0x8; // 查看商品详情
const NSInteger CONFIRM_RECEIPT = 16; //确认收货
const NSInteger CONFIRM_DELLETE = 32; //取消寄卖订单

@interface SendSaleVo : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger updatetime;
@property (nonatomic, copy) NSString *consigmentSn;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger gradeLevel;
@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, strong) NSArray *attachment;
@property (nonatomic, assign) double userHopePrice;
@property (nonatomic, assign) NSInteger status;//状态  0，初始状态,1，待收货,2，待鉴定,3，待发布,4，已发布,5，已下架，6，已付款 买家已收货 7，鉴定不通过 8，已退回 9，已退回,已收货
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, copy) NSString *logistical;
@property (nonatomic, copy) NSString *logisticalNum;
@property (nonatomic, copy) NSString *returnLogistical;
@property (nonatomic, copy) NSString *returnLogisticalNum;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString * themeName;
@property (nonatomic, copy) NSString * themeAvatar;
@property (nonatomic, assign) NSInteger labelNum;
@property (nonatomic, copy) NSString *statusDesc;
@property (nonatomic, copy) NSString *sdesc;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *returnAddress;
@property (nonatomic, assign) long onlineTime;
@property (nonatomic, assign) long outLineTime;
@property (nonatomic, assign) long dealTime;
@property (nonatomic, assign) NSInteger estimatorId;
@property (nonatomic, copy) NSString * goodsSn;
+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSMutableArray *)returnActionsButtons;

@end
