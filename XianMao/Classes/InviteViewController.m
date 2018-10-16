//
//  InviteViewController.m
//  XianMao
//
//  Created by simon cai on 24/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "InviteViewController.h"
#import "Command.h"
#import "URLScheme.h"
#import "RewardService.h"
#import "Error.h"
#import "NSString+Addtions.h"

#import "PullRefreshTableView.h"
#import "DataListLogic.h"
#import "DataSources.h"
#import "Session.h"
#import "RewardTableViewCell.h"

#import "TTTAttributedLabel.h"

@interface InviteCodeConvertController () <TTTAttributedLabelDelegate>
@property(nonatomic,weak) UIView *inviteView;
@property(nonatomic,weak) UIView *hasInvitedView;

@property(nonatomic,assign) BOOL is_receive;
@property(nonatomic,assign) float reward_money;
@property(nonatomic,copy) NSString *redirect_uri;

@property(nonatomic,copy) NSString *invite_text;
@property(nonatomic,copy) NSString *reward_desc;

@property(nonatomic,weak) UIInsetTextField *textFiled;

@end

@implementation InviteCodeConvertController

- (id)init {
    self = [super init];
    if (self) {
        self.is_receive = NO;
        self.reward_money = 0.f;
        self.redirect_uri = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@"输入邀请码"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    [self bringTopBarToTop];
    
    
    WEAKSELF;
    [weakSelf showLoadingView];
    [RewardService getInputInfo:^(BOOL is_receive, float reward_money, NSString *redirect_uri,NSString *invite_text,NSString *reward_desc) {
        [weakSelf hideLoadingView];
        weakSelf.is_receive = is_receive;
        weakSelf.reward_money = reward_money;
        weakSelf.redirect_uri = redirect_uri;
        weakSelf.invite_text = invite_text;
        weakSelf.reward_desc = reward_desc;
        [weakSelf updateInviteView];
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInviteView {
    
    CGFloat topBarHeight = self.topBarHeight;
    
    [_inviteView removeFromSuperview];
    _inviteView = nil;
    
    [_hasInvitedView removeFromSuperview];
    _hasInvitedView = nil;
    
    if (self.is_receive) {
        UIView *hasInvitedView = [self buildHasInvitedView];
        hasInvitedView.frame = CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight);
        [self.view addSubview:hasInvitedView];
        _hasInvitedView = hasInvitedView;
    } else {
        UIView *inviteView = [self buildInviteView];
        inviteView.frame = CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight);
        [self.view addSubview:inviteView];
        _inviteView = inviteView;
    }
    
    [self bringTopBarToTop];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if (label.tag == 1001 || label.tag == 1002) {
        if ([self.redirect_uri length]>0) {
            [URLScheme locateWithRedirectUri:self.redirect_uri andIsShare:YES];
        }
    }
}

- (UIView*)buildInviteView {
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat marginTop = 0.f;
    marginTop += 30.f;
    
    UIInsetTextField *textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(0, marginTop, view.width-80, 50) rectInsetDX:17 rectInsetDY:0];
    textFiled.backgroundColor = [UIColor whiteColor];
    textFiled.placeholder = @"请输入邀请码";
    textFiled.font = [UIFont systemFontOfSize:15.f];
    [view addSubview:textFiled];
    _textFiled = textFiled;
    
    
    CALayer *topLine = [CALayer layer];
    topLine.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    topLine.frame = CGRectMake(0, marginTop, view.width, 0.5f);
    [view.layer addSublayer:topLine];
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    bottomLine.frame = CGRectMake(0, textFiled.bottom-0.5f, view.width, 0.5f);
    [view.layer addSublayer:bottomLine];
    
    CommandButton *submitBtn = [[CommandButton alloc] initWithFrame:CGRectMake(view.width-80, marginTop, 80, view.height)];
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [view addSubview:submitBtn];
    
    marginTop += textFiled.height;
    marginTop += 17;
    
    
    NSString *detailText = @" 详情 > ";
    
    TTTAttributedLabel *lblInvite = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(15, marginTop, view.width-30, 0)];
    lblInvite.delegate = self;
    lblInvite.font = [UIFont systemFontOfSize:12.f];
    lblInvite.textColor = [UIColor colorWithHexString:@"282828"];
    lblInvite.lineBreakMode = NSLineBreakByWordWrapping;
    lblInvite.userInteractionEnabled = YES;
    lblInvite.highlightedTextColor = [UIColor colorWithHexString:@"D9A22B"];
    lblInvite.lineSpacing = 7.f;
    lblInvite.numberOfLines = 0;
    lblInvite.activeLinkAttributes = nil;
    lblInvite.linkAttributes = nil;
    lblInvite.tag = 1001;
    
    NSString *text = nil;
    if ([self.invite_text length]>0) {
        text = self.invite_text;
    } else {
        NSString *rewardStr = [NSString stringWithFormat:@"%@元",formatRewardMoney(self.reward_money)];
        NSString *cashStr = @"现金。";
        text = [NSString stringWithFormat:@"输入好友的邀请码\n你和他都将立即获得%@%@",rewardStr,cashStr];
    }
    [lblInvite setText:[NSString stringWithFormat:@"%@ %@",text,detailText] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange stringRange = NSMakeRange(mutableAttributedString.length-detailText.length,detailText.length);
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"D9A22B"] CGColor] range:stringRange];
        return mutableAttributedString;
    }];
    
    [lblInvite addLinkToURL:[NSURL URLWithString:@""] withRange:NSMakeRange(lblInvite.attributedText.length-detailText.length,detailText.length)];
    [lblInvite sizeToFit];
    [view addSubview:lblInvite];
    
    marginTop += lblInvite.height;
    marginTop += 20.f;
    
