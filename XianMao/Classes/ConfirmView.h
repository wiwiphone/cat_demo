//
//  ConfirmView.h
//  XianMao
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighestBidVo.h"
#import "RecoveryGoodsVo.h"
@protocol ConfirmViewDelegate <NSObject>

@optional
-(void)authUser:(HighestBidVo *)bidVO;

@end

@interface ConfirmView : UIView

-(void)getBidVO:(HighestBidVo *)bidVO andGoodsVO:(RecoveryGoodsVo *)goodsVo;
@property (nonatomic, weak) id<ConfirmViewDelegate> conDelegate;

@end
