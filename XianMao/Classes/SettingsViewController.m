//
//  SettingsViewController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SettingsViewController.h"
#import "NSDictionary+Additions.h"
#import "Command.h"

#import "AboutViewController.h"

#import "Session.h"
#import "NetworkAPI.h"
#import "DeviceUtil.h"
#import "EMSession.h"
#import "KLSwitch.h"
#import "Version.h"
#import "ClientVersionService.h"
#import "MyNavigationController.h"
#import "AboutTableViewCell.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "UIActionSheet+Blocks.h"

#import "MineTableViewCell.h"
#import "UserAddressViewController.h"
#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import "SettingAdviserTableViewCell.h"


@interface SettingsViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSources;
@property(nonatomic,strong) HTTPRequest *request;
@end


@implementation SettingsViewController

- (void)dealloc
{
    self.tableView = nil;
    self.dataSources = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    
    self.view.clipsToBounds = YES;
    
    WEAKSELF;
    self.dataSources = [NSArray arrayWithObjects:
                        
                        //                        [[SettingsTableViewCell buildCellDictWithRightArrowAndSubTitle:@"联系客服" subTitle:@"(工作日9:00-20:00)"] fillAction:^{
                        //                            [UIActionSheet showInView:weakSelf.view
                        //                                            withTitle:nil
                        //                                    cancelButtonTitle:@"取消"
                        //                               destructiveButtonTitle:nil
                        //                                    otherButtonTitles:[NSArray arrayWithObjects:kCustomServicePhoneDisplay, nil]
                        //                                             tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                        //                                                 if (buttonIndex == 0) {
                        //                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                        //                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                        //                                                 }
                        //                                             }];
                        //        }],
//                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"管理收货地址"] fillAction:^{
//        [MobClick event:@"click_manage_my_address"];
//        [ClientReportObject clientReportObjectWithViewCode:MineSettingViewCode regionCode:ManagePutGoodsAddrViewCode referPageCode:ManagePutGoodsAddrViewCode andData:nil];
//        UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
//        [weakSelf pushViewController:viewController animated:YES];
//        
//    }],
//                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"管理退货地址"] fillAction:^{
//        [MobClick event:@"click_manage_my_address_send"];
//        [ClientReportObject clientReportObjectWithViewCode:MineSettingViewCode regionCode:ManageOutGoodsAddrViewCode referPageCode:ManageOutGoodsAddrViewCode andData:nil];
//        UserAddressViewController *viewController = [[UserAddressViewControllerReturn alloc] init];
//        [weakSelf pushViewController:viewController animated:YES];
//        
//    }],
//                        [[SettingsSegTableViewCell buildCellDict:@""] fillAction:^{
//        
//    }],
                        
                        [[SettingsNotificationTableViewCell buildCellDict:@"接收消息通知"] fillAction:^{
    }],
                        [[SettingAdviserTableViewCell buildCellDict:@"首页顾问浮窗"] fillAction:^{
    }],
                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"分享给好友"] fillAction:^{
        [weakSelf share];
        
    }],
                        
                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"意见反馈"] fillAction:^{
        [MobClick event:@"click_manage_feedback"];
        //需要修改埋点
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFeedbackViewCode referPageCode:MineFeedbackViewCode andData:nil];
        FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
        
    }],
                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"清除缓存"] fillAction:^{
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [weakSelf showHUD:@"清除成功" hideAfterDelay:0.8];
            [ClientReportObject clientReportObjectWithViewCode:MineSettingViewCode regionCode:DeleHuanCunRegionCode referPageCode:NoReferPageCode andData:nil];
        }];
    }],
                        //                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"意见反馈"] fillAction:^{
                        //        FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
                        //        [weakSelf pushViewController:viewController animated:YES];
                        //    }],
                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"关于爱丁猫"] fillAction:^{
        AboutViewController *viewController = [[AboutViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        [[SettingsSegTableViewCell buildCellDict:@""] fillAction:^{
        
    }],
                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"帮助中心"] fillAction:^{
        [MobClick event:@"click_manage_help_center"];
        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineWebViewCode referPageCode:MineWebViewCode andData:nil];
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.title = @"帮助中心";
        viewController.url = @"http://activity.aidingmao.com/share/page/351";
        [weakSelf pushViewController:viewController animated:YES];
    }],
                        [[SettingsTableViewCell buildCellDictWithRightArrow:@"联系客服(工作时间9:00-20:00)"] fillAction:^{
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
                        

                        
                        
//                        [[SettingsLogoutTableViewCell buildCellDict:@"退出登录"] fillAction:^{
//        [weakSelf showProcessingHUD:nil forView:weakSelf.view];
//        weakSelf.request = [[NetworkAPI sharedInstance] logout:^{
//            
//            [[EMSession sharedInstance] logout:^{
//                [weakSelf dismiss];
//            } failure:^(XMError *error) {
//                [weakSelf dismiss];
//            }];
//        } failure:^(XMError *error) {
//            [[EMSession sharedInstance] logout:^{
//                [weakSelf dismiss];
//            } failure:^(XMError *error) {
//                [weakSelf dismiss];
//            }];
//        }];
//        
//    }],
                        nil];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"我的设置"];
    [super setupTopBarBackButton];
    
    //CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight-49)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutBtn setBackgroundColor:[UIColor blackColor]];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
    [self.view insertSubview:logoutBtn aboveSubview:self.tableView];
    
    [super bringTopBarToTop];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)logoutAction:(UIButton *)btn {
    [self showProcessingHUD:nil forView:self.view];
    self.request = [[NetworkAPI sharedInstance] logout:^{
        
//        LoginViewController * login = [[LoginViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
//        [[CoordinatingController sharedInstance] presentViewController:nav animated:YES completion:^{
//            [self hideHUD];
//            [self dismiss];
//        }];
        
        LoginViewController *viewController = [[LoginViewController alloc] init];
        viewController.title = @"登录";
        UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
        [super presentViewController:navController animated:YES completion:^{
            [self hideHUD];
            [self dismiss];
        }];
        [[EMSession sharedInstance] logout:^{
            [self dismiss];
        } failure:^(XMError *error) {
            [self dismiss];
        }];
    } failure:^(XMError *error) {
        [[EMSession sharedInstance] logout:^{
            [self dismiss];
        } failure:^(XMError *error) {
            [self dismiss];
        }];
    }];
}

