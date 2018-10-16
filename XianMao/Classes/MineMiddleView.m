//
//  MineMiddleView.m
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineMiddleView.h"
#import "Command.h"
#import "Masonry.h"
#import "Session.h"
#import "BonusListViewController.h"
#import "WalletTwoViewController.h"
#import "User.h"
#import "URLScheme.h"
#import "ConsultantViewController.h"
#import "AdviserPage.h"
#import "CardViewController.h"
#import "MineIncomeViewController.h"

@interface MineMiddleView ()

@property (nonatomic, strong) VerticalCommandButton *wallerBtn;
@property (nonatomic, strong) VerticalCommandButton *catDiamondBtn;
@property (nonatomic, strong) VerticalCommandButton *quanBtn;
@property (nonatomic, strong) VerticalCommandButton *likeBtn;

@end

@implementation MineMiddleView

-(VerticalCommandButton *)wallerBtn{
    if (!_wallerBtn) {
        _wallerBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _wallerBtn.contentAlignmentCenter = YES;
        _wallerBtn.imageTextSepHeight = 6;
        [_wallerBtn setImage:[[SkinIconManager manager] isValidWithPath:KMine_Purse]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_Purse]]:[UIImage imageNamed:@"mine_wallet_New_New_MF"] forState:UIControlStateNormal];
        [_wallerBtn setTitle:@"钱包" forState:UIControlStateNormal];
        [_wallerBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _wallerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _wallerBtn;
}

-(VerticalCommandButton *)catDiamondBtn{
    if (!_catDiamondBtn) {
        _catDiamondBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _catDiamondBtn.contentAlignmentCenter = YES;
        _catDiamondBtn.imageTextSepHeight = 6;
        [_catDiamondBtn setImage:[[SkinIconManager manager] isValidWithPath:KMine_Consultant]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_Consultant]]:[UIImage imageNamed:@"mine_adviser_new_new"] forState:UIControlStateNormal];
        [_catDiamondBtn setTitle:@"顾问" forState:UIControlStateNormal];
        [_catDiamondBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _catDiamondBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _catDiamondBtn;
}

-(VerticalCommandButton *)quanBtn{
    if (!_quanBtn) {
        _quanBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _quanBtn.contentAlignmentCenter = YES;
        _quanBtn.imageTextSepHeight = 6;
        [_quanBtn setImage:[[SkinIconManager manager] isValidWithPath:KMine_Ticket]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_Ticket]]:[UIImage imageNamed:@"quan_New_New_MF"] forState:UIControlStateNormal];
        [_quanBtn setTitle:@"卡券" forState:UIControlStateNormal];
        [_quanBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _quanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _quanBtn;
}

-(VerticalCommandButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _likeBtn.contentAlignmentCenter = YES;
        _likeBtn.imageTextSepHeight = 6;
        [_likeBtn setImage:[[SkinIconManager manager] isValidWithPath:KMine_Heart]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_Heart]]:[UIImage imageNamed:@"like_New_New_MF"] forState:UIControlStateNormal];
        [_likeBtn setTitle:@"心动" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _likeBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.wallerBtn];
        [self addSubview:self.catDiamondBtn];
        [self addSubview:self.quanBtn];
        [self addSubview:self.likeBtn];
        
        self.wallerBtn.handleClickBlock = ^(CommandButton *sender) {
            [MobClick event:@"click_my_wallet_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MinePurseViewCode referPageCode:MinePurseViewCode andData:nil];
//            WalletTwoViewController *wallerController = [[WalletTwoViewController alloc] init];
            MineIncomeViewController * income = [[MineIncomeViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:income animated:YES];
        };
        
        self.catDiamondBtn.handleClickBlock = ^(CommandButton *sender) {
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                
                AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                
            } failure:^(XMError *error) {
                
            } queue:nil]];
        };
        
        self.quanBtn.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineDiscountCouponViewCode referPageCode:MineDiscountCouponViewCode andData:nil];
            [MobClick event:@"click_coupon_from_mine"];
            //BonusListViewController *viewController = [[BonusListViewController alloc] init];
            CardViewController * card = [[CardViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:card animated:YES];
        };
        
        self.likeBtn.handleClickBlock = ^(CommandButton *sender) {
            [MobClick event:@"click_favor_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineLikeViewCode referPageCode:MineLikeViewCode andData:nil];
            [[CoordinatingController sharedInstance] gotoUserLikesViewController:[Session sharedInstance].currentUserId
                                                                        animated:YES];
        };
        
        [self setUpUI];
        [self setData];
    }
    return self;
}

-(void)setData{
    User *user = [Session sharedInstance].currentUser;
    [self.likeBtn setTitle:[NSString stringWithFormat:@" 心动(%ld)", (long)user.likesNum] forState:UIControlStateNormal];
    [self.quanBtn setTitle:[NSString stringWithFormat:@" 卡券(%ld)", (long)user.bonusNum] forState:UIControlStateNormal];
}

-(void)setUpUI{
    
    [self.wallerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.quanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.wallerBtn.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.quanBtn.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.catDiamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.likeBtn.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
