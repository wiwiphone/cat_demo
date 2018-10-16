//
//  BlackView.m
//  XianMao
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BlackView.h"
#import "Masonry.h"

@interface BlackView ()

@end

@implementation BlackView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.7;
        }];
        
    }
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMissResales" object:nil];
    
    if (self.dissMissBlackView) {
        self.dissMissBlackView();
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
       
//        [self removeFromSuperview];
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
