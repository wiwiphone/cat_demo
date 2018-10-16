//
//  SendSaleViewController.m
//  XianMao
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SendSaleViewController.h"
#import "DataSources.h"
#import "Masonry.h"
#import "VerifyStateTopView.h"
#import "VerifyStateView.h"
#import "SaleStateTopView.h"
#import "SaleStateView.h"
#import "UnfinishedStateTopView.h"
#import "UnfinishedStateView.h"
#import "VerifyViewController.h"
#import "SaleStateViewController.h"
#import "UnfinishViewController.h"
#import "WebViewController.h"
#import "NetworkManager.h"
#import "Session.h"
#import "SendSaleModel.h"

@interface SendSaleViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XMWebImageView *headerIconView;
@property (nonatomic, strong) UIView *segView;
@property (nonatomic, strong) VerifyStateTopView *verifyStateTopView;
@property (nonatomic, strong) VerifyStateView *verifyStateCateView;
@property (nonatomic, strong) UIButton *sendPublishBtn;
@property (nonatomic, strong) UILabel *sendPublishLbl;
@property (nonatomic, strong) UIView *segView1;
@property (nonatomic, strong) SaleStateTopView *saleStateTopView;
@property (nonatomic, strong) SaleStateView *saleStateView;
@property (nonatomic, strong) UnfinishedStateTopView *unfinishTopView;
@property (nonatomic, strong) UnfinishedStateView *unfinishView;
@property (nonatomic, strong) UIView *segView2;

@end

@implementation SendSaleViewController

-(UnfinishedStateView *)unfinishView{
    if (!_unfinishView) {
        _unfinishView = [[UnfinishedStateView alloc] initWithFrame:CGRectZero];
        _unfinishView.backgroundColor = [UIColor whiteColor];
    }
    return _unfinishView;
}

-(UnfinishedStateTopView *)unfinishTopView{
    if (!_unfinishTopView) {
        _unfinishTopView = [[UnfinishedStateTopView alloc] initWithFrame:CGRectZero];
        _unfinishTopView.backgroundColor = [UIColor whiteColor];
    }
    return _unfinishTopView;
}

-(SaleStateView *)saleStateView{
    if (!_saleStateView) {
        _saleStateView = [[SaleStateView alloc] initWithFrame:CGRectZero];
        _saleStateView.backgroundColor = [UIColor whiteColor];
    }
    return _saleStateView;
}

-(SaleStateTopView *)saleStateTopView{
    if (!_saleStateTopView) {
        _saleStateTopView = [[SaleStateTopView alloc] initWithFrame:CGRectZero];
        _saleStateTopView.backgroundColor = [UIColor whiteColor];
    }
    return _saleStateTopView;
}

-(UILabel *)sendPublishLbl{
    if (!_sendPublishLbl) {
        _sendPublishLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _sendPublishLbl.font = [UIFont systemFontOfSize:15.f];
        _sendPublishLbl.textColor = [UIColor whiteColor];
        _sendPublishLbl.text = @"发布寄卖";
        [_sendPublishLbl sizeToFit];
    }
    return _sendPublishLbl;
}

-(UIButton *)sendPublishBtn{
    if (!_sendPublishBtn) {
        _sendPublishBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sendPublishBtn setImage:[UIImage imageNamed:@"sendPublish"] forState:UIControlStateNormal];
        [_sendPublishBtn sizeToFit];
    }
    return _sendPublishBtn;
}

-(VerifyStateView *)verifyStateCateView{
    if (!_verifyStateCateView) {
        _verifyStateCateView = [[VerifyStateView alloc] initWithFrame:CGRectZero];
        _verifyStateCateView.backgroundColor = [UIColor whiteColor];
    }
    return _verifyStateCateView;
}

-(VerifyStateTopView *)verifyStateTopView{
    if (!_verifyStateTopView) {
        _verifyStateTopView = [[VerifyStateTopView alloc] initWithFrame:CGRectZero];
        _verifyStateTopView.backgroundColor = [UIColor whiteColor];
    }
    return _verifyStateTopView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return _scrollView;
}

