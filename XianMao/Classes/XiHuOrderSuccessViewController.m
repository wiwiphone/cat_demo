//
//  XiHuOrderSuccessViewController.m
//  XianMao
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "XiHuOrderSuccessViewController.h"
#import "Command.h"

@interface XiHuOrderSuccessViewController ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *successLbl;
@property (nonatomic, strong) UIView *detailView;

@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *consumePrice;
@property (nonatomic, strong) UILabel *presentPrice;
@property (nonatomic, strong) UILabel *orderIDLabel;

@property (nonatomic, strong) CommandButton *finishBtn;
@end

@implementation XiHuOrderSuccessViewController

-(CommandButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"333333"];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 20.f;
    }
    return _finishBtn;
}

-(UILabel *)orderIDLabel{
    if (!_orderIDLabel) {
        _orderIDLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderIDLabel.font = [UIFont systemFontOfSize:12.f];
        _orderIDLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [_orderIDLabel sizeToFit];
    }
    return _orderIDLabel;
}

-(UILabel *)presentPrice{
    if (!_presentPrice) {
        _presentPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _presentPrice.font = [UIFont systemFontOfSize:12.f];
        _presentPrice.textColor = [UIColor colorWithHexString:@"333333"];
        [_presentPrice sizeToFit];
    }
    return _presentPrice;
}

-(UILabel *)consumePrice{
    if (!_consumePrice) {
        _consumePrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _consumePrice.font = [UIFont systemFontOfSize:12.f];
        _consumePrice.textColor = [UIColor colorWithHexString:@"333333"];
        [_consumePrice sizeToFit];
    }
    return _consumePrice;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _lineView;
}

-(UILabel *)shopName{
    if (!_shopName) {
        _shopName = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopName.font = [UIFont systemFontOfSize:14.f];
        _shopName.textColor = [UIColor colorWithHexString:@"333333"];
        [_shopName sizeToFit];
    }
    return _shopName;
}

-(UIView *)detailView{
    if (!_detailView) {
        _detailView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailView.backgroundColor = [UIColor whiteColor];
    }
    return _detailView;
}

-(UILabel *)successLbl{
    if (!_successLbl) {
        _successLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _successLbl.font = [UIFont systemFontOfSize:15.f];
        _successLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_successLbl sizeToFit];
        _successLbl.text = @"支付成功";
    }
    return _successLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.image = [UIImage imageNamed:@"OrderPaySuccess"];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];

    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.successLbl];
    [self.view addSubview:self.detailView];
    [self.detailView addSubview:self.shopName];
    [self.detailView addSubview:self.lineView];
    [self.detailView addSubview:self.consumePrice];
    [self.detailView addSubview:self.presentPrice];
    [self.detailView addSubview:self.orderIDLabel];
    [self.view addSubview:self.finishBtn];
    
    self.presentPrice.text = [NSString stringWithFormat:@"消费金额:%.2f",self.presentPriceStr.doubleValue + self.consumePriceStr.doubleValue];
    self.consumePrice.text = [NSString stringWithFormat:@"实付金额:%@",self.consumePriceStr];
    if (self.orderId && self.orderId.length > 0) {
        self.orderIDLabel.text = [NSString stringWithFormat:@"订单编号:%@",self.orderId];
    }
    self.shopName.text = self.topBarTitle;
    
    WEAKSELF;
    self.finishBtn.handleClickBlock = ^(CommandButton *sender){
        [weakSelf dismiss];
    };
    
    [self setUpUI];
}

-(void)setUpUI{
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.successLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successLbl.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@133);
    }];
    
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView.mas_top).offset(15);
        make.left.equalTo(self.detailView.mas_left).offset(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopName.mas_bottom).offset(12);
        make.left.equalTo(self.detailView.mas_left);
        make.right.equalTo(self.detailView.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.consumePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.left.equalTo(self.detailView.mas_left).offset(12);
    }];
    
    [self.presentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consumePrice.mas_bottom).offset(12);
        make.left.equalTo(self.detailView.mas_left).offset(12);
    }];
    
    [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.presentPrice.mas_bottom).offset(12);
        make.left.equalTo(self.detailView.mas_left).offset(12);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView.mas_bottom).offset(42);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@190);
        make.height.equalTo(@40);
    }];
    
}

@end
