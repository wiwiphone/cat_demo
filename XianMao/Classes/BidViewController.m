//
//  BidViewController.m
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BidViewController.h"

@interface BidViewController ()

@end

@implementation BidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setupTopBar];
    [super setupTopBarBackButton:[UIImage imageNamed:@"back_Log_MF"] imgPressed:nil];
    [super setupTopBarTitle:@"确认出价"];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Insure_rigth_btn_MF"] imgPressed:nil];
    
    
}


@end
