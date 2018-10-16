//
//  MineViewController.m
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MineViewController.h"

#import "MineTableViewCell.h"
#import "SetTableViewCell.h"
#import "SepTableViewCell.h"
#import "NSDictionary+Additions.h"
#import "Command.h"

#import "CoordinatingController.h"

#import "SettingsViewController.h"

#import "MyNavigationController.h"
#import "OnSaleViewController.h"
#import "BoughtViewController.h"
#import "SoldViewController.h"
#import "FavoriteViewController.h"

#import "WalletViewController.h"  //修改钱包controller  2016.4.13 Feng
#import "WalletTwoViewController.h"

#import "BoughtCollectionViewController.h"
#import "SoldCollectionViewController.h"
#import "RecoverCollectionViewController.h"

#import "DataSources.h"
#import "UIColor+Expanded.h"

#import "EditProfileViewController.h"
#import "UserHomeViewController.h"
#import "UserLikesViewController.h"
#import "FollowsViewController.h"
#import "ShoppingCartViewController.h"
#import "UserAddressViewController.h"
#import "ConsignViewController.h"
#import "AboutViewController.h"
#import "MySaleViewController.h"
#import "Session.h"

#import "BonusListViewController.h"
#import "ConsultantViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "NetworkAPI.h"
#import "PictureItem.h"
#import "QrCodeScanViewController.h"
#import "URLScheme.h"

#import "WebViewController.h"
#import "InviteViewController.h"

#import "UIActionSheet+Blocks.h"
#import "DidPriceViewController.h"
#import "GuideView.h"

#import "VisualEffectView.h"

@interface MineViewController () <UITableViewDataSource,UITableViewDelegate,ConsignOrdersChangedReceiver,UserProfileChangedReceiver,UserInfoChangedReceiver,EditProfileViewControllerDelegate,QrCodeScanViewControllerDelegate>

@property(nonatomic,weak) MineHeaderView *headerView;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSources;

@end


@implementation MineViewController