//
//    UILabel *lblReward = [[UILabel alloc] initWithFrame:CGRectMake(17, marginTop, view.width-34, 0)];
//    lblReward.font = [UIFont systemFontOfSize:12.f];
//    lblReward.textColor = [UIColor colorWithHexString:@"282828"];
//    lblReward.numberOfLines = 0;
//    [view addSubview:lblReward];
//    if ([self.invite_text length]>0) {
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.invite_text];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:7];//调整行间距
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
//        lblReward.attributedText = attributedString;
//        
//        [lblReward sizeToFit];
//        lblReward.frame = CGRectMake(lblReward.left, lblReward.top, lblReward.width, lblReward.height);
//        
//        marginTop += lblReward.height;
//        marginTop += 20.f;
//        
//        detailBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
//        [detailBtn setTitleColor:[UIColor colorWithHexString:@"D9A22B"] forState:UIControlStateNormal];
//        [detailBtn setTitle:@"详情 >" forState:UIControlStateNormal];
//        detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        [view addSubview:detailBtn];
//        [detailBtn sizeToFit];
//        detailBtn.frame = CGRectMake(lblReward.right-50, lblReward.bottom-detailBtn.height+6, 50, detailBtn.height);
//        
//        marginTop += detailBtn.height;
//        marginTop += 20.f;
//        
//    } else {
//        
//        NSString *rewardStr = [NSString stringWithFormat:@"%@元",formatRewardMoney(self.reward_money)];
//        NSString *cashStr = @"现金。";
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"输入好友的邀请码\n你和他都将立即获得%@%@",rewardStr,cashStr]];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:3];//调整行间距
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
//        
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.f] range:NSMakeRange(attributedString.length-rewardStr.length-cashStr.length, rewardStr.length-1)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.f] range:NSMakeRange(attributedString.length-rewardStr.length-1, 1)];
//        
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D9A22B"] range:NSMakeRange(attributedString.length-rewardStr.length-cashStr.length, rewardStr.length)];
//        
//        lblReward.attributedText = attributedString;
//        
//        [lblReward sizeToFit];
//        lblReward.frame = CGRectMake(lblReward.left, lblReward.top, lblReward.width, lblReward.height);
//        
//        detailBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
//        [detailBtn setTitleColor:[UIColor colorWithHexString:@"D9A22B"] forState:UIControlStateNormal];
//        [detailBtn setTitle:@"详情 >" forState:UIControlStateNormal];
//        detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        [view addSubview:detailBtn];
//        [detailBtn sizeToFit];
//        detailBtn.frame = CGRectMake(lblReward.right, lblReward.bottom-detailBtn.height+4, 50, detailBtn.height);
//        
//        marginTop += lblReward.height;
//        marginTop += 20.f;
//    }
    

    view.contentSize = CGSizeMake(view.width, marginTop);
   
    WEAKSELF;
    submitBtn.handleClickBlock = ^(CommandButton *sender) {
        BOOL isValid = YES;
        NSString *code = [weakSelf.textFiled.text trim];
        if (code.length != 5) {
            [weakSelf showHUD:@"请输入5位邀请码" hideAfterDelay:0.8f];
            isValid = NO;
        }
        if (isValid) {
            [weakSelf showProcessingHUD:nil];
            [RewardService submitInputCode:code completion:^(BOOL is_receive, float reward_money, NSString *redirect_uri) {
                [weakSelf hideHUD];
                weakSelf.is_receive = is_receive;
                weakSelf.reward_money = reward_money;
                weakSelf.redirect_uri = redirect_uri;
                [weakSelf updateInviteView];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        }
    };
    
//    detailBtn.handleClickBlock = ^(CommandButton *sender) {
//        if ([weakSelf.redirect_uri length]>0) {
//            [URLScheme locateWithRedirectUri:weakSelf.redirect_uri andIsShare:YES];
//        }
//    };
    
    return view;
}

- (UIView*)buildHasInvitedView {
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat marginTop = 0.f;
    marginTop += 60.f;
    
    UIView *rewardBgView = [[UIView alloc] initWithFrame:CGRectMake(40, marginTop, view.width-80, 140.f)];
    rewardBgView.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
    [view addSubview:rewardBgView];
    
    {
        UIView *contentBGView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 7.5, rewardBgView.width-15, rewardBgView.height-15)];
        contentBGView.backgroundColor = [UIColor clearColor];
        contentBGView.layer.borderColor = [UIColor colorWithHexString:@"181818"].CGColor;
        contentBGView.layer.borderWidth = 0.5f;
        contentBGView.layer.masksToBounds = YES;
        [rewardBgView addSubview:contentBGView];
        
        UILabel *rewardMoneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, contentBGView.height)];
        rewardMoneyLbl.backgroundColor = [UIColor colorWithHexString:@"282828"];
        rewardMoneyLbl.textColor = [UIColor colorWithHexString:@"FFE8B0"];
        rewardMoneyLbl.textAlignment = NSTextAlignmentCenter;
        [contentBGView addSubview:rewardMoneyLbl];
        
        NSString *strMoney = formatRewardMoney(self.reward_money);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",strMoney]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30.f] range:NSMakeRange(0, attributedString.length-1)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.f] range:NSMakeRange(attributedString.length-1, 1)];
        rewardMoneyLbl.attributedText = attributedString;

    
        UILabel *rewardDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(90+8, 0, contentBGView.width-90-16, contentBGView.height)];
        rewardDescLbl.backgroundColor = [UIColor clearColor];
        rewardDescLbl.textColor = [UIColor colorWithHexString:@"181818"];
        rewardDescLbl.font = [UIFont systemFontOfSize:13.5f];
        rewardDescLbl.textAlignment = NSTextAlignmentCenter;
        rewardDescLbl.numberOfLines = 0;
        if ([self.reward_desc length]>0) {
            rewardDescLbl.text = self.reward_desc;
        } else {
            rewardDescLbl.text = [NSString stringWithFormat:@"恭喜你获得%@元\n现金奖励 !",strMoney];
        }
        
        [contentBGView addSubview:rewardDescLbl];
    }
    
    marginTop += rewardBgView.height;
    marginTop += 20.f;
    
    
    NSString *detailText = @" 详情 > ";
    
    TTTAttributedLabel *lblInvite = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(52, marginTop, view.width-52*2, 0)];
    lblInvite.delegate = self;
    lblInvite.font = [UIFont systemFontOfSize:12.f];
    lblInvite.textColor = [UIColor colorWithHexString:@"282828"];
    lblInvite.lineBreakMode = NSLineBreakByWordWrapping;
    lblInvite.userInteractionEnabled = YES;
    lblInvite.highlightedTextColor = [UIColor colorWithHexString:@"D9A22B"];
    lblInvite.lineSpacing = 7.f;
    lblInvite.numberOfLines = 0;
    lblInvite.activeLinkAttributes = nil;
    lblInvite.linkAttributes = nil;
    lblInvite.tag = 1002;
    
    NSString *text = nil;
    if ([self.invite_text length]>0) {
        text = self.invite_text;
    } else {
        NSString *rewardStr = [NSString stringWithFormat:@"%@元",formatRewardMoney(self.reward_money)];
        NSString *cashStr = @"现金。";
        text = [NSString stringWithFormat:@"输入好友的邀请码\n你和他都将立即获得%@%@",rewardStr,cashStr];
    }
    [lblInvite setText:[NSString stringWithFormat:@"%@ %@",text,detailText] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange stringRange = NSMakeRange(mutableAttributedString.length-detailText.length,detailText.length);
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"D9A22B"] CGColor] range:stringRange];
        return mutableAttributedString;
    }];
    
    [lblInvite addLinkToURL:[NSURL URLWithString:@""] withRange:NSMakeRange(lblInvite.attributedText.length-detailText.length,detailText.length)];
    [lblInvite sizeToFit];
    [view addSubview:lblInvite];
    
    marginTop += lblInvite.height;
    marginTop += 20.f;
    
