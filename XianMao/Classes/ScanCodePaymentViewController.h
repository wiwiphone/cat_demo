//
//  ScanCodePaymentViewController.h
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfo.h"

@interface ScanCodePaymentViewController : BaseViewController

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger payWay;
@property (nonatomic, strong) OrderInfo *orderInfo;
@property (nonatomic, assign) BOOL isFromOrder;
@property (nonatomic, copy) NSString *topBarTitle;

@end
