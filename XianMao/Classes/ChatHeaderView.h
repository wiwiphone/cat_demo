//
//  ChatHeaderView.h
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoveryGoodsVo.h"
#import "HighestBidVo.h"
#import "RecoveryGoodsDetail.h"

@interface ChatHeaderView : UIView

-(void)getHeaderViewGoodsVO:(RecoveryGoodsVo *)goodsVO andBidVO:(HighestBidVo *)bidVO andGoodsDeatil:(RecoveryGoodsDetail *)goodsDetail;

@end
