//
//  GoodsBottomView.h
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"
#import "Command.h"

typedef void(^commentGoods)();
typedef void(^handleAddShopBag)();

typedef void(^clickLikeBtn)();

@interface GoodsBottomView : UIView

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) handleAddShopBag handleAddShopBag;
@property (nonatomic, copy) void(^handleEditGoodsBlock)(GoodsInfo *goodsInfo);
@property (nonatomic, copy) commentGoods commentGoods;
@property (nonatomic, strong) CommandButton *addShopBag;

@property (nonatomic, copy) clickLikeBtn clickLikeBtn;

-(void)getGoodsInfo:(GoodsInfo *)goodsInfo;

@end