- (void)dealloc
{
    self.tableView = nil;
    self.headerView = nil;
    self.dataSources = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.clipsToBounds = YES;
    
//#if DEBUG
//    if (![GuideView isNeedShowWaitItGuideView]) {
//        [GuideView showMainGuideView:self.view];
//    }
//#else
//    if ([GuideView isNeedShowWaitItGuideView]) {
//        [GuideView showMainGuideView:self.view];
//    }
//#endif
    
    WEAKSELF;
    self.dataSources = [NSArray arrayWithObjects:
//                        [SepTableViewCell buildCellDict],
//                        [[MineTableViewCell buildCellDict:@"输入邀请码" icon:@"mine_icon_invite_code"  bottomLinePaddingLeft:15] fillAction:^{
//        [MobClick event:@"click_invite_from_mine"];
//        InviteCodeConvertController *viewController = [[InviteCodeConvertController alloc] init];
//        viewController.title = @"输入邀请码";
//        [weakSelf pushViewController:viewController animated:YES];
//    }],
//                        [[MineTableViewCell buildCellDict:@"邀请朋友有钱拿" icon:@"mine_icon_invite_bonus" bottomLinePaddingLeft:0] fillAction:^{
//        [MobClick event:@"click_invite_from_mine"];
//        InviteViewController *viewController = [[InviteViewController alloc] init];
//        [weakSelf pushViewController:viewController animated:YES];
//    }],
                        [SepTableViewCell buildCellDict],
                        [[MineTableViewCell buildCellDict:@"我出价的" icon:@"recover_icon_MF" bottomLinePaddingLeft:15] fillAction:^{
        [MobClick event:@"click_my_belongs_from_mine"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineOfferedViewCode referPageCode:MineOfferedViewCode andData:nil];
        //ADD code
        DidPriceViewController *viewController = [[DidPriceViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
        
    }],
                        [[MineTableViewCell buildCellDict:@"我买到的" icon:@"mine_icon_bought" bottomLinePaddingLeft:15] fillAction:^{
        [MobClick event:@"click_my_belongs_from_mine"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
        BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        [[MineTableViewCell buildCellDict:@"我卖出的" icon:@"mine_icon_sold" bottomLinePaddingLeft:0] fillAction:^{
        [MobClick event:@"click_on_sell_from_mine"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineSoldViewCode referPageCode:MineSoldViewCode andData:nil];
//        MySaleViewController *viewController = [[MySaleViewController alloc] init];
        SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        [[MineTableViewCell buildCellDict:@"我发布的商品" icon:@"issue_recover_MF" bottomLinePaddingLeft:0] fillAction:^{
//        [MobClick event:@"click_on_sell_from_mine"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineOnSaleViewCode referPageCode:MineOnSaleViewCode andData:nil];
        RecoverCollectionViewController *viewController = [[RecoverCollectionViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        [SepTableViewCell buildCellDict],
                        [[MineTableViewCell buildCellDict:@"我的顾问" icon:@"Main_Consultant" bottomLinePaddingLeft:0] fillAction:^{
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineConsultantViewCode referPageCode:MineConsultantViewCode andData:nil];
        ConsultantViewController *viewController = [[ConsultantViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        //                        [[MineTableViewCell buildCellDict:@"购物车"] fillAction:^{
                        //        [MobClick event:@"click_shopping_chart_from_mine"];
                        //        ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        //                        [[MineTableViewCell buildCellDict:@"已买订单"] fillAction:^{
                        //        [MobClick event:@"click_bought_from_mine"];
                        //        BoughtViewController *viewController = [[BoughtViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        //
                        //                        [SepTableViewCell buildCellDict],
                        //                        [[MineTableViewCell buildCellDict:@"在售商品"] fillAction:^{
                        //        [MobClick event:@"click_for_sale_from_mine"];
                        //        OnSaleViewController *viewController = [[OnSaleViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        //                        [[MineTableViewCell buildCellDict:@"已售订单"] fillAction:^{
                        //        [MobClick event:@"click_sold_from_mine"];
                        //        SoldViewController *viewController = [[SoldViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        //                        [[MineTableViewCell buildCellDict:@"我的寄卖"] fillAction:^{
                        //        [MobClick event:@"click_my_consignment_from_mine"];
                        //        ConsignOrderListViewController *viewController = [[ConsignOrderListViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        
                        //                        [SepTableViewCell buildCellDict],
                        //
                        //                        [[MineTableViewCell buildCellDict:@"我的钱包"] fillAction:^{
                        //        [MobClick event:@"click_my_wallet_from_mine"];
                        //        WalletViewController *viewController = [[WalletViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //
                        //    }],
                        //                        [[MineTableViewCell buildCellDict:@"我的优惠券"] fillAction:^{
                        //        [MobClick event:@"click_coupon_from_mine"];
                        //        BonusListViewController *viewController = [[BonusListViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        
                        //移动到设置选项中
//                        [SepTableViewCell buildCellDict],
//                        [[MineTableViewCell buildCellDict:@"管理收货地址" icon:@"mine_icon_shouhuo" bottomLinePaddingLeft:15] fillAction:^{
//        [MobClick event:@"click_manage_my_address"];
//        UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
//        [weakSelf pushViewController:viewController animated:YES];
//    }],
//                        [[MineTableViewCell buildCellDict:@"管理退货地址" icon:@"mine_icon_tuihuo" bottomLinePaddingLeft:0] fillAction:^{
//        [MobClick event:@"click_manage_my_address_send"];
//        UserAddressViewController *viewController = [[UserAddressViewControllerReturn alloc] init];
//        [weakSelf pushViewController:viewController animated:YES];
//    }],
                        [SepTableViewCell buildCellDict],
//                                                [[MineTableViewCell buildCellDict:@"帮助中心"] fillAction:^{
//                                [MobClick event:@"click_manage_help_center"];
//                                WebViewController *viewController = [[WebViewController alloc] init];
//                                viewController.title = @"帮助中心";
//                                viewController.url = @"http://activity.aidingmao.com/share/page/351";
//                                [weakSelf pushViewController:viewController animated:YES];
//                        
//                            }],
//                        [[MineTableViewCell buildCellDict:@"在线客服" icon:@"OnLine_customer" bottomLinePaddingLeft:15] fillAction:^{
//        [UserSingletonCommand chatWithGroup:@"aidingmao"];
//    }],
        
                        [[SettingsTableViewCell buildCellDictWithRightArrowAndSubTitle:@"拨打客服电话" icon:@"mine_icon_contact" subTitle:@"(工作日9:00-20:00)"] fillAction:^{
        [UIActionSheet showInView:weakSelf.view
                        withTitle:nil
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:[NSArray arrayWithObjects:kCustomServicePhoneDisplay, nil]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:CallCustomerRegionCode referPageCode:NoReferPageCode andData:nil];
                                 NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                             }
                         }];
    }],
                        [SepTableViewCell buildCellDict],
                        [[MineTableViewCell buildCellDict:@"意见反馈" icon:@"mine_icon_feedback" bottomLinePaddingLeft:15] fillAction:^{
        [MobClick event:@"click_manage_feedback"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFeedbackViewCode referPageCode:MineFeedbackViewCode andData:nil];
        FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
        
    }],
                        [[MineTableViewCell buildCellDict:@"帮助中心" icon:@"mine_help" bottomLinePaddingLeft:15] fillAction:^{
        [MobClick event:@"click_manage_help_center"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineWebViewCode referPageCode:MineWebViewCode andData:nil];
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.title = @"帮助中心";
        viewController.url = @"http://activity.aidingmao.com/share/page/351";
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        
                        //                        [[MineTableViewCell buildCellDict:@"扫一扫"] fillAction:^{
                        //        [MobClick event:@"click_manage_qr_scan"];
                        //        QrCodeScanViewController *viewController = [[QrCodeScanViewController alloc] init];
                        //        viewController.delegate = weakSelf;
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //
                        //    }],
                        //图标
                        [[SetTableViewCell buildCellDict:@"设置" icon:@"mine_setting" bottomLinePaddingLeft:15] fillAction:^{
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineSettingViewCode referPageCode:MineSettingViewCode andData:nil];
        SettingsViewController *viewController = [[SettingsViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }],
                        
                        [SepTableViewCell buildCellDict],
                        nil];
    
//    CGFloat topBarHeight = [self topBarHeight];
//    [super setupTopBarTitle:@"我的"];
//    [super setupTopBarBackButton:[UIImage imageNamed:@"mine_help"] imgPressed:nil];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"mine_setting"] imgPressed:nil];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor colorWithHexString:@"dcdddd"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-10-32, kTopBarContentMarginTop+(kTopBarHeight-kTopBarContentMarginTop-32)/2, 32, 32)];
//    rightBtn.layer.cornerRadius = 16.f;
//    rightBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
//    [rightBtn addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setImage:[UIImage imageNamed:@"setting_normal"] forState:UIControlStateNormal];
//    [self.view addSubview:rightBtn];
//    
//    TapDetectingView *backBgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(self.view.width-62, rightBtn.top-(62-rightBtn.height)/2, 62, 62)];
//    backBgView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:backBgView];
//    backBgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//        [weakSelf handleTopBarRightButtonClicked:nil];
//    };
    
    MineHeaderView *headerView = [[MineHeaderView alloc] initWithFrame:CGRectZero];
    headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [MineHeaderView heightForOrientationPortrait]);
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    
    headerView.handleSingleTapDetected = ^(MineHeaderView *view) {
        [[CoordinatingController sharedInstance] gotoUserHomeViewController:[Session sharedInstance].currentUserId
                                                                   animated:YES];
        //        EditProfileViewController *viewController = [[EditProfileViewController alloc] init];
        //        viewController.delegate = weakSelf;
        //        [weakSelf pushViewController:viewController animated:YES];
    };
    
    [super bringTopBarToTop];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    self.view = nil;
    //    self.dataSources = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
            self.dataSources = nil;
        }
    }
}

//- (void)handleTopBarBackButtonClicked:(UIButton *)sender
//{mine_help
//    WEAKSELF;
//    [MobClick event:@"click_manage_help_center"];
//    WebViewController *viewController = [[WebViewController alloc] init];
//    viewController.title = @"帮助中心";
//    viewController.url = @"http://activity.aidingmao.com/share/page/351";
//    [weakSelf pushViewController:viewController animated:YES];
//}

- (void)editProfileGalleryChanged:(EditProfileViewController*)viewController gallery:(NSArray*)gallary
{
    WEAKSELF;
    NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
    for (PictureItem *item in gallary) {
        if ([item isKindOfClass:[PictureItem class]]) {
            if (item.picId == kPictureItemLocalPicId) {
                [uploadFiles addObject:item.picUrl];
            }
        }
    }
    
    if ([uploadFiles count]>0) {
        [weakSelf showProcessingHUD:nil];
        [[NetworkAPI sharedInstance] updaloadPics:uploadFiles completion:^(NSArray *picUrlArray) {
            NSInteger index = 0;
            for (PictureItem *tempItem in gallary) {
                if (tempItem.picId == kPictureItemLocalPicId) {
                    tempItem.picId = 0;
                    if (index<[picUrlArray count]) {
                        tempItem.picUrl = [picUrlArray objectAtIndex:index];
                    }
                    index+=1;
                }
            }
            [weakSelf upddateGallery:gallary];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [self upddateGallery:gallary];
    }
}

- (void)upddateGallery:(NSArray*)gallary
{
    WEAKSELF;
    [[NetworkAPI sharedInstance] setGallery:gallary completion:^{
        [weakSelf hideHUD];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

//- (void)handleTopBarRightButtonClicked:(UIButton*)sender {
//    SettingsViewController *viewController = [[SettingsViewController alloc] init];
//    [super pushViewController:viewController animated:YES];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
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
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    [dict doAction];
}

- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    [self.headerView updateHeaderView];
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self.headerView updateHeaderView];
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    [self.headerView updateHeaderView];
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    
}

- (void)$$handleConsignDidFinishNotification:(id<MBNotification>)notifi ordersNum:(NSInteger)ordersNum
{
    
}

- (void)$$handleUserInfoChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    [self.headerView updateHeaderView];
}

- (void)$$handleUserProfileChangedNotification:(id<MBNotification>)notifi
{
    [self.headerView updateHeaderView];
}

- (void)$$handleAvatarChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    [self.headerView updateHeaderView];
}

- (void)$$handleUserNameChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    [self.headerView updateHeaderView];
}

- (void)processScanResults:(QrCodeScanViewController*)viewController url:(NSString*)url
{
    [viewController dismiss:NO];
    [URLScheme locateWithRedirectUri:url andIsShare:NO];
}

- (void)processScanResults:(QrCodeScanViewController*)viewController data:(NSString*)data
{
    
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi addedItem:(ShoppingCartItem*)item
{
    [self handleShoppingCartGoodsNumChanged];
}
- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi removedGoodsIds:(NSArray*)goodsIds
{
    [self handleShoppingCartGoodsNumChanged];
}
- (void)$$handleShoppingCartSyncFinishedNotification:(id<MBNotification>)notifi
{
    [self handleShoppingCartGoodsNumChanged];
}
- (void)handleShoppingCartGoodsNumChanged
{
    [self.headerView updateHeaderView];
}

@end


@interface UserStatTextButton ()
@property(nonatomic,retain) UILabel *topLbl;
@property(nonatomic,retain) UILabel *bottomLbl;
@property(nonatomic,assign) CGFloat sepHeight;
@end

@implementation UserStatTextButton

- (id)initWithFrame:(CGRect)frame topText:(NSString*)topText bottomText:(NSString*)bottomText sepHeight:(CGFloat)sepHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.topLbl.font = [UIFont systemFontOfSize:13.f];
        self.topLbl.textColor = [UIColor whiteColor];
        self.topLbl.text = topText;
        self.topLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topLbl];
        
        self.bottomLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.bottomLbl.font = [UIFont systemFontOfSize:13.5f];
        self.bottomLbl.textColor = [UIColor colorWithHexString:@"FFE8B0"];
        self.bottomLbl.text = bottomText;
        self.bottomLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.bottomLbl];
        
        self.sepHeight = sepHeight;
        
    }
    return self;
    
}

- (void)setTopText:(NSString*)topText
{
    self.topLbl.text = topText;
    [self layoutSubviews];
}

- (void)setBottomText:(NSString*)bottomText
{
    self.bottomLbl.text = bottomText;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.topLbl sizeToFit];
    self.topLbl.frame = CGRectMake(0, self.bounds.size.height/2-self.topLbl.bounds.size.height-(self.sepHeight/2), self.bounds.size.width, self.topLbl.bounds.size.height);
    
    [self.bottomLbl sizeToFit];
    self.bottomLbl.frame = CGRectMake(0, self.bounds.size.height/2+(self.sepHeight/2), self.bounds.size.width, self.bottomLbl.bounds.size.height);
}

- (void)dealloc
{
    self.topLbl = nil;
    self.bottomLbl = nil;
}
@end


@interface MineHeaderView ()

@property(nonatomic,retain) UIView *topView;
@property(nonatomic,retain) UIView *bottomView;

@property(nonatomic,retain) XMWebImageView *frontView;

@property(nonatomic,retain) UIView *avatarBgView;
@property(nonatomic,retain) XMWebImageView *avatarView;
@property(nonatomic,retain) UILabel *nickNameLbl;

@property(nonatomic,strong) TapDetectingLabel *followingsBtn;
@property(nonatomic,strong) TapDetectingLabel *followersBtn;
@property(nonatomic,strong) UILabel *soldNumLbl;

@property(nonatomic,strong) UIView *line;

@property(nonatomic,retain) VerticalCommandButton *shoppingCartBtn;
@property(nonatomic,retain) VerticalCommandButton *walletBtn;
@property(nonatomic,retain) VerticalCommandButton *quanBtn;;
@property(nonatomic,retain) VerticalCommandButton *likedBtn;

@property (nonatomic, strong) VisualEffectView *visualEffectView;
@end

@implementation MineHeaderView

+ (CGFloat)heightForOrientationPortrait {
    return 240.f;//kScreenWidth*240.f/320.f;
}

- (void)dealloc
{
    //    self.topView = nil;
    //    self.bottomView = nil;
    //
    //    self.avatarView = nil;
    //    self.nickNameLbl = nil;
    //    self.statLbl = nil;
    //    self.arrowView = nil;
    //
    //    self.goodsBtn = nil;
    //    self.likedBtn = nil;
    //    self.followingsBtn = nil;
    //    self.followersBtn = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        
        WEAKSELF;
        
        //        self.topView = [[UIView alloc] initWithFrame:CGRectNull];
        //        self.topView.backgroundColor = [UIColor whiteColor];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        //        [self.topView addGestureRecognizer:tap];
        //        [self addSubview:self.topView];
        //
        //        self.bottomView = [[UIView alloc] initWithFrame:CGRectNull];
        //        [self addSubview:self.bottomView];
        //        self.bottomView.backgroundColor = [UIColor colorWithHexString:@"282828"];
        //
        
        self.frontView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        self.frontView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.frontView];
        
        if (SYSTEMCURRENTV < 8.0) {
            self.frontView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
                [weakSelf handleTap:nil];
            };
        } else {
            VisualEffectView *visualEffectView = [[VisualEffectView alloc] initWithFrame:self.frontView.bounds style:MFBlurEffectStyleLight];
            visualEffectView.alpleValue = 0.98;
            [self addSubview:visualEffectView];
            self.visualEffectView = visualEffectView;
            
            visualEffectView.touchView = ^(){
                [weakSelf handleTap:nil];
            };
        }
        
        _avatarBgView = [[UIView alloc] initWithFrame:CGRectZero];
        self.avatarBgView.userInteractionEnabled = YES;
        self.avatarBgView.layer.masksToBounds=YES;
        self.avatarBgView.layer.cornerRadius=33;    //最重要的是这个地方要设成imgview高的一半
        self.avatarBgView.backgroundColor = [UIColor whiteColor];
        self.avatarBgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarBgView.clipsToBounds = YES;
        [self addSubview:self.avatarBgView];
        
        
        self.avatarView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        self.avatarView.userInteractionEnabled = YES;
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.cornerRadius=30;    //最重要的是这个地方要设成imgview高的一半
        self.avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarView.clipsToBounds = YES;
        [self addSubview:self.avatarView];
        
        
        
        self.nickNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.nickNameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        self.nickNameLbl.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:self.nickNameLbl];
        
        
        _followingsBtn = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        _followingsBtn.textColor = [UIColor colorWithHexString:@"898989"];
        _followingsBtn.font = [UIFont systemFontOfSize:11.f];
        [self addSubview:_followingsBtn];
        
        _followersBtn = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        _followersBtn.textColor = [UIColor colorWithHexString:@"898989"];
        _followersBtn.font = [UIFont systemFontOfSize:11.f];
        [self addSubview:_followersBtn];
        
        _soldNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _soldNumLbl.textColor = [UIColor colorWithHexString:@"898989"];
        _soldNumLbl.font = [UIFont systemFontOfSize:11.f];
        [self addSubview:_soldNumLbl];
        
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [self addSubview:_line];
        
        _shoppingCartBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _shoppingCartBtn.contentAlignmentCenter = YES;
        _shoppingCartBtn.imageTextSepHeight = 6;
        [_shoppingCartBtn setImage:[UIImage imageNamed:@"mine_shoppingcart"] forState:UIControlStateNormal];
        [_shoppingCartBtn setTitle:@" 购物车" forState:UIControlStateNormal];
        [_shoppingCartBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
        _shoppingCartBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_shoppingCartBtn];
        
        _walletBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _walletBtn.contentAlignmentCenter = YES;
        _walletBtn.imageTextSepHeight = 6;
        [_walletBtn setImage:[UIImage imageNamed:@"mine_wallet"] forState:UIControlStateNormal];
        [_walletBtn setTitle:@" 钱包" forState:UIControlStateNormal];
        [_walletBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
        _walletBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_walletBtn];
        
        _quanBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _quanBtn.contentAlignmentCenter = YES;
        _quanBtn.imageTextSepHeight = 6;
        [_quanBtn setImage:[UIImage imageNamed:@"mine_quan"] forState:UIControlStateNormal];
        [_quanBtn setTitle:@" 优惠券" forState:UIControlStateNormal];
        [_quanBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
        _quanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_quanBtn];
        
        _likedBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _likedBtn.contentAlignmentCenter = YES;
        _likedBtn.imageTextSepHeight = 6;
        [_likedBtn setImage:[UIImage imageNamed:@"mine_likes"] forState:UIControlStateNormal];
        [_likedBtn setTitle:@" 想要" forState:UIControlStateNormal];
        [_likedBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
        _likedBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_likedBtn];
        
        
        _shoppingCartBtn.handleClickBlock = ^(CommandButton *sender) {
            
            //            [MobClick event:@"click_goods_from_mine"];
            //            [[CoordinatingController sharedInstance] gotoUserHomeViewController:[Session sharedInstance].currentUserId
            //                                                                       animated:YES];
            [MobClick event:@"click_shopping_chart_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:HomeShopCarRegionCode referPageCode:HomeShopCarRegionCode andData:nil];
            ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        _walletBtn.handleClickBlock = ^(CommandButton *sender) {
            
            [MobClick event:@"click_my_wallet_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MinePurseViewCode referPageCode:MinePurseViewCode andData:nil];
            WalletTwoViewController *wallerController = [[WalletTwoViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:wallerController animated:YES];
            
//            WalletViewController *viewController = [[WalletViewController alloc] init];
//            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        _quanBtn.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineDiscountCouponViewCode referPageCode:MineDiscountCouponViewCode andData:nil];
            [MobClick event:@"click_coupon_from_mine"];
            BonusListViewController *viewController = [[BonusListViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        _likedBtn.handleClickBlock = ^(CommandButton *sender) {
            [MobClick event:@"click_favor_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineLikeViewCode referPageCode:MineLikeViewCode andData:nil];
            [[CoordinatingController sharedInstance] gotoUserLikesViewController:[Session sharedInstance].currentUserId
                                                                        animated:YES];
        };
        
        
        //
        //        self.statLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        //        self.statLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        //        self.statLbl.font = [UIFont systemFontOfSize:12.f];
        //        [self addSubview:self.statLbl];
        //
        //        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow_gray"]];
        //        [self addSubview:self.arrowView];
        //
        //        self.goodsBtn = [[UserStatTextButton alloc] initWithFrame:CGRectNull topText:@"" bottomText:@"" sepHeight:8.f];
        //        [self addSubview:self.goodsBtn];
        //
        //        self.likedBtn = [[UserStatTextButton alloc] initWithFrame:CGRectNull topText:@"" bottomText:@"" sepHeight:8.f];
        //        [self addSubview:self.likedBtn];
        //
        //        self.followingsBtn = [[UserStatTextButton alloc] initWithFrame:CGRectNull topText:@"" bottomText:@"" sepHeight:8.f];
        //        [self addSubview:self.followingsBtn];
        //
        //        self.followersBtn = [[UserStatTextButton alloc] initWithFrame:CGRectNull topText:@"" bottomText:@"" sepHeight:8.f];
        //        [self addSubview:self.followersBtn];
        //
        //        WEAKSELF;
        _avatarView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [MobClick event:@"click_goods_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:HomeChosenUserHomeRegionCode referPageCode:UserHomeReferPageCode andData:nil];
            [[CoordinatingController sharedInstance] gotoUserHomeViewController:[Session sharedInstance].currentUserId
                                                                       animated:YES];
            
            // 1.封装图片数据
            //            User *user = [Session sharedInstance].currentUser;
            //            if ([user.avatarUrl length]>0) {
            //
            //                MJPhoto *photo = [[MJPhoto alloc] init];
            //                NSString *url = [XMWebImageView imageUrlToQNImageUrl:user.avatarUrl
            //                                                              isWebP:NO
            //                                                           scaleType:XMWebImageScale400x400];
            //                photo.url = [NSURL URLWithString:url]; // 图片路径
            //                photo.srcImageView = weakSelf.avatarView; // 来源于哪个UIImageView
            //
            //                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
            //                [photos addObject:photo];
            //
            //                // 2.显示相册
            //                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            //                browser.photos = photos; // 设置所有的图片
            //                [browser show];
            //            }
        };
        //
        //        _goodsBtn.handleClickBlock = ^(CommandButton *sender) {
        //
        ////            [MobClick event:@"click_goods_from_mine"];
        ////            [[CoordinatingController sharedInstance] gotoUserHomeViewController:[Session sharedInstance].currentUserId
        ////                                                                       animated:YES];
        //
        //            [MobClick event:@"click_shopping_chart_from_mine"];
        //            ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
        //            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        //        };
        //        _likedBtn.handleClickBlock = ^(CommandButton *sender) {
        //            [MobClick event:@"click_favor_from_mine"];
        //            [[CoordinatingController sharedInstance] gotoUserLikesViewController:[Session sharedInstance].currentUserId
        //                                                                        animated:YES];
        //        };
        _followingsBtn.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_follow_list_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineAttentionViewCode referPageCode:MineAttentionViewCode andData:nil];
            [[CoordinatingController sharedInstance] gotoFollowingsViewController:[Session sharedInstance].currentUserId
                                                                         animated:YES];
        };
        _followersBtn.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_fans_list_from_mine"];
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFansViewCode referPageCode:MineFansViewCode andData:nil];
            [[CoordinatingController sharedInstance] gotoFollowersViewController:[Session sharedInstance].currentUserId
                                                                        animated:YES];
        };
        //
        [self updateHeaderView];
    }
    return self;
}

- (void)updateHeaderView {
    User *user = [Session sharedInstance].currentUser;
    
    [_frontView setImageWithURL:user.frontUrl placeholderImage:[UIImage imageNamed:@"mine_front_default"] size:CGSizeMake(kScreenWidth*2,kScreenWidth*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
    [_avatarView setImageWithURL:user.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"] XMWebImageScaleType:XMWebImageScale160x160];
    
    [_shoppingCartBtn setTitle:[NSString stringWithFormat:@" 购物车(%ld)", (long)[Session sharedInstance].shoppingCartNum] forState:UIControlStateNormal];
    [_likedBtn setTitle:[NSString stringWithFormat:@" 想要(%ld)", (long)user.likesNum] forState:UIControlStateNormal];
    
    
    
    self.followingsBtn.text = [NSString stringWithFormat:@"关注 %ld ", (long)user.followingsNum];
    self.followersBtn.text = [NSString stringWithFormat:@" 粉丝 %ld ", (long)user.fansNum];
    self.soldNumLbl.text = [NSString stringWithFormat:@" 已售 %ld ", (long)user.soldNum];
    
    self.nickNameLbl.text = user.userName;
    
    ////    self.statLbl.text = [NSString stringWithFormat:@"已售 %ld", (long)user.soldNum];
    //
    //    if (user.score==48) {
    //        self.statLbl.text = [NSString stringWithFormat:@"已售 %ld 诚信分 %ld (满分)",(long)user.soldNum,(long)user.score];
    //    } else {
    //        self.statLbl.text = [NSString stringWithFormat:@"已售 %ld 诚信分 %ld",(long)user.soldNum,(long)user.score];
    //    }
    //
    //    [self.goodsBtn setTopText:@"购物车"];
    //    [self.goodsBtn setBottomText:[NSString stringWithFormat:@"%ld", (long)[Session sharedInstance].shoppingCartNum]];
    //    [self.likedBtn setTopText:@"想要"];
    //    [self.likedBtn setBottomText:[NSString stringWithFormat:@"%ld", (long)user.likesNum]];
    //    [self.followingsBtn setTopText:@"关注"];
    //    [self.followingsBtn setBottomText:[NSString stringWithFormat:@"%ld", (long)user.followingsNum]];
    //    [self.followersBtn setTopText:@"粉丝"];
    //    [self.followersBtn setBottomText:[NSString stringWithFormat:@"%ld", (long)user.fansNum]];
    //
    //    [_avatarView setImageWithURL:user.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"] XMWebImageScaleType:XMWebImageScale160x160];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frontView.frame = CGRectMake(0, -(kScreenWidth-110), kScreenWidth, kScreenWidth);
    self.visualEffectView.frame = CGRectMake(0, -(kScreenWidth-110), kScreenWidth, kScreenWidth);
    self.avatarBgView.frame = CGRectMake(15, 110-18, 66, 66);
    self.avatarView.frame = CGRectMake(self.avatarBgView.left+3,self.avatarBgView.top+3, 60, 60);
    
    
    _line.frame = CGRectMake(15, 110+62, kScreenWidth-30, 0.5);
    
    _shoppingCartBtn.frame = CGRectMake(0, self.height-69, kScreenWidth/4, 69);
    _walletBtn.frame = CGRectMake(kScreenWidth/4, self.height-69, kScreenWidth/4, 69);
    _quanBtn.frame = CGRectMake(kScreenWidth/4*2, self.height-69, kScreenWidth/4, 69);
    _likedBtn.frame = CGRectMake(kScreenWidth/4*3, self.height-69, kScreenWidth/4, 69);
    
    [_nickNameLbl sizeToFit];
    _nickNameLbl.frame = CGRectMake(87, 117, kScreenWidth-87-15, _nickNameLbl.height);
    
    [_followingsBtn sizeToFit];
    [_followersBtn sizeToFit];
    [_soldNumLbl sizeToFit];
    _followingsBtn.frame = CGRectMake(_nickNameLbl.left, _nickNameLbl.bottom+5, _followingsBtn.width, _followingsBtn.height);
    _followersBtn.frame = CGRectMake(_followingsBtn.right, _nickNameLbl.bottom+5, _followersBtn.width, _followersBtn.height);
    _soldNumLbl.frame = CGRectMake(_followersBtn.right, _nickNameLbl.bottom+5, _soldNumLbl.width, _soldNumLbl.height);
    
    
    //    CGFloat bottomViewHeight = 70.f;
    //    CGFloat topViewHeight = CGRectGetHeight(self.bounds)-bottomViewHeight;
    //    CGFloat width = CGRectGetWidth(self.bounds);
    //    
    //    self.topView.frame = CGRectMake(0, 0, width, topViewHeight);
    //    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-bottomViewHeight, width, bottomViewHeight);
    //    
    //    self.avatarView.frame = CGRectMake(25, topViewHeight-66-(kScreenWidth*30/320), 66, 66);
    //    self.arrowView.frame = CGRectMake(width-15-CGRectGetWidth(self.arrowView.bounds),self.avatarView.top+(self.avatarView.height-self.arrowView.height)/2, CGRectGetWidth(self.arrowView.bounds), CGRectGetHeight(self.arrowView.bounds));
    //    
    //    CGFloat marginLeft = self.avatarView.frame.origin.x+self.avatarView.frame.size.width;
    //    marginLeft += 20;
    //    
    //    CGFloat marginRight = width-self.arrowView.frame.origin.x+15;
    //    
    //    [self.nickNameLbl sizeToFit];
    //    self.nickNameLbl.frame = CGRectMake(marginLeft, self.avatarView.top+4, width-marginLeft-marginRight, CGRectGetHeight(self.nickNameLbl.bounds));
    //    
    //    [self.statLbl sizeToFit];
    //    self.statLbl.frame = CGRectMake(marginLeft, self.nickNameLbl.frame.origin.y+self.nickNameLbl.frame.size.height+6, width-marginLeft-marginRight, CGRectGetHeight(self.statLbl.bounds));
    //    
    //    
    //    CGFloat btnWidth = CGRectGetWidth(self.bottomView.bounds)/4;
    //    CGFloat btnHeight = CGRectGetHeight(self.bottomView.bounds);
    //    CGFloat btnY = self.bottomView.frame.origin.y;
    //    CGFloat btnX = 0.f;
    //    
    //    self.goodsBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    //    
    //    btnX += btnWidth;
    //    self.likedBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    //    
    //    btnX += btnWidth;
    //    self.followingsBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    //    
    //    btnX += btnWidth;
    //    self.followersBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_handleSingleTapDetected) {
        _handleSingleTapDetected(self);
    }
}

@end


