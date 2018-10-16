//
//  DigitalKeyboardView.m
//  XianMao
//
//  Created by simon cai on 3/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "DigitalKeyboardView.h"
#import "Command.h"
#import "UIImage+Color1.h"


@implementation DigitalInputContainerView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillShowKeyboardNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillHideKeyboardNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification {
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSNumber *curveValue = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    UIViewAnimationOptions options = animationCurve << 16;
    
    WEAKSELF;
    CGRect rect;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        rect = CGRectMake(0, kScreenHeight-endRect.size.height-self.height, kScreenWidth, self.height);
    } else {
        rect = CGRectMake(0, kScreenHeight, kScreenWidth, self.height);
    }
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         weakSelf.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.frame = rect;
                     }];
}

@end

@interface DigitalPriceInputView ()

@end


@implementation DigitalPriceInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat height = 49;
        
        TapDetectingLabel *priceTitleLbl = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        priceTitleLbl.font = [UIFont systemFontOfSize:14.f];
//        priceTitleLbl.text = @"售价";
        priceTitleLbl.text = @"买入价";
        [priceTitleLbl sizeToFit];
        priceTitleLbl.frame = CGRectMake(20, 0, priceTitleLbl.width+10, 48);
        [self addSubview:priceTitleLbl];
        
        TapDetectingLabel *moneyLbl = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        moneyLbl.font = [UIFont systemFontOfSize:15.f];
        moneyLbl.text = @"￥";
        moneyLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [moneyLbl sizeToFit];
        moneyLbl.frame = CGRectMake(priceTitleLbl.right, 0, moneyLbl.width+5, 48);
        [self addSubview:moneyLbl];
        
        UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(moneyLbl.right, 0, kScreenWidth/2-(moneyLbl.right+8), 48)];
        priceTextField.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:priceTextField];
        priceTextField.textColor = [UIColor blackColor];
        priceTextField.text = @"";
        _priceTextField = priceTextField;
        
        WEAKSELF;
        priceTitleLbl.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [weakSelf.priceTextField becomeFirstResponder];
        };
        moneyLbl.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [weakSelf.priceTextField becomeFirstResponder];
        };
        
        
        TapDetectingLabel *marketPriceTitleLbl = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        marketPriceTitleLbl.font = [UIFont systemFontOfSize:14.f];
        
//        marketPriceTitleLbl.text = @"购入价";
        marketPriceTitleLbl.text = @"出售价";
        [marketPriceTitleLbl sizeToFit];
        marketPriceTitleLbl.frame = CGRectMake(kScreenWidth/2+20, 0, marketPriceTitleLbl.width+10, 48);
        [self addSubview:marketPriceTitleLbl];
        
        TapDetectingLabel *marketMoneyLbl = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        marketMoneyLbl.font = [UIFont systemFontOfSize:15.f];
        marketMoneyLbl.text = @"￥";
        marketMoneyLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [marketMoneyLbl sizeToFit];
        marketMoneyLbl.frame = CGRectMake(marketPriceTitleLbl.right, 0, marketMoneyLbl.width+5, 48);
        [self addSubview:marketMoneyLbl];
        
        marketPriceTitleLbl.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [weakSelf.marketPriceTextField becomeFirstResponder];
        };
        marketMoneyLbl.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [weakSelf.marketPriceTextField becomeFirstResponder];
        };
        
        UITextField *marketPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(marketMoneyLbl.right, 0, kScreenWidth-(marketMoneyLbl.right+8), 48)];
        marketPriceTextField.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:marketPriceTextField];
        marketPriceTextField.textColor = [UIColor colorWithHexString:@"999999"];
        marketPriceTextField.text = @"";
        _marketPriceTextField = marketPriceTextField;
        
        
        CALayer *sepLine1 = [CALayer layer];
        sepLine1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:sepLine1];
        sepLine1.frame = CGRectMake(kScreenWidth/2, 0, 0.5, height);

        
