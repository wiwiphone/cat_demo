//
//  PayWaySelectedView.h
//  XianMao
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayDO.h"

typedef void(^changeSelectedPayWay)(PayWayDO *payWay);

@interface PayWaySelectedView : UIView

@property (nonatomic, copy) changeSelectedPayWay changeSelectedPayWay;

-(void)getPayWayDo:(PayWayDO *)payWayDo;

@property (nonatomic, assign) NSInteger avaMoneyCent;
@end
