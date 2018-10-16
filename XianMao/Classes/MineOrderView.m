//
//  MineOrderView.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineOrderView.h"
#import "Command.h"
#import "Masonry.h"
#import "BoughtCollectionViewController.h"
#import "Session.h"
#import "OrderGoodsInfoVo.h"
#import "DataSources.h"

@interface MineOrderView ()

@property (nonatomic, strong) VerticalCommandButton *dSendGoods;
@property (nonatomic, strong) VerticalCommandButton *dDetermine;
@property (nonatomic, strong) VerticalCommandButton *dComeGoods;
@property (nonatomic, strong) VerticalCommandButton *close;

@property (nonatomic, strong) UILabel *dSendGoodsLbl;
@property (nonatomic, strong) UILabel *dDetermineLbl;
@property (nonatomic, strong) UILabel *dComeGoodsLbl;
@property (nonatomic, strong) UILabel *closeLbl;

@end

@implementation MineOrderView

-(UILabel *)closeLbl{
    if (!_closeLbl) {
        _closeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _closeLbl.font = [UIFont systemFontOfSize:10.f];
        _closeLbl.textColor = [UIColor whiteColor];
        _closeLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _closeLbl.backgroundColor = [UIColor blackColor];
        _closeLbl.layer.borderWidth = 1.f;
        _closeLbl.textAlignment = NSTextAlignmentCenter;

    }
    return _closeLbl;
}

-(UILabel *)dComeGoodsLbl{
    if (!_dComeGoodsLbl) {
        _dComeGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dComeGoodsLbl.font = [UIFont systemFontOfSize:10.f];
        _dComeGoodsLbl.textColor = [UIColor whiteColor];
        _dComeGoodsLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dComeGoodsLbl.layer.borderWidth = 1.f;
        _dComeGoodsLbl.textAlignment = NSTextAlignmentCenter;
        _dComeGoodsLbl.backgroundColor = [DataSources colorf9384c];

    }
    return _dComeGoodsLbl;
}

-(UILabel *)dDetermineLbl{
    if (!_dDetermineLbl) {
        _dDetermineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dDetermineLbl.font = [UIFont systemFontOfSize:10.f];
        _dDetermineLbl.backgroundColor = [DataSources colorf9384c];
        _dDetermineLbl.textColor = [UIColor whiteColor];
        _dDetermineLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dDetermineLbl.layer.borderWidth = 1.f;
        _dDetermineLbl.textAlignment = NSTextAlignmentCenter;

    }
    return _dDetermineLbl;
}

-(UILabel *)dSendGoodsLbl{
    if (!_dSendGoodsLbl) {
        _dSendGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dSendGoodsLbl.font = [UIFont systemFontOfSize:10.f];
        _dSendGoodsLbl.textColor = [UIColor whiteColor];
        _dSendGoodsLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dSendGoodsLbl.layer.borderWidth = 1.f;
        _dSendGoodsLbl.textAlignment = NSTextAlignmentCenter;
        _dSendGoodsLbl.backgroundColor = [DataSources colorf9384c];

    }
    return _dSendGoodsLbl;
}