//        CALayer *bottomLine1 = [CALayer layer];
//        bottomLine1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
//        [self.layer addSublayer:bottomLine1];
//        bottomLine1.frame = CGRectMake(20, height/2, kScreenWidth-20, 0.5);
        
        CALayer *bottomLine = [CALayer layer];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:bottomLine];
        bottomLine.frame = CGRectMake(0, height-0.5, kScreenWidth, 0.5);
        
        
        self.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return self;
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)setShopPriceCent:(NSInteger)shopPriceCent {
    if (shopPriceCent>0) {
        _priceTextField.text = [[NSNumber numberWithDouble:(double)shopPriceCent/100.f] stringValue];
    }
}

- (void)setMarketPriceCent:(NSInteger)marketPriceCent {
    if (marketPriceCent>0) {
        _marketPriceTextField.text = [[NSNumber numberWithDouble:(double)marketPriceCent/100.f] stringValue];
    }
}

- (NSInteger)shopPriceCent {
    return [self.priceTextField.text length]>0?[self.priceTextField.text doubleValue]*100:0;
}

- (NSInteger)marketPriceCent {
    return [self.marketPriceTextField.text length]>0?[self.marketPriceTextField.text doubleValue]*100:0;
}

@end


@interface DigitalKeyboardView ()

@property(nonatomic,strong) NSArray *noRetainingTextInputDelegateArray;
@property(nonatomic,strong) NSArray *noRetainingTextFieldArray;

@property(nonatomic,copy) void(^handleKeyboardOkBtnClicked)(DigitalKeyboardView *view);

@end

@implementation DigitalKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat height = 216;
        
        CGFloat btnHeight = 216/4;
        CGFloat btnWidth = kScreenWidth/4;
        
        CGFloat marginTop = 0;
        [self addSubview:[self addNumericKeyWithTitle:@"1" frame:CGRectMake(0, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"2" frame:CGRectMake(btnWidth, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"3" frame:CGRectMake(btnWidth*2, marginTop, btnWidth, btnHeight)]];
        marginTop += btnHeight;
        [self addSubview:[self addNumericKeyWithTitle:@"4" frame:CGRectMake(0, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"5" frame:CGRectMake(btnWidth, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"6" frame:CGRectMake(btnWidth*2, marginTop, btnWidth, btnHeight)]];
        marginTop += btnHeight;
        [self addSubview:[self addNumericKeyWithTitle:@"7" frame:CGRectMake(0, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"8" frame:CGRectMake(btnWidth, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"9" frame:CGRectMake(btnWidth*2, marginTop, btnWidth, btnHeight)]];
        marginTop += btnHeight;
        [self addSubview:[self addNumericKeyWithTitle:@"." frame:CGRectMake(0, marginTop, btnWidth, btnHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"0" frame:CGRectMake(btnWidth, marginTop, btnWidth, btnHeight)]];
        
        CommandButton *hidenBtn = [[CommandButton alloc] initWithFrame:CGRectMake(btnWidth*2, marginTop, btnWidth, btnHeight)];
        [hidenBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [hidenBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"babdc2"]] forState:UIControlStateHighlighted];
        [hidenBtn setImage:[UIImage imageNamed:@"digital_keyboard_hide"] forState:UIControlStateNormal];
        [self addSubview:hidenBtn];
        
        marginTop = 0;
        CommandButton *delBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-btnWidth, marginTop, btnWidth, btnHeight*2)];
        [delBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"babdc2"]] forState:UIControlStateHighlighted];
        [delBtn setImage:[UIImage imageNamed:@"digital_keyboard_back"] forState:UIControlStateNormal];
        [self addSubview:delBtn];
        
        marginTop += delBtn.height;
        
        CommandButton *okBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-btnWidth, marginTop, btnWidth, btnHeight*2)];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
