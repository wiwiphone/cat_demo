//
//  VerifyTopView.m
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "VerifyTopView.h"
#import "Command.h"
#import "Masonry.h"

@interface VerifyTopView ()

@property (nonatomic, strong) CommandButton *waitVerify;
@property (nonatomic, strong) CommandButton *passVerify;
@property (nonatomic, strong) CommandButton *unPassVerify;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) NSInteger selectedindex;
@end

@implementation VerifyTopView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    }
    return _lineView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _bottomView;
}

-(CommandButton *)unPassVerify{
    if (!_unPassVerify) {
        _unPassVerify = [[CommandButton alloc] initWithFrame:CGRectZero];
        _unPassVerify.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_unPassVerify setTitleColor:[UIColor colorWithHexString:@"bebebe"] forState:UIControlStateNormal];
        [_unPassVerify setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_unPassVerify setTitle:@"审核未通过" forState:UIControlStateNormal];
        [_unPassVerify sizeToFit];
    }
    return _unPassVerify;
}

-(CommandButton *)passVerify{
    if (!_passVerify) {
        _passVerify = [[CommandButton alloc] initWithFrame:CGRectZero];
        _passVerify.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_passVerify setTitleColor:[UIColor colorWithHexString:@"bebebe"] forState:UIControlStateNormal];
        [_passVerify setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_passVerify setTitle:@"审核通过" forState:UIControlStateNormal];
        [_passVerify sizeToFit];
    }
    return _passVerify;
}

-(CommandButton *)waitVerify{
    if (!_waitVerify) {
        _waitVerify = [[CommandButton alloc] initWithFrame:CGRectZero];
        _waitVerify.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_waitVerify setTitleColor:[UIColor colorWithHexString:@"bebebe"] forState:UIControlStateNormal];
        [_waitVerify setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_waitVerify setTitle:@"待审核" forState:UIControlStateNormal];
        [_waitVerify sizeToFit];
    }
    return _waitVerify;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.waitVerify.selected = YES;
        [self addSubview:self.waitVerify];
        [self addSubview:self.passVerify];
        [self addSubview:self.unPassVerify];
        [self addSubview:self.lineView];
        
        [self addSubview:self.bottomView];
        WEAKSELF;
        self.waitVerify.handleClickBlock = ^(CommandButton *sender){
            weakSelf.waitVerify.selected = YES;
            weakSelf.passVerify.selected = NO;
            weakSelf.unPassVerify.selected = NO;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.lineView.frame = CGRectMake(weakSelf.waitVerify.frame.origin.x, weakSelf.waitVerify.bottom - 5, weakSelf.waitVerify.width, 1);
            }];
            if ([weakSelf.delegate respondsToSelector:@selector(selectedItem:)]) {
                [weakSelf.delegate selectedItem:1];
            }
        };
        
        self.passVerify.handleClickBlock = ^(CommandButton *sender){
            weakSelf.waitVerify.selected = NO;
            weakSelf.passVerify.selected = YES;
            weakSelf.unPassVerify.selected = NO;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.lineView.frame = CGRectMake(weakSelf.passVerify.frame.origin.x, weakSelf.passVerify.bottom - 5, weakSelf.passVerify.width, 1);
            }];
            if ([weakSelf.delegate respondsToSelector:@selector(selectedItem:)]) {
                [weakSelf.delegate selectedItem:2];
            }
        };
        
        self.unPassVerify.handleClickBlock = ^(CommandButton *sender){
            weakSelf.waitVerify.selected = NO;
            weakSelf.passVerify.selected = NO;
            weakSelf.unPassVerify.selected = YES;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.lineView.frame = CGRectMake(weakSelf.unPassVerify.frame.origin.x, weakSelf.unPassVerify.bottom - 5, weakSelf.unPassVerify.width, 1);
            }];
            if ([weakSelf.delegate respondsToSelector:@selector(selectedItem:)]) {
                [weakSelf.delegate selectedItem:3];
            }
        };
    }
    return self;
}

-(void)getSelectIndex:(NSInteger)selectedindex{
    self.selectedindex = selectedindex;
    self.waitVerify.frame = CGRectMake(17, 0, self.waitVerify.width, 35);
    self.passVerify.frame = CGRectMake(self.waitVerify.right + 25, 0, self.passVerify.width, 35);
    self.unPassVerify.frame = CGRectMake(self.passVerify.right + 25, 0, self.unPassVerify.width, 35);
    if (selectedindex == 1) {
        self.waitVerify.selected = YES;
        self.passVerify.selected = NO;
        self.unPassVerify.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.waitVerify.frame.origin.x, self.waitVerify.bottom - 5, self.waitVerify.width, 1);
        }];
    } else if (selectedindex == 2) {
        self.waitVerify.selected = NO;
        self.passVerify.selected = YES;
        self.unPassVerify.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.passVerify.frame.origin.x, self.passVerify.bottom - 5, self.passVerify.width, 1);
        }];
    } else if (selectedindex == 3) {
        self.waitVerify.selected = NO;
        self.passVerify.selected = NO;
        self.unPassVerify.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.unPassVerify.frame.origin.x, self.unPassVerify.bottom - 5, self.unPassVerify.width, 1);
        }];
    }
}

-(void)selectedTopBtn:(NSInteger)index{
    if (index == 1) {
        self.waitVerify.selected = YES;
        self.passVerify.selected = NO;
        self.unPassVerify.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.waitVerify.frame.origin.x, self.waitVerify.bottom - 5, self.waitVerify.width, 1);
        }];
    } else if (index == 2) {
        self.waitVerify.selected = NO;
        self.passVerify.selected = YES;
        self.unPassVerify.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.passVerify.frame.origin.x, self.passVerify.bottom - 5, self.passVerify.width, 1);
        }];
    } else if (index == 3) {
        self.waitVerify.selected = NO;
        self.passVerify.selected = NO;
        self.unPassVerify.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.unPassVerify.frame.origin.x, self.unPassVerify.bottom - 5, self.unPassVerify.width, 1);
        }];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.waitVerify.frame = CGRectMake(17, 0, self.waitVerify.width, 35);
    self.passVerify.frame = CGRectMake(self.waitVerify.right + 25, 0, self.passVerify.width, 35);
    self.unPassVerify.frame = CGRectMake(self.passVerify.right + 25, 0, self.unPassVerify.width, 35);
    
    if (self.selectedindex == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.waitVerify.frame.origin.x, self.waitVerify.bottom - 5, self.waitVerify.width, 1);
        }];
    } else if (self.selectedindex == 2) {
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.passVerify.frame.origin.x, self.passVerify.bottom - 5, self.passVerify.width, 1);
        }];
    } else if (self.selectedindex == 3) {
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.frame = CGRectMake(self.unPassVerify.frame.origin.x, self.unPassVerify.bottom - 5, self.unPassVerify.width, 1);
        }];
    } else {
        self.lineView.frame = CGRectMake(self.waitVerify.frame.origin.x, self.waitVerify.bottom - 5, self.waitVerify.width, 1);
    }
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

@end
