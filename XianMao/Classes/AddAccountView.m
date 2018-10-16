//
//  AddAccountView.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AddAccountView.h"
#import "AddAccountIconVo.h"
#import "AddAccountButton.h"
#import "AddBandCardViewController.h"
#import "AddAlipayViewController.h"

@implementation AddAccountView

- (void)getAddAccountVo:(NSArray *)array
{
    for (id obj in self.subviews) {
        [obj removeFromSuperview];
    }
    
    for (int i = 0; i < array.count; i++) {
        AddAccountIconVo * addAccountVo = [array objectAtIndex:i];
        AddAccountButton * button = [[AddAccountButton alloc] initWithFrame:CGRectMake(0, i*68, kScreenWidth, 68)];
        button.addAccountVo = addAccountVo;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(AddAccountButton *)button
{
    NSInteger type = button.addAccountVo.type;
    switch (type) {
        case 0:
        {
            AddAlipayViewController * alipay = [[AddAlipayViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:alipay animated:YES];
            break;
        }
        case 1:
        {
            AddBandCardViewController * bank = [[AddBandCardViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:bank animated:YES];
            
            break;
        }
            
        default:
            break;
    }
}

@end
