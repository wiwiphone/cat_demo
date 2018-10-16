//
//  ADMShoppingHeaderView.m
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ADMShoppingHeaderView.h"
#import "ADMShoppingTagsView.h"
#import "Command.h"
#import "SearchViewController.h"
#import "SDCycleScrollView.h"
#import "RedirectInfo.h"
#import "URLScheme.h"

@interface ADMShoppingHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) XMWebImageView *headerImageView;
@property (nonatomic, strong) ADMShoppingTagsView *tagsView;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) CommandButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchIconImageView;
@property (nonatomic, strong) UILabel *searchPlaceholder;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic, strong) UserDetailInfo *detailInfo;
@end

@implementation ADMShoppingHeaderView

-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.autoScrollTimeInterval = 4;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        [_cycleScrollView getIsMain:NO];
    }
    return _cycleScrollView;
}

-(UILabel *)searchPlaceholder{
    if (!_searchPlaceholder) {
        _searchPlaceholder = [[UILabel alloc] initWithFrame:CGRectZero];
        _searchPlaceholder.font = [UIFont systemFontOfSize:15.f];
        _searchPlaceholder.textColor = [UIColor colorWithHexString:@"999999"];
        _searchPlaceholder.text = @"搜索";
        [_searchPlaceholder sizeToFit];
    }
    return _searchPlaceholder;
}

-(UIImageView *)searchIconImageView{
    if (!_searchIconImageView) {
        _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _searchIconImageView.image = [UIImage imageNamed:@"Zixuan_Search_Icon"];
        [_searchIconImageView sizeToFit];
    }
    return _searchIconImageView;
}

-(CommandButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _searchBtn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _searchBtn.alpha = 0.8;
        _searchBtn.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _searchBtn.layer.borderWidth = 0.5;
    }
    return _searchBtn;
}

-(UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] initWithFrame:CGRectZero];
        _sepView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _sepView;
}

-(ADMShoppingTagsView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[ADMShoppingTagsView alloc] initWithFrame:CGRectZero];
        _tagsView.backgroundColor = [UIColor whiteColor];
    }
    return _tagsView;
}

-(XMWebImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _headerImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF;
        //[self addSubview:self.headerImageView];
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.tagsView];
        [self addSubview:self.sepView];
        
        [self addSubview:self.searchBtn];
        [self.searchBtn addSubview:self.searchIconImageView];
        [self.searchBtn addSubview:self.searchPlaceholder];
        self.searchBtn.handleClickBlock = ^(CommandButton *sender){
            SearchViewController *viewController = [[SearchViewController alloc] init];
            viewController.sellerId = weakSelf.userId;
            viewController.isForSelected = NO;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.detailInfo.userInfo.autotrophyGoodsVo.promiseList.count > 0) {
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-50);
        }];
        
        
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cycleScrollView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@40);
        }];
        
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagsView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(12);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.equalTo(@29);
        }];
        
        [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            make.left.equalTo(self.searchBtn.mas_left).offset(12);
        }];
        
        [self.searchPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            make.left.equalTo(self.searchIconImageView.mas_right).offset(10);
        }];
    } else {
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        
//        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.headerImageView.mas_bottom);
//            make.left.equalTo(self.mas_left);
//            make.right.equalTo(self.mas_right);
//            make.height.equalTo(@40);
//        }];
        
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cycleScrollView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(12);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.equalTo(@29);
        }];
        
        [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            make.left.equalTo(self.searchBtn.mas_left).offset(12);
        }];
        
        [self.searchPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            make.left.equalTo(self.searchIconImageView.mas_right).offset(10);
        }];
    }
    
    
}

-(void)getUserDetailInfo:(UserDetailInfo *)userDetailInfo{
    self.detailInfo = userDetailInfo;
//    [self.headerImageView setImageWithURL:userDetailInfo.userInfo.frontUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    NSMutableArray * imagesURLStrings = [[NSMutableArray alloc] init];
    NSArray * array = userDetailInfo.userInfo.sellerBanners;
    for (RedirectInfo * redirectInfo in array) {
        [imagesURLStrings addObject:redirectInfo.imageUrl];
    }
    self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    [self.tagsView getTags:userDetailInfo.userInfo.autotrophyGoodsVo];
//    if (userDetailInfo.userInfo.autotrophyGoodsVo.promiseList.count > 0) {
//        self.tagsView.hidden = NO;
//    } else {
//        self.tagsView.hidden = YES;
//    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSArray * redirectInfoList = self.detailInfo.userInfo.sellerBanners;
    if (index >=0 && index <[redirectInfoList count]) {
        RedirectInfo *redirectInfo = [redirectInfoList objectAtIndex:index];
        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:NO];
    }
}

@end
