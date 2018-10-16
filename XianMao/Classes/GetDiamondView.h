//
//  GetDiamondView.h
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeowRecordVo.h"
#import "MeowCatVo.h"

@interface GetDiamondView : UIView



- (void)showGetDiamondView:(MeowCatVo *)meowCatVo;
- (void)dismissGetDiamondView;
+ (BOOL)isNeedShowGetDiamondView;

@end

