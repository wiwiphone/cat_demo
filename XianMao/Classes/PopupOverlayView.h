//
//  PopupOverlayView.h
//  XianMao
//
//  Created by simon cai on 17/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopupOverlayViewConfirmBlock)();
typedef void (^PopupOverlayViewCancelBlock)();

@interface PopupOverlayView : UIScrollView

- (id)init;

- (void)showInView:(UIView *)view
        conentView:(UIView*)conentView
      confirmBlock:(PopupOverlayViewConfirmBlock)confirmBlock
       cancelBlock:(PopupOverlayViewCancelBlock)cancelBlock;

- (void)showInViewMF:(UIView *)view
        conentView:(UIView*)conentView
      confirmBlock:(PopupOverlayViewConfirmBlock)confirmBlock
       cancelBlock:(PopupOverlayViewCancelBlock)cancelBlock;

@end