//
//  QuanGoodsSubView.m
//  XianMao
//
//  Created by apple on 16/11/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "QuanGoodsSubView.h"

@interface QuanGoodsSubView ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation QuanGoodsSubView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    }
    return _lineView;
}

-(UILabel *)rightLbl{
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLbl.font = [UIFont systemFontOfSize:13.f];
        _rightLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_rightLbl sizeToFit];
    }
    return _rightLbl;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:12.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 10;
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.subLbl];
        [self addSubview:self.rightLbl];
        [self addSubview:self.lineView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@0.5);
    }];
}

-(void)getBonusInfo:(BounsGoodsInfo *)bonusInfo{
    [self.iconImageView setImageWithURL:bonusInfo.icon_url XMWebImageScaleType:XMWebImageScale160x160];
    self.titleLbl.text = bonusInfo.bonus_name;
    self.subLbl.text = [NSString stringWithFormat:@"%@失效", [NSDate stringForTimestampSince1970:bonusInfo.use_end_time]];
    self.rightLbl.text = bonusInfo.tag;
}

@end
