//
//  TagView.m
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TagView.h"
#import "Masonry.h"
#import "GoodsService.h"
#import "PreferenceInJson.h"

@interface TagView ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *backBtn2;
@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) UIButton *chooseBtn2;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UIButton *fondBtn;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *redCircleView;

@end

@implementation TagView

-(UIView *)redCircleView{
    if (!_redCircleView) {
        _redCircleView = [[UIView alloc] init];
        _redCircleView.layer.masksToBounds = YES;
        _redCircleView.layer.cornerRadius = 5;
        _redCircleView.backgroundColor = [UIColor redColor];
    }
    return _redCircleView;
}

-(UIButton *)fondBtn{
    if (!_fondBtn) {
        _fondBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_fondBtn setTitle:@"设置我的偏好" forState:UIControlStateNormal];
        [_fondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fondBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _fondBtn.backgroundColor = [UIColor colorWithHexString:@"3e3a39"];
    }
    return _fondBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dadada"];
    }
    return _lineView;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _backBtn;
}

-(UILabel *)lbl1{
    if (!_lbl1) {
        _lbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbl1.font = [UIFont systemFontOfSize:17.f];
        _lbl1.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _lbl1.text = @"所有";
        [_lbl1 sizeToFit];
    }
    return _lbl1;
}

-(UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chooseBtn setImage:[UIImage imageNamed:@"choose_recoverGoods_MF"] forState:UIControlStateNormal];
    }
    return _chooseBtn;
}

-(UIButton *)backBtn2{
    if (!_backBtn2) {
        _backBtn2 = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _backBtn2;
}

-(UILabel *)lbl2{
    if (!_lbl2) {
        _lbl2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbl2.font = [UIFont systemFontOfSize:17.f];
        _lbl2.textColor = [UIColor colorWithHexString:@"595757"];
        _lbl2.text = @"我偏好的";
        [_lbl2 sizeToFit];
    }
    return _lbl2;
}

-(UIButton *)chooseBtn2{
    if (!_chooseBtn2) {
        _chooseBtn2 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chooseBtn2 setImage:[UIImage imageNamed:@"choose_recoverGoods_MF"] forState:UIControlStateNormal];
    }
    return _chooseBtn2;
}

-(UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView2.backgroundColor = [UIColor colorWithHexString:@"dadada"];
    }
    return _lineView2;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backBtn];
        [self.backBtn addSubview:self.lbl1];
        [self.backBtn addSubview:self.chooseBtn];
        [self addSubview:self.lineView];
        [self addSubview:self.backBtn2];
        [self.backBtn2 addSubview:self.lbl2];
        [self.backBtn2 addSubview:self.chooseBtn2];
        [self addSubview:self.lineView2];
        [self addSubview:self.fondBtn];
        [self addSubview:self.redCircleView];
        self.chooseBtn2.hidden = YES;
        [self.backBtn addTarget:self action:@selector(clickAllBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn2 addTarget:self action:@selector(clickFondBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.fondBtn addTarget:self action:@selector(clickSetFondBtn) forControlEvents:UIControlEventTouchUpInside];
        [self setUpUI];
    }
    return self;
}

-(void)getPreferenceArr:(NSMutableArray *)preInJsonArr{
    WEAKSELF;
    
    if (preInJsonArr.count == 0) {
        self.redCircleView.hidden = NO;
    } else {
        self.redCircleView.hidden = YES;
    }
    [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
        NSMutableArray *preferenceInJsonArr = dict[@"get_recovery_preference_in_json"];
        if (preferenceInJsonArr.count > 0) {
            weakSelf.redCircleView.hidden = YES;
        } else {
            weakSelf.redCircleView.hidden = NO;
        }
    } failure:^(XMError *error) {
        
    }];
}

-(void)clickAllBtn{
    self.chooseBtn.hidden = NO;
    self.chooseBtn2.hidden = YES;
    self.lbl1.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    self.lbl2.textColor = [UIColor colorWithHexString:@"595757"];
    self.index = 1;
    WEAKSELF;
    if (self.dismissTagViewBlock) {
        self.dismissTagViewBlock(weakSelf.index);
    }
}

-(void)clickFondBtn{
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        if (self.dismissTagViewBlock) {
            self.dismissTagViewBlock(1);
        }
        return;
    }
    self.chooseBtn2.hidden = NO;
    self.chooseBtn.hidden = YES;
    self.lbl1.textColor = [UIColor colorWithHexString:@"595757"];
    self.lbl2.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    self.index = 2;
    WEAKSELF;
    if (self.dismissTagViewBlock) {
        self.dismissTagViewBlock(weakSelf.index);
    }
}

-(void)clickSetFondBtn{
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        if (self.dismissTagViewBlock) {
            self.dismissTagViewBlock(1);
        }
        return;
    }
    if (self.dismissTagViewBlock) {
        self.dismissTagViewBlock(0);
    }
    if (self.pushFondControllerBlock) {
        self.pushFondControllerBlock();
    }
    
}

-(void)setUpUI{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@54);
    }];
    
    [self.lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_left).offset(15);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backBtn.mas_right).offset(-15);
        make.centerY.equalTo(self.lbl1.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    [self.backBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@54);
    }];
    
    [self.lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn2.mas_left).offset(15);
        make.centerY.equalTo(self.backBtn2.mas_centerY);
    }];
    
    [self.chooseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backBtn2.mas_right).offset(-15);
        make.centerY.equalTo(self.lbl2.mas_centerY);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn2.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    [self.fondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@40);
    }];
    
    [self.redCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbl2.mas_right).offset(5);
        make.centerY.equalTo(self.lbl2.mas_centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //适配ios7 移动布局到setUpUI中
//    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@54);
//    }];
//    
//    [self.lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backBtn.mas_left).offset(15);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
//    }];
//    
//    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backBtn.mas_right).offset(-15);
//        make.centerY.equalTo(self.lbl1.mas_centerY);
//    }];
//    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backBtn.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@0.5);
//    }];
//    
//    [self.backBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@54);
//    }];
//    
//    [self.lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backBtn2.mas_left).offset(15);
//        make.centerY.equalTo(self.backBtn2.mas_centerY);
//    }];
//    
//    [self.chooseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backBtn2.mas_right).offset(-15);
//        make.centerY.equalTo(self.lbl2.mas_centerY);
//    }];
//    
//    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backBtn2.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@0.5);
//    }];
//    
//    [self.fondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView2.mas_bottom).offset(8);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.equalTo(@40);
//    }];
//    
//    [self.redCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lbl2.mas_right).offset(5);
//        make.centerY.equalTo(self.lbl2.mas_centerY);
//        make.width.equalTo(@10);
//        make.height.equalTo(@10);
//    }];
}

@end
