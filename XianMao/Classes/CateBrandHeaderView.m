//
//  CateBrandHeaderView.m
//  XianMao
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandHeaderView.h"
#import "BrandVO.h"
#import "Command.h"
#import "URLScheme.h"
#import "SearchViewController.h"

@interface CateBrandHeaderView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *brandTitleView;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation CateBrandHeaderView

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.text = @"全部品牌";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIView *)brandTitleView{
    if (!_brandTitleView) {
        _brandTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _brandTitleView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _lineView;
}

-(void)getBrandVoList:(NSArray *)list{
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat margin = 0;
    for (int i = 0; i < list.count; i++) {
        
        BrandVO *brandVo = [[BrandVO alloc] initWithJSONDictionary:list[i]];
        CommandButton *brandBgBtn = [[CommandButton alloc] initWithFrame:CGRectMake(x, y, kScreenWidth/3, kScreenWidth/3)];
        brandBgBtn.brandVo = brandVo;
        x += kScreenWidth/3;
        
        if (x >= kScreenWidth) {
            margin += kScreenWidth/3;
            y += kScreenWidth/3;
            x = 0;
        }
        
        if (i == list.count -1) {
            if (list.count % 3 != 0) {
                margin += kScreenWidth/3;
            }
        }
        
        [self addSubview:brandBgBtn];
        
        XMWebImageView *brandImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        brandImageView.userInteractionEnabled = NO;
        [brandBgBtn addSubview:brandImageView];
        [brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(brandBgBtn.mas_centerY);
            make.centerX.equalTo(brandBgBtn.mas_centerX);
            make.width.equalTo(@(kScreenWidth/3));
            make.height.equalTo(@(kScreenWidth/3));
        }];
        [brandImageView setImageWithURL:brandVo.logoUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        brandBgBtn.handleClickBlock = ^(CommandButton *sender){
            if (sender.brandVo.redirect_uri != nil) {
                [URLScheme locateWithRedirectUri:sender.brandVo.redirect_uri andIsShare:NO];
            } else {
                SearchViewController *searchVC = [[SearchViewController alloc] init];
                searchVC.searchKeywords = sender.brandVo.brandName;
                [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
            }
        };
    }
//    margin += kScreenWidth/3;
    
    self.lineView.frame = CGRectMake(0, margin, kScreenWidth, 12);
    [self addSubview:self.lineView];
    margin += 12;
    
    self.brandTitleView.frame = CGRectMake(0, margin, kScreenWidth, 60);
    [self addSubview:self.brandTitleView];
    
    [self.brandTitleView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.brandTitleView.mas_centerX);
        make.centerY.equalTo(self.brandTitleView.mas_centerY);
    }];
}

@end
