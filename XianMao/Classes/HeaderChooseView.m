//
//  HeaderChooseView.m
//  XianMao
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HeaderChooseView.h"
#import "Command.h"

@interface HeaderChooseView ()

@property (nonatomic, strong) CommandButton *picBtn;
@property (nonatomic, strong) CommandButton *parameterBtn;
@property (nonatomic, strong) CommandButton *guardBtn;

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger index;//定义变量防止重复滑动
@end

@implementation HeaderChooseView

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [DataSources colorf9384c];
    }
    return _bottomLineView;
}

-(CommandButton *)guardBtn{
    if (!_guardBtn) {
        _guardBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_guardBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_guardBtn setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
        _guardBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_guardBtn sizeToFit];
    }
    return _guardBtn;
}

-(CommandButton *)parameterBtn{
    if (!_parameterBtn) {
        _parameterBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_parameterBtn setTitle:@"商品参数" forState:UIControlStateNormal];
        [_parameterBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_parameterBtn setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
        _parameterBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_parameterBtn sizeToFit];
    }
    return _parameterBtn;
}

-(CommandButton *)picBtn{
    if (!_picBtn) {
        _picBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_picBtn setTitle:@"商品图片" forState:UIControlStateNormal];
        [_picBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_picBtn setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
        _picBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_picBtn sizeToFit];
    }
    return _picBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF;
        [self addSubview:self.picBtn];
        [self addSubview:self.parameterBtn];
        [self addSubview:self.guardBtn];
        [self addSubview:self.bottomLineView];
        
        self.picBtn.selected = YES;
        
        self.picBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf selectedBrn:1];
        };
        
        self.parameterBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf selectedBrn:2];
        };
        
        self.guardBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf selectedBrn:3];
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseSelecteIndex:) name:@"chooseSelecteIndex" object:nil];
    }
    return self;
}

- (void)getGoodsDetailInfo:(GoodsDetailInfo *)detailInfo{
    
    if ([detailInfo.goodsInfo.seller isMeowGoods]) {
        [_guardBtn setTitle:@"交易说明" forState:UIControlStateNormal];
    }else{
        [_guardBtn setTitle:@"交易保障" forState:UIControlStateNormal];
    }
}

-(void)chooseSelecteIndex:(NSNotification *)notify{
    NSInteger index = ((NSNumber *)notify.object).integerValue;
    if (index == 1) {
        self.picBtn.selected = YES;
        self.parameterBtn.selected = NO;
        self.guardBtn.selected = NO;
    } else if (index == 2) {
        self.picBtn.selected = NO;
        self.parameterBtn.selected = YES;
        self.guardBtn.selected = NO;
    } else if (index == 3) {
        self.picBtn.selected = NO;
        self.parameterBtn.selected = NO;
        self.guardBtn.selected = YES;
    }
    [self bottomLineViewScrollWillScroll:index];
}

-(void)selectedBrn:(NSInteger)index{
//    if (index == 1) {
//        self.picBtn.selected = YES;
//        self.parameterBtn.selected = NO;
//        self.guardBtn.selected = NO;
//    } else if (index == 2) {
//        self.picBtn.selected = NO;
//        self.parameterBtn.selected = YES;
//        self.guardBtn.selected = NO;
//    } else if (index == 3) {
//        self.picBtn.selected = NO;
//        self.parameterBtn.selected = NO;
//        self.guardBtn.selected = YES;
//    }
    if (self.headerScrollTableInfIndexP) {
        self.headerScrollTableInfIndexP(index);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelctCellIndex" object:@(index)];
}

-(void)bottomLineViewScrollWillScroll:(NSInteger)index{
    WEAKSELF;
    if (self.index != index) {
        switch (index) {
            case 1: {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.bottomLineView.frame = CGRectMake(self.picBtn.left-11, self.height-2, self.picBtn.width+20, 2);
                }];
                break;
            }
            case 2:{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.bottomLineView.frame = CGRectMake(self.parameterBtn.left-11, self.height-2, self.parameterBtn.width+20, 2);
                }];
                break;
            }
            case 3:{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.bottomLineView.frame = CGRectMake(self.guardBtn.left-11, self.height-2, self.guardBtn.width+20, 2);
                }];
            }
            default:
                break;
        }
        self.index = index;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelctCellIndex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelecteIndex" object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    WEAKSELF;
    [self.picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(31);
    }];
    
    [self.parameterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.guardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-31);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.bottomLineView.frame = CGRectMake(20, self.height-2, self.picBtn.width+20, 2);
    }];
}

@end
