//
//  LogisticsViewController.h
//  XianMao
//
//  Created by WJH on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailInfo.h"

@interface LogisticsViewController : BaseViewController

@property (nonatomic, copy) NSString * url;
@property (nonatomic, strong) MailInfo * mailInfo;
@property (nonatomic, strong) OrderInfo * orderInfo;

@end
