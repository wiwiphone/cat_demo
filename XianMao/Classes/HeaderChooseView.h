//
//  HeaderChooseView.h
//  XianMao
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailInfo.h"

typedef void(^headerScrollTableInfIndexP)(NSInteger index);

@interface HeaderChooseView : UIView

@property (nonatomic, copy) headerScrollTableInfIndexP headerScrollTableInfIndexP;


- (void)getGoodsDetailInfo:(GoodsDetailInfo *)detailInfo;

@end
