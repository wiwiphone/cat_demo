//
//  PayTypeView.h
//  XianMao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParyialDo.h"

typedef void(^showPayWayView)();

@interface PayTypeView : UIView

@property(nonatomic, copy) showPayWayView showPayWayView;
-(void)getPartialDo:(ParyialDo *)partialDo;

@end
