//
//  PromptView.m
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PromptView.h"

@implementation PromptView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMissBackView" object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
