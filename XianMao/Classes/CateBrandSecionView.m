//
//  CateBrandSecionView.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandSecionView.h"
#import "Command.h"
#import "URLScheme.h"
#import "SearchViewController.h"

@interface CateBrandSecionView ()

@property (nonatomic, strong) CommandButton *secBtn;

@end

@implementation CateBrandSecionView

-(CommandButton *)secBtn{
    if (!_secBtn) {
        _secBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_secBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _secBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _secBtn.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
        _secBtn.layer.borderWidth = 1.f;
    }
    return _secBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.secBtn];
        
        self.secBtn.handleClickBlock = ^(CommandButton *sender){
            if (sender.cateInfo.redirect_uri != nil) {
                [URLScheme locateWithRedirectUri:sender.cateInfo.redirect_uri andIsShare:NO];
            } else {
                SearchViewController *searchVC = [[SearchViewController alloc] init];
                searchVC.searchKeywords = sender.cateInfo.categoryName;
                [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
            }
        };
    }
    return self;
}

-(void)layoutSubviews{
    [self.secBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@92);
        make.height.equalTo(@28);
    }];
}

-(void)getCateNewInfo:(CateNewInfo *)cateInfo{
    
    self.secBtn.cateInfo = cateInfo;
    [self.secBtn setTitle:cateInfo.categoryName forState:UIControlStateNormal];
    
}
@end
