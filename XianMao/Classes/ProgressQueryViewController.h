//
//  ProgressQueryViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfo.h"

@interface ProgressQueryViewController : BaseViewController

@property (nonatomic,copy) NSString * orderID;
@property (nonatomic,strong) OrderInfo * orderInfo;
@end
