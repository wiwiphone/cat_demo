//
//  RealRefundCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RealRefundCell.h"

@implementation RealRefundCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RealRefundCell class]);
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
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RealRefundCell class]];
    return dict;
}


-(UILabel *)refundTotal
{
    if (!_refundTotal) {
        _refundTotal = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundTotal.font = [UIFont systemFontOfSize:14.0f];
        _refundTotal.textColor = [UIColor colorWithHexString:@"434342"];
        _refundTotal.text = @"实际退款总金额:";
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

//+ (NSMutableDictionary*)buildCellDict:(getrderReturnsModel *)getrderReturnsModel
//{
//    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RealRefundCell class]];
//    if (getrderReturnsModel) {
//        [dict setObject:getrderReturnsModel forKey:@"getrderReturnsModel"];
//    }
//    return dict;
//}

+(NSMutableDictionary *)buildCellTitle:(NSString *)totalAmount
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RealRefundCell class]];
        if (totalAmount) {
            [dict setObject:totalAmount forKey:@"money"];
        }
        return dict;
}


-(void)updateCellWithDict:(NSDictionary *)dict
{
    NSString * totalAmount = dict[@"money"];
    if (totalAmount) {
        _refundMoneyLbl.text = [NSString stringWithFormat:@"¥%@",totalAmount];
    }
    
}

@end
