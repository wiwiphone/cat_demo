//
//  LaunchScreenViewController.m
//  XianMao
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LaunchBottomView.h"

@interface LaunchScreenViewController ()

@property (nonatomic, strong) LaunchBottomView *launchBottomView;

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.launchBottomView = [[LaunchBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-142, kScreenWidth, 142)];
    [self.view addSubview:self.launchBottomView];
    
}

@end
