//
//  OfferedViewController.h
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "RecoveryGoodsVo.h"
#import "HighestBidVo.h"

@interface OfferedViewController : BaseViewController

-(void)getExprtime:(RecoveryGoodsVo *)recoverGoodsVO andAuthBidVO:(HighestBidVo *)authBidVO;
@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, assign) NSInteger index;

@end
