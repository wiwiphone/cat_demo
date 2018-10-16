//
//  MessageViewController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MessageViewController.h"

#import "MyNavigationController.h"
#import "ConversationViewController.h"
#import "NoticeViewController.h"
#import "DataSources.h"
#import "Command.h"
#import "Session.h"
#import "MsgCountManager.h"
#import "NewMessageViewController.h"
#import "ShoppingCartViewController.h"
@interface MessageViewController () <MsgCountChangedReceiver>

@property(nonatomic,strong) NSArray *viewControllers;
@property(nonatomic,weak) MessageTabBar *tabBar;
@property(nonatomic,weak) UIView *transitionView;
@property(nonatomic,assign) NSInteger curSelectAtIndex;

@property (nonatomic, strong) UIButton *goodsNumLbl;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MessageViewController

- (id)init {
    self = [super init];
    if (self) {
        self.curSelectAtIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[MsgCountManager sharedInstance] syncMsgCount];
    
    [super setupTopBar];
    
    _viewControllers = [NSArray arrayWithObjects:
                        [[MyNavigationController alloc] initWithRootViewController:[[ConversationViewController alloc] init]],
                        [[MyNavigationController alloc] initWithRootViewController:[[NewMessageViewController alloc] init]], nil];
//                        [[MyNavigationController alloc] initWithRootViewController:[[NoticeViewController alloc] init]],nil];

    
    UIView *transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.topBarHeight)];
    _transitionView = transitionView;
    _transitionView.backgroundColor = [UIColor orangeColor];
    _transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_transitionView];
    
    
    NSArray *tabBtnTitles = [NSArray arrayWithObjects:@"聊天",@"通知", nil];
//    MessageTabBar *tabBar = [[MessageTabBar alloc] initWithFrame:CGRectMake(0, kTopBarContentMarginTop, kScreenWidth, self.topBarHeight-kTopBarContentMarginTop)tabBtnTitles:tabBtnTitles];
    MessageTabBar *tabBar = [[MessageTabBar alloc] initWithFrame:CGRectMake(kScreenWidth / 5.f, kTopBarContentMarginTop, kScreenWidth / 5.f * 3, self.topBarHeight-kTopBarContentMarginTop)tabBtnTitles:tabBtnTitles];
    _tabBar = tabBar;
    [self.topBar addSubview:_tabBar];
    
    WEAKSELF;
    _tabBar.didSelectAtIndex = ^(NSInteger index) {
        weakSelf.curSelectAtIndex = index;
        UIViewController *targetViewController = [weakSelf.viewControllers objectAtIndex:index];
        targetViewController.view.hidden = NO;
        targetViewController.view.frame = weakSelf.transitionView.bounds;
        if (index == 0) {
             [MobClick event:@"click_chat_from_message"];
            if (self.currentIndex != index) {
                self.currentIndex = index;
                [ClientReportObject clientReportObjectWithViewCode:MessageRegionCode regionCode:MessageNavChatViewCode referPageCode:MessageNavChatViewCode andData:nil];
            }
        } else if (index == 1) {
            if (self.currentIndex != index) {
                self.currentIndex = index;
                [ClientReportObject clientReportObjectWithViewCode:MessageRegionCode regionCode:MessageNavNotifyTypeViewCode referPageCode:MessageNavNotifyTypeViewCode andData:nil];
            }
            [MobClick event:@"click_notification_from_message"];
        }
        
        NSArray *subviews = [weakSelf.transitionView subviews];
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        
        if ([targetViewController.view isDescendantOfView:weakSelf.transitionView])
        {
            [weakSelf.transitionView bringSubviewToFront:targetViewController.view];
        }
        else
        {
            targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [weakSelf.transitionView addSubview:targetViewController.view];
        }
        
    };
    
    NSLog(@"noticeCount:%ld", [MsgCountManager sharedInstance].noticeCount);
    [_tabBar resetNumOfNotifications:[MsgCountManager sharedInstance].chatMsgCount atIndex:0];
    [_tabBar resetNumOfNotifications:[MsgCountManager sharedInstance].noticeCount atIndex:1];
    
    if ([MsgCountManager sharedInstance].chatMsgCount>0) {
        [_tabBar setTabAtIndex:0 animated:NO];
    } else if ([MsgCountManager sharedInstance].noticeCount>0) {
        [_tabBar setTabAtIndex:1 animated:NO];
    } else {
        [_tabBar setTabAtIndex:self.curSelectAtIndex animated:NO];
    }
    
    [self setupTopBarRightButton:[UIImage imageNamed:@"ShopBag_New_MF"] imgPressed:[UIImage imageNamed:@"ShopBag_New_MF"]];
    
    
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    [self.topBarRightButton addSubview:goodsNumLbl];
    
    
    [self bringTopBarToTop];
}

