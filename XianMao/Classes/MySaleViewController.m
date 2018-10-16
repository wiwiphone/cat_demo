//
//  MySaleViewController.m
//  XianMao
//
//  Created by simon cai on 13/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "MyNavigationController.h"
#import "MySaleViewController.h"
#import "OnSaleViewController.h"
#import "SoldViewController.h"
#import "Command.h"
#import "UIImage+Color1.h"

@interface MySaleTabButton : CommandButton
@end
@implementation MySaleTabButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self isSelected])
    [super touchesBegan:touches withEvent:event];
}
@end

@interface MySaleViewController ()
@property(nonatomic,strong) UIView *tabBar;
@property(nonatomic,strong) NSArray *viewControllers;
@property(nonatomic,strong) UIView *transitionView;
@end

@implementation MySaleViewController

- (void)dealloc
{
    
}

- (id)init {
    self = [super init];
    if (self) {
        _selectAtIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"我卖出的"];
    [super setupTopBarBackButton];
    
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Recover_Search_MF"] imgPressed:nil];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    
    CGFloat marginTop = topBarHeight;
    marginTop += 10;
    
    CGRect frame = self.tabBar.frame;
    frame.origin.y = marginTop;
    self.tabBar.frame = frame;
    [self.view addSubview:self.tabBar];
    
    marginTop += self.tabBar.height;
    marginTop += 10.f;
    
    _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, self.view.width, self.view.height-marginTop)];
    [self.view addSubview:_transitionView];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [[PublishedViewController alloc] init],
                            [[OnSaleViewController alloc] init],
                            [[SoldViewController alloc] init], nil];
    
    
    CommandButton *btn = (CommandButton*)[self.tabBar viewWithTag:(_selectAtIndex+1)*10];
    btn.selected = YES;
    [self displayBAtIndex:_selectAtIndex];
    
    [self bringTopBarToTop];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    SearchMyGoodsViewController *viewController = [[SearchMyGoodsViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)tabBar {
    if (!_tabBar) {
        _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 30)];
        CGFloat width = (kScreenWidth-30)/3;
        CGFloat height = _tabBar.height;
        CGFloat marginLeft = 15.f;
        
        
        UIImage *leftBg = [UIImage imageNamed:@"trade_tab_left"];
        UIImage *leftBgSelected = [UIImage imageNamed:@"trade_tab_left_on"];
        CommandButton *btnLeft = [[MySaleTabButton alloc] initWithFrame:CGRectMake(marginLeft, 0, width, height)];
        [btnLeft setBackgroundImage:[leftBg stretchableImageWithLeftCapWidth:leftBg.size.width/2 topCapHeight:leftBg.size.height/2] forState:UIControlStateNormal];
        [btnLeft setBackgroundImage:[leftBgSelected stretchableImageWithLeftCapWidth:leftBgSelected.size.width/2 topCapHeight:leftBgSelected.size.height/2] forState:UIControlStateSelected];
        [btnLeft setTitle:@"审核拒绝" forState:UIControlStateNormal];
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnLeft setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
        btnLeft.titleLabel.font = [UIFont systemFontOfSize:13.f];
        btnLeft.backgroundColor = [UIColor clearColor];
        btnLeft.tag = 10;
        [_tabBar addSubview:btnLeft];
        
        marginLeft += btnLeft.width;
        
        UIImage *middleBg = [UIImage imageWithColor:[UIColor colorWithHexString:@"282828"]];
        CommandButton *btnMiddle = [[MySaleTabButton alloc] initWithFrame:CGRectMake(marginLeft, 0, width, height)];
        [btnMiddle setTitle:@"售卖中" forState:UIControlStateNormal];
        [btnMiddle setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnMiddle setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
        btnMiddle.titleLabel.font = [UIFont systemFontOfSize:13.f];
        btnMiddle.backgroundColor = [UIColor whiteColor];
        [btnMiddle setBackgroundImage:[middleBg stretchableImageWithLeftCapWidth:middleBg.size.width/2
                                                                    topCapHeight:middleBg.size.height/2] forState:UIControlStateSelected];
        btnMiddle.layer.masksToBounds = YES;
        btnMiddle.layer.borderWidth = 0.5f;
        btnMiddle.layer.borderColor = [UIColor colorWithHexString:@"282828"].CGColor;
        btnMiddle.tag = 20;
        [_tabBar addSubview:btnMiddle];
        
        marginLeft += btnMiddle.width;
        
        UIImage *rightBg = [UIImage imageNamed:@"trade_tab_right"];
        UIImage *rightBgSelected = [UIImage imageNamed:@"trade_tab_right_on"];
        CommandButton *btnRight = [[MySaleTabButton alloc] initWithFrame:CGRectMake(marginLeft, 0, width, height)];
        [btnRight setBackgroundImage:[rightBg stretchableImageWithLeftCapWidth:rightBg.size.width/2 topCapHeight:rightBg.size.height/2] forState:UIControlStateNormal];
        [btnRight setBackgroundImage:[rightBgSelected stretchableImageWithLeftCapWidth:rightBgSelected.size.width/2 topCapHeight:rightBgSelected.size.height/2] forState:UIControlStateSelected];
        [btnRight setTitle:@"已售订单" forState:UIControlStateNormal];
        [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnRight setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
        btnRight.titleLabel.font = [UIFont systemFontOfSize:13.f];
        btnRight.backgroundColor = [UIColor clearColor];
        btnRight.tag = 30;
        [_tabBar addSubview:btnRight];
        
        WEAKSELF;
        btnLeft.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf handleTabBarClicked:sender];
        };
        btnMiddle.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf handleTabBarClicked:sender];
        };
        btnRight.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf handleTabBarClicked:sender];
        };
    }
    return _tabBar;
}

- (void)handleTabBarClicked:(CommandButton*)sender
{
    if (![sender isSelected]) {
        sender.selected = YES;
        
        for (CommandButton*btn in [self.tabBar subviews]) {
            if (btn != sender) {
                btn.selected = NO;
            }
        }
    }
    [self displayBAtIndex:sender.tag/10-1];
}

- (void)displayBAtIndex:(NSInteger)index
{
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    targetViewController.view.hidden = NO;
    targetViewController.view.frame = _transitionView.bounds;//
    
//    [targetViewController willMoveToParentViewController:self];
//    targetViewController.view.frame = CGRectMake(0, marginTop, kScreenWidth, self.view.height-marginTop);
//    [self.view addSubview:targetViewController.view];
//    [targetViewController didMoveToParentViewController:targetViewController];
    
    NSArray *subviews = [self.transitionView subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }

    if ([targetViewController.view isDescendantOfView:self.view])
    {
        [self.transitionView bringSubviewToFront:targetViewController.view];
    }
    else
    {
        targetViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.transitionView addSubview:targetViewController.view];
    }
}

@end
