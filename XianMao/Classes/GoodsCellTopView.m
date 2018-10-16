//
//  GoodsCellTopView.m
//  XianMao
//
//  Created by 黄崇国 on 2017/3/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GoodsCellTopView.h"
#import "Command.h"
#import "URLScheme.h"

@interface GoodsCellTopView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitlelbl;
@property (nonatomic, strong) CommandButton *moreBtn;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation GoodsCellTopView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(CommandButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_moreBtn setTitleColor:[DataSources colorf9384c] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn sizeToFit];
    }
    return _moreBtn;
}

-(UILabel *)subTitlelbl{
    if (!_subTitlelbl) {
        _subTitlelbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitlelbl.font = [UIFont systemFontOfSize:12.f];
        _subTitlelbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_subTitlelbl sizeToFit];
    }
    return _subTitlelbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont boldSystemFontOfSize:24.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.subTitlelbl];
        [self addSubview:self.moreBtn];

        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(14);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [self.subTitlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
        make.left.equalTo(self.titleLbl.mas_left);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_top).offset(3);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
}

-(void)getRecommendInfo:(RecommendInfo *)recommendInfo{
    self.titleLbl.text = recommendInfo.moreInfo.title;
    self.subTitlelbl.text = recommendInfo.moreInfo.subTitle;
    if (recommendInfo.moreInfo.redirectUri && recommendInfo.moreInfo.redirectUri.length>0) {
        self.moreBtn.hidden = NO;
    } else {
        self.moreBtn.hidden = YES;
    }
    
    self.moreBtn.handleClickBlock = ^(CommandButton *sender){
        [URLScheme locateWithRedirectUri:recommendInfo.moreInfo.redirectUri andIsShare:YES];
    };
}

@end
