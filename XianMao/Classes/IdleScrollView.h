//
//  IdleScrollView.h
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

@interface IdleScrollView : UIScrollView

-(void)getPicData:(NSArray *)picData andGoodsInfo:(GoodsInfo *)goodsInfo;

@end
