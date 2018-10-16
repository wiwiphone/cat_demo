//
//  PopupOverlayView.m
//  XianMao
//
//  Created by simon cai on 17/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PopupOverlayView.h"

#import "DeviceUtil.h"
#import "UIInsetCtrls.h"

#import "Command.h"

#define kPopupOverlayViewBottomBarHeight 62.f
#define kPopupOverlayViewBottomNotBarHeight 122.f

#import "UIView+FirstResponder.h"

@interface PopupOverlayView () <UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,copy) PopupOverlayViewConfirmBlock confirmBlock;
@property(nonatomic,copy) PopupOverlayViewCancelBlock cancelBlock;

@end

@implementation PopupOverlayView {
    
}

- (id)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        //        tapGesture.delegate = self;
        //        [self addGestureRecognizer:tapGesture];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.bgView];
    }
    return self;
}


//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    UIView *view = [self findFirstResponder];
//    if (view)  {
//        [view resignFirstResponder];
//    }
//
//    CGPoint pt = [gestureRecognizer locationInView:self];
//    if (CGRectContainsPoint(self.bgView.frame, pt)) {
//        return NO;
//    }
//    return YES;
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
        WEAKSELF;
        UIView *view = [weakSelf findFirstResponder];
        if (view) {
            [view resignFirstResponder];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf removeFromSuperview];
                    
                    if (weakSelf.cancelBlock) {
                        weakSelf.cancelBlock();
                    }
                }
            }];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
            
            if (weakSelf.cancelBlock) {
                weakSelf.cancelBlock();
            }
        }
    }];
}

//- (void)tappedBgView:(UIGestureRecognizer*)gesture {
//    WEAKSELF;
//    UIView *view = [weakSelf findFirstResponder];
//    if (view) {
//        [view resignFirstResponder];
//    }
//}

- (void)tapConfirm
{
    WEAKSELF;
    //    [UIView animateWithDuration:0.3 animations:^{
    //        weakSelf.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        if (finished) {
    //            [weakSelf removeFromSuperview];
    //
    //            if (weakSelf.confirmBlock) {
    //                weakSelf.confirmBlock();
    //            }
    //        }
    //    }];
    
    if (weakSelf.confirmBlock) {
        weakSelf.confirmBlock();
    }
}

- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 112, self.width-40, self.height-224)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 3.f;
        

        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBgView:)];
        //        tapGesture.delegate = self;
        //        [_bgView addGestureRecognizer:tapGesture];
        
        if ([DeviceUtil isIphone4]||[DeviceUtil isIphone3]) {
            _bgView.frame = CGRectMake(20, 60, self.width-40, self.height-120);
        }
        
        WEAKSELF;
        CommandButton *cancelBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, _bgView.height-kPopupOverlayViewBottomBarHeight, _bgView.width/2, kPopupOverlayViewBottomBarHeight)];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        cancelBtn.tag = 100;
        [_bgView addSubview:cancelBtn];
        cancelBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf tappedCancel:nil];
        };
        
        CommandButton *confirmBtn = [[CommandButton alloc] initWithFrame:CGRectMake(_bgView.width/2, _bgView.height-kPopupOverlayViewBottomBarHeight, _bgView.width/2, kPopupOverlayViewBottomBarHeight)];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        confirmBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        confirmBtn.tag = 200;
        [_bgView addSubview:confirmBtn];
        confirmBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf tapConfirm];
        };
    }
    return _bgView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *cancelBtn = [self viewWithTag:100];
    UIView *confirmBtn = [self viewWithTag:200];
    
    cancelBtn.frame = CGRectMake(0, _bgView.height-kPopupOverlayViewBottomBarHeight, _bgView.width/2, kPopupOverlayViewBottomBarHeight);
    confirmBtn.frame = CGRectMake(_bgView.width/2, _bgView.height-kPopupOverlayViewBottomBarHeight, _bgView.width/2, kPopupOverlayViewBottomBarHeight);
}

- (void)showInView:(UIView *)view
        conentView:(UIView*)conentView
      confirmBlock:(PopupOverlayViewConfirmBlock)confirmBlock
       cancelBlock:(PopupOverlayViewCancelBlock)cancelBlock
{
    [self removeFromSuperview];
    if (view == nil) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    } else {
        [view addSubview:self];
    }
    
    _confirmBlock = confirmBlock;
    _cancelBlock = cancelBlock;
    
    self.bgView.frame = CGRectMake((self.width-conentView.width)/2, (self.height-(conentView.height+kPopupOverlayViewBottomBarHeight))/2, conentView.width, conentView.height+kPopupOverlayViewBottomBarHeight);
    
    [conentView removeFromSuperview];
    [self.bgView addSubview:conentView];
    conentView.frame = CGRectMake(0, 0, conentView.width, conentView.height);
    
    WEAKSELF;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf setAlpha:1.0];
    }];
}

- (void)showInViewMF:(UIView *)view
        conentView:(UIView*)conentView
      confirmBlock:(PopupOverlayViewConfirmBlock)confirmBlock
       cancelBlock:(PopupOverlayViewCancelBlock)cancelBlock
{
    [self removeFromSuperview];
    if (view == nil) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    } else {
        [view addSubview:self];
    }
    
    _confirmBlock = confirmBlock;
    _cancelBlock = cancelBlock;
    
    self.bgView.frame = CGRectMake((self.width-conentView.width)/2, (self.height-(conentView.height+kPopupOverlayViewBottomNotBarHeight))/2-50, conentView.width, conentView.height+kPopupOverlayViewBottomBarHeight);
    
    [conentView removeFromSuperview];
    [self.bgView addSubview:conentView];
    conentView.frame = CGRectMake(0, 0, conentView.width, conentView.height);
    
    WEAKSELF;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf setAlpha:1.0];
    }];
}

@end
