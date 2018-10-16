//
//  SuccessfulPayViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailInfo.h"

@interface SuccessfulPayViewController : BaseViewController

@property (nonatomic, copy) NSString *goodsId;

-(void)getOrderDetailInfo:(OrderDetailInfo *)orderDetailInfo;

@end