- (UIButton*)buildGoodsNumLbl
{
//    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(27.5, 6, 14, 13)];
    goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    [goodsNumLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    goodsNumLbl.enabled = NO;
    goodsNumLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    goodsNumLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
    return goodsNumLbl;
}

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    if (goodsNum > 0) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
//            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        }
        
    } else {
        [_goodsNumLbl setTitle:@"" forState:UIControlStateDisabled];
        _goodsNumLbl.hidden = YES;
    }
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    NSLog(@"购物车");
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    if (isLoggedIn) {
        [MobClick event:@"click_shopping_chart_from_recommend"];
        
        if ([self.navigationController.viewControllers count]>1) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
            if ([viewController isKindOfClass:[ShoppingCartViewController class]]) {
                [self dismiss];
                return;
            }
        }
        ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.view = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    
    if ([MsgCountManager sharedInstance].chatMsgCount>0) {
        [_tabBar setTabAtIndex:0 animated:NO];
    } else if ([MsgCountManager sharedInstance].noticeCount>0) {
        [_tabBar setTabAtIndex:1 animated:NO];
    }
}

- (void)$$handleChatMsgCountDidFinishNotification:(id<MBNotification>)notifi chatMsgCount:(NSNumber*)chatMsgCount
{
    [_tabBar resetNumOfNotifications:[MsgCountManager sharedInstance].chatMsgCount atIndex:0];
}

- (void)$$handleNoticeCountDidFinishNotification:(id<MBNotification>)notifi noticeCount:(NSNumber*)noticeCount
{
    [_tabBar resetNumOfNotifications:[MsgCountManager sharedInstance].noticeCount atIndex:1];
}

@end


@interface MessageTabBar ()

@property(nonatomic,strong) UIView *indicatorView;

@end

@implementation MessageTabBar {
    
}

- (void)dealloc
{
    
}
//[Session sharedInstance].shoppingCartNum]
- (id)initWithFrame:(CGRect)frame tabBtnTitles:(NSArray*)tabBtnTitles {
     self = [super initWithFrame:frame];
    if (self) {
        UIFont *btnFont = [UIFont systemFontOfSize:14.f];
        UIColor*btnTextColor = [UIColor colorWithHexString:@"181818"];//[UIColor colorWithHexString:@"C7AF7A"];
        CGFloat btnHeight = self.height;
        CGFloat btnWidth = (self.width)/[tabBtnTitles count];
        CGFloat btnX = 0.f;
        for (NSInteger i=0;i<[tabBtnTitles count];i++) {
            MessageTabBarButton *btn = [[MessageTabBarButton alloc] initWithFrame:CGRectMake(btnX, 0, btnWidth, btnHeight)];
            btn.tag = i;
            btn.titleLabel.font = btnFont;
            [btn setTitleColor:btnTextColor forState:UIControlStateNormal];
            [btn setTitle:[tabBtnTitles objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:btn];
            
            WEAKSELF;
            btn.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf setTabAtIndex:sender.tag animated:YES];
            };
            btnX += btnWidth;
        }
        
        CGFloat indicatorWidth = self.width/[tabBtnTitles count];
        CGFloat indicatorX = 25.f;
        indicatorWidth = indicatorWidth-50.f;
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(indicatorX, self.height-2, indicatorWidth, 2)];
        _indicatorView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)setTabAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSArray *subViews = [self subviews];
    WEAKSELF;
    if (index < [subViews count]-1 && [subViews count]-1>0) {
        CGFloat indicatorWidth = weakSelf.width/([subViews count]-1);
        CGFloat indicatorX = index*indicatorWidth+25.f;
        CGRect endFrame = CGRectMake(indicatorX, weakSelf.indicatorView.top, weakSelf.indicatorView.width, weakSelf.indicatorView.height);
        
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                weakSelf.indicatorView.frame = endFrame;
            } completion:^(BOOL finished) {
                if (weakSelf.didSelectAtIndex) {
                    weakSelf.didSelectAtIndex(index);
                }
            }];
        } else {
            weakSelf.indicatorView.frame = endFrame;
            if (weakSelf.didSelectAtIndex) {
                weakSelf.didSelectAtIndex(index);
            }
        }
    }
}

