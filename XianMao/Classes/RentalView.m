//
//  RentalView.m
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RentalView.h"
#import "OrderInfo.h"


@interface RentalView()<UITextFieldDelegate>
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UILabel * titleLbl;

@property (nonatomic, strong) NSString * tempStr;


@end

@implementation RentalView

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _titleLbl.font = [UIFont systemFontOfSize:14];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UITextField *)tf{
    if (!_tf) {
        _tf = [[UITextField alloc] init];
        _tf.keyboardType = UIKeyboardTypeDecimalPad;
        _tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _tf.font = [UIFont boldSystemFontOfSize:15];
        _tf.textColor = [UIColor colorWithHexString:@"f4433e"];
        _tf.placeholder = @"跟店家确认后输入";
        _tf.textAlignment = NSTextAlignmentRight;
    }
    return _tf;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        if (title && title.length > 0) {
            self.title = title;
            self.titleLbl.text = title;
        }
        [self addSubview:self.titleLbl];
        [self addSubview:self.tf];
        
        self.tf.tag = 1229;
        
        _tf.delegate = self;
        [self.tf addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];

    }
    return self;
}

-(void)textFieldEditingChanged:(UITextField *)tf{

    [self resetTextFieldTextColor:tf];

}

- (void)getOrderPrice:(OrderInfo *)orderInfo{
    self.tf.text = [NSString stringWithFormat:@"%.2f",orderInfo.totalPrice];
    self.tf.enabled = NO;
}

- (void)getreWardMoneyPay:(OrderInfo *)orderInfo{
    self.tf.text = [NSString stringWithFormat:@"%.2f",orderInfo.reward_money_pay];
    self.tf.enabled = NO;
}

- (void)resetTextFieldTextColor:(UITextField *)tf{
    
    NSArray * stringArray = [[NSString stringWithFormat:@"%@",tf.text] componentsSeparatedByString:@"¥"];
    NSString * str13 = [stringArray componentsJoinedByString:@""];
    tf.text = [NSString stringWithFormat:@"¥%@",str13];
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",str13]];
    NSRange range = [[hintString string] rangeOfString:[NSString stringWithFormat:@"¥"]];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f4433e"] range:range];
    self.tf.attributedText = hintString;
    
    if (self.sumOfConsumption) {
        self.sumOfConsumption(str13);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"totalPriceChange" object:self.tf];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deductibleAmountNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"totalPriceChange" object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-35);
        make.height.mas_equalTo(@40);
    }];
}

@end
