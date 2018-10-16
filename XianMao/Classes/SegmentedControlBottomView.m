//
//  SegmentedControlBottomView.m
//  XianMao
//
//  Created by Marvin on 2017/4/5.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SegmentedControlBottomView.h"

@implementation SegmentedControlBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 开启分页
        self.pagingEnabled = YES;
        // 没有弹簧效果
        self.bounces = NO;
        // 隐藏水平滚动条
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

+ (instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

/**
 *  给外界提供的方法（必须实现）
 *  @param index    外界控制器子控制器View的下表
 *  @param outsideVC    外界控制器（主控制器、self的父控制器）
 */
- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)outsideVC {
    
//    CGFloat offsetX = index * self.frame.size.width;
//
//    UIViewController *vc = outsideVC.childViewControllers[index];
//
//    
//    [self addSubview:vc.view];
//    vc.view.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
    
    
    CGFloat offsetX = index * self.frame.size.width;
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


- (void)setChildViewController:(NSArray *)childViewController {
    _childViewController = childViewController;
    
    for (int i = 0; i < childViewController.count; i++) {
        CGFloat offsetX = i * self.frame.size.width;
        UIViewController *vc = childViewController[i];
        vc.view.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:vc.view];
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width * childViewController.count, 0);
}

@end
