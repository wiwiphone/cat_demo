//
//  AddBagView.m
//  XianMao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AddBagView.h"
#import "Masonry.h"

@interface AddBagView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation AddBagView

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.text = @"加入购物车成功";
        _subLbl.font = [UIFont systemFontOfSize:15.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"恭喜您";
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sureBtn setTitle:@"立即结算" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _sureBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
    }
    return _lineView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.subLbl];
        [self addSubview:self.sureBtn];
        [self addSubview:self.lineView];
        [self.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [self setUpUI];
    }
    return self;
}

-(void)clickSureBtn{
    if (self.pushShopBag) {
        self.pushShopBag();
    }
}

-(void)setUpUI{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kScreenWidth/320*17);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLbl.mas_centerX);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-45);
        make.height.equalTo(@1);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end
