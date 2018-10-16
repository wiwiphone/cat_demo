//
//  PartialPayWayView.m
//  XianMao
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PartialPayWayView.h"
#import "PayWaySelectedView.h"

@interface PartialPayWayView ()

@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) NSArray *payWays;

@property (nonatomic, strong) PayWayDO *payWay;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UILabel *titleLbl;
@end

@implementation PartialPayWayView

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"请选择本次支付方式";
    }
    return _titleLbl;
}

-(UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView1;
}

-(NSArray *)payWays{
    if (!_payWays) {
        _payWays = [[NSArray alloc] init];
    }
    return _payWays;
}

-(UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_dismissBtn setImage:[UIImage imageNamed:@"Back_Promrt_MF"] forState:UIControlStateNormal];
        [_dismissBtn sizeToFit];
    }
    return _dismissBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.dismissBtn];
        [self addSubview:self.lineView1];
        [self addSubview:self.titleLbl];
        [self.dismissBtn addTarget:self action:@selector(clickDismissBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)getPartialDo:(ParyialDo *)partialDo{
    WEAKSELF;
    self.payWays = partialDo.payWays;
    CGFloat margin = 45;
    NSLog(@"%ld", self.subviews.count);
    if (self.subviews.count <= 3) {
        for (int i = 0; i < partialDo.payWays.count; i++) {
            PayWayDO *payWayDo = partialDo.payWays[i];
            //屏蔽分次支付和大额支付
            if (payWayDo.pay_way != 20) {// || payWayDo.pay_way != 15
                PayWaySelectedView *selectedView = [[PayWaySelectedView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, 62)];
                selectedView.avaMoneyCent = partialDo.avaMoneyCent;
                [self addSubview:selectedView];
                margin += selectedView.height;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, margin, kScreenWidth-24, 0.5)];
                lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
                [self addSubview:lineView];
                margin += lineView.height;
                [selectedView getPayWayDo:payWayDo];
                
                selectedView.changeSelectedPayWay = ^(PayWayDO *payWay){
                    weakSelf.payWay = payWay;
                    
                    if (weakSelf.changePayWay) {
                        weakSelf.changePayWay(payWay);
                    }
                };
            }
        }
    }
}

-(void)dealloc{
    
}

-(void)clickDismissBtn{
    if (self.dismissPartialPayWayView) {
        self.dismissPartialPayWayView();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.top.equalTo(self.mas_top).offset(44);
        make.right.equalTo(self.mas_right).offset(-14);
        make.height.equalTo(@0.5);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(13);
    }];
}

@end
