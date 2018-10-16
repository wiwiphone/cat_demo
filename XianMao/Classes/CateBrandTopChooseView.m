//
//  CateBrandTopChooseView.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandTopChooseView.h"
#import "Command.h"

@interface CateBrandTopChooseView ()

@property (nonatomic, strong) CommandButton *cateBtn;
@property (nonatomic, strong) CommandButton *brandBtn;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation CateBrandTopChooseView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"434342"];
    }
    return _lineView;
}

-(CommandButton *)brandBtn{
    if (!_brandBtn) {
        _brandBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_brandBtn setTitle:@"品牌" forState:UIControlStateNormal];
        [_brandBtn setTitleColor:[UIColor colorWithHexString:@"bebebe"] forState:UIControlStateNormal];
        [_brandBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateSelected];
        _brandBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _brandBtn;
}

-(CommandButton *)cateBtn{
    if (!_cateBtn) {
        _cateBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_cateBtn setTitle:@"分类" forState:UIControlStateNormal];
        [_cateBtn setTitleColor:[UIColor colorWithHexString:@"bebebe"] forState:UIControlStateNormal];
        [_cateBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateSelected];
        _cateBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _cateBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        [self addSubview:self.cateBtn];
        [self addSubview:self.brandBtn];
        [self addSubview:self.lineView];
        
        self.cateBtn.selected = YES;
        self.cateBtn.handleClickBlock = ^(CommandButton *sender){
            
            if (weakSelf.showCateBrandView) {
                weakSelf.showCateBrandView(1);
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.cateBtn.selected = YES;
                weakSelf.brandBtn.selected = NO;
                
                weakSelf.lineView.frame = CGRectMake((self.width/2-50)/2, self.height-1, 50, 1);
            }];
        };
        
        self.brandBtn.handleClickBlock = ^(CommandButton *sender){
            
            if (weakSelf.showCateBrandView) {
                weakSelf.showCateBrandView(2);
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.cateBtn.selected = NO;
                weakSelf.brandBtn.selected = YES;
                
                weakSelf.lineView.frame = CGRectMake((self.width-50)-(self.width/2-50)/2, self.height-1, 50, 1);
            }];
        };
    }
    return self;
}

-(void)getIndex:(NSInteger)index{
    WEAKSELF;
    if (index == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.cateBtn.selected = YES;
            weakSelf.brandBtn.selected = NO;
            
            weakSelf.lineView.frame = CGRectMake((self.width/2-50)/2, self.height-1, 50, 1);
        }];
    } else if (index == 2) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.cateBtn.selected = NO;
            weakSelf.brandBtn.selected = YES;
            
            weakSelf.lineView.frame = CGRectMake((self.width-50)-(self.width/2-50)/2, self.height-1, 50, 1);
        }];
    }
}

-(void)layoutSubviews{
    [self.cateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.brandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.cateBtn.mas_centerX);
        make.width.equalTo(@50);
        make.height.equalTo(@1);
    }];
}

@end
