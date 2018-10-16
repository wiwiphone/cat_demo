//
//  C2CGoodsPriceView.m
//  XianMao
//
//  Created by WJH on 16/10/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "C2CGoodsPriceView.h"

@interface C2CGoodsPriceView()

@property (nonatomic, strong) UILabel * shoppingPrice;
@property (nonatomic, strong) UILabel * marketPrice;
@property (nonatomic, strong) UIView * line;

@end

@implementation C2CGoodsPriceView


-(UILabel *)shoppingPrice
{
    if (!_shoppingPrice) {
        _shoppingPrice = [[UILabel alloc] init];
        _shoppingPrice.font = [UIFont systemFontOfSize:14];
        _shoppingPrice.textColor = [UIColor colorWithHexString:@"f4433e"];
        [_shoppingPrice sizeToFit];
    }
    return _shoppingPrice;
}

-(UILabel *)marketPrice
{
    if (!_marketPrice) {
        _marketPrice = [[UILabel alloc] init];
        _marketPrice.font = [UIFont systemFontOfSize:14];
        _marketPrice.textColor = [UIColor colorWithHexString:@"999999"];
        [_marketPrice sizeToFit];
    }
    return _marketPrice;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _line;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.shoppingPrice];
        [self addSubview:self.marketPrice];
        [self.marketPrice addSubview:self.line];
    }
    return self;
}

-(void)getGoodsDetailInfo:(GoodsInfo *)goodsInfo
{
    if (goodsInfo) {
        if (goodsInfo.meowReduceTitle.length > 0) {
            self.shoppingPrice.text = goodsInfo.meowReduceTitle;
        }else{
            self.shoppingPrice.text = [NSString stringWithFormat:@"¥%.2f", goodsInfo.shopPrice];
        }
        if (goodsInfo.marketPrice > 0) {
            self.marketPrice.text = [NSString stringWithFormat:@"¥%.2f", goodsInfo.marketPrice];
        }else{
            self.marketPrice.text = @"零售价";
            self.line.hidden = YES;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.shoppingPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(1);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.marketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-1);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.marketPrice.mas_centerY);
        make.left.equalTo(self.marketPrice.mas_left);
        make.right.equalTo(self.marketPrice.mas_right);
        make.height.mas_equalTo(@1);
    }];
}
@end
