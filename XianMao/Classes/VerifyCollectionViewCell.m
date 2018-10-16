//
//  VerifyCollectionViewCell.m
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "VerifyCollectionViewCell.h"
#import "Masonry.h"

@interface VerifyCollectionViewCell () 

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation VerifyCollectionViewCell

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightBtn setTitle:@"鉴定未通过" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"95989a"] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _rightBtn;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_leftBtn setTitle:@"初审未通过" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"95989a"] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _leftBtn;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        self.verifyController = [[VerifyTableViewController alloc] init];
        [self.contentView addSubview:self.verifyController.view];
        
        [self.contentView addSubview:self.topView];
        [self.topView addSubview:self.leftBtn];
        [self.topView addSubview:self.rightBtn];
        [self.topView addSubview:self.lineView];
        self.topView.hidden = YES;
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        
        [self clickLeftBtn];
        [self.leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setIsRecept:(BOOL)isRecept{
    _isRecept = isRecept;
    if (isRecept) {
        [self clickLeftBtn];
    }
}

-(void)clickLeftBtn{
    self.leftBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];
    self.leftBtn.selected = YES;
    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.rightBtn.selected = NO;
    self.verifyController.status = 13;
//    [self.verifyController initDataListLogic];
}

-(void)clickRightBtn{
    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];
    self.rightBtn.selected = YES;
    self.leftBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.leftBtn.selected = NO;
    self.verifyController.status = 14;
    [self.verifyController initDataListLogic];
}

-(void)setIsThred:(BOOL)isThred{
    _isThred = isThred;
    if (isThred) {
        self.verifyController.isThred = YES;
        self.topView.hidden = NO;
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
    } else {
        self.verifyController.isThred = NO;
        self.topView.hidden = YES;
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@35);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_centerX);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-1);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top);
        make.right.equalTo(self.topView.mas_right);
        make.left.equalTo(self.topView.mas_centerX);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.height.equalTo(@1);
    }];
    
}

@end
