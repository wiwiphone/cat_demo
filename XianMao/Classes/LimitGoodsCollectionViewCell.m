//
//  LimitGoodsCollectionViewCell.m
//  XianMao
//
//  Created by Marvin on 2017/6/22.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "LimitGoodsCollectionViewCell.h"
#import "Command.h"
#import "GoodsInfo.h"
#import "ActivityInfo.h"

@interface LimitGoodsCollectionViewCell()

@property (nonatomic, strong) XMWebImageView *goodsImage;
@property (nonatomic, strong) UILabel *summaryLbl;
@property (nonatomic, strong) UILabel *goodsNameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) CommandButton *buyBtn;
@property (nonatomic, strong) GoodsInfo *goodsInfo;

@end

@implementation LimitGoodsCollectionViewCell

- (XMWebImageView *)goodsImage{
    if (!_goodsImage) {
        _goodsImage = [[XMWebImageView alloc] init];
        _goodsImage.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _goodsImage;
}

- (UILabel *)goodsNameLbl{
    if (!_goodsNameLbl) {
        _goodsNameLbl = [[UILabel alloc] init];
        _goodsNameLbl.font = [UIFont boldSystemFontOfSize:15];
        [_goodsNameLbl sizeToFit];
    }
    return _goodsNameLbl;
}

- (UILabel *)summaryLbl{
    if (!_summaryLbl) {
        _summaryLbl = [[UILabel alloc] init];
        _summaryLbl.font = [UIFont systemFontOfSize:15];
        _summaryLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_summaryLbl sizeToFit];
    }
    return _summaryLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] init];
        _priceLbl.textColor = [DataSources colorf9384c];
        _priceLbl.font = [UIFont systemFontOfSize:15];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

- (CommandButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [[CommandButton alloc] init];
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        _buyBtn.layer.cornerRadius = 3;
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _buyBtn.backgroundColor = [DataSources colorf9384c];
    }
    return _buyBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        self.contentView.layer.borderColor = [UIColor colorWithHexString:@"f2f2f2"].CGColor;
        self.contentView.layer.borderWidth = 1;
        [self.contentView addSubview:self.goodsImage];
        [self.contentView addSubview:self.goodsNameLbl];
        [self.contentView addSubview:self.summaryLbl];
        [self.contentView addSubview:self.buyBtn];
        [self.contentView addSubview:self.priceLbl];
        
        WEAKSELF;
        _buyBtn.handleClickBlock = ^(CommandButton *sender) {
            if (self.handleBuyBtnBlock && self.goodsInfo) {
                weakSelf.handleBuyBtnBlock(weakSelf.goodsInfo);
            }
        };
    }
    return self;
}


- (void)getGoodsInfo:(GoodsInfo *)goodsInfo{

    if (goodsInfo) {
        _goodsInfo = goodsInfo;
        
        [self.goodsImage setImageWithURL:goodsInfo.thumbUrl XMWebImageScaleType:XMWebImageScale200x200];
        
        self.goodsNameLbl.text = goodsInfo.goodsName;
        
        self.summaryLbl.text = goodsInfo.summary;
        
        self.priceLbl.text = [NSString stringWithFormat:@"限时价格 ¥ %.2f",goodsInfo.activityBaseInfo.activityPrice];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*90, kScreenWidth/375*90));
    }];
    
    [self.goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.mas_top);
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.summaryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsNameLbl.mas_bottom).offset(2);
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryLbl.mas_bottom).offset(4);
        make.left.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImage.mas_bottom);
        make.left.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*50, 20));
    }];
}

@end
