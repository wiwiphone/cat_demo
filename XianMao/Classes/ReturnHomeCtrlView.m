//
//  ReturnHomeCtrlView.m
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnHomeCtrlView.h"
#import "BlackView.h"
#import "Command.h"

@interface ReturnHomeCtrlView()

@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIImageView * iconImg;
@property (nonatomic,strong) UIView * container;
@property (nonatomic,strong) UILabel * lbl;
@property (nonatomic,strong) UILabel * lbl2;
@property (nonatomic,strong) TapDetectingImageView * closeBtn;
@property (nonatomic,strong) CommandButton * btn;


@end

@implementation ReturnHomeCtrlView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [self addSubview:self.bgView];
        [self addSubview];
        
    }
    return self;
}


-(void)addSubview
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
        _container.alpha = 0;
        [self addSubview:self.container];
        
        WEAKSELF;
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage imageNamed:@"Suc_wjh"];
        [self.container addSubview:self.iconImg];
        
        
        _lbl = [[UILabel alloc] init];
        _lbl.text = @"提交成功,感谢反馈";
        _lbl.textColor = [UIColor colorWithHexString:@"333333"];
        _lbl.font = [UIFont systemFontOfSize:15];
        [_lbl sizeToFit];
        _lbl.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:self.lbl];
        
        
        _lbl2 = [[UILabel alloc] init];
        _lbl2.text = @"如果迫切需求,您还可以添加\n爱丁猫产品经理微信号beauling";
        _lbl2.textColor = [UIColor colorWithHexString:@"888888"];
        _lbl2.font = [UIFont systemFontOfSize:13];
        _lbl2.numberOfLines = 0;
        [_lbl2 sizeToFit];
        _lbl2.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:self.lbl2];
        
        
        _btn = [[CommandButton alloc] init];
        [_btn setTitle:@"回到首页" forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn setBackgroundColor:[UIColor colorWithHexString:@"333333"]];
        [self.container addSubview:self.btn];
        
        _closeBtn = [[TapDetectingImageView alloc] init];
        _closeBtn.image = [UIImage imageNamed:@"close_btn"];
        _closeBtn.handleSingleTapDetected = ^(TapDetectingImageView * imageView,UIGestureRecognizer * tap){
            [weakSelf dismiss];
        };
        [self.container addSubview:self.closeBtn];
        
        _btn.handleClickBlock = ^(CommandButton * button){
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf dismiss];
            } completion:^(BOOL finished) {
                [[CoordinatingController sharedInstance] gotoHomeRecommendViewControllerAnimated:YES];
            }];
        };
    }
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*250, kScreenWidth/375*250));
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.container.mas_top).offset(40);
    }];
    
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.iconImg.mas_bottom).offset(16);
    }];
    
    [self.lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbl.mas_bottom).offset(16);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(30);
        make.right.equalTo(self.container.mas_right).offset(-30);
        make.bottom.equalTo(self.container.mas_bottom).offset(-28);
        make.height.mas_equalTo(40);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_top).offset(12);
        make.right.equalTo(self.container.mas_right).offset(-12);
    }];
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
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
        self.container.alpha = 0;
 
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
