//
//  LaunchNewPageView.m
//  XianMao
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LaunchNewPageView.h"
#import "AppDelegate.h"
#import "WeakTimerTarget.h"
#import "LaunchPageView.h"

@interface LaunchNewPageView ()

@property(nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) WeakTimerTarget *weakTimerTarget;

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) XMWebImageView *nameImageView;
@property (nonatomic, strong) XMWebImageView *contentImageView;
@property (nonatomic, strong) XMWebImageView *bottomImageView;
@property (nonatomic, strong) XMWebImageView *conetntBottomImageView;

@property (nonatomic, strong) NSTimer *timerTwo;
@end

@implementation LaunchNewPageView

-(XMWebImageView *)conetntBottomImageView{
    if (!_conetntBottomImageView) {
        _conetntBottomImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _conetntBottomImageView.image = [UIImage imageNamed:@"ADMBottomName_Content"];
        [_conetntBottomImageView sizeToFit];
    }
    return _conetntBottomImageView;
}

-(XMWebImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _bottomImageView.image = [UIImage imageNamed:@"ADMBottomName"];
        [_bottomImageView sizeToFit];
    }
    return _bottomImageView;
}

-(XMWebImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _contentImageView.image = [UIImage imageNamed:@"ADMName_Content"];
        [_contentImageView sizeToFit];
    }
    return _contentImageView;
}

-(XMWebImageView *)nameImageView{
    if (!_nameImageView) {
        _nameImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _nameImageView.image = [UIImage imageNamed:@"ADMName"];
        [_nameImageView sizeToFit];
    }
    return _nameImageView;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageView;
}

+(void)showNewLaunchPageView{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone)
    {
        LaunchNewPageView *view = [[LaunchNewPageView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [view show];
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)show
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self removeFromSuperview];
    self.contentMode = UIViewContentModeScaleAspectFill;
    [appDelegate.window addSubview:self];
    [appDelegate.window bringSubviewToFront:self];
    
    [_timer invalidate];
    WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
    self.weakTimerTarget = weakTimerTarget;
    
    self.timerTwo = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    if (!self.iconImageView.isAnimating) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 19; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"LaunchAni_%d", i]]];
        }
        self.iconImageView.animationImages = arr;
        self.iconImageView.animationDuration = 45*0.055;
        self.iconImageView.animationRepeatCount = 1;
        [self.iconImageView setImage:[UIImage imageNamed:@"LaunchAni_18"]];
        [self.iconImageView startAnimating];
        [self.iconImageView sizeToFit];
        [self addSubview:self.iconImageView];
        [self.iconImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.iconImageView.animationDuration];
    }
    
    [self addSubview:self.nameImageView];
    [self addSubview:self.contentImageView];
    [self addSubview:self.bottomImageView];
    [self addSubview:self.conetntBottomImageView];
    self.nameImageView.alpha = 0;
    self.contentImageView.alpha = 0;
    self.bottomImageView.alpha = 0;
    self.conetntBottomImageView.alpha = 0;
    [self setUpUI];
}

-(void)onTimer {
    WEAKSELF;
    if ( [self.iconImageView isAnimating] )
    {
        // still animating
    } else {
        [self.timerTwo invalidate];
        
        [UIView animateWithDuration:0.6 animations:^{
            weakSelf.nameImageView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.nameImageView.alpha = 1;
                weakSelf.contentImageView.alpha = 0.4;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    weakSelf.contentImageView.alpha = 1;
                } completion:^(BOOL finished) {
                    
//                    [UIView animateWithDuration:0.6 animations:^{
//                        weakSelf.bottomImageView.alpha = 0.6;
//                    } completion:^(BOOL finished) {
//                        [UIView animateWithDuration:0.3 animations:^{
//                            weakSelf.bottomImageView.alpha = 1;
//                            weakSelf.conetntBottomImageView.alpha = 0.4;
//                        } completion:^(BOOL finished) {
//                            [UIView animateWithDuration:0.4 animations:^{
//                                weakSelf.conetntBottomImageView.alpha = 1;
//                            } completion:^(BOOL finished) {
//                                
//                            }];
//                        }];
//                    }];
                    
                }];
            }];
        }];
        
    }
    
}

-(void)dealloc{
    [self.timer invalidate];
    [self.timerTwo invalidate];
    self.timer = nil;
    self.timerTwo = nil;
}

-(void)setUpUI{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(110);
    }];
    
    [self.nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameImageView.mas_bottom).offset(10);
    }];
    
    [self.conetntBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-90);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.conetntBottomImageView.mas_top).offset(-15);
    }];
}

-(void)setAnimationImages:(NSMutableArray*)arr{

}

- (void)onTimer:(NSTimer*)theTimer
{
    [_timer invalidate];
    _timer = nil;
    [self dismiss:nil];
}

- (void)dismiss:(void (^)(BOOL finished))completion
{
    [LaunchPageView showLaunchView];
    CGRect endFrame = CGRectMake(-self.width, 0, self.width, self.height);
    endFrame = CGRectMake(-[UIScreen mainScreen].bounds.size.width * 0.5, -[UIScreen mainScreen].bounds.size.height * 0.5, [UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height * 2);
    [UIView animateWithDuration:0.5 animations:^{
        //        self.frame = endFrame;
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPageImage" object:nil];
        if (completion) {
            completion(finished);
        }
    }];
}

@end
