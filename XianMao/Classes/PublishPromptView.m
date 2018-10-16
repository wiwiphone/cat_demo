//
//  PublishPromptView.m
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishPromptView.h"
#import "NetworkManager.h"
#import "PhotoTipModel.h"
#import "PublishCateView.h"
#import "Error.h"
#import "MBProgressHUD.h"
#import "LoadingView.h"
#import "Command.h"

@interface PublishPromptView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *disBtn;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) PhotoTipModel *photoTipModel;

@property (nonatomic, strong) CommandButton *closeBtn;

@end

@implementation PublishPromptView

-(CommandButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[CommandButton alloc] init];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _closeBtn;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor whiteColor];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIButton *)disBtn{
    if (!_disBtn) {
        _disBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_disBtn setImage:[UIImage imageNamed:@"Publish_Prompt_Dis"] forState:UIControlStateNormal];
        [_disBtn sizeToFit];
    }
    return _disBtn;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.85;
    }
    return _bgView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF;
        [self addSubview:self.bgView];
        [self addSubview:self.scrollView];
        [self addSubview:self.disBtn];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.disBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(42);
            make.right.equalTo(self.mas_right).offset(-30);
        }];
        
        [self.disBtn addTarget:self action:@selector(clickDisBtn) forControlEvents:UIControlEventTouchUpInside];

        [self showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_photo_tip" parameters:nil completionBlock:^(NSDictionary *data) {
            [weakSelf hideLoadingView];
            
            PhotoTipModel *photoTipModel = [[PhotoTipModel alloc] initWithJSONDictionary:data[@"get_photo_tip"]];
            
            weakSelf.photoTipModel = photoTipModel;

            [weakSelf.scrollView addSubview:self.titleLbl];
            
            weakSelf.closeBtn.hidden = YES;
            
            [weakSelf setUpUI];
            [weakSelf setData];
        } failure:^(XMError *error) {
            [weakSelf hideLoadingView];
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
        
        [self addSubview:self.closeBtn];
        [self bringSubviewToFront:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(24);
            make.right.equalTo(self.mas_right).offset(-12);
            make.width.equalTo(@30);
            make.height.equalTo(@15);
        }];
        self.closeBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf removeFromSuperview];
        };
    }
    return self;
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

-(void)clickDisBtn{
    if (self.disPublishPrompt) {
        self.disPublishPrompt();
    }
}

-(void)setData{
    
    self.titleLbl.text = self.photoTipModel.title;
    
}

-(void)setUpUI{
    CGFloat margin = 0;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.disBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(42);
        make.right.equalTo(self.mas_right).offset(-30);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(44);
        make.left.equalTo(self.scrollView.mas_left).offset(20);
    }];
    margin += 44;
    margin += self.titleLbl.height;
    margin += 40;
    
    for (int i = 0; i < self.photoTipModel.categoryPhotoTipList.count; i++) {
        PublishCateView *cateView = [[PublishCateView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, 500)];
        cateView.backgroundColor = [UIColor clearColor];
        [cateView getModel:self.photoTipModel.categoryPhotoTipList[i]];
        [self.scrollView addSubview:cateView];
        margin += cateView.height;
        margin += 40;
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, margin);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
