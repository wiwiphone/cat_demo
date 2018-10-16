//
//  ConfirmBackView.m
//  XianMao
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ConfirmBackView.h"

@implementation ConfirmBackView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.confirmBackDelegate respondsToSelector:@selector(dissMissConBackView)]) {
        [self.confirmBackDelegate dissMissConBackView];
    }
}

@end
