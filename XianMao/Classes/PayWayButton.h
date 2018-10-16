//
//  PayWayButton.h
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayDO.h"

@interface PayWayButton : UIButton

@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic ,strong) PayWayDO * payWayDO;

@end