- (void)share
{
    [[CoordinatingController sharedInstance] shareWithTitle:@"推荐爱丁猫"
                                                      image:[UIImage imageNamed:@"AppIcon_120"]
                                                        url:kAppShareUrl
                                                    content:@"在这里时尚从未闲置..."];
    [CoordinatingController sharedInstance].shareChannel = ^(NSInteger shareData){
        NSDictionary *data = @{@"channel":[NSNumber numberWithInteger:shareData], @"shareUrl":kAppShareUrl};
        
        [ClientReportObject clientReportObjectWithViewCode:MineSettingViewCode regionCode:HomeChosenShareRegionCode referPageCode:NoReferPageCode andData:data];
        
    };

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (void)didBecomeActiveNotification:(NSNotification*)notifi {
    [_tableView reloadData];
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

@end


@interface SettingsTableViewCell ()
@property(nonatomic,retain) UIImageView *iconView;
@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,weak) UILabel *subTitleLbl;
@property(nonatomic,strong) CALayer *bottomLine;
@property(nonatomic,strong) CALayer *rightArrow;

@end

@implementation SettingsTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SettingsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingsTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

+ (NSMutableDictionary*)buildCellDictWithRightArrow:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingsTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:[self cellDictKeyForRightArrow]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDictWithRightArrowAndSubTitle:(NSString*)title icon:(NSString*)icon subTitle:(NSString*)subTitle
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingsTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    if (subTitle)[dict setObject:subTitle forKey:@"subTitle"];
    if (icon)[dict setObject:icon forKey:@"icon"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:[self cellDictKeyForRightArrow]];
    return dict;
}

+ (NSString*)cellDictKeyForRightArrow {
    return @"arrow";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.hidden = YES;
        [self addSubview:_iconView];
        
        // Initialization code
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:_titleLbl];
        
        UILabel *subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLbl = subTitleLbl;
        _subTitleLbl.backgroundColor = [UIColor clearColor];
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _subTitleLbl.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:_subTitleLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)[UIImage imageNamed:@"right_arrow_gray"].CGImage;
        _rightArrow.frame = CGRectMake(0, 0, rightArrow.size.width, rightArrow.size.height);
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _titleLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
    _subTitleLbl.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginLeft = 25;
    if (![_iconView isHidden]) {
        marginLeft = 15;
        _iconView.frame = CGRectMake(marginLeft, (self.height-_iconView.height)/2, _iconView.width, _iconView.height);
        marginLeft += _iconView.width;
        marginLeft += 10;
    }
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(marginLeft, 0, _titleLbl.width, self.contentView.height);
    
    [_subTitleLbl sizeToFit];
    _subTitleLbl.frame = CGRectMake(_titleLbl.right+8, 1, _subTitleLbl.width, self.contentView.height-1);
    
    CGFloat rightArrowX = self.contentView.width-15-_rightArrow.bounds.size.width;
    _rightArrow.frame = CGRectMake(rightArrowX, (self.contentView.height-_rightArrow.bounds.size.height)/2, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width-30, 1);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSString *title = [dict stringValueForKey:@"title"];
    NSString *subTitle = [dict stringValueForKey:@"subTitle"];
    if (title) {
        _titleLbl.text = title;
        
        if ([subTitle length]>0) {
            _subTitleLbl.text = subTitle;
            _subTitleLbl.hidden = NO;
        } else {
            _subTitleLbl.hidden = YES;
        }
        
        NSString *icon = [dict stringValueForKey:@"icon"];
        if ([icon length]>0) {
            _iconView.image = [UIImage imageNamed:icon];
            _iconView.frame = CGRectMake(0, 0, _iconView.image.size.width, _iconView.image.size.height);
            _iconView.hidden = NO;
        } else {
            _iconView.hidden = YES;
        }
        
        _rightArrow.hidden = ![dict boolValueForKey:[[self class] cellDictKeyForRightArrow] defaultValue:NO];
    }
}

