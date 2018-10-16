//
//  MineNewViewController.m
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineNewViewController.h"
#import "MineNewHeaderView.h"
#import "VisualEffectView.h"
#import "MineMiddleView.h"
#import "MineSegNewView.h"
#import "MineCateNewView.h"
#import "MineUserHomeCell.h"
#import "ShoppingCartViewController.h"
#import "SettingsViewController.h"
#import "Error.h"
#import "MineOrderButton.h"
#import "MineOrderView.h"
#import "MineContactView.h"
#import "MineContactCateView.h"
#import "UserDetailInfo.h"
#import "MineStampSendCell.h"
#import "MineNewBottomCell.h"
#import "MineSmallSegNewView.h"
#import "NetworkAPI.h"
#import "Session.h"
#import "Masonry.h"
#import "BoughtCollectionViewController.h"
#import "WCAlertView.h"
#import "URLScheme.h"
#import "WebViewController.h"
#import "AboutViewController.h"
#import "SuccessfulPayViewController.h"
#import "GuideView.h"
#import "SearchSiftGradeViewController.h"
#import "CardViewController.h"
#import "inviteNewViewController.h"


@interface MineNewViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) MineNewHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HTTPRequest * request;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *shopCarBtn;
@property (nonatomic, strong) MineMiddleView *middleView;
@property (nonatomic, strong) MineSegNewView *segView;
@property (nonatomic, strong) MineCateNewView *cateView;
@property (nonatomic, strong) MineSegNewView *segView2;
@property (nonatomic, strong) MineSegNewView *segView3;
@property (nonatomic, strong) MineUserHomeCell *userHomeCell;
@property (nonatomic, strong) UIButton *goodsNum;

@property (nonatomic, strong) MineOrderButton *orderBtn;
@property (nonatomic, strong) MineOrderView *orderView;
@property (nonatomic, strong) MineContactView *contantView;
@property (nonatomic, strong) MineContactCateView *contactCateView;

@property (nonatomic, strong) MineStampSendCell *stampSendCell;
@property (nonatomic, strong) MineSegNewView *segView4;
@property (nonatomic, strong) MineNewBottomCell *kefuCell;
@property (nonatomic, strong) MineSmallSegNewView *smallSegCell1;
@property (nonatomic, strong) MineNewBottomCell *onLineKefuCell;
@property (nonatomic, strong) MineSmallSegNewView *smallSegCell2;
@property (nonatomic, strong) MineNewBottomCell *helpCenterCell;
@property (nonatomic, strong) MineSmallSegNewView *smallSegCell3;
@property (nonatomic, strong) MineNewBottomCell *backIdeaCell;
@property (nonatomic, strong) MineSmallSegNewView *smallSegCell4;
@property (nonatomic, strong) MineNewBottomCell *shareAppCell;
@property (nonatomic, strong) MineSmallSegNewView *smallSegCell5;
@property (nonatomic, strong) MineNewBottomCell *inviteCell;

@property (nonatomic, strong) UIButton *topLeftBtn;
@property (nonatomic, strong) UIButton *topRightBtn;
@property (nonatomic, strong) UIButton *topLeftBtnBg;
@property (nonatomic, strong) UIButton *topRightBtnBg;
@end

@implementation MineNewViewController

-(MineNewBottomCell *)inviteCell{
    if (!_inviteCell) {
        _inviteCell = [[MineNewBottomCell alloc] initWithIcon:@"invite" title:@"我的邀请" subTitle:@"赚88元商城券" isRightAllow:YES];
    }
    return _inviteCell;
}

-(MineSmallSegNewView *)smallSegCell5{
    if (!_smallSegCell5) {
        _smallSegCell5 = [[MineSmallSegNewView alloc] initWithFrame:CGRectZero];
    }
    return _smallSegCell5;
}

-(MineNewBottomCell *)shareAppCell{
    if (!_shareAppCell) {
        _shareAppCell = [[MineNewBottomCell alloc] initWithIcon:@"Share_App_New_MF" title:@"分享App" subTitle:@"" isRightAllow:YES];
    }
    return _shareAppCell;
}

-(MineSmallSegNewView *)smallSegCell4{
    if (!_smallSegCell4) {
        _smallSegCell4 = [[MineSmallSegNewView alloc] initWithFrame:CGRectZero];
    }
    return _smallSegCell4;
}

-(MineNewBottomCell *)backIdeaCell{
    if (!_backIdeaCell) {
        _backIdeaCell = [[MineNewBottomCell alloc] initWithIcon:@"BackIdea_New_New_MF" title:@"意见反馈" subTitle:@"" isRightAllow:YES];
    }
    return _backIdeaCell;
}