//    UILabel *lblInvite = [[UILabel alloc] initWithFrame:CGRectMake(52, marginTop, view.width-52*2, 0)];
//    lblInvite.font = [UIFont systemFontOfSize:12.f];
//    lblInvite.textColor = [UIColor colorWithHexString:@"282828"];
//    lblInvite.numberOfLines = 0;
//    [view addSubview:lblInvite];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"你还可以通过邀请好友注册爱丁猫获得\n跟多现金奖励"];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
//    lblInvite.attributedText = attributedString;
//    [lblInvite sizeToFit];
//    lblInvite.frame = CGRectMake(lblInvite.left, lblInvite.top, lblInvite.width, lblInvite.height);
//    
//    marginTop += lblInvite.height;
//    marginTop += 22;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    line.frame = CGRectMake(40, marginTop, view.width-80, 0.5f);
    [view.layer addSublayer:line];
    
    marginTop += 0.5f;
    marginTop += 21.5;
    
    CommandButton *lblTitle = [[CommandButton alloc] initWithFrame:CGRectMake(0, marginTop, view.width, 0)];
    lblTitle.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [lblTitle setTitle:@"去邀请" forState:UIControlStateNormal];
    [lblTitle setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    [view addSubview:lblTitle];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake((view.width-150)/2, marginTop, 150, 48);
    lblTitle.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
    
    
    marginTop += lblTitle.height;
    marginTop += 20.f;
    
//    InviteButtonsView *btnsView = [[InviteButtonsView alloc] init];
//    btnsView.frame = CGRectMake(0, marginTop, btnsView.width, btnsView.height);
//    [view addSubview:btnsView];
//    
//    marginTop += btnsView.height;
//    marginTop += 20.f;
    
    view.contentSize = CGSizeMake(view.width, marginTop);
    
    
    WEAKSELF;
    lblTitle.handleClickBlock = ^(CommandButton *sender) {
        InviteViewController *viewController = [[InviteViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    };
    
    return view;
}

//reward/get_input_info【GET】 返回｛is_receive, reward_money, redirect_uri｝ 输入邀请码 点击接口

@end

@interface InviteViewController () <TTTAttributedLabelDelegate>
@property(nonatomic,weak) UIView *contentView;
@property(nonatomic,copy) NSString *invitation_code;
@property(nonatomic,assign) float reward_money;
@property(nonatomic,copy) NSString *redirect_uri;
@property(nonatomic,assign) float gain_reward_money;
@property(nonatomic,copy) NSString *share_text;
@property(nonatomic,copy) NSString *share_url;
@property(nonatomic,copy) NSString *invite_text;
@property(nonatomic,weak) UILabel *invitationCodeLbl;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@"邀请朋友有钱拿"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    [super setupTopBarRightButton];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"奖励记录" forState:UIControlStateNormal];
//    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    
    [self bringTopBarToTop];
    
    
    WEAKSELF;
    weakSelf.topBarRightButton.hidden = YES;
    [weakSelf showLoadingView];
    [RewardService getinvitationCode:^(NSString *invitation_code, float reward_money, NSString *redirect_uri, float gain_reward_money, NSString *share_text, NSString *share_url, NSString *invite_text) {
        [weakSelf hideLoadingView];
        weakSelf.invitation_code = invitation_code;
        weakSelf.reward_money = reward_money;
        weakSelf.redirect_uri = redirect_uri;
        weakSelf.gain_reward_money = gain_reward_money;
        weakSelf.share_text = share_text;
        weakSelf.share_url = share_url;
        weakSelf.invite_text = invite_text;
        weakSelf.topBarRightButton.hidden = NO;
        [weakSelf updateContentView];
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    
    RewardListViewController *viewController = [[RewardListViewController alloc] init];
    viewController.gain_reward_money = self.gain_reward_money;
    [self pushViewController:viewController animated:YES];
}

- (void)updateContentView {
    
    CGFloat topBarHeight = self.topBarHeight;
    
    [_contentView removeFromSuperview];
    UIView *contentView = [self buildContentView];
    contentView.frame = CGRectMake(0, topBarHeight, contentView.width, self.view.height-topBarHeight);
    [self.view addSubview:contentView];
    _contentView = contentView;
}

- (NSAttributedString*)buildInvitationCode:(NSString*)invitationCode {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你的邀请码是\n%@",invitationCode]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f] range:NSMakeRange(0, attributedString.length-invitationCode.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30.f] range:NSMakeRange(attributedString.length-invitationCode.length, invitationCode.length)];
    return attributedString;
}

- (void)longPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.invitation_code) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.invitation_code;
            
            [self showHUD:@"邀请码已复制" hideAfterDelay:0.8f forView:[_contentView viewWithTag:1000]];
        }
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if ([self.redirect_uri length]>0) {
        [URLScheme locateWithRedirectUri:self.redirect_uri andIsShare:YES];
    }
}

