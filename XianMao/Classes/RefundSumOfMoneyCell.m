//
//  RefundSumOfMoneyCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RefundSumOfMoneyCell.h"

@implementation RefundSumOfMoneyCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RefundSumOfMoneyCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 43;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RefundSumOfMoneyCell class]];
    return dict;
}


-(UILabel *)refundTotal
{
    if (!_refundTotal) {
        _refundTotal = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundTotal.font = [UIFont systemFontOfSize:14.0f];
        _refundTotal.textColor = [UIColor colorWithHexString:@"434342"];
    }
    return _refundTotal;
}

-(UILabel *)refundMoneyLbl
{
    if (!_refundMoneyLbl) {
        _refundMoneyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundMoneyLbl.font = [UIFont systemFontOfSize:12.0f];
        _refundMoneyLbl.textColor = [UIColor redColor];
        _refundMoneyLbl.textAlignment = NSTextAlignmentRight;
    }
    return _refundMoneyLbl;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.refundTotal];
        [self.contentView addSubview:self.refundMoneyLbl];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.refundTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/2);
    }];
    
    [self.refundMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.refundTotal.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

+ (NSMutableDictionary*)buildCellDict:(orderReturnItemListModel *)orderReturnItemListModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RefundSumOfMoneyCell class]];
    if (orderReturnItemListModel) {
        [dict setObject:orderReturnItemListModel forKey:@"orderReturnItemListModel"];
    }
    return dict;
}


-(void)updateCellWithDict:(NSDictionary *)dict
{
    orderReturnItemListModel * model = dict[@"orderReturnItemListModel"];
    if (model.totalPrice) {
        _refundMoneyLbl.text = [NSString stringWithFormat:@"¥%@",model.totalPriceStr];
    }
    //支付方式 0 支付宝 1 微信支付 2 银联 3 一网通 10 爱丁猫余额 50 分期乐 100 线下支付
    if (model.payType) {
        if ([model.payType integerValue] == 0) {
            _refundTotal.text = @"支付宝";
        }
        
        if ([model.payType integerValue] == 1) {
            _refundTotal.text = @"微信支付";
        }
        
        if ([model.payType integerValue] == 2) {
            _refundTotal.text = @"银联";
        }
        
        if ([model.payType integerValue] == 3) {
            _refundTotal.text = @"一网通";
        }
        
        if ([model.payType integerValue] == 10) {
            _refundTotal.text = @"爱丁猫余额";
        }
        
        if ([model.payType integerValue] == 50) {
            _refundTotal.text = @"分期乐";
        }
        
        if ([model.payType integerValue] == 100) {
            _refundTotal.text = @"线下支付";
        }
    }
    
}

@end
