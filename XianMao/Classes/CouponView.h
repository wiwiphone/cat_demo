//
//  CouponView.h
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusInfo.h"


@interface CouponView : UIView


@property (nonatomic, strong) void(^selectBouns)(NSMutableArray * array);

- (BonusInfo *)getbouns:(NSMutableArray *)bounsArray;
- (CGFloat)getBounsInfo:(BonusInfo *)bonusInfo;

@end