- (UIView*)buildContentView {
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    CGFloat marginTop = 0.f;
    
    UIView *gainRewardBgView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, view.width, 44)];
    gainRewardBgView.backgroundColor = [UIColor colorWithHexString:@"282828"];
    [view addSubview:gainRewardBgView];
    {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, gainRewardBgView.width-30, gainRewardBgView.height)];
        lblTitle.textColor = [UIColor colorWithHexString:@"999999"];
        lblTitle.text = @"已获奖励:";
        lblTitle.font = [UIFont systemFontOfSize:14.f];
        [gainRewardBgView addSubview:lblTitle];
        
        UILabel *gainMoneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, gainRewardBgView.width-30, gainRewardBgView.height)];
        gainMoneyLbl.textAlignment = NSTextAlignmentRight;
        gainMoneyLbl.textColor = [UIColor colorWithHexString:@"FFE8B0"];
        gainMoneyLbl.font = [UIFont systemFontOfSize:15.f];
        gainMoneyLbl.text = [NSString stringWithFormat:@"¥ %@",formatRewardMoney(self.gain_reward_money)];
        [gainRewardBgView addSubview:gainMoneyLbl];
    }
    marginTop += gainRewardBgView.height;
    marginTop += 40.f;
    
    UIView *invitationCodeBgView = [[UIView alloc] initWithFrame:CGRectMake(40, marginTop, view.width-80, 140.f)];
    invitationCodeBgView.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
    [view addSubview:invitationCodeBgView];
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [invitationCodeBgView addGestureRecognizer:longPressGesture];
    
    {
        UIView *contentBGView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 7.5, invitationCodeBgView.width-15, invitationCodeBgView.height-15)];
        contentBGView.backgroundColor = [UIColor clearColor];
        contentBGView.layer.borderColor = [UIColor colorWithHexString:@"181818"].CGColor;
        contentBGView.layer.borderWidth = 0.5f;
        contentBGView.layer.masksToBounds = YES;
        [invitationCodeBgView addSubview:contentBGView];
        
        UILabel *invitationCodeLbl = [[UILabel alloc] initWithFrame:contentBGView.bounds];
        invitationCodeLbl.numberOfLines = 0;
        invitationCodeLbl.textColor = [UIColor colorWithHexString:@"181818"];
        [contentBGView addSubview:invitationCodeLbl];
        
        NSString *invitationCode = self.invitation_code;
        invitationCodeLbl.attributedText = [self buildInvitationCode:invitationCode];
        invitationCodeLbl.textAlignment = NSTextAlignmentCenter;
        _invitationCodeLbl = invitationCodeLbl;
    }
    
    marginTop += invitationCodeBgView.height;
    marginTop += 20.f;
    
    {
        UIView *hudViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 80)];
        hudViewContainer.tag = 1000;
        hudViewContainer.userInteractionEnabled = NO;
        [view addSubview:hudViewContainer];
    }
    
    NSString *detailText = @" 查看详情 > ";
    
    TTTAttributedLabel *lblInvite = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(52, marginTop, view.width-52*2, 0)];
    lblInvite.delegate = self;
    lblInvite.font = [UIFont systemFontOfSize:12.f];
    lblInvite.textColor = [UIColor colorWithHexString:@"282828"];
    lblInvite.lineBreakMode = NSLineBreakByWordWrapping;
    lblInvite.userInteractionEnabled = YES;
    lblInvite.highlightedTextColor = [UIColor colorWithHexString:@"D9A22B"];
    lblInvite.lineSpacing = 7.f;
    lblInvite.numberOfLines = 0;
    lblInvite.activeLinkAttributes = nil;
    lblInvite.linkAttributes = nil;
    lblInvite.tag = 1001;
    
    NSString *text = nil;
    if ([self.invite_text length]>0) {
        text = self.invite_text;
    } else {
        NSString *rewardStr = [NSString stringWithFormat:@"%@元",formatRewardMoney(self.reward_money)];
        text = [NSString stringWithFormat:@"邀请朋友注册爱丁猫\n在“我的”—“输入邀请码” 输入你的邀请码\n你和朋友都将获得现金奖励%@",rewardStr];
    }
    [lblInvite setText:[NSString stringWithFormat:@"%@ %@",text,detailText] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange stringRange = NSMakeRange(mutableAttributedString.length-detailText.length,detailText.length);
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"D9A22B"] CGColor] range:stringRange];
        return mutableAttributedString;
    }];
    
    [lblInvite addLinkToURL:[NSURL URLWithString:@""] withRange:NSMakeRange(lblInvite.attributedText.length-detailText.length,detailText.length)];
    [lblInvite sizeToFit];
    [view addSubview:lblInvite];
    
    marginTop += lblInvite.height;
    marginTop += 20.f;
    
