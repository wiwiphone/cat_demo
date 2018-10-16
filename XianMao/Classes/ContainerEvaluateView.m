//
//  ContainerEvaluateView.m
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ContainerEvaluateView.h"


@interface ContainerEvaluateView()

@property (nonatomic,strong) UIImageView * iconImg;
@property (nonatomic,strong) UILabel * desLbl;


@end

@implementation ContainerEvaluateView


-(UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
    }
    return _iconImg;
}

-(TapDetectingImageView *)colseBtn
{
    if (!_colseBtn) {
        _colseBtn = [[TapDetectingImageView alloc] init];
        _colseBtn.image = [UIImage imageNamed:@"close_btn"];
    }
    return _colseBtn;
}

-(UILabel *)desLbl
{
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _desLbl.font = [UIFont systemFontOfSize:13];
        _desLbl.textAlignment = NSTextAlignmentCenter;
        [_desLbl sizeToFit];
    }
    return _desLbl;
}

-(CommandButton *)btn1
{
    if (!_btn1) {
        _btn1 = [[CommandButton alloc] init];
        _btn1.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
        _btn1.layer.borderWidth = 1;
        _btn1.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    return _btn1;
}


-(CommandButton *)btn2
{
    if (!_btn2) {
        _btn2 = [[CommandButton alloc] init];
        _btn2.backgroundColor = [UIColor colorWithHexString:@"333333"];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn2 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];

    }
    return _btn2;
}

-(instancetype)initWithiconName:(NSString *)iconName
                      desString:(NSString *)desString
                       btn1Name:(NSString *)btn1Name
                       btn2Name:(NSString *)btn2Name
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.colseBtn];
        [self addSubview:self.iconImg];
        self.iconImg.image = [UIImage imageNamed:iconName];
        
        [self addSubview:self.desLbl];
        self.desLbl.text  = desString;
        
        [self addSubview:self.btn1];
        [self.btn1 setTitle:btn1Name forState:UIControlStateNormal];
        [self addSubview:self.btn2];
        [self.btn2 setTitle:btn2Name forState:UIControlStateNormal];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.colseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(50);
    }];
    
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.mas_bottom).offset(34);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLbl.mas_bottom).offset(32);
        make.right.equalTo(self.mas_right).offset(-28);
        make.left.equalTo(self.mas_left).offset(28);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn1.mas_bottom).offset(13);
        make.right.equalTo(self.mas_right).offset(-28);
        make.left.equalTo(self.mas_left).offset(28);
        make.height.mas_equalTo(40);
    }];
}


@end
