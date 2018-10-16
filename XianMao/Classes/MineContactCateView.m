//
//  MineContactCateView.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineContactCateView.h"
#import "Command.h"
#import "Masonry.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "WCAlertView.h"
#import "AboutViewController.h"
#import "Session.h"

@interface MineContactCateView ()

@property (nonatomic, strong) VerticalCommandButton *dSendGoods;
@property (nonatomic, strong) VerticalCommandButton *dDetermine;
@property (nonatomic, strong) VerticalCommandButton *dComeGoods;
@property (nonatomic, strong) VerticalCommandButton *close;

@end

@implementation MineContactCateView

-(VerticalCommandButton *)dSendGoods{
    if (!_dSendGoods) {
        _dSendGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dSendGoods.contentAlignmentCenter = YES;
        _dSendGoods.imageTextSepHeight = 6;
        [_dSendGoods setImage:[UIImage imageNamed:@"Mine_Phone_MF"] forState:UIControlStateNormal];
        [_dSendGoods setTitle:@"客服电话" forState:UIControlStateNormal];
        [_dSendGoods setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _dSendGoods.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dSendGoods;
}

-(VerticalCommandButton *)dDetermine{
    if (!_dDetermine) {
        _dDetermine = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dDetermine.contentAlignmentCenter = YES;
        _dDetermine.imageTextSepHeight = 6;
        [_dDetermine setImage:[UIImage imageNamed:@"Mine_OnLine_MF"] forState:UIControlStateNormal];
        [_dDetermine setTitle:@"在线客服" forState:UIControlStateNormal];
        [_dDetermine setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _dDetermine.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dDetermine;
}

-(VerticalCommandButton *)dComeGoods{
    if (!_dComeGoods) {
        _dComeGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dComeGoods.contentAlignmentCenter = YES;
        _dComeGoods.imageTextSepHeight = 6;
        [_dComeGoods setImage:[UIImage imageNamed:@"Mine_Help_MF"] forState:UIControlStateNormal];
        [_dComeGoods setTitle:@"帮助中心" forState:UIControlStateNormal];
        [_dComeGoods setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _dComeGoods.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dComeGoods;
}

-(VerticalCommandButton *)close{
    if (!_close) {
        _close = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _close.contentAlignmentCenter = YES;
        _close.imageTextSepHeight = 6;
        [_close setImage:[UIImage imageNamed:@"Mine_Feedback_MF"] forState:UIControlStateNormal];
        [_close setTitle:@"意见反馈" forState:UIControlStateNormal];
        [_close setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _close.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _close;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.dSendGoods];
        [self addSubview:self.dDetermine];
        [self addSubview:self.dComeGoods];
        [self addSubview:self.close];
        WEAKSELF;
        self.dSendGoods.handleClickBlock = ^(CommandButton *sender) {
            
            [WCAlertView showAlertWithTitle:@"拨打客服电话" message:kCustomServicePhoneDisplay customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex == 0) {
                    
                } else {
                    [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:CallCustomerRegionCode referPageCode:NoReferPageCode andData:nil];
                    NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        };
        
        self.dDetermine.handleClickBlock = ^(CommandButton *sender) {
            
        };
        
        self.dComeGoods.handleClickBlock = ^(CommandButton *sender) {
            [MobClick event:@"click_manage_help_center"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineWebViewCode referPageCode:MineWebViewCode andData:nil];
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.title = @"帮助中心";
            viewController.url = @"http://activity.aidingmao.com/share/page/351";
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.close.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFeedbackViewCode referPageCode:MineFeedbackViewCode andData:nil];
            FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
    [self.dSendGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.dDetermine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.dSendGoods.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.dComeGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.dDetermine.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.dComeGoods.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
