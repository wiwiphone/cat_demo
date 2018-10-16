//
//  GuideView.h
//  XianMao
//
//  Created by simon cai on 13/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"

@interface GuideView : TapDetectingView

+ (BOOL)isNeedShowWaitItGuideView;
+ (void)showWaitItGuideView:(UIView*)fromView;
+ (void)showMainGuideView:(UIView*)fromView;
+ (void)showIssueGuideView:(UIView*)fromView;
+ (void)showMainRedGuideView:(UIView*)fromView;
+ (void)showNewUserGuideViewInMineViewController:(UIView*)fromView;
+ (BOOL)isNeedShowText;
+ (BOOL)isNeedShowGuideViewInMineViewCtroller;
- (void)showNewUserGuideView:(NSMutableArray *)dateSources guideView:(GuideView *)guideView reOffset:(CGFloat)reOffset addGuite:(NSInteger)addGuite;

@end

extern NSString *const kGuideGoodsDetailWant;
