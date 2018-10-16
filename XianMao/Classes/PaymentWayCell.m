//
//  PaymentWayCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PaymentWayCell.h"

@implementation PaymentWayCell

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PaymentWayCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait
{
    CGFloat height = 43;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PaymentWayCell class]];
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    
}


-(UILabel *)paymentWayLbl
{
    if (!_paymentWayLbl) {
        _paymentWayLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _paymentWayLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _paymentWayLbl.font = [UIFont systemFontOfSize:14.0f];
        _paymentWayLbl.text = @"保价到付(更安全)";
    }
    return _paymentWayLbl;
}

-(UISwitch *)sw
{
    if (!_sw) {
        _sw = [[UISwitch alloc] initWithFrame:CGRectZero];
        _sw.onTintColor = [DataSources colorf9384c];
        _sw.transform = CGAffineTransformMakeScale(.75, .75);
    }
    return _sw;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.paymentWayLbl];
        [self.contentView addSubview:self.sw];
        [self.sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

//选择报价到付(更安全)
-(void)sw:(UISwitch *)sw
{
    if (sw.on) {
        if ([self.delegate respondsToSelector:@selector(showPaymentWay:)]) {
            [self.delegate showPaymentWay:sw];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(dismissPaymentWay:)]) {
            [self.delegate dismissPaymentWay:sw];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.paymentWayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-64);
    }];
    
    [self.sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.paymentWayLbl.mas_right);
        make.center.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

@end