//        [okBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [okBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0d85ff"]] forState:UIControlStateNormal];
        [okBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"babdc2"]] forState:UIControlStateHighlighted];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:okBtn];
        
        CALayer *verLine1 = [CALayer layer];
        verLine1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:verLine1];
        verLine1.frame = CGRectMake(btnWidth, 0, 0.5, height);
        
        CALayer *verLine2 = [CALayer layer];
        verLine2.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:verLine2];
        verLine2.frame = CGRectMake(btnWidth*2, 0, 0.5, height);
        
        CALayer *verLine3 = [CALayer layer];
        verLine3.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:verLine3];
        verLine3.frame = CGRectMake(btnWidth*3, 0, 0.5, height);
        
        CALayer *horLine1 = [CALayer layer];
        horLine1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:horLine1];
        horLine1.frame = CGRectMake(0, btnHeight, kScreenWidth-btnWidth, 0.5);
        
        CALayer *horLine2 = [CALayer layer];
        horLine2.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:horLine2];
        horLine2.frame = CGRectMake(0, btnHeight*2, kScreenWidth, 0.5);
        
        CALayer *horLine3 = [CALayer layer];
        horLine3.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.layer addSublayer:horLine3];
        horLine3.frame = CGRectMake(0, btnHeight*3, kScreenWidth-btnWidth, 0.5);
        
        
        WEAKSELF;
        hidenBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf dismiss];
        };
        delBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf pressBackspaceKey];
        };
        okBtn.handleClickBlock = ^(CommandButton *sender) {
            
//            [weakSelf dismiss];
            
            if (weakSelf.handleKeyboardOkBtnClicked) {
                weakSelf.handleKeyboardOkBtnClicked(weakSelf);
            }
        };
        
        self.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return self;
}

