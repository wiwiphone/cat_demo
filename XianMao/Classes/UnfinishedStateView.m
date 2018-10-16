//
//  UnfinishedStateView.m
//  XianMao
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "UnfinishedStateView.h"
#import "Masonry.h"
#import "Command.h"
#import "UnfinishViewController.h"

@interface UnfinishedStateView ()

@property (nonatomic, strong) VerticalCommandButton *dSendGoods;
@property (nonatomic, strong) VerticalCommandButton *dDetermine;
@property (nonatomic, strong) VerticalCommandButton *dComeGoods;

@property (nonatomic, strong) UILabel *dSendGoodsLbl;
@property (nonatomic, strong) UILabel *dDetermineLbl;
@property (nonatomic, strong) UILabel *dComeGoodsLbl;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineViewTwo;

@end

@implementation UnfinishedStateView

-(UIView *)lineViewTwo{
    if (!_lineViewTwo) {
        _lineViewTwo = [[UIView alloc] initWithFrame:CGRectZero];
        _lineViewTwo.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _lineViewTwo;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _lineView;
}

-(UILabel *)dComeGoodsLbl{
    if (!_dComeGoodsLbl) {
        _dComeGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dComeGoodsLbl.font = [UIFont systemFontOfSize:13.f];
        _dComeGoodsLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_dComeGoodsLbl sizeToFit];
    }
    return _dComeGoodsLbl;
}

-(UILabel *)dDetermineLbl{
    if (!_dDetermineLbl) {
        _dDetermineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dDetermineLbl.font = [UIFont systemFontOfSize:13.f];
        _dDetermineLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_dDetermineLbl sizeToFit];
    }
    return _dDetermineLbl;
}

-(UILabel *)dSendGoodsLbl{
    if (!_dSendGoodsLbl) {
        _dSendGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dSendGoodsLbl.font = [UIFont systemFontOfSize:13.f];
        _dSendGoodsLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_dSendGoodsLbl sizeToFit];
    }
    return _dSendGoodsLbl;
}

-(VerticalCommandButton *)dSendGoods{
    if (!_dSendGoods) {
        _dSendGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dSendGoods.contentAlignmentCenter = YES;
        _dSendGoods.imageTextSepHeight = -10;
        //        [_dSendGoods setImage:[UIImage imageNamed:@"Mine_Phone_MF"] forState:UIControlStateNormal];
        [_dSendGoods setTitle:@"寄回中" forState:UIControlStateNormal];
        [_dSendGoods setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _dSendGoods.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dSendGoods;
}

-(VerticalCommandButton *)dDetermine{
    if (!_dDetermine) {
        _dDetermine = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dDetermine.contentAlignmentCenter = YES;
        _dDetermine.imageTextSepHeight = -10;
        //        [_dDetermine setImage:[UIImage imageNamed:@"Mine_OnLine_MF"] forState:UIControlStateNormal];
        [_dDetermine setTitle:@"已下架" forState:UIControlStateNormal];
        [_dDetermine setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _dDetermine.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dDetermine;
}

-(VerticalCommandButton *)dComeGoods{
    if (!_dComeGoods) {
        _dComeGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dComeGoods.contentAlignmentCenter = YES;
        _dComeGoods.imageTextSepHeight = -10;
        //        [_dComeGoods setImage:[UIImage imageNamed:@"Mine_Help_MF"] forState:UIControlStateNormal];
        [_dComeGoods setTitle:@"已关闭" forState:UIControlStateNormal];
        [_dComeGoods setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _dComeGoods.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dComeGoods;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.dSendGoods];
        [self addSubview:self.dDetermine];
        [self addSubview:self.dComeGoods];
        
        [self.dSendGoods addSubview:self.dSendGoodsLbl];
        [self.dDetermine addSubview:self.dDetermineLbl];
        [self.dComeGoods addSubview:self.dComeGoodsLbl];
        
        [self.dSendGoods addSubview:self.lineView];
        [self.dComeGoods addSubview:self.lineViewTwo];
        
        self.dSendGoods.handleClickBlock = ^(CommandButton *sender) {
            UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            viewController.selectedIndexPath = indexPath;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dDetermine.handleClickBlock = ^(CommandButton *sender) {
            UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            viewController.selectedIndexPath = indexPath;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dComeGoods.handleClickBlock = ^(CommandButton *sender) {
            UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
            viewController.selectedIndexPath = indexPath;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
    }
    return self;
}

-(void)getSendModel:(SendSaleModel *)sendModel{
    self.dSendGoodsLbl.text = [NSString stringWithFormat:@"(%ld)", sendModel.comeBack];
    self.dDetermineLbl.text = [NSString stringWithFormat:@"(%ld)", sendModel.removed];
    self.dComeGoodsLbl.text = [NSString stringWithFormat:@"(%ld)", sendModel.closed];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.dSendGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dSendGoods.mas_top).offset(20);
        make.right.equalTo(self.dSendGoods.mas_right);
        make.bottom.equalTo(self.dSendGoods.mas_bottom).offset(-15);
        make.width.equalTo(@1);
    }];
    
    [self.dDetermine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.dSendGoods.mas_right);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    
    [self.dComeGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.dDetermine.mas_right);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    
    [self.lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dComeGoods.mas_top).offset(20);
        make.left.equalTo(self.dComeGoods.mas_left);
        make.bottom.equalTo(self.dComeGoods.mas_bottom).offset(-15);
        make.width.equalTo(@1);
    }];
    
    [self.dSendGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dSendGoods.mas_bottom).offset(-9);
        make.centerX.equalTo(self.dSendGoods.mas_centerX);
    }];
    
    [self.dDetermineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dDetermine.mas_bottom).offset(-9);
        make.centerX.equalTo(self.dDetermine.mas_centerX);
    }];
    
    [self.dComeGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dComeGoods.mas_bottom).offset(-9);
        make.centerX.equalTo(self.dComeGoods.mas_centerX);
    }];
    
}

@end
