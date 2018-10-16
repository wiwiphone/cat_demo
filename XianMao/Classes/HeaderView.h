//
//  HeaderView.h
//  XianMao
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoveryGoodsVo.h"
#import "MainPic.h"
#import "HighestBidVo.h"
#import "RecoveryGoodsDetail.h"

@protocol HeaderViewDelegate <NSObject>

@optional
-(void)pushChatViewController:(HighestBidVo *)authBidVO;

@end

@interface HeaderView : UIView

-(void)getRecoveryGoodsVO:(RecoveryGoodsVo *)recoveryGoodsVo andMianPic:(MainPic *)mainPic andBigVO:(HighestBidVo *)bigVO andGoodsDetail:(RecoveryGoodsDetail *)goodsDetail andDict:(NSDictionary *)dict;

@property (nonatomic, weak) id<HeaderViewDelegate> headerDelegate;

@end
