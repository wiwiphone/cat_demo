//
//  MineNewBottomCell.m
//  XianMao
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineNewBottomCell.h"

@interface MineNewBottomCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *subTitleLbl;

@end

@implementation MineNewBottomCell

-(UILabel *)subTitleLbl{
    if (!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLbl.font = [UIFont systemFontOfSize:15.f];
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_subTitleLbl sizeToFit];
    }
    return _subTitleLbl;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
        [_rightImageView sizeToFit];
    }
    return _rightImageView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}

-(instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle isRightAllow:(BOOL)isYes{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.rightImageView];
        [self addSubview:self.subTitleLbl];
        
        self.iconImageView.image = [UIImage imageNamed:iconName];
        self.titleLbl.text = title;
        self.subTitleLbl.text = subTitle;
    }
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.handlsCell) {
        self.handlsCell();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-18);
    }];
    
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.rightImageView.mas_left).offset(-5);
    }];
}

@end
