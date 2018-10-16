//
//  ZBExpressionSectionBar.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//
#import "ZBExpressionSectionBar.h"

#define kButtonWidth 80.f
#define kPaddingRight 15.f
#define kVerticalPadding 5
@interface ZBExpressionSectionBar()

@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *likeBtn;

@end

@implementation ZBExpressionSectionBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kButtonWidth, 0, kButtonWidth,CGRectGetHeight(self.bounds) )];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        
        [_sendBtn addTarget:self action:@selector(keyboardSendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_sendBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _sendBtn.frame = CGRectMake(kScreenWidth-kButtonWidth, 0, kButtonWidth,CGRectGetHeight(self.bounds) );
}

- (void)keyboardSendButtonTapped:(UIButton *)sender {
    if (self.keyboardSendButtonTappedBlock) {
        self.keyboardSendButtonTappedBlock();
    }
}

@end