//    CommandButton *detailBtn = nil;
//    UILabel *lblReward = nil;
//    
//    if ([self.invite_text length]>0) {
//        ///
//        lblReward = [[UILabel alloc] initWithFrame:CGRectMake(52, marginTop, view.width-52-20, 0)];
//        lblReward.font = [UIFont systemFontOfSize:12.f];
//        lblReward.textColor = [UIColor colorWithHexString:@"282828"];
//        lblReward.numberOfLines = 0;
//        [view addSubview:lblReward];
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.invite_text];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:7];//调整行间距
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
//        lblReward.attributedText = attributedString;
//        [lblReward sizeToFit];
//        lblReward.frame = CGRectMake(lblReward.left, lblReward.top, lblReward.width, lblReward.height);
//        
//        detailBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 44, 0)];
//        [detailBtn setTitleColor:[UIColor colorWithHexString:@"D9A22B"] forState:UIControlStateNormal];
//        [detailBtn setTitle:@"查看详情 >" forState:UIControlStateNormal];
//        detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        [view addSubview:detailBtn];
//        [detailBtn sizeToFit];
//        detailBtn.frame = CGRectMake(lblReward.right-detailBtn.width, lblReward.bottom-detailBtn.height+8, detailBtn.width, detailBtn.height);
//        
//        marginTop += lblReward.height;
//        marginTop += 22;
//        
//    } else {
//        
//        ///
//        UILabel *inviteDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(52, marginTop, view.width-52-20, 0)];
//        inviteDescLbl.backgroundColor = [UIColor clearColor];
//        inviteDescLbl.textColor = [UIColor colorWithHexString:@"181818"];
//        inviteDescLbl.font = [UIFont systemFontOfSize:12.f];
//        inviteDescLbl.textAlignment = NSTextAlignmentLeft;
//        inviteDescLbl.numberOfLines = 0;
//        [view addSubview:inviteDescLbl];
//        
//        NSMutableAttributedString *inviteDescAttrString = [[NSMutableAttributedString alloc] initWithString:@"邀请朋友注册爱丁猫\n在“我的”—“输入邀请码” 输入你的邀请码"];
//        NSMutableParagraphStyle *inviteDescStyle = [[NSMutableParagraphStyle alloc] init];
//        [inviteDescStyle setLineSpacing:7];//调整行间距
//        [inviteDescAttrString addAttribute:NSParagraphStyleAttributeName value:inviteDescStyle range:NSMakeRange(0, [inviteDescAttrString length])];
//        inviteDescLbl.attributedText = inviteDescAttrString;
//        [inviteDescLbl sizeToFit];
//        inviteDescLbl.frame = CGRectMake(inviteDescLbl.left, inviteDescLbl.top, view.width-52-20, inviteDescLbl.height);
//        
//        
//        marginTop += inviteDescLbl.height;
//        marginTop += 7;
//        
//        ///
//        lblReward = [[UILabel alloc] initWithFrame:CGRectMake(52, marginTop, view.width-52-20, 0)];
//        lblReward.font = [UIFont systemFontOfSize:12.f];
//        lblReward.textColor = [UIColor colorWithHexString:@"282828"];
//        lblReward.numberOfLines = 0;
//        [view addSubview:lblReward];
//        
//        float money = self.reward_money;
//        NSString *strMoney = formatRewardMoney(money);
//        NSString *rewardStr = [NSString stringWithFormat:@"%@元",strMoney];
//        NSString *cashStr = @"现金。";
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你和朋友都将获得现金奖励"]];
//        
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D9A22B"] range:NSMakeRange(attributedString.length-4, 2)];
//        
//        //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你和朋友都将获得现金奖励%@%@",rewardStr,cashStr]];
//        //
//        //    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.f] range:NSMakeRange(attributedString.length-rewardStr.length-cashStr.length, rewardStr.length-1)];
//        //    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.f] range:NSMakeRange(attributedString.length-rewardStr.length-1, 1)];
//        
//        //    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D9A22B"] range:NSMakeRange(attributedString.length-rewardStr.length-cashStr.length, rewardStr.length)];
//        
//        lblReward.attributedText = attributedString;
//        
//        [lblReward sizeToFit];
//        lblReward.frame = CGRectMake(lblReward.left, lblReward.top, lblReward.width, lblReward.height);
//        
//        detailBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 44, 0)];
//        [detailBtn setTitleColor:[UIColor colorWithHexString:@"D9A22B"] forState:UIControlStateNormal];
//        [detailBtn setTitle:@"查看详情 >" forState:UIControlStateNormal];
//        detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        [view addSubview:detailBtn];
//        [detailBtn sizeToFit];
//        detailBtn.frame = CGRectMake(lblReward.right+10, lblReward.bottom-detailBtn.height+6, detailBtn.width, detailBtn.height);
//        
//        marginTop += lblReward.height;
//        marginTop += 22;
//    }
    
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    line.frame = CGRectMake(40, marginTop, view.width-80, 0.5f);
    [view.layer addSublayer:line];
    
    marginTop += 0.5f;
    marginTop += 21.5;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, marginTop, view.width, 0)];
    lblTitle.font = [UIFont systemFontOfSize:12.f];
    lblTitle.textColor = [UIColor colorWithHexString:@"AAAAAA"];
    lblTitle.text = @"马上去邀请";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblTitle];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, marginTop, view.width, lblTitle.height);
    
    marginTop += lblTitle.height;
    marginTop += 20.f;
    
    InviteButtonsView *btnsView = [[InviteButtonsView alloc] init];
    btnsView.frame = CGRectMake(0, marginTop, btnsView.width, btnsView.height);
    btnsView.viewController = self;
    btnsView.share_text = self. share_text;
    btnsView.share_url = self.share_url;
    [view addSubview:btnsView];
    
    marginTop += btnsView.height;
    marginTop += 20.f;
    
