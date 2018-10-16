//
//  SaleStateTopView.m
//  XianMao
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SaleStateTopView.h"
#import "Masonry.h"

@interface SaleStateTopView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightAllowImage;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SaleStateTopView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eaebeb"];
    }
    return _lineView;
}

-(UIImageView *)rightAllowImage{
    if (!_rightAllowImage) {
        _rightAllowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightAllowImage.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
    }
    return _rightAllowImage;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.text = @"出售状态";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.rightAllowImage];
        [self addSubview:self.lineView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(18);
    }];
    
    [self.rightAllowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-18);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
}

@end