-(MineSmallSegNewView *)smallSegCell3{
    if (!_smallSegCell3) {
        _smallSegCell3 = [[MineSmallSegNewView alloc] initWithFrame:CGRectZero];
    }
    return _smallSegCell3;
}

-(MineNewBottomCell *)helpCenterCell{
    if (!_helpCenterCell) {
        _helpCenterCell = [[MineNewBottomCell alloc] initWithIcon:@"HelpCenter_New_New_MF" title:@"帮助中心" subTitle:@"" isRightAllow:YES];
    }
    return _helpCenterCell;
}

-(MineSmallSegNewView *)smallSegCell2{
    if (!_smallSegCell2) {
        _smallSegCell2 = [[MineSmallSegNewView alloc] initWithFrame:CGRectZero];
    }
    return _smallSegCell2;
}

-(MineNewBottomCell *)onLineKefuCell{
    if (!_onLineKefuCell) {
        _onLineKefuCell = [[MineNewBottomCell alloc] initWithIcon:@"OnLine_Kefu_MF" title:@"在线客服" subTitle:@"" isRightAllow:YES];
    }
    return _onLineKefuCell;
}

-(MineSmallSegNewView *)smallSegCell1{
    if (!_smallSegCell1) {
        _smallSegCell1 = [[MineSmallSegNewView alloc] initWithFrame:CGRectZero];
    }
    return _smallSegCell1;
}

-(MineNewBottomCell *)kefuCell{
    if (!_kefuCell) {
        _kefuCell = [[MineNewBottomCell alloc] initWithIcon:@"Mine_New_New_Kefu_MF" title:@"客服电话" subTitle:@"" isRightAllow:YES];
    }
    return _kefuCell;
}

-(MineStampSendCell *)stampSendCell{
    if (!_stampSendCell) {
        _stampSendCell = [[MineStampSendCell alloc] initWithFrame:CGRectZero];
    }
    return _stampSendCell;
}

-(UIButton *)topLeftBtnBg{
    if (!_topLeftBtnBg) {
        _topLeftBtnBg = [[UIButton alloc] initWithFrame:CGRectZero];
        _topLeftBtnBg.backgroundColor = [UIColor clearColor];
    }
    return _topLeftBtnBg;
}

-(UIButton *)topRightBtnBg{
    if (!_topRightBtnBg) {
        _topRightBtnBg = [[UIButton alloc] initWithFrame:CGRectZero];
        _topRightBtnBg.backgroundColor = [UIColor clearColor];
    }
    return _topRightBtnBg;
}

-(UIButton *)topRightBtn{
    if (!_topRightBtn) {
        _topRightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_topRightBtn setImage:[[SkinIconManager manager] isValidWithPath:KMine_TopBarRightImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_TopBarRightImg]]:[UIImage imageNamed:@"shopping_bag_white_new"] forState:UIControlStateNormal];
        [_topRightBtn sizeToFit];
    }
    return _topRightBtn;
}

-(UIButton *)topLeftBtn{
    if (!_topLeftBtn) {
        _topLeftBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_topLeftBtn setImage:[[SkinIconManager manager] isValidWithPath:KMine_TopBarLeftImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_TopBarLeftImg]]:[UIImage imageNamed:@"mine_setting_new"] forState:UIControlStateNormal];
        [_topLeftBtn sizeToFit];
    }
    return _topLeftBtn;
}

-(MineContactCateView *)contactCateView{
    if (!_contactCateView) {
        _contactCateView = [[MineContactCateView alloc] initWithFrame:CGRectZero];
    }
    return _contactCateView;
}

-(MineContactView *)contantView{
    if (!_contantView) {
        _contantView = [[MineContactView alloc] initWithFrame:CGRectZero];
    }
    return _contantView;
}

-(MineOrderView *)orderView{
    if (!_orderView) {
        _orderView = [[MineOrderView alloc] initWithFrame:CGRectZero];
    }
    return _orderView;
}

-(MineOrderButton *)orderBtn{
    if (!_orderBtn) {
        _orderBtn = [[MineOrderButton alloc] initWithFrame:CGRectZero];
        _orderBtn.backgroundColor = [UIColor whiteColor];
    }
    return _orderBtn;
}

