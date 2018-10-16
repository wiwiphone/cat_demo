//
//  RefundProgressViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfo.h"

@interface RefundProgressViewController : BaseViewController

@property (nonatomic,copy) NSString * orderID;
@property (nonatomic,strong) OrderInfo * orderInfo;
@end
