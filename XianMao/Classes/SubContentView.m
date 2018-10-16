//
//  SubContentView.m
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SubContentView.h"
#import "Masonry.h"

@interface SubContentView ()

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *subLbl;

@end

@implementation SubContentView

-(UIView *)leftLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLineView.backgroundColor = [UIColor colorWithHexString:@"cacbcc"];
    }
    return _leftLineView;
}

-(UIView *)rightLineView{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLineView.backgroundColor = [UIColor colorWithHexString:@"cacbcc"];
    }
    return _rightLineView;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.text = @"热门分类";
        _subLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        _subLbl.font = [UIFont systemFontOfSize:13.f];
    }
    return _subLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.leftLineView];
        [self addSubview:self.rightLineView];
        [self addSubview:self.subLbl];
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subLbl.mas_left).offset(-12);
        make.centerY.equalTo(self.subLbl.mas_centerY);
        make.left.equalTo(self.mas_left).offset(68);
        make.height.equalTo(@1);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subLbl.mas_right).offset(12);
        make.centerY.equalTo(self.subLbl.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-68);
        make.height.equalTo(@1);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
