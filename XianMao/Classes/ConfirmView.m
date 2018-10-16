//
//  ConfirmView.m
//  XianMao
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ConfirmView.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
@interface ConfirmView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *priceContentLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *desLbl;
@property (nonatomic, strong) UILabel *recoverBottomLbl;
@property (nonatomic, strong) UIButton *authBtn;

@property (nonatomic, strong) HighestBidVo *bidVO;
@property (nonatomic, strong) RecoveryGoodsVo *goodsVo;

@end

@implementation ConfirmView

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 15.f;
    }
    return _iconImageView;
}

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.font = [UIFont systemFontOfSize:13.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_nameLbl sizeToFit];
    }
    return _nameLbl;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:10.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:13.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)priceContentLbl{
    if (!_priceContentLbl) {
        _priceContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceContentLbl.font = [UIFont systemFontOfSize:10.f];
        _priceContentLbl.text = @"他出的回收价";
        _priceContentLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_priceContentLbl sizeToFit];
    }
    return _priceContentLbl;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
    }
    return _lineView;
}

-(UILabel *)desLbl{
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLbl.font = [UIFont systemFontOfSize:13.f];
        _desLbl.textColor = [UIColor colorWithHexString:@"989898"];
//        _desLbl.text = @"确认授权后，20分钟内，只有该回收商能拍下这件商品，20分钟后，可以重新授权给他或其他人。";
        _desLbl.numberOfLines = 0;
        [_desLbl sizeToFit];
    }
    return _desLbl;
}

-(UILabel *)recoverBottomLbl{
    if (!_recoverBottomLbl) {
        _recoverBottomLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _recoverBottomLbl.font = [UIFont systemFontOfSize:15.f];
        _recoverBottomLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _recoverBottomLbl.textAlignment = NSTextAlignmentCenter;
        _recoverBottomLbl.backgroundColor = [UIColor colorWithHexString:@"eeeeef"];
    }
    return _recoverBottomLbl;
}

-(UIButton *)authBtn{
    if (!_authBtn) {
        _authBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_authBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _authBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        _authBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _authBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_authBtn setTitle:@"确认" forState:UIControlStateNormal];  //根据产品需求进行更改   2016.4.8 Feng
    }
    return _authBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.priceLbl];
        [self addSubview:self.priceContentLbl];
        [self addSubview:self.lineView];
        [self addSubview:self.desLbl];
        [self addSubview:self.recoverBottomLbl];
        [self addSubview:self.authBtn];
        
        [self.authBtn addTarget:self action:@selector(clickAuthBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)clickAuthBtn{
    if ([self.conDelegate respondsToSelector:@selector(authUser:)]) {
        [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsAuthUserViewCode regionCode:RecoveryGoodsDetailViewCode referPageCode:RecoveryGoodsDetailViewCode andData:@{@"goodsId":self.goodsVo.goodsSn}];
        [self.conDelegate authUser:self.bidVO];
    }
}

-(void)setUpUI{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.priceContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(17);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.recoverBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.right.equalTo(self.mas_right).offset(-15);
        make.left.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(30);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.width.equalTo(@30);
//        make.height.equalTo(@30);
//    }];
//    
//    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_top);
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//    }];
//    
//    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.iconImageView.mas_bottom);
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//    }];
//    
//    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_top);
//        make.right.equalTo(self.mas_right).offset(-15);
//    }];
//    
//    [self.priceContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.iconImageView.mas_bottom);
//        make.right.equalTo(self.mas_right).offset(-15);
//    }];
//    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.equalTo(@1);
//    }];
//    
//    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.mas_bottom).offset(17);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//    }];
//    
//    [self.recoverBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-20);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_centerX);
//        make.height.equalTo(@40);
//    }];
//    
//    [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-20);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.left.equalTo(self.mas_centerX);
//        make.height.equalTo(@40);
//    }];
}

-(void)getBidVO:(HighestBidVo *)bidVO andGoodsVO:(RecoveryGoodsVo *)goodsVo{
    if (bidVO) {
        _bidVO = bidVO;
    }
    if (goodsVo) {
        _goodsVo = goodsVo;
    }
    RecoveryUserVo *userVo = bidVO.recoveryUserVo;
    if (userVo) {
        self.nameLbl.text = userVo.username;
        self.contentLbl.text = [NSString stringWithFormat:@"成功收货%ld件", (long)userVo.recoveryNum];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userVo.avatar] placeholderImage:nil];
        self.priceLbl.text = [NSString stringWithFormat:@"%.2f元", bidVO.price];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsVo.exprTime/1000];
        NSInteger time = [date minute];
        self.desLbl.text = [NSString stringWithFormat:@"确认卖给他以后，将生成定单并锁定商品，买家有%ld分钟的时间可以付款。", (long)time];  //根据产品需求进行更改   2016.4.8 Feng
        self.recoverBottomLbl.text = [NSString stringWithFormat:@"回收价：%.2f", bidVO.price];
        [self setUpUI];
    }
}

@end