-(UIButton *)goodsNum{
    if (!_goodsNum) {
        _goodsNum = [[UIButton alloc] initWithFrame:CGRectZero];
        _goodsNum.backgroundColor = [DataSources colorf9384c];
        _goodsNum.layer.cornerRadius = 6.5f;
        _goodsNum.layer.masksToBounds = YES;
        _goodsNum.layer.borderWidth = 1;
        _goodsNum.layer.borderColor = [UIColor blackColor].CGColor;
        [_goodsNum setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        _goodsNum.enabled = NO;
        _goodsNum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _goodsNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _goodsNum.titleLabel.font = [UIFont systemFontOfSize:9.5f];
        return _goodsNum;
    }
    return _goodsNum;
}

-(MineUserHomeCell *)userHomeCell{
    if (!_userHomeCell) {
        _userHomeCell = [[MineUserHomeCell alloc] initWithFrame:CGRectZero];
        _userHomeCell.backgroundColor = [UIColor whiteColor];
    }
    return _userHomeCell;
}

-(MineCateNewView *)cateView{
    if (!_cateView) {
        _cateView = [[MineCateNewView alloc] initWithFrame:CGRectZero];
    }
    return _cateView;
}

-(MineSegNewView *)segView{
    if (!_segView) {
        _segView = [[MineSegNewView alloc] initWithFrame:CGRectZero];
    }
    return _segView;
}

-(MineMiddleView *)middleView{
    if (!_middleView) {
        _middleView = [[MineMiddleView alloc] initWithFrame:CGRectZero];
    }
    return _middleView;
}

-(UIButton *)shopCarBtn{
    if (!_shopCarBtn) {
        _shopCarBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shopCarBtn setImage:[UIImage imageNamed:@"Shop_Bag_New_MF"] forState:UIControlStateNormal];
        [_shopCarBtn sizeToFit];
    }
    return _shopCarBtn;
}

-(UIButton *)settingBtn{
    if (!_settingBtn) {
        _settingBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_settingBtn setImage:[UIImage imageNamed:@"Mine_New_ShoppingBad_White_MF"] forState:UIControlStateNormal];
        [_settingBtn sizeToFit];
    }
    return _settingBtn;
}

