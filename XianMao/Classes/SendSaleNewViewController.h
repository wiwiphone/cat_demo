//
//  SendSaleNewViewController.h
//  XianMao
//
//  Created by WJH on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface SendSaleNewViewController : BaseViewController

@property (nonatomic, assign) BOOL isNeesGuideView;

@end



@interface SendSaleGuideView : UIView
- (void)show:(UIView *)view;
@end
