//
//  CateScrollView.m
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateScrollView.h"
#import "NetworkManager.h"
#import "Masonry.h"
#import "CateVO.h"
#import "SubContentView.h"
#import "HotCateView.h"
#import "CateHotButton.h"
#import "SearchViewController.h"
#import "DataSources.h"
#import "URLScheme.h"

@interface CateScrollView ()
@property (nonatomic, strong) NSMutableArray *cateArr;
@property (nonatomic, strong) NSMutableArray *recomendArr;
@property (nonatomic, strong) UIView *cateView;
@property (nonatomic, strong) UIView *segView;
@property (nonatomic, strong) SubContentView *subContentView;
@property (nonatomic, strong) HotCateView *hotCateView;
@end

@implementation CateScrollView

-(HotCateView *)hotCateView{
    if (!_hotCateView) {
        _hotCateView = [[HotCateView alloc] initWithFrame:CGRectZero];
        _hotCateView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return _hotCateView;
}

-(SubContentView *)subContentView{
    if (!_subContentView) {
        _subContentView = [[SubContentView alloc] initWithFrame:CGRectZero];
        _subContentView.backgroundColor = [UIColor whiteColor];
    }
    return _subContentView;
}

-(UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return _segView;
}

-(UIView *)cateView{
    if (!_cateView) {
        _cateView = [[UIView alloc] initWithFrame:CGRectZero];
        _cateView.backgroundColor = [UIColor greenColor];
    }
    return _cateView;
}

-(NSMutableArray *)recomendArr{
    if (!_recomendArr) {
        _recomendArr = [[NSMutableArray alloc] init];
    }
    return _recomendArr;
}

-(NSMutableArray *)cateArr{
    if (!_cateArr) {
        _cateArr = [[NSMutableArray alloc] init];
    }
    return _cateArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"search_category_list" parameters:nil completionBlock:^(NSDictionary *data) {
            [self hideLoadingView];
            NSMutableArray *cateArr = data[@"baseCategories"];
            NSMutableArray *recomendArr = data[@"recommendCategories"];
            self.recomendArr = recomendArr;
            self.cateArr = cateArr;
            
            [self addSubview:self.cateView];
            for (int i = 0; i < cateArr.count; i++) {
                CateVO *cate = [[CateVO alloc] initWithJSONDictionary:cateArr[i]];
                
                XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake((i%2)*(kScreenWidth/2), (i/2)*(kScreenWidth/2*0.6), kScreenWidth/2, (kScreenWidth/2*0.6))];
                imageView.userInteractionEnabled = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
                imageView.clipsToBounds = YES;
                [imageView setImageWithURL:cate.categoryBackImage XMWebImageScaleType:XMWebImageScale480x480];
                [self addSubview:imageView];
                
                CateHotButton *cateBtn = [[CateHotButton alloc] initWithFrame:imageView.bounds];
                [cateBtn setTitle:cate.categoryName forState:UIControlStateNormal];
                [cateBtn setTitleColor:[UIColor colorWithHexString:@"e6e7e9"] forState:UIControlStateNormal];
                cateBtn.backgroundColor = [UIColor clearColor];
//                [cateBtn setImage:[UIImage imageNamed:cate.categoryBackImage] forState:UIControlStateNormal];
                cateBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
                cateBtn.cateId = cate.categoryId;
                cateBtn.cateName = cate.categoryName;
                cateBtn.redirect_uri = cate.redirect_uri;
                [cateBtn addTarget:self action:@selector(pushSearchViewC:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:cateBtn];
            }
            [self addSubview:self.segView];
            [self addSubview:self.subContentView];
            [self addSubview:self.hotCateView];
            [self.hotCateView getData:recomendArr];
            
            self.hotCateView.clickHotCateBtn = ^(CateHotButton *sender){
                if (sender.redirect_uri != nil) {
                    [URLScheme locateWithRedirectUri:sender.redirect_uri andIsShare:NO];
                } else {
                    SearchViewController *searchVC = [[SearchViewController alloc] init];
                    searchVC.searchKeywords = sender.cateName;
                    [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
                }
            };
            
            [self setUpUI];
        } failure:nil queue:nil]];
        
    }
    return self;
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(void)pushSearchViewC:(CateHotButton *)senders{
    if (senders.redirect_uri != nil) {
        [URLScheme locateWithRedirectUri:senders.redirect_uri andIsShare:NO];
    } else {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchKeywords = senders.cateName;
        [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
    }
}

-(void)setUpUI{
    
    if (self.cateArr.count%2 == 0) {
        self.cateView.frame = CGRectMake(0, 0, kScreenWidth, (self.cateArr.count/2)*(kScreenWidth/2*0.6));
    } else {
        self.cateView.frame = CGRectMake(0, 0, kScreenWidth, ((self.cateArr.count+1)/2)*(kScreenWidth/2*0.6));
    }
    
    self.segView.frame = CGRectMake(0, self.cateView.bottom, kScreenWidth, 12);
    self.subContentView.frame = CGRectMake(0, self.segView.bottom, kScreenWidth, 45);
    if (self.recomendArr.count%3==0) {
        self.hotCateView.frame = CGRectMake(0, self.subContentView.bottom, kScreenWidth, 8+(self.recomendArr.count/3)*((kScreenWidth-(8*4))/3+8));
    } else {
        self.hotCateView.frame = CGRectMake(0, self.subContentView.bottom, kScreenWidth, 8+((self.recomendArr.count/3)+1)*((kScreenWidth-(8*4))/3+8));
    }
    
    self.contentSize = CGSizeMake(kScreenWidth, self.cateView.height+self.segView.height+self.subContentView.height+self.hotCateView.height);
    [self setNeedsDisplay];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
