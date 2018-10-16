//
//  BankAccountView.h
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WithdrawalsAccountVo;

@interface BankAccountView : UIButton

@property (nonatomic, strong) WithdrawalsAccountVo * withdrawaVo;


- (void)getWithdrawaVo:(WithdrawalsAccountVo *)withdrawaVo account:(NSString *)account;

@end
