//
//  WristInviteView.m
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristInviteView.h"
#import "Masonry.h"
#import "WebViewController.h"
#import "URLScheme.h"
@interface WristInviteView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *dissBtn;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WristInviteView

-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_bottomBtn setTitle:@"如何获得内测权限？" forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_bottomBtn setTitleColor:[UIColor colorWithHexString:@"5dc3f0"] forState:UIControlStateNormal];
    }
    return _bottomBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"inviteIconImage"];
    }
    return _iconImageView;
}

-(UIButton *)dissBtn{
    if (!_dissBtn) {
        _dissBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_dissBtn setImage:[UIImage imageNamed:@"Partial_Close_MF"] forState:UIControlStateNormal];
        [_dissBtn sizeToFit];
    }
    return _dissBtn;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _subLbl.font = [UIFont systemFontOfSize:15.f];
        _subLbl.text = @"您未在内测邀请尊贵席位之列";
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLbl.hidden = YES;
        self.contentLbl.hidden = YES;
        self.imageView.hidden = YES;
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.subLbl];
        [self addSubview:self.lineView];
        [self addSubview:self.bottomBtn];
        [self addSubview:self.dissBtn];
        
        [self.bottomBtn addTarget:self action:@selector(clickBottomBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.dissBtn addTarget:self action:@selector(clickDissBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickBottomBtn{
    
    WebViewController *webView = [[WebViewController alloc] init];
    webView.url = kSendBackUrl;
    [[CoordinatingController sharedInstance] pushViewController:webView animated:YES];
}

-(void)clickDissBtn{
    if (self.inviteDiss) {
        self.inviteDiss();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(20);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(18);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subLbl.mas_bottom).offset(18);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
}

@end
