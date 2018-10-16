//
//  TipView.h
//  XianMao
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

typedef void(^handleDisButton)();
@interface TipView : UIView

-(void)getOrderInfo:(OrderInfo *)orderInfo;

@property (nonatomic, copy) handleDisButton handleDisButton;

@end
