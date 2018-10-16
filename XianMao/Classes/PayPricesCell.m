//
//  PayPricesCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayPricesCell.h"
#import "Command.h"
#import "BoughtCollectionViewController.h"

@interface PayPricesCell()

@property (nonatomic, strong) UILabel * price;
@property (nonatomic, strong) CommandButton * orderBtn;
@property (nonatomic, strong) CommandButton * homeBtn;

@end

@implementation PayPricesCell

-(UILabel *)price
{
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.textColor = [UIColor colorWithHexString:@"333333"];
        _price.font = [UIFont systemFontOfSize:15];
        _price.textAlignment = NSTextAlignmentLeft;
        [_price sizeToFit];
    }
    return _price;
}

-(CommandButton *)orderBtn
{
    if (!_orderBtn) {
        _orderBtn = [[CommandButton alloc] init];
        [_orderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _orderBtn.layer.borderWidth = 0.5;
        _orderBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _orderBtn;
}


-(CommandButton *)homeBtn
{
    if (!_homeBtn) {
        _homeBtn = [[CommandButton alloc] init];
        [_homeBtn setTitle:@"回到首页" forState:UIControlStateNormal];
        [_homeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _homeBtn.layer.borderWidth = 0.5;
        _homeBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        _homeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _homeBtn;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.price];
        [self.contentView addSubview:self.orderBtn];
        [self.contentView addSubview:self.homeBtn];
        
        self.orderBtn.handleClickBlock = ^(CommandButton *sender){
            [[CoordinatingController sharedInstance] popToRootViewControllerAnimated:YES];
            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.homeBtn.handleClickBlock = ^(CommandButton *sender){
            [[CoordinatingController sharedInstance] popToRootViewControllerAnimated:YES];
            [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:0];
        };
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(52);
        make.top.equalTo(self.price.mas_bottom).offset(23);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*119, 33));
    }];

    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.price.mas_bottom).offset(23);
        make.left.equalTo(self.orderBtn.mas_right).offset(33);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*119, 33));
    }];
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PayPricesCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 105;

    return height;
}

+ (NSMutableDictionary *)buildCellDict:(OrderDetailInfo *)orderDetailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PayPricesCell class]];
    if (orderDetailInfo) {
        [dict setObject:orderDetailInfo forKey:@"orderDetailInfo"];
    }
    return dict;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    OrderDetailInfo *orderDetailInfo = dict[@"orderDetailInfo"];
    self.price.text = [NSString stringWithFormat:@"实付总计:¥%ld", orderDetailInfo.orderInfo.actual_pay_cent/100];
}


@end
