//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYHeader.h"

@interface MJDIYHeader() {
    double p;
}
@property (weak, nonatomic) UILabel *label;
//@property (weak, nonatomic) UISwitch *s;
@property (weak, nonatomic) UIImageView *myImageView;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@property (weak, nonatomic) NSTimer *timer;
//@property (weak, nonatomic) CABasicAnimation* rotationAnimation;
@end

@implementation MJDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_refresh_arrow"]];
    [self addSubview:myImageView];
    self.myImageView = myImageView;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_refresh_indicator"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:logo];
    self.logo = logo;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    self.label.frame = self.bounds;
    
    self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 100);
    self.logo.center = CGPointMake(self.mj_w * 0.5, - self.logo.mj_h + 20);
    
    self.loading.center = CGPointMake(self.mj_w - 30, self.mj_h * 0.5);
    self.myImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2. - 40, self.mj_h * 0.5);
    
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.myImageView.transform = CGAffineTransformMakeRotation(M_PI);
            p = M_PI;
            self.myImageView.image = [UIImage imageNamed:@"pull_refresh_arrow"];
            if ([self.timer isValid]) {
                [self.timer invalidate];
                self.timer = nil;
            }
            self.label.text = @"下拉刷新";
//            NSLog(@"下拉刷新");
            break;
        case MJRefreshStatePulling:
            self.myImageView.transform = CGAffineTransformMakeRotation(0);
            p = 0;
            self.label.text = @"释放更新";
//            NSLog(@"释放更新");
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载中...";
//            NSLog(@"加载中");
            self.myImageView.image = [UIImage imageNamed:@"pull_round_refreshing"];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startss) userInfo:nil repeats:YES];
            [self.timer fire];
            
            break;
        default:
            break;
    }
}

- (void)startss {
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:( M_PI * 2.0 + p)];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 1;
        [self.myImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } completion:^(BOOL finished) {
//        NSLog(@"startss");
    }];
}


- (void)clockwiseRotationStopped:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext{
    /* 回到原始旋转 */
    self.myImageView.transform = CGAffineTransformIdentity;
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
