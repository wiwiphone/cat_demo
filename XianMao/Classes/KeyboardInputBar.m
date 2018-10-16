//
//  KeyboardInputBarView.m
//  XianMao
//
//  Created by simon cai on 11/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "KeyboardInputBar.h"

@interface KeyboardInputBar () <UITextViewDelegate>

@property(nonatomic, weak, readwrite) PlaceHolderTextView *textView;
@property(nonatomic,retain) UIButton *emojiBtn;
@property(nonatomic,retain) UIButton *atBtn;
@property(nonatomic,retain) UIButton *arrowBtn;
@end

@implementation KeyboardInputBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor =[UIColor redColor];
        
        // 初始化输入框
        PlaceHolderTextView *textView = [[PlaceHolderTextView  alloc] initWithFrame:CGRectZero];
        textView.returnKeyType = UIReturnKeySend;
        textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        textView.placeHolder = @"";
        textView.delegate = self;
        [self addSubview:textView];
        _textView = textView;
        
        _arrowBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_arrowBtn addTarget:self action:@selector(testdd:) forControlEvents:UIControlEventTouchUpInside];
        _arrowBtn.backgroundColor = [UIColor greenColor];
        [self addSubview:_arrowBtn];
    }
    return self;
}

- (void)dealloc {
    self.textView = nil;
    self.emojiBtn = nil;
    self.atBtn = nil;
    self.arrowBtn = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textView.frame = CGRectMake(CGRectGetWidth(self.bounds)-CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds)-100, CGRectGetHeight(self.bounds));
    
    _arrowBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
    
}

- (void)testdd:(UIButton*)sender
{
    [_textView resignFirstResponder];
}

@end
