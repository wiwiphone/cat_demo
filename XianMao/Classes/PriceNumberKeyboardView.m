//
//  PriceNumberKeyboardView.m
//  XianMao
//
//  Created by Marvin on 17/3/24.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "PriceNumberKeyboardView.h"
#import "BlackView.h"
#import "MMNumberKeyboard.h"

@interface PriceNumberKeyboardView()<UITextFieldDelegate,MMNumberKeyboardDelegate>

@property (nonatomic, strong) UILabel * yuanLbl;
@property (nonatomic, strong) UILabel * jianyiLbl;
@property (nonatomic, strong) UIView * line;

@end


@implementation PriceNumberKeyboardView

- (UILabel *)yuanLbl{
    if (!_yuanLbl) {
        _yuanLbl = [[UILabel alloc] init];
        _yuanLbl.text = @"买入价 ¥";
        _yuanLbl.font = [UIFont systemFontOfSize:15];
        [_yuanLbl sizeToFit];
    }
    return _yuanLbl;
}


- (UILabel *)jianyiLbl{
    if (!_jianyiLbl) {
        _jianyiLbl = [[UILabel alloc] init];
        _jianyiLbl.text = @"期望出手价 ¥";
        _jianyiLbl.font = [UIFont systemFontOfSize:15];
        [_jianyiLbl sizeToFit];
    }
    return _jianyiLbl;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

- (UITextField *)yuanjiaTf{
    if (!_yuanjiaTf) {
        _yuanjiaTf = [[UITextField alloc] init];
        _yuanjiaTf.delegate = self;
    }
    return _yuanjiaTf;
}

- (UITextField *)jianyiTf{
    if (!_jianyiTf) {
        _jianyiTf = [[UITextField alloc] init];
        _jianyiTf.delegate = self;
    }
    return _jianyiTf;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.yuanLbl];
        [self addSubview:self.jianyiLbl];
        [self addSubview:self.line];
        
        
        [self addSubview:self.yuanjiaTf];
        [self addSubview:self.jianyiTf];
        
        
        MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        MMNumberKeyboard *keyboard2 = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        keyboard.returnKeyButtonStyle = MMNumberKeyboardButtonStyleRed;
        keyboard2.returnKeyButtonStyle = MMNumberKeyboardButtonStyleRed;
        keyboard.allowsDecimalPoint = YES;
        keyboard.delegate = self;
        keyboard2.allowsDecimalPoint = YES;
        keyboard2.delegate = self;
        
        self.yuanjiaTf.inputView = keyboard;
        self.jianyiTf.inputView = keyboard2;
        
    }
    return self;
}

- (void)numberKeyboardShoulddismiss:(MMNumberKeyboard *)numberKeyboard{
    if (self.dissmissKeyboard) {
        self.dissmissKeyboard();
    }
}

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard{
    if (self.inputPrice) {
        self.inputPrice(self.yuanjiaTf.text, self.jianyiTf.text);
    }
    return YES;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    
    self.yuanLbl.frame = CGRectMake(15, self.height/2 - self.yuanLbl.height/2, self.yuanLbl.width, self.yuanLbl.height);
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@0.5);
    }];
    
    self.jianyiLbl.frame = CGRectMake(kScreenWidth/2+15, self.height/2 - self.jianyiLbl.height/2, self.jianyiLbl.width, self.jianyiLbl.height);
    
    [self.yuanjiaTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yuanLbl.mas_right);
        make.right.equalTo(self.line.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.jianyiTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jianyiLbl.mas_right);
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)showInView:(UIView *)contentView{
    if (contentView) {
        [contentView addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}
@end
