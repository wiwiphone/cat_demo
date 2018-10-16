//
//  ADMShoppingCentreViewController.h
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface ADMShoppingCentreViewController : BaseViewController

@property (nonatomic, assign) NSInteger userId;
-(void)setViews;
@property (nonatomic, strong) UIButton *goodsNumLbl;
- (void)updateGoodsNumLbl:(NSInteger)goodsNum;
@end
