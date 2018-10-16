//
//  PartialView.m
//  XianMao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PartialView.h"
#import "DigitalKeyboardView.h"
#import "ForumPostDetailViewController.h"
#import "MMNumberKeyboard.h"

@interface PartialView () <UITextFieldDelegate, MMNumberKeyboardDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UILabel *surplusMoney;
//@property (nonatomic, strong) UIButton *timeLbl;
@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) UIView *lineView3;
@property (nonatomic, strong) UILabel *payingNum;

@property (nonatomic, strong) UILabel *renminbiLbl;
@property (nonatomic, strong) ParyialDo *partialDo;

@end

@implementation PartialView

-(UILabel *)renminbiLbl{
    if (!_renminbiLbl) {
        _renminbiLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _renminbiLbl.font = [UIFont systemFontOfSize:15.f];
        _renminbiLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_renminbiLbl sizeToFit];
        _renminbiLbl.text = @"¥";
    }
    return _renminbiLbl;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        keyboard.allowsDecimalPoint = YES;
        keyboard.delegate = self;
        _textField.inputView = keyboard;
//        [_textField setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//        _textField.titleLabel.font = [UIFont systemFontOfSize:15.f];
//        _textField.titleLabel.textAlignment = NSTextAlignmentLeft;
//        _textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _textField;
}

-(UILabel *)payingNum{
    if (!_payingNum) {
        _payingNum = [[UILabel alloc] initWithFrame:CGRectZero];
        _payingNum.textColor = [UIColor colorWithHexString:@"333333"];
        _payingNum.font = [UIFont systemFontOfSize:14.f];
        [_payingNum sizeToFit];
        _payingNum.text = @"本次支付金额";
    }
    return _payingNum;
}

-(UIView *)lineView3{
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView3.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView3;
}

-(PayTypeView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [[PayTypeView alloc] initWithFrame:CGRectZero];
        _payTypeView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _payTypeView;
}

-(UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView2.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView2;
}

//-(UIButton *)timeLbl{
//    if (!_timeLbl) {
//        _timeLbl = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_timeLbl setImage:[UIImage imageNamed:@"verify_clock"] forState:UIControlStateNormal];
//        [_timeLbl setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//        _timeLbl.titleLabel.font = [UIFont systemFontOfSize:13.f];
//        [_timeLbl sizeToFit];
////        [_timeLbl setTitle:@" 12分13秒" forState:UIControlStateNormal];
//    }
//    return _timeLbl;
//}

-(UILabel *)surplusMoney{
    if (!_surplusMoney) {
        _surplusMoney = [[UILabel alloc] initWithFrame:CGRectZero];
        _surplusMoney.font = [UIFont systemFontOfSize:13.f];
        _surplusMoney.textColor = [UIColor colorWithHexString:@"f54e49"];
        [_surplusMoney sizeToFit];
        _surplusMoney.text = @"还需要";
    }
    return _surplusMoney;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_closeBtn setImage:[UIImage imageNamed:@"Partial_Close_MF"] forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
    }
    return _closeBtn;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"爱丁猫分次支付";
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF;
        [self addSubview:self.titleLbl];
        [self addSubview:self.closeBtn];
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        lineView1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [self addSubview:lineView1];
        self.lineView1 = lineView1;
        [self addSubview:self.surplusMoney];
//        [self addSubview:self.timeLbl];
        [self addSubview:self.lineView2];
        [self addSubview:self.payTypeView];
        [self addSubview:self.lineView3];
        [self addSubview:self.payingNum];
        [self addSubview:self.renminbiLbl];
        [self addSubview:self.textField];
        
        self.payTypeView.showPayWayView = ^(){
            if (weakSelf.showPayWayView) {
                weakSelf.showPayWayView();
            }
        };
        
        [self.textField addTarget:self action:@selector(inputPriceNum) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)getPayingPrice:(CGFloat )payingPrice{
//    [self.textField setTitle:[NSString stringWithFormat:@"%.2f", payingPrice] forState:UIControlStateNormal];
}

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard
{
    if (self.inputPrice) {
        self.inputPrice(self.textField.text, self.partialDo);
    }
    return YES;
}

-(void)inputPriceNum{
    
}

-(void)getPartialDo:(ParyialDo *)partialDo{
    [self.payTypeView getPartialDo:partialDo];
    self.partialDo = partialDo;
    self.surplusMoney.text = [NSString stringWithFormat:@"本单还需支付¥%.2f", partialDo.surplusPriceNum];
}

-(void)clickCloseBtn{
    if (self.clickProtialCloseBtn) {
        self.clickProtialCloseBtn();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left).offset(18);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@0.5);
    }];
    
    [self.surplusMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(18);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
//    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView1.mas_bottom).offset(18);
//        make.right.equalTo(self.mas_right).offset(-12);
//    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surplusMoney.mas_bottom).offset(18);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@0.5);
    }];
    
    [self.payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@60);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTypeView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@0.5);
    }];
    
    [self.payingNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView3.mas_bottom).offset(18);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
    [self.renminbiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payingNum.mas_bottom).offset(18);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@10);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payingNum.mas_bottom).offset(15);
        make.left.equalTo(self.renminbiLbl.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@24);
    }];
}

@end