- (UIButton *)addNumericKeyWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"babdc2"]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(pressNumericKey:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setTextFieldArray:(NSArray *)textFieldArray {
    NSMutableArray *noRetainingTextFieldArray = [NSMutableArray noRetainingArray];
    NSMutableArray *noRetainingTextInputDelegateArray = [NSMutableArray noRetainingArray];
    for (UIView *view in textFieldArray) {
        if ([view isKindOfClass:[UITextField class]]) {
            ((UITextField*)view).inputView = self;
            [noRetainingTextFieldArray addObject:view];
            [noRetainingTextInputDelegateArray addObject:view];
        }
    }
    _noRetainingTextFieldArray = noRetainingTextFieldArray;
    _noRetainingTextInputDelegateArray = noRetainingTextInputDelegateArray;
}

- (void)pressNumericKey:(UIButton *)button {
    NSInteger index = -1;
    UITextField *textField = nil;
    for (NSInteger i=0;i<[_noRetainingTextFieldArray count];i++) {
        UITextField *tmp = (UITextField*)[_noRetainingTextFieldArray objectAtIndex:i];
        if ([tmp isFirstResponder]) {
            textField = tmp;
            index = i;
            break;
        }
    }
    id<UITextInput> textInputDelegate = nil;
    if (index>=0 && index < [_noRetainingTextInputDelegateArray count]) {
        textInputDelegate = (id<UITextInput>)[_noRetainingTextInputDelegateArray objectAtIndex:index];
    }
    
    NSString *keyText = button.titleLabel.text;
    int key = -1;
    
    if ([@"." isEqualToString:keyText]) {
        key = 10;
    } else {
        key = [keyText intValue];
    }
    
    NSRange dot = [textField.text rangeOfString:@"."];
    
    switch (key) {
        case 10:
            if (dot.location == NSNotFound && textField.text.length == 0) {
                [textInputDelegate insertText:@"0."];
            } else if (dot.location == NSNotFound) {
                [textInputDelegate insertText:@"."];
            }
            break;
        default:
            if ([NSString stringWithFormat:@"%@%d", textField.text, key].length>=8) {
                
            }
//            else if (kMaxNumber <= [[NSString stringWithFormat:@"%@%d", textField.text, key] doubleValue]) {
//                textField.text = [NSString stringWithFormat:@"%d", kMaxNumber];
//            }
            else if ([@"0.00" isEqualToString:textField.text]) {
                textField.text = [NSString stringWithFormat:@"%d", key];
            } else if (dot.location == NSNotFound || textField.text.length <= dot.location + 2) {
                [textInputDelegate insertText:[NSString stringWithFormat:@"%d", key]];
            }
            
            break;
    }
}

- (void)pressBackspaceKey {
    NSInteger index = -1;
    UITextField *textField = nil;
    for (NSInteger i=0;i<[_noRetainingTextFieldArray count];i++) {
        UITextField *tmp = (UITextField*)[_noRetainingTextFieldArray objectAtIndex:i];
        if ([tmp isFirstResponder]) {
            textField = tmp;
            index = i;
            break;
        }
    }
    id<UITextInput> textInputDelegate = nil;
    if (index>=0 && index < [_noRetainingTextInputDelegateArray count]) {
        textInputDelegate = (id<UITextInput>)[_noRetainingTextInputDelegateArray objectAtIndex:index];
    }
    
    if ([@"0." isEqualToString:textField.text]) {
        textField.text = @"";
        
        return;
    } else {
        [textInputDelegate deleteBackward];
    }
}

- (void)dismiss {
    for (NSInteger i=0;i<[_noRetainingTextFieldArray count];i++) {
        UITextField *tmp = (UITextField*)[_noRetainingTextFieldArray objectAtIndex:i];
        if ([tmp isFirstResponder]) {
            [tmp resignFirstResponder];
        }
    }
    
    UIView *view = _inputContainerView.superview;
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

+ (void)showInView:(UIView*)view
inputContainerView:(DigitalInputContainerView*)inputContainerView
    textFieldArray:(NSArray*)textFieldArray
        completion:(void (^)(DigitalInputContainerView *inputContainerView))completion {
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:bgView];
    
    inputContainerView.frame = CGRectMake(0, kScreenHeight-inputContainerView.height, kScreenWidth, inputContainerView.height);
    inputContainerView.tag = 200;
    [inputContainerView removeFromSuperview];
    [bgView addSubview:inputContainerView];
    
    DigitalKeyboardView *keyboard = [[DigitalKeyboardView alloc] initWithFrame:CGRectZero];
    keyboard.frame = CGRectMake(0, kScreenHeight-keyboard.height, kScreenWidth, keyboard.height);
    keyboard.tag = 100;
    keyboard.inputContainerView = inputContainerView;
    keyboard.textFieldArray = textFieldArray;
    if ([textFieldArray count]>0 && [[textFieldArray objectAtIndex:0] isKindOfClass:[UIView class]]) {
        [((UIView*)[textFieldArray objectAtIndex:0]) becomeFirstResponder];
    }
    __weak typeof(keyboard) weakKeyBoard = keyboard;
    keyboard.handleKeyboardOkBtnClicked = ^(DigitalKeyboardView *view) {
        if (completion) {
            NSLog(@"next");
            
            if (textFieldArray.count > 1 && ((UIView*)[textFieldArray objectAtIndex:0]).isFirstResponder) {
                [((UIView*)[textFieldArray objectAtIndex:1]) becomeFirstResponder];
            } else {
                [weakKeyBoard dismiss];
                completion(inputContainerView);
            }
        }
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } completion:^(BOOL finished) {
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
}

+ (void)showInViewFromPublish:(UIView*)view
inputContainerView:(DigitalInputContainerView*)inputContainerView
    textFieldArray:(NSArray*)textFieldArray
        completion:(void (^)(DigitalInputContainerView *inputContainerView))completion {
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:bgView];
    
    inputContainerView.frame = CGRectMake(0, kScreenHeight/2-inputContainerView.height, kScreenWidth, inputContainerView.height);
    inputContainerView.tag = 200;
    [inputContainerView removeFromSuperview];
    [bgView addSubview:inputContainerView];
    
    DigitalKeyboardView *keyboard = [[DigitalKeyboardView alloc] initWithFrame:CGRectZero];
    keyboard.frame = CGRectMake(0, kScreenHeight-keyboard.height, kScreenWidth, keyboard.height);
    keyboard.tag = 100;
    keyboard.inputContainerView = inputContainerView;
    keyboard.textFieldArray = textFieldArray;
    if ([textFieldArray count]>0 && [[textFieldArray objectAtIndex:0] isKindOfClass:[UIView class]]) {
        [((UIView*)[textFieldArray objectAtIndex:0]) becomeFirstResponder];
    }
    __weak typeof(keyboard) weakKeyBoard = keyboard;
    keyboard.handleKeyboardOkBtnClicked = ^(DigitalKeyboardView *view) {
        if (completion) {
            NSLog(@"next");
            
            if (textFieldArray.count > 1 && ((UIView*)[textFieldArray objectAtIndex:0]).isFirstResponder) {
                [((UIView*)[textFieldArray objectAtIndex:1]) becomeFirstResponder];
            } else {
                [weakKeyBoard dismiss];
                completion(inputContainerView);
            }
        }
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } completion:^(BOOL finished) {
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
}

+ (void)showInViewMF:(UIView*)view
inputContainerView:(DigitalInputContainerView*)inputContainerView
    textFieldArray:(NSArray*)textFieldArray
        completion:(void (^)(DigitalInputContainerView *inputContainerView))completion {
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:bgView];
    
    inputContainerView.frame = CGRectMake(0, kScreenHeight-inputContainerView.height, kScreenWidth, inputContainerView.height);
    inputContainerView.tag = 200;
    [inputContainerView removeFromSuperview];
    [bgView addSubview:inputContainerView];
    
    DigitalKeyboardView *keyboard = [[DigitalKeyboardView alloc] initWithFrame:CGRectZero];
    keyboard.frame = CGRectMake(0, kScreenHeight-keyboard.height, kScreenWidth, keyboard.height);
    keyboard.tag = 100;
    keyboard.inputContainerView = inputContainerView;
    keyboard.textFieldArray = textFieldArray;
    if ([textFieldArray count]>0 && [[textFieldArray objectAtIndex:0] isKindOfClass:[UIView class]]) {
        [((UIView*)[textFieldArray objectAtIndex:0]) becomeFirstResponder];
    }
    __weak typeof(keyboard) weakKeyBoard = keyboard;
    keyboard.handleKeyboardOkBtnClicked = ^(DigitalKeyboardView *view) {
        if (completion) {
            [weakKeyBoard dismiss];
            completion(inputContainerView);
        }
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } completion:^(BOOL finished) {
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
}

+ (void)showInViewBought:(UIView*)view
  inputContainerView:(DigitalInputContainerView*)inputContainerView
      textFieldArray:(NSArray*)textFieldArray
          completion:(void (^)(DigitalInputContainerView *inputContainerView))completion {
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:bgView];
    
    inputContainerView.frame = CGRectMake(0, kScreenHeight-inputContainerView.height, kScreenWidth, inputContainerView.height);
    inputContainerView.tag = 200;
    [inputContainerView removeFromSuperview];
    [bgView addSubview:inputContainerView];
    
    DigitalKeyboardView *keyboard = [[DigitalKeyboardView alloc] initWithFrame:CGRectZero];
    keyboard.frame = CGRectMake(0, kScreenHeight-keyboard.height, kScreenWidth, keyboard.height);
    keyboard.tag = 100;
    keyboard.inputContainerView = inputContainerView;
    keyboard.textFieldArray = textFieldArray;
    if ([textFieldArray count]>0 && [[textFieldArray objectAtIndex:0] isKindOfClass:[UIView class]]) {
        [((UIView*)[textFieldArray objectAtIndex:0]) becomeFirstResponder];
    }
    __weak typeof(keyboard) weakKeyBoard = keyboard;
    keyboard.handleKeyboardOkBtnClicked = ^(DigitalKeyboardView *view) {
        if (completion) {
            [weakKeyBoard dismiss];
            completion(inputContainerView);
        }
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } completion:^(BOOL finished) {
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
}

@end


