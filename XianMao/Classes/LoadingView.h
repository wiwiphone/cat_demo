//
//  LoadingView.h
//  XianMao
//
//  Created by simon on 1/23/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingView;

typedef void(^LoadingViewHandleRetryBtnClicked)(LoadingView *view);

@interface LoadingView : UIView

@property(nonatomic,copy) LoadingViewHandleRetryBtnClicked handleRetryBtnClicked;

- (void)showLoadingView;
- (void)hideLoadingView;
- (void)loadEndWithNoContent:(NSString*)title image:(UIImage*)noContentImage withRetryButton:(BOOL)withRetryButton;
- (void)loadEndWithError:(NSString*)title;

+ (LoadingView*)loadingView:(UIView*)forView;
+ (LoadingView*)createLoadingView:(UIView*)forView;

+ (LoadingView*)showRemindLoginView:(UIView*)forView;
+ (LoadingView*)showLoadingView:(UIView*)forView;
+ (void)hideLoadingView:(UIView*)forView;

+ (LoadingView*)loadEndWithNoContent:(UIView*)forView title:(NSString*)title;
+ (LoadingView*)loadEndWithNoContentWithRetryButton:(UIView*)forView title:(NSString*)title;
+ (LoadingView*)loadEndWithNoContent:(UIView*)forView title:(NSString*)title image:(UIImage*)noContentImage;
+ (LoadingView*)loadEndWithError:(UIView*)forView title:(NSString*)title;

@end

//



