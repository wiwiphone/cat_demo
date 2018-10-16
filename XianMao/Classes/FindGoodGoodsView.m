//
//  FindGoodGoodsView.m
//  XianMao
//
//  Created by 黄崇国 on 2017/3/6.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "FindGoodGoodsView.h"

@interface FindGoodGoodsView ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;

@property (nonatomic, strong) RedirectInfo *redirectInfo;
@end

@implementation FindGoodGoodsView

-(UILabel *)subTitleLbl{
    if (!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLbl.font = [UIFont systemFontOfSize:11.f];
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"888888"];
        [_subTitleLbl sizeToFit];
        _subTitleLbl.numberOfLines = 0;
    }
    return _subTitleLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont boldSystemFontOfSize:16.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_titleLbl sizeToFit];
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.subTitleLbl];
        
    }
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchFindGoodsView) {
        self.touchFindGoodsView(self.redirectInfo);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)getRedirectInfo:(RedirectInfo *)redirectInfo{
    self.redirectInfo = redirectInfo;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.width.equalTo(@(redirectInfo.width>0?redirectInfo.width*kScreenWidth/320:120-40));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [self.iconImageView setImageWithURL:redirectInfo.imageUrl XMWebImageScaleType:XMWebImageScale480x480];
    self.titleLbl.text = redirectInfo.title;
    self.subTitleLbl.text = redirectInfo.subTitle;
}

@end
