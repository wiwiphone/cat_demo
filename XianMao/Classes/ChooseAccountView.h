//
//  ChooseAccountView.h
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountList.h"
#import "WithdrawalsAccountVo.h"

@interface ChooseAccountView : UIView

@property (nonatomic, copy) void(^handleCloseBtnBlock)();
@property (nonatomic, copy) void(^handleWithdrawaAccountBlock)(WithdrawalsAccountVo * withdrawaVo);


-(void)getAccountList:(AccountList *)account withdrawalsVo:(WithdrawalsAccountVo *)withdrawalsVo;

@end
