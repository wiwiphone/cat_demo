//
//  ForumInputToolBar.m
//  XianMao
//
//  Created by simon cai on 21/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumInputToolBar.h"
#import "NSString+Addtions.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 100
#define kHorizontalPadding 8
#define kVerticalPadding 5

#define kTouchToRecord NSLocalizedString(@"message.toolBar.record.touch", @"hold down to talk")
#define kTouchToFinish NSLocalizedString(@"message.toolBar.record.send", @"loosen to send")

@interface ForumInputToolBar()<ZBMessageManagerFaceViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
    BOOL _isAutoGrowToolbarHeight;
}

@property (nonatomic) CGFloat version;

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@property(nonatomic,assign) BOOL isNeedMoreView;

@end

@implementation ForumInputToolBar

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_attachContainerView && CGRectContainsPoint(_attachContainerView.frame,point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withInputTextView:nil];
}

- (instancetype)initWithFrame:(CGRect)frame withInputTextView:(XHMessageTextView*)inputTextView {
    return [self initWithFrame:frame withInputTextView:inputTextView isNeedMoreView:YES];
}
- (instancetype)initWithFrame:(CGRect)frame withInputTextView:(XHMessageTextView*)inputTextView isNeedMoreView:(BOOL)isNeedMoreView {
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _isAutoGrowToolbarHeight = inputTextView?NO:YES;
        _isNeedMoreView = isNeedMoreView;
        _doSendWhenEditDone = YES;
        // Initialization code
        [self setupConfigure];
        [self setupSubviews:inputTextView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] init];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _toolbarBackgroundImageView;
}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    return _toolbarView;
}

