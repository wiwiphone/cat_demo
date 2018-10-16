//
//  MineOrderButton.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineOrderButton.h"
#import "Masonry.h"

@interface MineOrderButton ()

@property (nonatomic, strong) UILabel *titleLbL;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MineOrderButton

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
    }
    return _rightImageView;
}

-(UILabel *)titleLbL{
    if (!_titleLbL) {
        _titleLbL = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbL.font = [UIFont systemFontOfSize:15.f];
        _titleLbL.textColor = [UIColor colorWithHexString:@"434342"];
        _titleLbL.text = @"我的订单";
        [_titleLbL sizeToFit];
}
    return _titleLbL;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLbL];
        [self addSubview:self.rightImageView];
        [self addSubview:self.lineView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLbL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@9);
        make.height.equalTo(@15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@0.5);
    }];
}

@end
