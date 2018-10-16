//
//  QuanGoodsView.m
//  XianMao
//
//  Created by apple on 16/11/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "QuanGoodsView.h"
#import "BounsGoodsInfo.h"
#import "QuanGoodsSubView.h"
#import "Command.h"
#import "inviteNewViewController.h"

@interface QuanGoodsView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) CommandButton *bottomBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation QuanGoodsView

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}

-(CommandButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.backgroundColor = [UIColor colorWithHexString:@"000000"];
        [_bottomBtn setTitle:@"邀请好友赚88元商城券 >" forState:UIControlStateNormal];
    }
    return _bottomBtn;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont systemFontOfSize:15.f];
        _title.textColor = [UIColor colorWithHexString:@"333333"];
        _title.text = @"我的优惠券";
        [_title sizeToFit];
    }
    return _title;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.title];
        [self addSubview:self.bottomBtn];
        [self addSubview:self.scrollView];
        
        self.bottomBtn.handleClickBlock = ^(CommandButton *sender){
            inviteNewViewController *viewController = [[inviteNewViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-22);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@48);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(40);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(2*72));
    }];
}

-(void)setQuanList:(NSArray *)quanList{
    _quanList = quanList;
    
    CGFloat margin = 0;
    for (int i = 0; i < quanList.count; i++) {
        BounsGoodsInfo *bonusInfo = [[BounsGoodsInfo alloc] initWithJSONDictionary:quanList[i]];
        QuanGoodsSubView *subView = [[QuanGoodsSubView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, 72)];
        [subView getBonusInfo:bonusInfo];
        [self.scrollView addSubview:subView];
        margin += 72;
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, margin);
}

@end
