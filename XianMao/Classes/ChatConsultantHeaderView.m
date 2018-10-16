//
//  ChatConsultantHeaderView.m
//  XianMao
//
//  Created by 黄崇国 on 2017/3/6.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ChatConsultantHeaderView.h"

@interface ChatConsultantHeaderView ()

@property (nonatomic, strong) UILabel *userNameLbl;
@property (nonatomic, strong) UILabel *consultantCateLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) XMWebImageView *rightImageView;

@end

@implementation ChatConsultantHeaderView

-(XMWebImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Chat_RightIcon"];
        [_rightImageView sizeToFit];
    }
    return _rightImageView;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:15.f];
        _contentLbl.textColor = [UIColor whiteColor];
        [_contentLbl sizeToFit];
        _contentLbl.numberOfLines = 0;
    }
    return _contentLbl;
}

-(UILabel *)consultantCateLbl{
    if (!_consultantCateLbl) {
        _consultantCateLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _consultantCateLbl.font = [UIFont systemFontOfSize:15.f];
        _consultantCateLbl.textColor = [UIColor whiteColor];
        [_consultantCateLbl sizeToFit];
        _consultantCateLbl.numberOfLines = 0;
    }
    return _consultantCateLbl;
}

-(UILabel *)userNameLbl{
    if (!_userNameLbl) {
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLbl.font = [UIFont boldSystemFontOfSize:33.f];
        _userNameLbl.textColor = [UIColor whiteColor];
        [_userNameLbl sizeToFit];
    }
    return _userNameLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.userNameLbl];
        [self addSubview:self.consultantCateLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.rightImageView];
        
    }
    return self;
}

-(void)getAdviserPage:(AdviserPage *)adviserPage{
    self.userNameLbl.text = @"爱丁猫顾问";
    self.consultantCateLbl.text = adviserPage.nickname;
    self.contentLbl.text = adviserPage.summary;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.userNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    
    [self.consultantCateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLbl.mas_bottom).offset(6);
        make.left.equalTo(self.userNameLbl.mas_left);
        make.right.equalTo(self.mas_right).offset(-140);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consultantCateLbl.mas_bottom).offset(6);
        make.left.equalTo(self.userNameLbl.mas_left);
        make.right.equalTo(self.mas_right).offset(-140);
    }];
    
}

@end
