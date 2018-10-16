//
//  UserHomeAlSelaCataCell.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "UserHomeAlSelaCataCell.h"
#import "Command.h"
#import "Masonry.h"
#import "SoldCollectionViewController.h"
#import "Session.h"
#import "OrderGoodsInfoVo.h"
#import "DataSources.h"

@interface UserHomeAlSelaCataCell ()

@property (nonatomic, strong) VerticalCommandButton *dSendGoods;
@property (nonatomic, strong) VerticalCommandButton *dDetermine;
@property (nonatomic, strong) VerticalCommandButton *dComeGoods;
@property (nonatomic, strong) VerticalCommandButton *close;
@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UILabel *dSendGoodsLbl;
@property (nonatomic, strong) UILabel *dDetermineLbl;
@property (nonatomic, strong) UILabel *dComeGoodsLbl;
@property (nonatomic, strong) UILabel *closeLbl;

@end

@implementation UserHomeAlSelaCataCell

-(UILabel *)closeLbl{
    if (!_closeLbl) {
        _closeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _closeLbl.font = [UIFont systemFontOfSize:12.f];
        _closeLbl.textColor = [UIColor whiteColor];
        _closeLbl.layer.masksToBounds = YES;
        _closeLbl.layer.cornerRadius = 9;
        _closeLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _closeLbl.layer.borderWidth = 1.f;
        _closeLbl.textAlignment = NSTextAlignmentCenter;
        _closeLbl.backgroundColor = [UIColor blackColor];
    }
    return _closeLbl;
}

-(UILabel *)dComeGoodsLbl{
    if (!_dComeGoodsLbl) {
        _dComeGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dComeGoodsLbl.font = [UIFont systemFontOfSize:12.f];
        _dComeGoodsLbl.textColor = [UIColor whiteColor];
        _dComeGoodsLbl.layer.masksToBounds = YES;
        _dComeGoodsLbl.layer.cornerRadius = 9;
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
        _dDetermineLbl.font = [UIFont systemFontOfSize:12.f];
        _dDetermineLbl.textColor = [UIColor whiteColor];
        _dDetermineLbl.layer.masksToBounds = YES;
        _dDetermineLbl.layer.cornerRadius = 9;
        _dDetermineLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dDetermineLbl.layer.borderWidth = 1.f;
        _dDetermineLbl.textAlignment = NSTextAlignmentCenter;
        _dDetermineLbl.backgroundColor = [DataSources colorf9384c];
    }
    return _dDetermineLbl;
}

-(UILabel *)dSendGoodsLbl{
    if (!_dSendGoodsLbl) {
        _dSendGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dSendGoodsLbl.font = [UIFont systemFontOfSize:12.f];
        _dSendGoodsLbl.textColor = [UIColor whiteColor];
        _dSendGoodsLbl.layer.masksToBounds = YES;
        _dSendGoodsLbl.layer.cornerRadius = 9;
        _dSendGoodsLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dSendGoodsLbl.layer.borderWidth = 1.f;
        _dSendGoodsLbl.textAlignment = NSTextAlignmentCenter;
        _dSendGoodsLbl.backgroundColor = [DataSources colorf9384c];
    }
    return _dSendGoodsLbl;
}

-(UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _topLineView;
}

