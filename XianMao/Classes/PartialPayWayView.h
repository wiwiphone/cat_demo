//
//  PartialPayWayView.h
//  XianMao
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParyialDo.h"
#import "PayWayDO.h"
typedef void(^dismissPartialPayWayView)();
typedef void(^changePayWay)(PayWayDO *payWay);

@interface PartialPayWayView : UIView

@property (nonatomic, copy) dismissPartialPayWayView dismissPartialPayWayView;
@property (nonatomic, copy) changePayWay changePayWay;

-(void)getPartialDo:(ParyialDo *)partialDo;

@end
