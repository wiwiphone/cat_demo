//
//  MineNewHeaderView.m
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineNewHeaderView.h"
#import "User.h"
#import "Session.h"
#import "VisualEffectView.h"
#import "Command.h"
#import "EditProfileViewController.h"

#import "XMWebImageView.h"
#import "Masonry.h"

#import "UIView+ZYDraggable.h"

@interface MineNewHeaderView ()

@property (nonatomic, strong) XMWebImageView *headerImage;
@property (nonatomic, strong) UILabel *fanslbl;
@property (nonatomic, strong) UILabel *followinglbl;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) CommandButton * fansBtn;
@property (nonatomic, strong) CommandButton * followingBtn;


@end

@implementation MineNewHeaderView


-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.textColor = [UIColor whiteColor];
        _userName.font = [UIFont boldSystemFontOfSize:38];
        [_userName sizeToFit];
    }
    return _userName;
}

-(UILabel *)followinglbl{
    if (!_followinglbl) {
        _followinglbl = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        _followinglbl.textColor = [UIColor whiteColor];
        _followinglbl.font = [UIFont systemFontOfSize:15.f];
        _followinglbl.textAlignment = NSTextAlignmentCenter;
        [_followinglbl sizeToFit];
    }
    return _followinglbl;
}

-(UILabel *)fanslbl{
    if (!_fanslbl) {
        _fanslbl = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        _fanslbl.textColor = [UIColor whiteColor];
        _fanslbl.font = [UIFont systemFontOfSize:15.f];
        _fanslbl.textAlignment = NSTextAlignmentCenter;
        [_fanslbl sizeToFit];
    }
    return _fanslbl;
}


- (CommandButton *)fansBtn{
    if (!_fansBtn) {
        _fansBtn = [[CommandButton alloc] init];
    }
    return _fansBtn;
}

- (CommandButton *)followingBtn{
    if (!_followingBtn) {
        _followingBtn = [[CommandButton alloc] init];
    }
    return _followingBtn;
}

-(XMWebImageView *)headerImage{
    if (!_headerImage) {
        _headerImage = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerImage.layer.borderWidth = 1;
        _headerImage.layer.masksToBounds = YES;
        _headerImage.layer.cornerRadius = (kScreenWidth/375*58)/2;
    }
    return _headerImage;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"userHeaderBg"];
        self.userInteractionEnabled = YES;
        
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        
        
        [self addSubview:self.headerImage];
        [self addSubview:self.userName];
        [self addSubview:self.fanslbl];
        [self addSubview:self.followinglbl];
        [self addSubview:self.fansBtn];
        [self addSubview:self.followingBtn];
        
        self.followingBtn.handleClickBlock = ^(CommandButton *sender){
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineAttentionViewCode referPageCode:MineAttentionViewCode andData:nil];
            [[CoordinatingController sharedInstance] gotoFollowingsViewController:[Session sharedInstance].currentUserId
                                                                         animated:YES];
        };
        
        self.fansBtn.handleClickBlock = ^(CommandButton * sender){
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFansViewCode referPageCode:MineFansViewCode andData:nil];
            [[CoordinatingController sharedInstance] gotoFollowersViewController:[Session sharedInstance].currentUserId
                                                                        animated:YES];
        };

        
        self.headerImage.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [MobClick event:@"click_goods_from_mine"];
            //我的资料
            [Session sharedInstance].viewCode = MineViewCode;
            EditProfileViewController *proViewController = [[EditProfileViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:proViewController animated:YES];
        };
        
        [self setData];
        [self setUpUI];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_handleNewSingleTapDetected) {
        _handleNewSingleTapDetected(self);
    }
}

-(void)setUpUI{
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.right.equalTo(self.mas_right).offset(-26);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*58, kScreenWidth/375*58));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(70+155);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.headerImage.mas_left).offset(-10);
    }];
    
    [self.fanslbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.userName.mas_bottom);
    }];
    
    [self.followinglbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fanslbl.mas_right).offset(5);
        make.top.equalTo(self.userName.mas_bottom);
    }];
    
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.fanslbl.mas_left);
        make.right.equalTo(self.fanslbl.mas_right);
    }];
    
    [self.followingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.followinglbl.mas_right);
        make.left.equalTo(self.followinglbl.mas_left);
    }];
}

-(void)setData{
    User *user = [Session sharedInstance].currentUser;
    [self.headerImage setImageWithURL:user.frontUrl placeholderImage:[UIImage imageNamed:@"mine_front_default"] size:CGSizeMake(kScreenWidth*2,kScreenWidth*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
    [self.headerImage setImageWithURL:user.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine_new"] XMWebImageScaleType:XMWebImageScale160x160];
    self.followinglbl.text = [NSString stringWithFormat:@"关注 %ld",(long)user.followingsNum];
    self.fanslbl.text = [NSString stringWithFormat:@"粉丝 %ld",(long)user.fansNum];
    self.userName.text = user.userName;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