//    
//    WEAKSELF;
//    detailBtn.handleClickBlock = ^(CommandButton *sender) {
//        if ([weakSelf.redirect_uri length]>0) {
//            [URLScheme locateWithRedirectUri:weakSelf.redirect_uri andIsShare:YES];
//        }
//    };
    
    view.contentSize = CGSizeMake(view.width, marginTop);
    
    return view;
}


@end



@interface RewardListViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,weak) UIView *headerView;

@end

@implementation RewardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@"奖励记录"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [DataSources globalWhiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [self buildHeaderView];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    [self initDataListLogic];
    
    if (self.gain_reward_money<=0) {
        
    }
    
//    reward/get_reward_record[GET]分页  返回{username，type（0邀请1注册2购物返利), type_desc 类型描述，reward_money   }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleReachabilityChanged:(id)notificationObject {
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
}

- (void)initDataListLogic
{
    WEAKSELF;
    NSInteger userId = [Session sharedInstance].currentUserId;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"reward" path:@"get_reward_record" pageSize:20];
    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        [newList addObject:[RewardTitleTableViewCell buildCellDict:nil]];
        for (int i=0;i<[addedItems count];i++) {
            RewardRecordItem *item = [RewardRecordItem modelWithJSONDictionary:[addedItems objectAtIndex:i]];
            if (item) {
                [newList addObject:[RewardTableViewCell buildCellDict:item]];
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithArray:weakSelf.dataSources];
        for (int i=0;i<[addedItems count];i++) {
            RewardRecordItem *item = [RewardRecordItem modelWithJSONDictionary:[addedItems objectAtIndex:i]];
            if (item) {
                [newList addObject:[RewardTableViewCell buildCellDict:item]];
            }
        }
        
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContent:@"你还没有获取奖励"];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
    
    [weakSelf showLoadingView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataList];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (UIView*)buildHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 115)];
    view.backgroundColor = [UIColor colorWithHexString:@"282828"];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)];
    titleLbl.font = [UIFont systemFontOfSize:12.f];
    titleLbl.text = @"已获得现金奖励:";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [view addSubview:titleLbl];
    
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)];
    moneyLbl.font = [UIFont systemFontOfSize:12.f];
    moneyLbl.text = [NSString stringWithFormat:@"¥%@",formatRewardMoney(self.gain_reward_money)];
    moneyLbl.textAlignment = NSTextAlignmentCenter;
    moneyLbl.textColor = [UIColor colorWithHexString:@"FFE8B0"];
    moneyLbl.font = [UIFont boldSystemFontOfSize:30];
    [view addSubview:moneyLbl];
    
    [titleLbl sizeToFit];
    [moneyLbl sizeToFit];
    
    CGFloat marginTop = (view.height-titleLbl.height-moneyLbl.height-12)/2;
    titleLbl.frame = CGRectMake(0, marginTop, view.width, titleLbl.height);
    marginTop += titleLbl.height;
    marginTop += 12;
    moneyLbl.frame = CGRectMake(0, marginTop, view.width, moneyLbl.height);
    
    return view;
}
@end

