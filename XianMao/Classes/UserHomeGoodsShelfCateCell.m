//
//  UserHomeGoodsShelfCateCell.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "UserHomeGoodsShelfCateCell.h"
#import "Command.h"
#import "Masonry.h"
#import "RecoverCollectionViewController.h"
#import "Session.h"
#import "OrderGoodsInfoVo.h"
#import "DataSources.h"

@interface UserHomeGoodsShelfCateCell ()

@property (nonatomic, strong) VerticalCommandButton *dSendGoods;
@property (nonatomic, strong) VerticalCommandButton *dDetermine;
@property (nonatomic, strong) VerticalCommandButton *dComeGoods;
@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UILabel *dSendGoodsLbl;
@property (nonatomic, strong) UILabel *dDetermineLbl;
@property (nonatomic, strong) UILabel *dComeGoodsLbl;


@end

@implementation UserHomeGoodsShelfCateCell



-(UILabel *)dComeGoodsLbl{
    if (!_dComeGoodsLbl) {
        _dComeGoodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dComeGoodsLbl.font = [UIFont systemFontOfSize:12.f];
        _dComeGoodsLbl.textColor = [UIColor whiteColor];
        _dComeGoodsLbl.layer.masksToBounds = YES;
        _dComeGoodsLbl.layer.cornerRadius = 9;
        _dComeGoodsLbl.layer.borderWidth = 1.f;
        _dComeGoodsLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dComeGoodsLbl.textAlignment = NSTextAlignmentCenter;
        _dComeGoodsLbl.backgroundColor = [UIColor blackColor];
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
        _dDetermineLbl.layer.borderWidth = 1.f;
        _dDetermineLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        _dDetermineLbl.textAlignment = NSTextAlignmentCenter;
        _dDetermineLbl.backgroundColor = [UIColor blackColor];
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
        _dSendGoodsLbl.layer.borderWidth = 1.f;
        _dSendGoodsLbl.layer.borderColor = [UIColor whiteColor].CGColor;
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
        [_dSendGoods setImage:[UIImage imageNamed:@"UserHome_Shelf_One"] forState:UIControlStateNormal];
        [_dSendGoods setTitle:@"待审核" forState:UIControlStateNormal];
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
        [_dDetermine setImage:[UIImage imageNamed:@"UserHome_Shelf_Two"] forState:UIControlStateNormal];
        [_dDetermine setTitle:@"售卖中" forState:UIControlStateNormal];
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
        [_dComeGoods setImage:[UIImage imageNamed:@"UserHome_Shelf_Three"] forState:UIControlStateNormal];
        [_dComeGoods setTitle:@"已下架" forState:UIControlStateNormal];
        [_dComeGoods setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _dComeGoods.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dComeGoods;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserHomeGoodsShelfCateCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 88.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserHomeGoodsShelfCateCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.dSendGoods];
        [self addSubview:self.dDetermine];
        [self addSubview:self.dComeGoods];
        [self addSubview:self.topLineView];
        
        [self.dSendGoods addSubview:self.dSendGoodsLbl];
        [self.dDetermine addSubview:self.dDetermineLbl];
        [self.dComeGoods addSubview:self.dComeGoodsLbl];

        
        self.dSendGoods.handleClickBlock = ^(CommandButton *sender) {
            RecoverCollectionViewController *viewController = [[RecoverCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:3 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dDetermine.handleClickBlock = ^(CommandButton *sender) {
            RecoverCollectionViewController *viewController = [[RecoverCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:1 inSection:0];
            viewController.collectionViewIP = indexP;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.dComeGoods.handleClickBlock = ^(CommandButton *sender) {
            RecoverCollectionViewController *viewController = [[RecoverCollectionViewController alloc] init];
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:2 inSection:0];
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
    self.dSendGoodsLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myGoodsValid];
    self.dDetermineLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myGoodsUp];
    self.dComeGoodsLbl.text = [NSString stringWithFormat:@"%ld", (long)orderGoodsInfo.myGoodsDown];
    
    if (orderGoodsInfo.myGoodsValid > 0) {
        self.dSendGoodsLbl.hidden = NO;
    } else {
        self.dSendGoodsLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.myGoodsUp > 0) {
        self.dDetermineLbl.hidden = NO;
    } else {
        self.dDetermineLbl.hidden = YES;
    }
    
    if (orderGoodsInfo.myGoodsDown > 0) {
        self.dComeGoodsLbl.hidden = NO;
    } else {
        self.dComeGoodsLbl.hidden = YES;
    }
    
}

-(void)setUpUI{
    
    [self.dSendGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kScreenWidth/3));
    }];

    
    [self.dDetermine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.dSendGoods.mas_right);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    
    [self.dComeGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.dDetermine.mas_right);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    

    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.height.equalTo(@1);
    }];
    
    [self.dSendGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dSendGoods.mas_top).offset(10);
        make.right.equalTo(self.dSendGoods.mas_right).offset(-(kScreenWidth/320*35));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.dDetermineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dDetermine.mas_top).offset(10);
        make.right.equalTo(self.dDetermine.mas_right).offset(-(kScreenWidth/320*35));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.dComeGoodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dComeGoods.mas_top).offset(10);
        make.right.equalTo(self.dComeGoods.mas_right).offset(-(kScreenWidth/320*35));
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
