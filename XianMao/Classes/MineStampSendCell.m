//
//  MineStampSendCell.m
//  XianMao
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineStampSendCell.h"
#import "SendSaleViewController.h"
#import "SendSaleNewViewController.h"

@implementation MineStampSendCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.subLbl.hidden = YES;
        self.titleLbl.text = @"我的寄卖";
        
    }
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    SendSaleViewController *viewController = [[SendSaleViewController alloc] init];
    SendSaleNewViewController *viewController = [[SendSaleNewViewController alloc] init];
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

@end