#import "UMSocial.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@implementation InviteButtonsView

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat sepWidth = 13.f;
        CGFloat marginLeft = (kScreenWidth-4*50-3*sepWidth)/2;
        CGFloat marginTop = 0.f;
        
        
        
        WEAKSELF;
        if ([WXApi isWXAppInstalled]) {
            CommandButton *btn1 = [self createButton:[UIImage imageNamed:@"invite_share_wechat"]];
            btn1.frame = CGRectMake(marginLeft, marginTop, btn1.width, btn1.height);
            [self addSubview:btn1];
            btn1.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf shareTo:UMShareToWechatSession];
            };
            
            marginLeft += btn1.width;
            marginLeft += sepWidth;
            
            CommandButton *btn2 = [self createButton:[UIImage imageNamed:@"invite_share_moment"]];
            btn2.frame = CGRectMake(marginLeft, marginTop, btn2.width, btn2.height);
            [self addSubview:btn2];
            btn2.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf shareTo:UMShareToWechatTimeline];
            };
            
            marginLeft += btn2.width;
            marginLeft += sepWidth;
        }
        

        if ([TencentOAuth iphoneQQInstalled]) {
            CommandButton *btn3 = [self createButton:[UIImage imageNamed:@"invite_share_qq"]];
            btn3.frame = CGRectMake(marginLeft, marginTop, btn3.width, btn3.height);
            [self addSubview:btn3];
            btn3.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf shareTo:UMShareToQQ];
            };
            
            marginLeft += btn3.width;
            marginLeft += sepWidth;
        }
        
        if ([WeiboSDK isWeiboAppInstalled]) {
            CommandButton *btn4 = [self createButton:[UIImage imageNamed:@"invite_share_weibo"]];
            btn4.frame = CGRectMake(marginLeft, marginTop, btn4.width, btn4.height);
            [self addSubview:btn4];
            btn4.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf shareTo:UMShareToSina];
            };
            
            marginTop += btn4.height;
            marginTop += 13.f;
            marginLeft = (kScreenWidth-4*50-3*sepWidth)/2;
        }
        
        CommandButton *btn5 = [self createButton:[UIImage imageNamed:@"invite_share_sms"]];
        btn5.frame = CGRectMake(marginLeft, marginTop, btn5.width, btn5.height);
        [self addSubview:btn5];
        btn5.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf shareTo:UMShareToSms];
        };
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 100+15);
    }
    return self;
}

