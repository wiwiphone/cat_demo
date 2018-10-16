//
//  WonderingView.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WonderingView.h"

@interface WonderingView()

@property (nonatomic,strong) UIView * containerView;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UILabel * label1;
@property (nonatomic,strong) UILabel * label2;
@property (nonatomic,strong) UILabel * label3;
@end

@implementation WonderingView






-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [self addSubview:_bgView];
        [self addSubview];
    }
    return self;
}

- (void)dismiss {

    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
        _containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_containerView removeFromSuperview];
    }];
}


-(void)addSubview
{
    
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(54, 0, kScreenWidth - 54*2, 177)];
        _containerView.alpha = 0;
        _containerView.center = self.center;
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 3;
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        
        NSInteger containerView_width = CGRectGetWidth(self.containerView.frame);
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView_width, 67)];
        _label1.font = [UIFont systemFontOfSize:14];
        _label1.textColor = [UIColor colorWithHexString:@"434342"];
        _label1.textAlignment =  NSTextAlignmentCenter;
        _label1.text = @"如何查看开户行";
        [self.containerView addSubview:self.label1];
        
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(27, 67, containerView_width - 27*2, 40)];
        _label2.font = [UIFont systemFontOfSize:14];
        _label2.textColor = [UIColor colorWithHexString:@"434342"];
        _label2.textAlignment =  NSTextAlignmentLeft;
        _label2.text = @"●  从地图上找你开户的位置\n     会有开户行名称。";
        _label2.numberOfLines = 2;
        [self.containerView addSubview:self.label2];
        
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(27, 67+40, containerView_width - 27*2, 40+15)];
        _label3.font = [UIFont systemFontOfSize:14];
        _label3.textColor = [UIColor colorWithHexString:@"434342"];
        _label3.textAlignment =  NSTextAlignmentLeft;
        _label3.numberOfLines = 2;
        _label3.text = @"●  拨打银行客服电话、登录网银、银行柜台都可以查询到。";
        [self.containerView addSubview:self.label3];

    }
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.3;
        _containerView.alpha = 1;
    }];
}

@end