-(MineNewHeaderView *)headerView{
    if (!_headerView ) {
        _headerView = [[MineNewHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WEAKSELF;
    [self.view addSubview:self.scrollView];
    [self customTopBar];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.middleView];
    [self.scrollView addSubview:self.segView];
//    [self.scrollView addSubview:self.cateView];
    [self.scrollView addSubview:self.orderBtn];
    [self.scrollView addSubview:self.orderView];
    MineSegNewView *segView3 = [[MineSegNewView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:segView3];
    self.segView3 = segView3;
//    [self.scrollView addSubview:self.contantView];
//    [self.scrollView addSubview:self.contactCateView];
    MineSegNewView *segView2 = [[MineSegNewView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:segView2];
    self.segView2 = segView2;
    [self.scrollView addSubview:self.userHomeCell];

    [self.scrollView addSubview:self.stampSendCell];
    MineSegNewView *segView4 = [[MineSegNewView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:segView4];
    self.segView4 = segView4;
//    [self.scrollView addSubview:self.inviteCell];
//    [self.scrollView addSubview:self.smallSegCell5];
    [self.scrollView addSubview:self.kefuCell];
    [self.scrollView addSubview:self.smallSegCell1];
    [self.scrollView addSubview:self.onLineKefuCell];
    [self.scrollView addSubview:self.smallSegCell2];
    [self.scrollView addSubview:self.helpCenterCell];
    [self.scrollView addSubview:self.smallSegCell3];
    [self.scrollView addSubview:self.backIdeaCell];
    [self.scrollView addSubview:self.smallSegCell4];
    [self.scrollView addSubview:self.shareAppCell];
    
    
//    [self.scrollView addSubview:self.settingBtn];
//    [self.scrollView addSubview:self.shopCarBtn];
//    [self.shopCarBtn addSubview:self.goodsNum];
//    [self.settingBtn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.shopCarBtn addTarget:self action:@selector(clickShopBagBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.inviteCell.handlsCell = ^(){
        inviteNewViewController *viewController = [[inviteNewViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    };
    
    self.kefuCell.handlsCell = ^(){
        [WCAlertView showAlertWithTitle:kCustomServicePhoneDisplay message:@"周一到周五：9:30--18:00" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 0) {
                
            } else {
                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:CallCustomerRegionCode referPageCode:NoReferPageCode andData:nil];
                NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    };
    
    self.onLineKefuCell.handlsCell = ^(){
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"em_user" parameters:nil completionBlock:^(NSDictionary *data) {
            EMAccount *emAccount = [[EMAccount alloc] initWithDict:data[@"emUser"]];
            [[Session sharedInstance] setUserKEFUEMAccount:emAccount];
            [UserSingletonCommand chatWithGroup:emAccount isShowDownTime:YES message:@"亲爱的，有什么可以帮您？" isKefu:YES];
        } failure:^(XMError *error) {
            
        } queue:nil]];
    };
    
    self.helpCenterCell.handlsCell = ^(){
        [MobClick event:@"click_manage_help_center"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineWebViewCode referPageCode:MineWebViewCode andData:nil];
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.title = @"帮助中心";
        viewController.url = @"http://activity.aidingmao.com/share/page/351";
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        
    };
    
    self.backIdeaCell.handlsCell = ^(){
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFeedbackViewCode referPageCode:MineFeedbackViewCode andData:nil];
        FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    };
    
    self.shareAppCell.handlsCell = ^(){
        UIImage *image = [UIImage imageNamed:@"AppIcon_120"];
        [[CoordinatingController sharedInstance] shareWithTitle:@"给你看个买卖奢侈品的App，很不错哟~"
                                                          image:image
                                                            url:kAppShareUrl
                                                        content:@"权威鉴定、快速出货、奢品顾问、超值特卖。\n爱丁猫·会买奢侈品·Just take it"];
        
    };
    
    self.headerView.handleNewSingleTapDetected = ^(MineNewHeaderView *view) {
        [[CoordinatingController sharedInstance] gotoUserHomeViewController:[Session sharedInstance].currentUserId
                                                                   animated:YES];
    };
    
    [self.orderBtn addTarget:self action:@selector(clickOrderBtn) forControlEvents:UIControlEventTouchUpInside];

    if ([GuideView isNeedShowGuideViewInMineViewCtroller]) {
        [GuideView showNewUserGuideViewInMineViewController:self.view];
    }
    [self setUpUI];
}

-(void)clickOrderBtn{
    [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
    BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
    [self pushViewController:viewController animated:YES];

    
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    [MobClick event:@"click_shopping_chart_from_mine"];
    [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:HomeShopCarRegionCode referPageCode:HomeShopCarRegionCode andData:nil];
    ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

-(void)handleTopBarBackButtonClicked:(UIButton *)sender{
    [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineSettingViewCode referPageCode:MineSettingViewCode andData:nil];
    SettingsViewController *settingViewVC = [[SettingsViewController alloc] init];
    [[CoordinatingController sharedInstance] pushViewController:settingViewVC animated:YES];
}

- (void)customTopBar{
    [super setupTopBar];
    User *user = [Session sharedInstance].currentUser;
    [super setupTopBarTitle:user.userName];
    self.topBarTitleLbl.font = [UIFont systemFontOfSize:20];
    self.topBarTitleLbl.textColor = [DataSources globalWhiteColor];
    self.topBarlineView.backgroundColor = [UIColor blackColor];
    self.topBarTitleLbl.alpha = 0;
    self.topBarlineView.alpha = 0;
    self.topBar.backgroundColor = [UIColor clearColor];
    
    UIImage * topBarRightImg = [[SkinIconManager manager] isValidWithPath:KMine_TopBarRightImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_TopBarRightImg]]:[UIImage imageNamed:@"shopping_bag_white_new"];
    
    UIImage * topBarLeftImg = [[SkinIconManager manager] isValidWithPath:KMine_TopBarLeftImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMine_TopBarLeftImg]]:[UIImage imageNamed:@"mine_setting_new"];
    
    UIImage * topBarImg = [[SkinIconManager manager] getPicturePath:KTopbar_BackgroudImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_BackgroudImg]]:[UIImage imageNamed:@"navgationbar_bg"];
    
    self.topBar.image = [self imageByApplyingAlpha:0 image:topBarImg];
    [super setupTopBarBackButton:topBarLeftImg imgPressed:topBarLeftImg];
    [super setupTopBarRightButton:topBarRightImg imgPressed:topBarRightImg];
    
    self.goodsNum.frame = CGRectMake(kScreenWidth-5-14, 28, 14, 13);
    self.goodsNum.layer.masksToBounds = YES;
    self.goodsNum.layer.cornerRadius = _goodsNum.height/2;
    [self.topBar addSubview:self.goodsNum];
    if ([Session sharedInstance].shoppingCartNum == 0) {
        self.goodsNum.hidden = YES;
    } else {
        self.goodsNum.hidden = NO;
    }
    
    [self bringTopBarToTop];
    
    //    [self.view addSubview:self.topLeftBtn];
    //    [self.view addSubview:self.topRightBtn];
    //    [self.view addSubview:self.topRightBtnBg];
    //    [self.view addSubview:self.topLeftBtnBg];
    //    [self.topLeftBtnBg addTarget:self action:@selector(handleTopBarBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.topRightBtnBg addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view.mas_top).offset(32);
    //        make.left.equalTo(self.view.mas_left).offset(10);
    //    }];
    //
    //    [self.topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view.mas_top).offset(32);
    //        make.right.equalTo(self.view.mas_right).offset(-10);
    //    }];
    //
    //    [self.topLeftBtnBg mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.topLeftBtn.mas_centerX);
    //        make.centerY.equalTo(self.topLeftBtn.mas_centerY);
    //        make.width.equalTo(@50);
    //        make.height.equalTo(@50);
    //    }];
    //
    //    [self.topRightBtnBg mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.topRightBtn.mas_centerX);
    //        make.centerY.equalTo(self.topRightBtn.mas_centerY);
    //        make.width.equalTo(@50);
    //        make.height.equalTo(@50);
    //    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    User *user = [Session sharedInstance].currentUser;
    [super setupTopBarTitle:user.userName];
    
    long goodsNum = [Session sharedInstance].shoppingCartNum;
    if (goodsNum == 0) {
        self.goodsNum.hidden = YES;
    } else {
        self.goodsNum.hidden = NO;
        [self.goodsNum setTitle:[NSString stringWithFormat:@"%ld", (long)[Session sharedInstance].shoppingCartNum] forState:UIControlStateNormal];
    }
    [self reloadUserData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)reloadUserData
{
    WEAKSELF;
    NSUInteger userId = [Session sharedInstance].currentUserId;
    _request = [[NetworkAPI sharedInstance] getUserDetail:userId completion:^(UserDetailInfo *userDetailInfo) {
        if (userDetailInfo.userInfo.userId == [Session sharedInstance].currentUserId) {
            [[Session sharedInstance] setUserInfo:userDetailInfo.userInfo];
            [self.headerView setData];
            [self.middleView setData];
            [self.orderView setData];
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:self.view];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSet_Y = self.scrollView.contentOffset.y;
    CGFloat alpha = offSet_Y/80;
    if (alpha>=1){
        alpha = 1;
        self.topBarTitleLbl.alpha = alpha;
    }else{
        self.topBarTitleLbl.alpha = 0;
    }
    
    if ([[SkinIconManager manager] isValidWithPath:KTopbar_BackgroudImg]) {
        UIImage * image = [UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_BackgroudImg]];
        self.topBar.image = [self imageByApplyingAlpha:alpha image:image];
    }else{
        UIImage *image = [UIImage imageNamed:@"navgationbar_bg"];;
        self.topBar.image = [self imageByApplyingAlpha:alpha image:image];
    }
    self.topBarlineView.alpha = alpha;
    
}
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#define kBottomTabBarHeight    (IS_IPHONE_6P ? 56.f : 50.f)
-(void)setUpUI{
    
    CGFloat margin = 0;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.headerView.frame = CGRectMake(0, -155, kScreenWidth, 310);
    margin += 155;
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@84);
    }];
    margin += 84;
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom);
        make.left.equalTo(self.middleView.mas_left);
        make.right.equalTo(self.middleView.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
    [self.userHomeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    [self.segView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userHomeCell.mas_bottom);
        make.left.equalTo(self.userHomeCell.mas_left);
        make.right.equalTo(self.userHomeCell.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView2.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    margin += 44;
    
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.orderBtn.mas_bottom);
        make.height.equalTo(@88);
    }];
    margin += 88;
    [self.segView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderView.mas_bottom);
        make.left.equalTo(self.orderView.mas_left);
        make.right.equalTo(self.orderView.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
    [self.stampSendCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView3.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    [self.segView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stampSendCell.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
//    [self.inviteCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.segView4.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(@48);
//    }];
//    margin += 48;
    
//    [self.smallSegCell5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.inviteCell.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(@1);
//    }];
//    margin += 1;
    
    [self.kefuCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView4.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    [self.smallSegCell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kefuCell.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    margin += 1;
    
    [self.onLineKefuCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallSegCell1.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    [self.smallSegCell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.onLineKefuCell.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    margin += 1;
    
    [self.helpCenterCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallSegCell2.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    [self.smallSegCell3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.helpCenterCell.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    margin += 1;
    
    [self.backIdeaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallSegCell3.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    [self.smallSegCell4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIdeaCell.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    margin += 1;
    
    [self.shareAppCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallSegCell4.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@48);
    }];
    margin += 48;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, margin);
}

@end