- (void)shareTo:(NSString*)UMShareToType {
    WEAKSELF;
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:[NSArray arrayWithObject:UMShareToType] content:weakSelf.share_text image:nil location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:weakSelf.share_url] presentedController:weakSelf.viewController completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//            if (weakSelf.viewController) {
//                [weakSelf.viewController showHUD:@"分享成功" hideAfterDelay:0.8f];
//            }
//        }
//        else if (response.responseCode == UMSResponseCodeFaild) {
//            [weakSelf.viewController showHUD:response.message hideAfterDelay:0.8f];
//        }
//    }];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToType] content:weakSelf.share_text image:nil location:nil urlResource:nil presentedController:weakSelf.viewController completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.viewController) {
                    [weakSelf.viewController showHUD:@"分享成功" hideAfterDelay:0.8f];
                }
            });
        } else if(response.responseCode != UMSResponseCodeCancel) {
            [weakSelf.viewController showHUD:response.message hideAfterDelay:0.8f];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat sepWidth = 13.f;
    CGFloat marginLeft = (kScreenWidth-4*50-3*sepWidth)/2;
    CGFloat marginTop = 0.f;
    
    NSArray *subviews = [self subviews];
    if (subviews.count < 4) {
        CGFloat totalWidth = 0;
        for (NSInteger i=0;i<subviews.count;i++) {
            if (totalWidth>0) {
                totalWidth+=sepWidth;
            }
            UIView *btn = (UIView*)[subviews objectAtIndex:i];
            totalWidth += btn.width;
            marginLeft = (kScreenWidth-totalWidth)/2;
        }
    }
    
    for (NSInteger i=0;i<subviews.count;i++) {
        UIView *btn = (UIView*)[subviews objectAtIndex:i];
        btn.frame = CGRectMake(marginLeft, marginTop, btn.width, btn.height);
        marginLeft += btn.width;
        marginLeft += sepWidth;
        if (i>0&&i%3==0) {
            marginTop += btn.height;
            marginTop += 13.f;
            marginLeft = (kScreenWidth-4*50-3*sepWidth)/2;
        }
    }
}

- (CommandButton*)createButton:(UIImage*)image {
    CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn.backgroundColor =[UIColor clearColor];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

@end

