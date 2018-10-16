//
//  UIInsetCtrls.m
//  XianMao
//
//  Created by simon cai on 11/16/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UIInsetCtrls.h"
#import "NSString+Addtions.h"

@implementation UIInsetLabel

@synthesize insets = _insets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self) {
        self.insets = insets;
    }
    return self;
}

- (id)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end

@interface UITextFieldDelegateProxyImpl : NSObject<UITextFieldDelegate>
@property(nonatomic,assign) id<UITextFieldDelegate> proxyDelegate;
@end

@implementation UITextFieldDelegateProxyImpl

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_proxyDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_proxyDelegate textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_proxyDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_proxyDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //emoji无效
    if([NSString isContainsEmoji:string]) {
        return NO;
    }
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_proxyDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        [_proxyDelegate textFieldShouldClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_proxyDelegate && [_proxyDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [_proxyDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

@end

@interface UIInsetTextField () <UITextFieldDelegate>
@property(nonatomic) CGFloat rectInsetDXRight;
@property(nonatomic) CGFloat rectInsetDX;
@property(nonatomic) CGFloat rectInsetDY;
@property(nonatomic,assign) id<UITextFieldDelegate> proxyDelegate;
@property(nonatomic,strong) UITextFieldDelegateProxyImpl *proxyDelegateImpl;
@end

@implementation UIInsetTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxLength = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame rectInsetDX:(CGFloat)rectInsetDX rectInsetDY:(CGFloat)rectInsetDY {
    self = [super initWithFrame:frame];
    if(self) {
        self.rectInsetDXRight = 0;
        self.rectInsetDX = rectInsetDX;
        self.rectInsetDY = rectInsetDY;
        self.unCopyable = NO;
        _maxLength = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self];

    }
    return self;
}

//IOS7有bug
- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    if (!_proxyDelegateImpl)
         _proxyDelegateImpl = [[UITextFieldDelegateProxyImpl alloc] init];
    _proxyDelegateImpl.proxyDelegate = delegate;
    [super setDelegate:_proxyDelegateImpl];
}

- (id)initWithFrame:(CGRect)frame rectInsetDX:(CGFloat)rectInsetDX rectInsetDY:(CGFloat)rectInsetDY rectInsetDXRight:(CGFloat)rectInsetDXRight {
    self = [super initWithFrame:frame];
    if(self) {
        self.rectInsetDXRight = rectInsetDXRight;
        self.rectInsetDX = rectInsetDX;
        self.rectInsetDY = rectInsetDY;
        _maxLength = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

//控制placeHolder的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectInset(bounds, self.rectInsetDX, self.rectInsetDY);
    rect.size.width -= self.rectInsetDXRight;
    return rect;
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectInset(bounds, self.rectInsetDX, self.rectInsetDY);
    rect.size.width -= self.rectInsetDXRight;
    return rect;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.unCopyable) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    }
    else
    {
        return [super canPerformAction:action withSender:sender];
    }
}

- (NSString*)text {
    return [NSString disable_emoji:[super text]];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    if (_maxLength>0) {
        UITextField *textField = (UITextField *)obj.object;
        NSString *toBeString = textField.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            if ([toBeString length]>_maxLength) {
                textField.text = [toBeString substringToIndex:_maxLength];
            }
//            UITextRange *selectedRange = [textField markedTextRange];
//            //获取高亮部分
//            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//            if (!position) {
//                if (toBeString.length > _maxLength) {
//                    textField.text = [toBeString substringToIndex:_maxLength];
//                }
//            }
//            // 有高亮选择的字符串，则暂不对文字进行统计和限制
//            else{
//                
//            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > _maxLength) {
                textField.text = [toBeString substringToIndex:_maxLength];
            }
        }
    }
}

@end


//
//
//- (void)textViewDidChange:(UITextView *)textView
//{
//    NSRange textRange = [textView selectedRange];
//    [textView setText:[self disable_emoji:[textView text]]];
//    [textView setSelectedRange:textRange];
//}
//


//



