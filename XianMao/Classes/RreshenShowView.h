//
//  RreshenShowView.h
//  AutoAdLabelScroll
//
//  Created by WJH on 16/11/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

@interface RreshenShowView : UIView

@property (nonatomic, copy) void(^handleRreshenBlcok)(GoodsInfo *goodsInfo);


- (void)show;
- (void)dismiss;
- (void)getGoodsInfo:(GoodsInfo *)goodsInfo;

@end