- (void)resetNumOfNotifications:(NSInteger)n atIndex:(NSInteger)index
{
    NSArray *subViews = [self subviews];
    if (index < [subViews count]) {
        MessageTabBarButton *btn = (MessageTabBarButton*)[subViews objectAtIndex:index];
        if ([btn isKindOfClass:[MessageTabBarButton class]]) {
            [btn resetNumOfNotifications:n];
        }
    }
}

@end


@interface MessageTabBarButton ()
@property(nonatomic,strong) UIButton *notifiCountLbl;
@property(nonatomic,assign) NSInteger notifiCount;
@end

@implementation MessageTabBarButton

- (void)dealloc {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.notifiCountLbl.frame = CGRectMake(self.bounds.size.width/2+20, 6, self.notifiCountLbl.width, self.notifiCountLbl.height);
}

- (void)resetNumOfNotifications:(NSInteger)n
{
    _notifiCount = n;
    [self resetNotifiCountLbl];
}

-(void)addNumOfNotifications:(NSInteger)n
{
    _notifiCount += n;
    [self resetNotifiCountLbl];
}

-(void)removeNumOfNotifications:(NSInteger)n
{
    _notifiCount -= n;
    if (_notifiCount<0) {
        _notifiCount = 0;
    }
    [self resetNotifiCountLbl];
}

- (void)clearNotifications
{
    _notifiCount = 0;
    [self resetNotifiCountLbl];
}

- (void)resetNotifiCountLbl {
    if (_notifiCount > 0)
    {
        self.notifiCountLbl.hidden = NO;
        if (_notifiCount<10) {
            [self.notifiCountLbl setTitle:[NSString stringWithFormat:@"%ld",(long)_notifiCount] forState:UIControlStateDisabled];
            [self.notifiCountLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            self.notifiCountLbl.frame = CGRectMake(0, 0, 17, 16);
            self.notifiCountLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.notifiCountLbl.layer.masksToBounds = YES;
            self.notifiCountLbl.layer.cornerRadius = 8;
        } else if (_notifiCount<99) {
            [self.notifiCountLbl setTitle:[NSString stringWithFormat:@"%ld",(long)_notifiCount] forState:UIControlStateDisabled];
            [self.notifiCountLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            self.notifiCountLbl.frame = CGRectMake(0, 0, 20, 16);
            self.notifiCountLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.notifiCountLbl.layer.masksToBounds = YES;
            self.notifiCountLbl.layer.cornerRadius = 8;
        } else {
            [self.notifiCountLbl setTitle:@"..." forState:UIControlStateDisabled];
            [self.notifiCountLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            self.notifiCountLbl.frame = CGRectMake(0, 0, 17, 16);
            self.notifiCountLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.notifiCountLbl.layer.masksToBounds = YES;
            self.notifiCountLbl.layer.cornerRadius = 8;
        }
        [self setNeedsLayout];
        
    } else {
        self.notifiCountLbl.hidden = YES;
        
    }
}

-(UIButton*)notifiCountLbl
{
    if (!_notifiCountLbl) {
        _notifiCountLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        _notifiCountLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
        _notifiCountLbl.backgroundColor = [UIColor colorWithHexString:@"fb0006"];
        _notifiCountLbl.enabled = NO;
        [_notifiCountLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self addSubview:_notifiCountLbl];
    }
    return _notifiCountLbl;
}

@end



//Conversation *item = [[Conversation alloc] init];
//item.nickName = @"nick name";
//item.message = @"message message message message message";
//
//self.dataSources = [NSMutableArray arrayWithObjects:
//                    [ConversationTableViewCell buildCellDict:item],
//                    [ConversationTableViewCell buildCellDict:item],
//                    [ConversationTableViewCell buildCellDict:item],
//                    nil];
//[self.tableView reloadData];







