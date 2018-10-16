//
//  RechargeAmountView.h
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountCard.h"

@interface RechargeAmountView : UIView
@property (nonatomic, strong) AccountCard * accountCard;
@property (nonatomic, strong) NSMutableArray * dataSources;

@end


@class RechargeRule;
@interface RechargeRuleButton : UIButton
@property (nonatomic, strong) RechargeRule * rechargeRule;

@end