-(XMWebImageView *)headerIconView{
    if (!_headerIconView) {
        _headerIconView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _headerIconView.userInteractionEnabled = YES;
        _headerIconView.contentMode = UIViewContentModeScaleAspectFill;
        _headerIconView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _headerIconView.clipsToBounds = YES;
        _headerIconView.image = [UIImage imageNamed:@"SendSaleTopView"];
    }
    return _headerIconView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"发布寄卖"];
    WEAKSELF;
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods/consignment" path:@"statistics" parameters:@{@"user_id":@([Session sharedInstance].currentUserId)} completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        
        SendSaleModel *sendModel = [[SendSaleModel alloc] initWithJSONDictionary:data[@"statistics"]];
        
        [weakSelf.view addSubview:self.scrollView];
        [weakSelf.scrollView addSubview:self.headerIconView];
        [weakSelf.headerIconView addSubview:self.sendPublishBtn];
        [weakSelf.sendPublishBtn addSubview:self.sendPublishLbl];
        
        weakSelf.segView = [[UIView alloc] initWithFrame:CGRectZero];
        weakSelf.segView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        [weakSelf.scrollView addSubview:self.segView];
        
        [weakSelf.scrollView addSubview:self.verifyStateTopView];
        [weakSelf.scrollView addSubview:self.verifyStateCateView];
        
        weakSelf.segView1 = [[UIView alloc] initWithFrame:CGRectZero];
        weakSelf.segView1.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        [weakSelf.scrollView addSubview:self.segView1];
        
        [weakSelf.scrollView addSubview:self.saleStateTopView];
        [weakSelf.scrollView addSubview:self.saleStateView];
        [weakSelf.scrollView addSubview:self.unfinishTopView];
        [weakSelf.scrollView addSubview:self.unfinishView];
        
        weakSelf.segView2 = [[UIView alloc] initWithFrame:CGRectZero];
        weakSelf.segView2.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        [weakSelf.scrollView addSubview:self.segView2];
        
        [weakSelf.sendPublishBtn addTarget:self action:@selector(clickSendPublishBtn) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.verifyStateTopView addTarget:self action:@selector(clickVerifyStateTopView) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.saleStateTopView addTarget:self action:@selector(clickSaleStateTopView) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.unfinishTopView addTarget:self action:@selector(clickUnfinishTopView) forControlEvents:UIControlEventTouchUpInside];
        
        [weakSelf.verifyStateCateView getSendModel:sendModel];
        [weakSelf.saleStateView getSendModel:sendModel];
        [weakSelf.unfinishView getSendModel:sendModel];
        
        [weakSelf setUpUI];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)clickSendPublishBtn{
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.url = SENDPUBLISH;
    [self pushViewController:viewController animated:YES];
}

-(void)clickVerifyStateTopView{
    VerifyViewController *verifyController = [[VerifyViewController alloc] init];
    [self pushViewController:verifyController animated:YES];
}

-(void)clickSaleStateTopView{
    SaleStateViewController *saleViewController = [[SaleStateViewController alloc] init];
    [self pushViewController:saleViewController animated:YES];
}

-(void)clickUnfinishTopView{
    UnfinishViewController *unfinishController = [[UnfinishViewController alloc] init];
    [self pushViewController:unfinishController animated:YES];
}

-(void)setUpUI{
    
    CGFloat margin = 0;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.headerIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kScreenWidth/320*160));
    }];
    margin += kScreenWidth/320*160;
    
    [self.sendPublishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerIconView.mas_bottom).offset(-20);
        make.right.equalTo(self.headerIconView.mas_right);
    }];
    
    [self.sendPublishLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendPublishBtn.mas_right).offset(-5);
        make.centerY.equalTo(self.sendPublishBtn.mas_centerY);
    }];
    
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerIconView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
    [self.verifyStateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@43);
    }];
    margin += 43;
    
    [self.verifyStateCateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyStateTopView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@70);
    }];
    margin += 70;
    
    [self.segView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyStateCateView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
    [self.saleStateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView1.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@43);
    }];
    margin += 43;
    
    [self.saleStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleStateTopView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@70);
    }];
    margin += 70;
    
    [self.segView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleStateView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@12);
    }];
    margin += 12;
    
    [self.unfinishTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segView2.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@43);
    }];
    margin += 43;
    
    [self.unfinishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unfinishTopView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@70);
    }];
    margin += 70;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, margin+50);
}

@end
