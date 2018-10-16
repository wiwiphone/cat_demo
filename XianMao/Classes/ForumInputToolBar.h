//
//  ForumInputToolBar.h
//  XianMao
//
//  Created by simon cai on 21/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"

#import "DXChatBarMoreView.h"
#import "EaseRecordView.h"
#import "ZBMessageManagerFaceView.h"

#import "EaseChatToolbar.h"//MessageTextView

@protocol ForumInputToolBarDelegate;;

@interface ForumInputToolBar : UIView<UITextViewDelegate>

@property (nonatomic, weak) id <ForumInputToolBarDelegate> delegate;

@property(nonatomic,assign) BOOL doSendWhenEditDone;

@property(nonatomic,weak) UIView *attachContainerView;

/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 *  更多的附加页面
 */
@property (strong, nonatomic) UIView *moreView;

/**
 *  表情的附加页面
 */
//@property (strong, nonatomic) FaceBoard *faceView;

@property (nonatomic,strong) ZBMessageManagerFaceView *faceView;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

@property (nonatomic,assign) BOOL hiddenWhenNoEditing;

/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return DXMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame withInputTextView:(XHMessageTextView*)inputTextView;
- (instancetype)initWithFrame:(CGRect)frame withInputTextView:(XHMessageTextView*)inputTextView isNeedMoreView:(BOOL)isNeedMoreView;

- (void)beginEditing;

- (BOOL)endEditing:(BOOL)force;

- (BOOL)isInEditing;

- (void)textViewDidChange:(XHMessageTextView *)textView;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

@end


@protocol ForumInputToolBarDelegate <NSObject>

@optional

- (void)didEndEditing:(ForumInputToolBar*)toolBar;

/**
 *  在普通状态和语音状态之间进行切换时，会触发这个回调函数
 *
 *  @param changedToRecord 是否改为发送语音状态
 */
- (void)didStyleChangeToRecord:(BOOL)changedToRecord;

/**
 *  点击“表情”按钮触发
 *
 *  @param isSelected 是否选中。YES,显示表情页面；NO，收起表情页面
 */
- (void)didSelectedFaceButton:(BOOL)isSelected;
//
///**
// *  点击“更多”按钮触发
// *
// *  @param isSelected 是否选中。YES,显示更多页面；NO，收起更多页面
// */
//- (void)didSelectedMoreButton:(BOOL)isSelected;

/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendFaceWithText:(NSString *)text;

/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

@end

