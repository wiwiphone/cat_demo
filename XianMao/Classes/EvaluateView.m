//
//  EvaluateView.m
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "EvaluateView.h"
#import "ContainerEvaluateView.h"
#import "Version.h"
#import "EvaluateViewController.h"
#import "BlackView.h"
#import "Session.h"


@interface EvaluateView()

@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) ContainerEvaluateView * container;
@property (nonatomic,strong) ContainerEvaluateView * container2;
@property (nonatomic,strong) ContainerEvaluateView * container3;


@end

@implementation EvaluateView


-(UIView *)container
{
    if (!_container) {
        WEAKSELF;
        _container = [[ContainerEvaluateView alloc] initWithiconName:@"smile" desString:@"此次购物还满意吗?" btn1Name:@"不太满意" btn2Name:@"还不错哦"];
        _container.alpha = 0;
        
        _container.colseBtn.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
            [weakSelf dismiss];
        };

    }
    return _container;
}

-(UIView *)container2
{
    if (!_container2) {
        WEAKSELF;
        _container2 = [[ContainerEvaluateView alloc] initWithiconName:@"letter" desString:@"给我们提点意见反馈吧?" btn1Name:@"不了,谢谢" btn2Name:@"好的,写点反馈"];
        _container2.alpha = 0;
        _container2.colseBtn.hidden = YES;
        _container2.btn1.handleClickBlock = ^(CommandButton * button){
            [weakSelf dismiss];
        };
        
        _container2.btn2.handleClickBlock = ^(CommandButton * button){
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf dismiss];
            } completion:^(BOOL finished) {
                EvaluateViewController * evaluate = [[EvaluateViewController alloc] init];
                [[CoordinatingController sharedInstance] pushViewController:evaluate animated:YES];
            }];
        };
        
    }
    return _container2;
}

-(UIView *)container3
{
    if (!_container3) {
        WEAKSELF;
        _container3 = [[ContainerEvaluateView alloc] initWithiconName:@"share_wjh" desString:@"此去App Store写个好评吧?" btn1Name:@"不了谢谢" btn2Name:@"好的,写个好评去"];
        _container3.colseBtn.hidden = YES;
        _container3.alpha = 0;
        _container3.btn1.handleClickBlock = ^(CommandButton * button){
            [weakSelf dismiss];
        };
        
        _container3.btn2.handleClickBlock = ^(CommandButton * button){
            NSInteger userId = [Session sharedInstance].currentUser.userId;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_ITUNES_URL]];
        };
    }
    return _container3;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [self addSubview:self.bgView];
        [self addSubview:self.container];
        [self addSubview:self.container2];
        [self addSubview:self.container3];
       
        
        WEAKSELF;
        
        _container.btn1.handleClickBlock = ^(CommandButton * button){
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.container.alpha = 0;
                weakSelf.container3.alpha = 0;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.container2.alpha = 1;
                }];
                
            }];
            
        };
        
        
        _container.btn2.handleClickBlock = ^(CommandButton * button){
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.container2.alpha = 0;
                weakSelf.container.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.container3.alpha = 1;
                }];
            }];
            
        };
        
        

    }
    return self;
}



-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.4;
        self.container.alpha = 1;
    }];

}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0;
        self.container.alpha = 0;
        self.container2.alpha = 0;
        self.container3.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*245, 285));
    }];
    
    [self.container2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*245, 285));
    }];
    
    [self.container3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*245, 285));
    }];
    
}
@end
