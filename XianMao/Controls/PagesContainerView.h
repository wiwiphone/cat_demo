//
//  PagesContainerView.h
//  XianMao
//
//  Created by simon cai on 18/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageIndicatorView.h"
#import "PagesContainerTopBar.h"

@class PageIndicatorView;

@protocol PagesContainerViewDelegate;

@interface PagesContainerView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (readonly, strong, nonatomic) PageIndicatorView *pageIndicatorView;
@property (readonly, strong, nonatomic) PagesContainerTopBar *topBar;
@property (assign, nonatomic) CGFloat topBarHeight;
@property (assign, nonatomic) CGFloat topBarShadowHeight;
@property (assign, nonatomic) CGSize pageIndicatorViewSize;
@property (strong, nonatomic) UIColor *topBarBackgroundColor;
@property (strong, nonatomic) UIFont *topBarItemLabelsFont;
//@property (strong, nonatomic) UIColor *pageItemsTitleColor;
//@property (strong, nonatomic) UIColor *selectedPageItemColor;
@property (strong, nonatomic) UIColor *pageIndicatorColor;
@property(nonatomic,assign) id<PagesContainerViewDelegate> delegate;
@property(nonatomic,assign) CGFloat contentMarginTop;

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation;

- (PageIndicatorView*)createPageIndicatorView;

@end

@protocol PagesContainerViewDelegate <NSObject>
@optional
- (void)pageTopBarItemClickedAtIndex:(NSInteger)index;
- (void)pageBeforeSelectAtIndex:(NSInteger)index;
- (void)pageDidSelectAtIndex:(NSInteger)index;
@end


