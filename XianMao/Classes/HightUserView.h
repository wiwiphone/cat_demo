//
//  HightUserView.h
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighestBidVo.h"
#import "RecoveryGoodsDetail.h"
#import "RecoveryGoodsVo.h"

@interface HightUserView : UIView

-(void)getHighUser:(HighestBidVo *)bidVO andGoodsDetail:(RecoveryGoodsDetail *)goodsDetail andRecoveryVO:(RecoveryGoodsVo *)goodsVO andDict:(NSDictionary *)dict;

@end
