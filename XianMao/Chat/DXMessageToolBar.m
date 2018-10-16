/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXMessageToolBar.h"
#import "BaseViewController.h"
#import "DXRecordView.h"

@interface DXMessageToolBar()<UITextViewDelegate,ZBMessageManagerFaceViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
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
@property (strong, nonatomic) UIButton *styleChangeButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;


@end

@implementation DXMessageToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
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

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
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
    self.styleChangeButton.selected = NO;
    self.moreButton.selected = NO;
    if (self.activityButtomView) {
        [self.activityButtomView removeFromSuperview];
        self.activityButtomView = nil;
    }
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
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendFaceWithText:)]) {
            [self.delegate didSendFaceWithText:textView.text];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
        return NO;
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

//- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
//{
//    NSString *chatText = self.inputTextView.text;
//    
//    if (!isDelete && str.length > 0) {
//        self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
//    }
//    else {
//        if (chatText.length >= 2)
//        {
//            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
//            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
//                self.inputTextView.text = [chatText substringToIndex:chatText.length-2];
//                
//                return;
//            }
//        }
//        
//        if (chatText.length > 0) {
//            self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
//        }
//    }
//    
//    [self textViewDidChange:self.inputTextView];
//}

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
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendFaceWithText:)]) {
            [self.delegate didSendFaceWithText:chatText];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
    }
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    BOOL needHandlekeyboardNotifi = NO;
    UIViewController *viewController = [self viewController];
    if ([viewController.navigationController.viewControllers count]>0) {
        UIViewController *tmpViewController = [viewController.navigationController.viewControllers objectAtIndex:viewController.navigationController.viewControllers.count-1];
        if (tmpViewController == viewController) {
            needHandlekeyboardNotifi = YES;
        }
    }
    if (needHandlekeyboardNotifi) {
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        void(^animations)() = ^{
            
            if (!self.activityButtomView) {
                
                [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
                
                if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
                    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                        [_delegate didChangeFrameToHeight:self.toolbarView.frame.size.height+endFrame.size.height];
                    }
                }
                else if (endFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
                    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                        [_delegate didChangeFrameToHeight:self.toolbarView.frame.size.height];
                    }
                }
                else {
                    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                        [_delegate didChangeFrameToHeight:self.toolbarView.frame.size.height+endFrame.size.height];
                    }
                }
            }
        };
        
        void(^completion)(BOOL) = ^(BOOL finished){
            
        };
        
        [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
        
        
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
    self.backgroundImageView.image = [[UIImage imageNamed:@"chat_messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    self.toolbarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.toolbarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 6.0;
    
    //转变输入样式
    self.styleChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.styleChangeButton setImage:[UIImage imageNamed:@"chatBar_record_New"] forState:UIControlStateNormal];
    [self.styleChangeButton setImage:[UIImage imageNamed:@"chatBar_record_New_S"] forState:UIControlStateHighlighted];
    [self.styleChangeButton setImage:[UIImage imageNamed:@"chat_keyboard_New"] forState:UIControlStateSelected];
    [self.styleChangeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.styleChangeButton.tag = 0;
    allButtonWidth += CGRectGetMaxX(self.styleChangeButton.frame);
    textViewLeftMargin += CGRectGetMaxX(self.styleChangeButton.frame);
    
    //更多
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_more_New"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_more_New_S"] forState:UIControlStateHighlighted];
    [self.moreButton setImage:[UIImage imageNamed:@"chat_keyboard_New"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.tag = 2;
    allButtonWidth += CGRectGetWidth(self.moreButton.frame) + kHorizontalPadding * 2.5;
    
    if (self.isGuwen) {
        if ([[Session sharedInstance] isNeedShowRedPoint]) {
            UIView *redPointView = [[UIView alloc] initWithFrame:CGRectMake(kInputTextViewMinHeight-13, 4, 7, 7)];
            redPointView.layer.masksToBounds = YES;
            redPointView.layer.cornerRadius = 7/2;
            redPointView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
            [self.moreButton addSubview:redPointView];
        }
    }
    
    //表情
    self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight - kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_face_New"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_face_New_S"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:[UIImage imageNamed:@"chat_keyboard_New"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = 1;
    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + kHorizontalPadding * 1.5;
    
    
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
    
    //录制
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:[[UIImage imageNamed:@"chatBar_recordBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:[[UIImage imageNamed:@"chatBar_recordSelectedBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [self.recordButton setTitle:kTouchToRecord forState:UIControlStateNormal];
    [self.recordButton setTitle:kTouchToFinish forState:UIControlStateHighlighted];
    self.recordButton.hidden = YES;
    [self.recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [self.recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    self.recordButton.hidden = YES;
    if (!self.moreView) {
        self.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 205) isForChat:YES isGuwen:self.isGuwen isJimai:self.isJimai];
        self.moreView.backgroundColor = [UIColor whiteColor];
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        topLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.moreView addSubview:topLine];
    }
    
    if (!self.faceView) {
        self.faceView = [[ZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                  CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 205)];
        self.faceView.delegate = self;
        
    }
    
    if (!self.recordView) {
        self.recordView = [[DXRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    [self.toolbarView addSubview:self.styleChangeButton];
    [self.toolbarView addSubview:self.moreButton];
    [self.toolbarView addSubview:self.faceButton];
    [self.toolbarView addSubview:self.inputTextView];
    [self.toolbarView addSubview:self.recordButton];   
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
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
            rect.origin.y = self.toolbarView.height;
            
            WEAKSELF;
            
            UIView *activityButtomViewTmp = weakSelf.activityButtomView;
            CGRect activityEndFrame = activityButtomViewTmp.frame;
            activityEndFrame.origin.y = kScreenHeight;
            
            CGRect rectBegin = bottomView.frame;
            rectBegin.origin.y = kScreenHeight-bottomView.height;
            bottomView.frame = rectBegin;
            [self addSubview:bottomView];
            weakSelf.activityButtomView = bottomView;
            
            [UIView animateWithDuration:0.3f animations:^{
                [weakSelf willShowBottomHeight:bottomHeight];
                bottomView.frame = rect;
                activityButtomViewTmp.frame = activityEndFrame;
            } completion:^(BOOL finished) {
                [activityButtomViewTmp removeFromSuperview];
                bottomView.frame = rect;
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                [_delegate didChangeFrameToHeight:bottomHeight+self.toolbarView.frame.size.height];
            }
        } else {
            WEAKSELF;
            if (weakSelf.activityButtomView) {
                CGFloat bottomHeight = 0;
                UIView *activityButtomView = weakSelf.activityButtomView;
                CGRect activityEndFrame = activityButtomView.frame;
                activityEndFrame.origin.y = kScreenHeight;
                
                weakSelf.activityButtomView = bottomView;
                
                [UIView animateWithDuration:0.3f animations:^{
                    activityButtomView.frame = activityEndFrame;
                    [weakSelf willShowBottomHeight:bottomHeight];
                } completion:^(BOOL finished) {
                    if (activityButtomView) {
                        [activityButtomView removeFromSuperview];
                    }
                }];
                
                if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
                    [_delegate didChangeFrameToHeight:bottomHeight+self.toolbarView.frame.size.height];
                }
            }
        }
    }
}

//- (void)willShowBottomView:(UIView *)bottomView
//{
//    if (![self.activityButtomView isEqual:bottomView]) {
//        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
//        [self willShowBottomHeight:bottomHeight];
//        
//        if (bottomView) {
//            CGRect rect = bottomView.frame;
//            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
//            bottomView.frame = rect;
//            [self addSubview:bottomView];
//        }
//        
//        if (self.activityButtomView) {
//            [self.activityButtomView removeFromSuperview];
//        }
//        self.activityButtomView = bottomView;
//    }
//}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
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

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
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
    
    switch (tag) {
        case 0://切换状态
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                self.moreButton.selected = NO;
                //录音状态下，不显示底部扩展页面
                [self willShowBottomView:nil];
                
                //将inputTextView内容置空，以使toolbarView回到最小高度
                self.inputTextView.text = @"";
                [self textViewDidChange:self.inputTextView];
                
                //[self.inputTextView resignFirstResponder]; //old
                CGRect frame = self.frame;
                [self.inputTextView resignFirstResponder];
//                [CATransaction begin];
//                [self.layer removeAllAnimations];
//                [CATransaction commit];
//                self.frame = frame;
            }
            else{
                //键盘也算一种底部扩展页面
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.recordButton.hidden = !button.selected;
                self.inputTextView.hidden = button.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didStyleChangeToRecord:)]) {
                [self.delegate didStyleChangeToRecord:button.selected];
            }
        }
            break;
        case 1://表情
        {
            if (button.selected) {
                
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.frame)-CGRectGetHeight(self.faceView.frame),CGRectGetWidth(self.frame),CGRectGetHeight(self.faceView.frame));
                
                [self willShowBottomView:self.faceView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
                
                [self.inputTextView resignFirstResponder];
                
                self.moreButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    //[self.inputTextView resignFirstResponder];//old
//                    CGRect frame = self.frame;
//                    [CATransaction begin];
//                    [self.layer removeAllAnimations];
//                    [CATransaction commit];
//                    self.frame = frame;
                }
            } else {
                if (!self.styleChangeButton.selected) {
                    [self.inputTextView becomeFirstResponder];
                }
                else{
                    [self willShowBottomView:nil];
                }
            }
        }
            break;
        case 2://更多
        {
            if (button.selected) {
                [self willShowBottomView:self.moreView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
                
                [self.inputTextView resignFirstResponder];
                
                self.faceButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    //[self.inputTextView resignFirstResponder];//old
//                    CGRect frame = self.frame;
//                    [CATransaction begin];
//                    [self.layer removeAllAnimations];
//                    [CATransaction commit];
//                    self.frame = frame;
                }
            }
            else
            {
                self.styleChangeButton.selected = NO;
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)recordButtonTouchDown
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchDown];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        [_delegate didStartRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpOutside
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
    {
        [_delegate didCancelRecordingVoiceAction:self.recordView];
    }
    
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchUpOutside];
    }
    
    [self.recordView removeFromSuperview];
}

- (void)recordButtonTouchUpInside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchUpInside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
    {
        [self.delegate didFinishRecoingVoiceAction:self.recordView];
    }
    
    [self.recordView removeFromSuperview];
}

- (void)recordDragOutside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonDragOutside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction:)])
    {
        [self.delegate didDragOutsideAction:self.recordView];
    }
}

- (void)recordDragInside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonDragInside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction:)])
    {
        [self.delegate didDragInsideAction:self.recordView];
    }
}


#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    [self willShowBottomView:nil];
    
    return result;
}

/**
 *  取消触摸录音键
 */
- (void)cancelTouchRecord
{
//    self.recordButton.selected = NO;
//    self.recordButton.highlighted = NO;
    if ([_recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)_recordView recordButtonTouchUpInside];
        [_recordView removeFromSuperview];
    }
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

@end