-(VerticalCommandButton *)dSendGoods{
    if (!_dSendGoods) {
        _dSendGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dSendGoods.contentAlignmentCenter = YES;
        _dSendGoods.imageTextSepHeight = 6;
        [_dSendGoods setImage:[UIImage imageNamed:@"Mine_SendGoods_MF"] forState:UIControlStateNormal];
        [_dSendGoods setTitle:@"待发货" forState:UIControlStateNormal];
        [_dSendGoods setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _dSendGoods.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dSendGoods;
}

-(VerticalCommandButton *)dDetermine{
    if (!_dDetermine) {
        _dDetermine = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dDetermine.contentAlignmentCenter = YES;
        _dDetermine.imageTextSepHeight = 6;
        [_dDetermine setImage:[UIImage imageNamed:@"Mine_Deter_MF"] forState:UIControlStateNormal];
        [_dDetermine setTitle:@"待鉴定" forState:UIControlStateNormal];
        [_dDetermine setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _dDetermine.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dDetermine;
}

-(VerticalCommandButton *)dComeGoods{
    if (!_dComeGoods) {
        _dComeGoods = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _dComeGoods.contentAlignmentCenter = YES;
        _dComeGoods.imageTextSepHeight = 6;
        [_dComeGoods setImage:[UIImage imageNamed:@"Mine_RecoverUserHome"] forState:UIControlStateNormal];
        [_dComeGoods setTitle:@"待收货" forState:UIControlStateNormal];
        [_dComeGoods setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _dComeGoods.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dComeGoods;
}

-(VerticalCommandButton *)close{
    if (!_close) {
        _close = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _close.contentAlignmentCenter = YES;
        _close.imageTextSepHeight = 6;
        [_close setImage:[UIImage imageNamed:@"Mine_ComeGoods_MF"] forState:UIControlStateNormal];
        [_close setTitle:@"已成交" forState:UIControlStateNormal];
        [_close setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _close.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _close;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserHomeAlSelaCataCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 88.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserHomeAlSelaCataCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.dSendGoods];
        [self addSubview:self.dDetermine];
        [self addSubview:self.dComeGoods];
        [self addSubview:self.close];
        [self addSubview:self.topLineView];
        
        [self.dSendGoods addSubview:self.dSendGoodsLbl];
        [self.dDetermine addSubview:self.dDetermineLbl];
        [self.dComeGoods addSubview:self.dComeGoodsLbl];
        [self.close addSubview:self.closeLbl];
        
        self.dSendGoods.handleClickBlock = ^(CommandButton *sender) {
            SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:1 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dDetermine.handleClickBlock = ^(CommandButton *sender) {
            SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:2 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dComeGoods.handleClickBlock = ^(CommandButton *sender) {
            SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:3 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.close.handleClickBlock = ^(CommandButton *sender) {
            SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
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
    
    self.dSendGoodsLbl.text = [NSString stringWithFormat:@"%ld", orderGoodsInfo.mySellNotSend];
    self.dDetermineLbl.text = [NSString stringWithFormat:@"%ld", orderGoodsInfo.myOrderAppraise];
    self.dComeGoodsLbl.text = [NSString stringWithFormat:@"%ld", orderGoodsInfo.mySellReceiving];
    self.closeLbl.text = [NSString stringWithFormat:@"%ld", orderGoodsInfo.mySellCancel];
    
    if (orderGoodsInfo.mySellNotSend > 0) {
        self.dSendGoodsLbl.hidden = NO;
    } else {
        self.dSendGoodsLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.myOrderAppraise > 0) {
        self.dDetermineLbl.hidden = NO;
    } else {
        self.dDetermineLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.mySellReceiving > 0) {
        self.dComeGoodsLbl.hidden = NO;
    } else {
        self.dComeGoodsLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.mySellCancel > 0) {
        self.closeLbl.hidden = NO;
    } else {
        self.closeLbl.hidden = YES;
    }
}

-(void)setUpUI{
    
    [self.dSendGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.mas_centerY);
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
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.height.equalTo(@1);
    }];
    
    [self.dSendGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dSendGoods.mas_top).offset(10);
        make.right.equalTo(self.dSendGoods.mas_right).offset(-(kScreenWidth/320*15));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.dDetermineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dDetermine.mas_top).offset(10);
        make.right.equalTo(self.dDetermine.mas_right).offset(-(kScreenWidth/320*15));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.dComeGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dComeGoods.mas_top).offset(10);
        make.right.equalTo(self.dComeGoods.mas_right).offset(-(kScreenWidth/320*15));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.closeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.close.mas_top).offset(10);
        make.right.equalTo(self.close.mas_right).offset(-(kScreenWidth/320*15));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


@end
