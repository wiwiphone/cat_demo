//
//  LaunchBottomView.m
//  XianMao
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LaunchBottomView.h"

@interface LaunchBottomView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subLbl;

@end

@implementation LaunchBottomView

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:13.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"a1a1a1"];
        _subLbl.text = @"Aidingmao · Just take it ";
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:20.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _titleLbl.text = @"爱丁猫·会买奢侈品";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"Lanuch_Bottom_Icon"];
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.subLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 0;
    if (self.titleLbl.width > self.subLbl.width) {
        margin = self.titleLbl.width;
    } else {
        margin = self.subLbl.width;
    }
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset((kScreenWidth-50-12-margin)/2);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(5);
        make.left.equalTo(self.iconImageView.mas_right).offset(12); 
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(-5);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
    }];
}

@end