-(VerticalCommandButton *)dSendGoods{
    if (!_dSendGoods) {
        _dSendGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dSendGoods.contentAlignmentCenter = YES;
        _dSendGoods.imageTextSepHeight = 6;
        [_dSendGoods setImage:[UIImage imageNamed:@"Mine_SendGoods_MF_New"] forState:UIControlStateNormal];
        [_dSendGoods setTitle:@"待付款" forState:UIControlStateNormal];
        [_dSendGoods setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _dSendGoods.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dSendGoods;
}

-(VerticalCommandButton *)dDetermine{
    if (!_dDetermine) {
        _dDetermine = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dDetermine.contentAlignmentCenter = YES;
        _dDetermine.imageTextSepHeight = 6;
        [_dDetermine setImage:[UIImage imageNamed:@"Mine_Deter_MF_New"] forState:UIControlStateNormal];
        [_dDetermine setTitle:@"待发货" forState:UIControlStateNormal];
        [_dDetermine setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _dDetermine.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dDetermine;
}

-(VerticalCommandButton *)dComeGoods{
    if (!_dComeGoods) {
        _dComeGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dComeGoods.contentAlignmentCenter = YES;
        _dComeGoods.imageTextSepHeight = 6;
        [_dComeGoods setImage:[UIImage imageNamed:@"Mine_ComeGoods_MF_New"] forState:UIControlStateNormal];
        [_dComeGoods setTitle:@"待收货" forState:UIControlStateNormal];
        [_dComeGoods setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _dComeGoods.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dComeGoods;
}

-(VerticalCommandButton *)close{
    if (!_close) {
        _close = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _close.contentAlignmentCenter = YES;
        _close.imageTextSepHeight = 6;
        [_close setImage:[UIImage imageNamed:@"Mine_Close_MF_New"] forState:UIControlStateNormal];
        [_close setTitle:@"已成交" forState:UIControlStateNormal];
        [_close setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _close.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _close;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.dSendGoods];
        [self addSubview:self.dDetermine];
        [self addSubview:self.dComeGoods];
        [self addSubview:self.close];
        
        [self.dSendGoods addSubview:self.dSendGoodsLbl];
        [self.dDetermine addSubview:self.dDetermineLbl];
        [self.dComeGoods addSubview:self.dComeGoodsLbl];
        [self.close addSubview:self.closeLbl];
        
        WEAKSELF;
        self.dSendGoods.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:1 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dDetermine.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:2 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dComeGoods.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:3 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.close.handleClickBlock = ^(CommandButton *sender) {
            [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:4 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        [self setUpUI];
        [self setData];
    }
    return self;
}

-(void)setData{
    User *user = [Session sharedInstance].currentUser;
    OrderGoodsInfoVo *orderGoodsInfo = user.orderGoodsInfoVo;
    
    self.dSendGoodsLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myOrderNotPayed];
    self.dDetermineLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myOrderNotSend];
    self.dComeGoodsLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myOrderReceiving];
    self.closeLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myOrderFinish];
    
    if (orderGoodsInfo.myOrderNotPayed > 0) {
        self.dSendGoodsLbl.hidden = NO;
    } else {
        self.dSendGoodsLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.myOrderNotSend > 0) {
        self.dDetermineLbl.hidden = NO;
    } else {
        self.dDetermineLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.myOrderReceiving > 0) {
        self.dComeGoodsLbl.hidden = NO;
    } else {
        self.dComeGoodsLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.myOrderFinish > 0) {
        self.closeLbl.hidden = NO;
    } else {
        self.closeLbl.hidden = YES;
    }
    
    self.dSendGoodsLbl.layer.masksToBounds = YES;
    self.dSendGoodsLbl.layer.cornerRadius = 18/2;
    
    self.dDetermineLbl.layer.masksToBounds = YES;
    self.dDetermineLbl.layer.cornerRadius = 18/2;
    
    self.dComeGoodsLbl.layer.masksToBounds = YES;
    self.dComeGoodsLbl.layer.cornerRadius = 18/2;
    
    self.closeLbl.layer.masksToBounds = YES;
    self.closeLbl.layer.cornerRadius = 18/2;
}

-(void)setUpUI{
    
    [self.dSendGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.dDetermine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.dSendGoods.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.dComeGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.dDetermine.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.dComeGoods.mas_right);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.dSendGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dSendGoods.mas_right).offset(-(kScreenWidth/320*15));
        make.top.equalTo(self.dSendGoods.mas_top).offset(10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.dDetermineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dDetermine.mas_right).offset(-(kScreenWidth/320*15));
        make.top.equalTo(self.dDetermine.mas_top).offset(10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.dComeGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dComeGoods.mas_right).offset(-(kScreenWidth/320*15));
        make.top.equalTo(self.dComeGoods.mas_top).offset(10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.closeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.close.mas_right).offset(-(kScreenWidth/320*15));
        make.top.equalTo(self.close.mas_top).offset(10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
