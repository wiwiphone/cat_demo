//
//  AuthView.h
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighestBidVo.h"
#import "RecoveryGoodsDetail.h"

@interface AuthView : UIView

-(void)getBidVO:(HighestBidVo *)authBidVO andGoodsDetail:(RecoveryGoodsDetail *)goodsDeatil;

@end