#pragma mark - setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
{
    _toolbarBackgroundImage = toolbarBackgroundImage;
    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(XHMessageTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(XHMessageTextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(XHMessageTextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([NSString isContainsEmoji:text]) {
        return NO;
    }
    
    if (_doSendWhenEditDone) {
        if ([text isEqualToString:@"\n"]) {
            if ([self.delegate respondsToSelector:@selector(didSendFaceWithText:)]) {
                [self.delegate didSendFaceWithText:textView.text];
                [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
            }
            return NO;
        }
    }
    
    if ([text length]==0 && range.length>0) {
        NSString *chatText = textView.text;
        NSInteger stringLength = chatText.length;
        if ([[chatText substringWithRange:range] isEqualToString:@"]"]) {
            NSRange rangeTmp = [chatText rangeOfString:@"[" options:NSBackwardsSearch];
            if (rangeTmp.location != NSNotFound) {
                if (stringLength>rangeTmp.location+1) {
                    textView.text= [chatText substringToIndex:rangeTmp.location+1];
                }
            }
        }
    }
    return YES;
}

- (void)textViewDidChange:(XHMessageTextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - DXFaceDelegate

//点击表情
-(void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele{
    NSString *chatText = self.inputTextView.text;
    
    if (!dele && faceStr.length > 0) {
        self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,faceStr];
    } else {
        NSString *string = nil;
        NSInteger stringLength = chatText.length;
        if (stringLength > 0) {
            if ([@"]" isEqualToString:[chatText substringFromIndex:stringLength-1]]) {
                if ([chatText rangeOfString:@"["].location == NSNotFound){
                    string = [chatText substringToIndex:stringLength - 1];
                } else {
                    string = [chatText substringToIndex:[chatText rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            } else {
                string = [chatText substringToIndex:stringLength - 1];
            }
        }
        self.inputTextView.text = string;
    }
    
    [self textViewDidChange:self.inputTextView];
    
}


- (void)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if ([self.delegate respondsToSelector:@selector(didSendFaceWithText:)]) {
        [self.delegate didSendFaceWithText:chatText];
//        self.inputTextView.text = @"";
        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
    }
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    BOOL needHandlekeyboardNotifi = YES;
    UIViewController *viewController = [self viewController];
    if ([viewController.navigationController.viewControllers count]>0) {
        UIViewController *tmpViewController = [viewController.navigationController.viewControllers objectAtIndex:viewController.navigationController.viewControllers.count-1];
        if (tmpViewController == viewController) {
            needHandlekeyboardNotifi = YES;
        }
    }
    if ([viewController.navigationController.viewControllers count]==0) {
        needHandlekeyboardNotifi = YES;
    }
    if (needHandlekeyboardNotifi) {
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        WEAKSELF;
        void(^animations)() = ^{
            [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
        };
        
        void(^completion)(BOOL) = ^(BOOL finished){
            
        };
        
        [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
        
        if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:self.toolbarView.frame.size.height+endFrame.size.height];
            }
        }
    }
}

- (UIViewController*)viewController {
    for (UIView* next=self; next; next=next.superview) {
        if ([next.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next.nextResponder;
        }
    }
    return nil;
}

#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    UIImage *bgImage = [UIImage imageNamed:@"chat_messageToolbarBg"];
    self.backgroundImageView.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    [self addSubview:self.toolbarView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews:(XHMessageTextView*)withInputTextView
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 6.0;
    
    CGFloat right = CGRectGetWidth(self.bounds);
    
    //更多
    if (_isNeedMoreView) {
        self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(right - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
        self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.moreButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
        [self.moreButton setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
        [self.moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.moreButton.tag = 2;
        allButtonWidth += CGRectGetWidth(self.moreButton.frame) + kHorizontalPadding * 2.5;
        [self.toolbarView addSubview:self.moreButton];
        
        right = CGRectGetMinX(self.moreButton.frame);
    }
    
    //表情
    self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(right - kInputTextViewMinHeight - kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = 1;
    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + kHorizontalPadding * 1.5;
    [self.toolbarView addSubview:self.faceButton];
    
    if (!withInputTextView) {
        // 输入框的高度和宽度
        CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
        // 初始化输入框
        self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
        self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //    self.inputTextView.contentMode = UIViewContentModeCenter;
        _inputTextView.scrollEnabled = YES;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _inputTextView.placeHolder = @"输入新消息";
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _inputTextView.layer.borderWidth = 0.65f;
        _inputTextView.layer.cornerRadius = 6.0f;
        _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
        [self.toolbarView addSubview:self.inputTextView];
    } else {
        self.inputTextView = withInputTextView;
        self.inputTextView.delegate = self;
    }
}

- (UIView*)moreView {
    if (!_moreView) {
        _moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 205) isForChat:NO isGuwen:NO isJimai:NO];
        _moreView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    }
    return _moreView;
}

- (ZBMessageManagerFaceView*)faceView {
    if (!_faceView) {
        _faceView = [[ZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0.0f,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame), 205)];
        [_faceView.sectionBar.sendBtn setTitle:@"提交" forState:UIControlStateNormal];
        _faceView.delegate = self;
    }
    return _faceView;
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height) {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    } else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
//    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//        [_delegate didChangeFrameToHeight:toHeight];
//    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        if (bottomView) {
            CGFloat bottomHeight = bottomView.frame.size.height;
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            
            WEAKSELF;
            
            CGRect rectBegin = bottomView.frame;
            rectBegin.origin.y = kScreenHeight-bottomView.height;
            bottomView.frame = rectBegin;
            [self addSubview:bottomView];
            
            UIView *activityButtomView = weakSelf.activityButtomView;
            CGRect activityEndFrame = activityButtomView.frame;
            activityEndFrame.origin.y = kScreenHeight;
            
            [UIView animateWithDuration:0.3f animations:^{
                [weakSelf willShowBottomHeight:bottomHeight];
                bottomView.frame = rect;
                activityButtomView.frame = activityEndFrame;
            } completion:^(BOOL finished) {
                if (weakSelf.activityButtomView) {
                    [weakSelf.activityButtomView removeFromSuperview];
                }
                weakSelf.activityButtomView = bottomView;
                bottomView.frame = rect;
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:bottomHeight+self.toolbarView.frame.size.height];
            }
        } else {
            WEAKSELF;
            CGFloat bottomHeight = 0;
            
            [UIView animateWithDuration:0.3f animations:^{
                [weakSelf willShowBottomHeight:bottomHeight];
                if (weakSelf.hiddenWhenNoEditing) {
                    weakSelf.alpha = 0.f;
                }
            } completion:^(BOOL finished) {
                if (weakSelf.activityButtomView) {
                    [weakSelf.activityButtomView removeFromSuperview];
                }
                weakSelf.activityButtomView = bottomView;
                
                if (weakSelf.hiddenWhenNoEditing) {
                    weakSelf.alpha = 0.f;
                    weakSelf.hidden = YES;
                }
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:bottomHeight+self.toolbarView.frame.size.height];
            }
        }
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self willShowBottomHeight:0];
    }
    else {
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (_isAutoGrowToolbarHeight) {
        if (toHeight < kInputTextViewMinHeight) {
            toHeight = kInputTextViewMinHeight;
        }
        if (toHeight > self.maxTextInputViewHeight) {
            toHeight = self.maxTextInputViewHeight;
            CGPoint bottomOffset = CGPointMake(0.0f, self.inputTextView.contentSize.height - self.inputTextView.bounds.size.height);
            [self.inputTextView setContentOffset:bottomOffset animated:YES];
            [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length - 2, 1)];
        }
        
        if (toHeight == _previousTextViewContentHeight)
        {
            return;
        }
        else{
            CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
            
            CGRect rect = self.frame;
            rect.size.height += changeHeight;
            rect.origin.y -= changeHeight;
            self.frame = rect;
            
            rect = self.toolbarView.frame;
            rect.size.height += changeHeight;
            self.toolbarView.frame = rect;
            
            self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.frame)-CGRectGetHeight(self.faceView.frame),CGRectGetWidth(self.frame),CGRectGetHeight(self.faceView.frame));
            
            if (self.version < 7.0) {
                
                [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
            }
            _previousTextViewContentHeight = toHeight;
            
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:self.frame.size.height];
            }
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    WEAKSELF;
    switch (tag) {
        case 1://表情
        {
            if (button.selected) {
                self.moreButton.selected = NO;
                
                CGRect frame = self.frame;
                [self.inputTextView resignFirstResponder];
                [CATransaction begin];
                [self.layer removeAllAnimations];
                [CATransaction commit];
                self.frame = frame;
                
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.frame)-CGRectGetHeight(self.faceView.frame),CGRectGetWidth(self.frame),CGRectGetHeight(self.faceView.frame));
                
                [self willShowBottomView:self.faceView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
        case 2://更多
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                
                CGRect frame = self.frame;
                [self.inputTextView resignFirstResponder];
                [CATransaction begin];
                [self.layer removeAllAnimations];
                [CATransaction commit];
                self.frame = frame;
                
                [self willShowBottomView:self.moreView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    weakSelf.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - public

- (void)beginEditing {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (_hiddenWhenNoEditing) {
        [self.inputTextView becomeFirstResponder];
        self.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.hidden = NO;
            self.alpha = 1;
        }];
    } else {
        [self.inputTextView becomeFirstResponder];
    }
}

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    BOOL result = [super endEditing:force];
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    [self.inputTextView endEditing:YES];
    [self willShowBottomView:nil];
    return result;
}

- (BOOL)isInEditing {
    if ([self.inputTextView isFirstResponder] || self.activityButtomView) {
        return YES;
    }
    return NO;
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

@end


