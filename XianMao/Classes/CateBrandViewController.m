//
//  CateBrandViewController.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandViewController.h"
#import "CateBrandTopChooseView.h"
#import "SearchViewController.h"

#import "CateNewView.h"
#import "BrandNewView.h"

#import "NetworkManager.h"
#import "Error.h"

@interface CateBrandViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat topbarHeight;

@property (nonatomic, strong) CateBrandTopChooseView *topChooseView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CateNewView *cateNewView;
@property (nonatomic, strong) BrandNewView *brandNewView;
@end

@implementation CateBrandViewController

-(CateNewView *)cateNewView{
    if (!_cateNewView) {
        _cateNewView = [[CateNewView alloc] initWithFrame:CGRectZero];
    }
    return _cateNewView;
}

-(BrandNewView *)brandNewView{
    if (!_brandNewView) {
        _brandNewView = [[BrandNewView alloc] initWithFrame:CGRectZero];
    }
    return _brandNewView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(CateBrandTopChooseView *)topChooseView{
    if (!_topChooseView) {
        _topChooseView = [[CateBrandTopChooseView alloc] initWithFrame:CGRectZero];
        _topChooseView.backgroundColor = [UIColor colorWithHexString:[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@19", SKIN]]?[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@19", SKIN]]:@"ffffff"];
    }
    return _topChooseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topbarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"search_wjh"] imgPressed:nil];
    
    WEAKSELF
    
    [self.topBar addSubview:self.topChooseView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.cateNewView];
    [self.scrollView addSubview:self.brandNewView];
    
    self.topChooseView.showCateBrandView = ^(NSInteger index){
        if (index == 1) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 2) animated:YES];
        } else if (index == 2) {
            [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth, 2) animated:YES];
        }
    };
    
    [self setUpUI];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    [self.topChooseView getIndex:index+1];
    
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    SearchViewController *viewController = [[SearchViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

-(void)setUpUI{
    
    [self.topChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_top).offset(20);
        make.bottom.equalTo(self.topBar.mas_bottom);
        make.centerX.equalTo(self.topBar.mas_centerX);
        make.width.equalTo(@150);
    }];
    
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topBar.mas_bottom).offset(1);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    
    self.scrollView.frame = CGRectMake(0, self.topbarHeight+2, kScreenWidth, kScreenHeight-self.topbarHeight-2);
    self.cateNewView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.topbarHeight);
    self.brandNewView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-self.topbarHeight);
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-self.topbarHeight-2);
}

@end
