//
//  MatchViewController.h
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "RecoveryGoodsVo.h"

@interface MatchViewController : BaseViewController

-(void)getRecoverGoodsVO:(RecoveryGoodsVo *)goosVO;
@property (nonatomic, copy) NSString *goods_id;

@end
