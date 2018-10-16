//
//  LimitGoodsCollectionViewCell.h
//  XianMao
//
//  Created by Marvin on 2017/6/22.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

@interface LimitGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) void(^handleBuyBtnBlock)(GoodsInfo *goodsInfo);

- (void)getGoodsInfo:(GoodsInfo *)goodsInfo;

@end
