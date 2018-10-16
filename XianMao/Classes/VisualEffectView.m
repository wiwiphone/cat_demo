//
//  VisualEffectView.m
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "VisualEffectView.h"

@interface VisualEffectView ()

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation VisualEffectView

-(instancetype)initWithFrame:(CGRect)frame style:(MFBlurEffectStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyle)style]];
        visualEffectView.frame = self.bounds;
        [self addSubview:visualEffectView];
        self.visualEffectView = visualEffectView;
        
    }
    return self;
}

-(void)setAlpleValue:(CGFloat)alpleValue{
    _alpleValue = alpleValue;
    self.visualEffectView.alpha = alpleValue;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.visualEffectView.frame = self.bounds;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchView) {
        self.touchView();
    }
}

@end
