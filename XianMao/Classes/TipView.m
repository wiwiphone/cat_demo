//
//  TipView.m
//  XianMao
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TipView.h"
#import "RTLabel.h"
#import "CopyLabel.h"

@interface TipView ()

@property (nonatomic, strong) UITextView *textLbl;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation TipView

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_closeBtn setImage:[UIImage imageNamed:@"Wrist_Diss"] forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
    }
    return _closeBtn;
}

-(UITextView *)textLbl{
    if (!_textLbl) {
        _textLbl = [[UITextView alloc] initWithFrame:CGRectZero];
        _textLbl.font = [UIFont systemFontOfSize:13.f];
        _textLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_textLbl setEditable:NO];
//        _textLbl.lineBreakMode = NSLineBreakByCharWrapping;
//        _textLbl.numberOfLines = 0;
//        _textLbl.adjustsFontSizeToFitWidth = YES;
    }
    return _textLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textLbl];
        [self addSubview:self.closeBtn];
        
        [self.closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickCloseBtn{
    if (self.handleDisButton) {
        self.handleDisButton();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(35);
        make.left.equalTo(self.mas_left).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(kScreenWidth-60-40));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}

-(void)getOrderInfo:(OrderInfo *)orderInfo{
    
//    self.textLbl.text = orderInfo.payTipVo.showText;
    [self.textLbl setText:orderInfo.payTipVo.showText];
    
}

@end