@end

@implementation SettingsNotificationTableViewCell {
    UILabel *_statusLbl;
    UILabel *_remindLbl;
    UISwitch *_newsPushSwith;
}
+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SettingsNotificationTableViewCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 45.f;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
//        rowHeight = 61;
        rowHeight = 45.f;
    }
    
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingsNotificationTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _statusLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLbl.backgroundColor = [UIColor clearColor];
        _statusLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
//        _statusLbl.font = [UIFont systemFontOfSize:16.f];
        _statusLbl.font = [UIFont systemFontOfSize:15.f];
        
        _remindLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _remindLbl.backgroundColor = [UIColor clearColor];
        _remindLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _remindLbl.font = [UIFont systemFontOfSize:15.f];
        _remindLbl.numberOfLines = 0;
        _newsPushSwith = [[UISwitch alloc] initWithFrame:CGRectZero];
        _newsPushSwith.on = NO;
        _newsPushSwith.onTintColor = [DataSources colorf9384c];
        
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    NSString *title = [dict stringValueForKey:@"title"];
    self.titleLbl.text = title;
    self.rightArrow.hidden = ![dict boolValueForKey:[[self class] cellDictKeyForRightArrow] defaultValue:NO];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        [_newsPushSwith removeFromSuperview];
        [[self contentView] addSubview:_newsPushSwith];
        
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (notificationSettings.types != UIUserNotificationTypeNone) {
            _newsPushSwith.on = YES;
        }
        [_newsPushSwith addTarget:self action:@selector(didNotificationSettingClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == UIRemoteNotificationTypeNone) {
            _statusLbl.text = @"未开启";
            _remindLbl.text = @"如果你要开启或者开启爱丁猫的新消息通知，请在iPhone “设置” - “通知” 功能中，找到应用程序 “爱丁猫” 更改。";
        } else {
            _statusLbl.text = @"已开启";
            _remindLbl.text = @"如果你要开启或者关闭爱丁猫的新消息通知，请在iPhone “设置” - “通知” 功能中，找到应用程序 “爱丁猫” 更改。";
        }
        [_statusLbl removeFromSuperview];
        [_remindLbl removeFromSuperview];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_remindLbl];
        
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
//    marginTop += 24.f;
        marginTop += 15.f;
    [self.titleLbl sizeToFit];
    self.titleLbl.frame = CGRectMake(25, marginTop, self.titleLbl.width, self.titleLbl.height);
    
    [_statusLbl sizeToFit];
    _statusLbl.frame = CGRectMake(self.contentView.width-19-_statusLbl.width, marginTop, _statusLbl.width, _statusLbl.height);
    
    // _newsPushSwith.frame = CGRectMake(self.contentView.width-60, marginTop-8, 60,30);
    
    marginTop += _statusLbl.height;
    marginTop += 18.f;
    
    _remindLbl.frame = CGRectMake(15, marginTop, self.contentView.width-15-19, 0);
    [_remindLbl sizeToFit];
    _remindLbl.frame = CGRectMake(15, marginTop, self.contentView.width-15-19, _remindLbl.height);
    
    _newsPushSwith.frame = CGRectMake(self.contentView.width - 60, 15.0-8, 60,30);
}

- (void)didNotificationSettingClick
{
    if (&UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

@end

@interface SettingsLogoutTableViewCell ()

@property(nonatomic,strong) CommandButton *logoutBtn;

@property(nonatomic,strong) NSDictionary *dict;

@end

@implementation SettingsLogoutTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingsLogoutTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 100.f;
    return rowHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _logoutBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
        _logoutBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 7.f;
        [self.contentView addSubview:_logoutBtn];
        
        WEAKSELF;
        _logoutBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf.dict doAction];
        };
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _logoutBtn.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _logoutBtn.frame = CGRectMake((self.contentView.width-200)/2, (self.contentView.height-40)/2, 200, 40);
    self.bottomLine.frame = CGRectZero;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSString *title = [dict stringValueForKey:@"title"];
    if (title) {
        [_logoutBtn setTitle:title forState:UIControlStateNormal];
        self.rightArrow.hidden = YES;
        _dict = dict;
    }
}

@end


@implementation SettingsSegTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingsSegTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 12.f;
    return rowHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.bottomLine.frame = CGRectZero;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSString *title = [dict stringValueForKey:@"title"];
    if (title) {
        self.rightArrow.hidden = YES;
        _dict = dict;
    }
}

@end



