//
//  PicSuccess.m
//  yuncangcat
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PicSuccess.h"

@interface PicSuccess ()

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *openWChat;

@end

@implementation PicSuccess

-(UIButton *)openWChat{
    if (!_openWChat) {
        _openWChat = [[UIButton alloc] initWithFrame:CGRectZero];
        [_openWChat setTitle:@"打开微信，从手机相册选取图片" forState:UIControlStateNormal];
        [_openWChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _openWChat.backgroundColor = [UIColor colorWithHexString:@"434342"];
        _openWChat.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _openWChat;
}

-(UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btn1 setTitle:@" 商品图片已保存到手机相册" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_btn1 setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateNormal];
        [_btn1 sizeToFit];
    }
    return _btn1;
}

-(UIButton *)btn2{
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btn2 setTitle:@" 商品名称，描述和链接已复制成功" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_btn2 setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateNormal];
        [_btn2 sizeToFit];
    }
    return _btn2;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.openWChat];
        
        [self.openWChat addTarget:self action:@selector(clickOpenWChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn1.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    
    [self.openWChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn2.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@35);
    }];
    
}

-(void)clickOpenWChat{
    if (self.disPicView) {
        self.disPicView();
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"weixin://dl/"]]];
}

@end



//weixin://dl/scan 扫一扫
//weixin://dl/feedback 反馈
//weixin://dl/moments 朋友圈
//weixin://dl/settings 设置
//weixin://dl/notifications 消息通知设置
//weixin://dl/chat 聊天设置
//weixin://dl/general 通用设置
//weixin://dl/officialaccounts 公众号
//weixin://dl/games 游戏
//weixin://dl/help 帮助
//weixin://dl/feedback 反馈
//weixin://dl/profile 个人信息
//weixin://dl/features 功能插件
