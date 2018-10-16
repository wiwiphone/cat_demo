//
//  WristView.m
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristView.h"
#import "Masonry.h"

@interface WristView ()

@end

@implementation WristView

-(UIButton *)imageView{
    if (!_imageView) {
        _imageView = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imageView setImage:[UIImage imageNamed:@"Wrist_Diss"] forState:UIControlStateNormal];
        [_imageView sizeToFit];
    }
    return _imageView;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:15.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _contentLbl.text = @"1.原价回收商品支持48小时无理由退货，在不影响第二次销售的情况下，原附件齐全，并无任何损坏，方可退货。\n\n"
        "2.至确认收货起90天后至1年内，可申请原价回购，爱丁猫收取售价5% 的服务费。\n\n\n\n\n\n\n";
        _contentLbl.numberOfLines = 0;
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:18.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _titleLbl.text = @"原价回购规则";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.imageView];
        
        [self.imageView addTarget:self action:@selector(clickDissImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickDissImage{
    if ([self.wristDissDelegate respondsToSelector:@selector(wristDissBtn)]) {
        [self.wristDissDelegate wristDissBtn];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(48);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
}

@end
