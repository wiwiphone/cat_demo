//
//  PagesContainerView.m
//  XianMao
//
//  Created by simon cai on 18/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PagesContainerView.h"
#import "PagesContainerTopBar.h"
#import "PageIndicatorView.h"

@interface PagesContainerView () <PagesContainerTopBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PagesContainerTopBar *topBar;

@property (weak,   nonatomic) UIScrollView *observingScrollView;
@property (strong, nonatomic) PageIndicatorView *pageIndicatorView;

@property (          assign, nonatomic) BOOL shouldObserveContentOffset;
@property (readonly, assign, nonatomic) CGFloat scrollWidth;
@property (readonly, assign, nonatomic) CGFloat scrollHeight;

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView;
- (void)stopObservingContentOffset;

@end


@implementation PagesContainerView


#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
    self.scrollView = nil;
    self.topBar = nil;
    self.pageIndicatorView = nil;
}

- (void)setUp
{
    _topBarHeight = 44.;
    _topBarShadowHeight = 0.f;
    _topBarBackgroundColor = [UIColor colorWithWhite:0.1 alpha:1.];
    _topBarItemLabelsFont = [UIFont systemFontOfSize:12];
    _pageIndicatorViewSize = CGSizeMake(17., 7.);
    _contentMarginTop = 0.f;
}

- (PageIndicatorView*)createPageIndicatorView {
    return [[PageIndicatorRectangleView alloc] initWithFrame:CGRectMake(0.,
                                                        self.topBarHeight,
                                                        self.pageIndicatorViewSize.width,
                                                        self.pageIndicatorViewSize.height)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        self.shouldObserveContentOffset = YES;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.,
                                                                         self.topBarHeight-self.topBarShadowHeight+_contentMarginTop,
                                                                         CGRectGetWidth(self.frame),
                                                                         self.scrollHeight)];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        [self startObservingContentOffsetForScrollView:self.scrollView];
        
        self.topBar = [[PagesContainerTopBar alloc] initWithFrame:CGRectMake(0.,
                                                                             0.,
                                                                             CGRectGetWidth(self.frame),
                                                                             self.topBarHeight)];
        self.topBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        self.topBar.delegate = self;
        [self addSubview:self.topBar];
        
        self.pageIndicatorView = [self createPageIndicatorView];
        [self addSubview:self.pageIndicatorView];
        self.topBar.backgroundColor = self.pageIndicatorView.color = self.topBarBackgroundColor;
    }
    return self;
}

#pragma mark - Public

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    if (_delegate && [_delegate respondsToSelector:@selector(pageBeforeSelectAtIndex:)]) {
        [_delegate pageBeforeSelectAtIndex:selectedIndex];
    }
    
    UIButton *previosSelectdItem = self.topBar.itemViews[self.selectedIndex];
    UIButton *nextSelectdItem = self.topBar.itemViews[selectedIndex];
    if (abs(self.selectedIndex - selectedIndex) <= 1) {
        [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:animated];
        if (selectedIndex == _selectedIndex) {
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        self.pageIndicatorView.center.y);
        }
        
//        //点击的时候，抖一下
//        [UIView animateWithDuration:(animated) ? 0.3 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
//         {
////             [previosSelectdItem setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.] forState:UIControlStateNormal];
////             [nextSelectdItem setTitleColor:[UIColor colorWithWhite:1. alpha:1.] forState:UIControlStateNormal];
//             [previosSelectdItem setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.] forState:UIControlStateNormal];
//             [nextSelectdItem setTitleColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1.] forState:UIControlStateNormal];
//         } completion:nil];
    } else {
        // This means we should "jump" over at least one view controller
        self.shouldObserveContentOffset = NO;
        BOOL scrollingRight = (selectedIndex > self.selectedIndex);
        UIViewController *leftViewController = self.viewControllers[MIN(self.selectedIndex, selectedIndex)];
        UIViewController *rightViewController = self.viewControllers[MAX(self.selectedIndex, selectedIndex)];
        leftViewController.view.frame = CGRectMake(0., 0., self.scrollWidth, self.scrollHeight);
        rightViewController.view.frame = CGRectMake(self.scrollWidth, 0., self.scrollWidth, self.scrollHeight);
        self.scrollView.contentSize = CGSizeMake(2 * self.scrollWidth, self.scrollHeight);
        
        CGPoint targetOffset;
        if (scrollingRight) {
            self.scrollView.contentOffset = CGPointZero;
            targetOffset = CGPointMake(self.scrollWidth, 0.);
        } else {
            self.scrollView.contentOffset = CGPointMake(self.scrollWidth, 0.);
            targetOffset = CGPointZero;
            
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        self.pageIndicatorView.center.y);
            self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:selectedIndex];
//            [previosSelectdItem setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.] forState:UIControlStateNormal];
//            [nextSelectdItem setTitleColor:[UIColor colorWithWhite:1. alpha:1.] forState:UIControlStateNormal];
            
            [previosSelectdItem setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] forState:UIControlStateNormal];
            [nextSelectdItem setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.] forState:UIControlStateNormal];
            
        } completion:^(BOOL finished) {
            for (NSUInteger i = 0; i < self.viewControllers.count; i++) {
                UIViewController *viewController = self.viewControllers[i];
                viewController.view.frame = CGRectMake(i * self.scrollWidth, 0., self.scrollWidth, self.scrollHeight);
                [self.scrollView addSubview:viewController.view];
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollWidth * self.viewControllers.count, self.scrollHeight);
            [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:NO];
            self.scrollView.userInteractionEnabled = YES;
            self.shouldObserveContentOffset = YES;
        }];
    }
    _selectedIndex = selectedIndex;
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageDidSelectAtIndex:)]) {
        [_delegate pageDidSelectAtIndex:selectedIndex];
    }
}

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews];
}

#pragma mark * Overwritten setters

- (void)setPageIndicatorViewSize:(CGSize)size
{
    if (!CGSizeEqualToSize(self.pageIndicatorView.frame.size, size)) {
        _pageIndicatorViewSize = size;
        [self layoutSubviews];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
    
    self.scrollView.userInteractionEnabled = YES;
    
    if (selectedIndex>=0&&selectedIndex<self.topBar.itemViews.count) {
        UIButton *nextSelectdItem = self.topBar.itemViews[selectedIndex];
        [nextSelectdItem setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.] forState:UIControlStateNormal];
    }
}

- (void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor
{
    _topBarBackgroundColor = topBarBackgroundColor;
    self.topBar.backgroundColor = topBarBackgroundColor;
}

- (void)setTopBarHeight:(CGFloat)topBarHeight
{
    if (_topBarHeight != topBarHeight) {
        _topBarHeight = topBarHeight;
        [self layoutSubviews];
    }
}

- (void)setTopBarShadowHeight:(CGFloat)topBarShadowHeight {
    if (_topBarShadowHeight != topBarShadowHeight) {
        _topBarShadowHeight = topBarShadowHeight;
        [self layoutSubviews];
    }
}

- (void)setTopBarItemLabelsFont:(UIFont *)font
{
    self.topBar.font = font;
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor
{
    self.pageIndicatorView.color = pageIndicatorColor;
}

- (void)setContentMarginTop:(CGFloat)contentMarginTop {
    if (_contentMarginTop!=contentMarginTop) {
        _contentMarginTop = contentMarginTop;
        [self layoutSubviews];
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

//- (void)setViewsOrControllers:(NSArray *)viewsOrControllers
//{
//    if (_viewsOrControllers != viewsOrControllers) {
//        _viewsOrControllers = viewsOrControllers;
//        
//        self.topBar.itemTitles = [viewsOrControllers valueForKey:@"title"];
//        
//        for (NSObject *obj in viewsOrControllers) {
//            if ([obj isKindOfClass:[UIViewController class]]) {
//                UIViewController *viewController = (UIViewController*)obj;
//                UIViewController *parentUIViewController = [self viewController];
//                
//                [viewController willMoveToParentViewController:parentUIViewController];
//                viewController.view.frame = CGRectMake(0., 0., CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
//                [self.scrollView addSubview:viewController.view];
//                [viewController didMoveToParentViewController:parentUIViewController];
//            } else if ([obj isKindOfClass:[UIView class]]) {
//                
//            }
//        }
//        
//        [self layoutSubviews];
//        self.selectedIndex = 0;
//        self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
//                                                    self.pageIndicatorView.center.y);
//    }
//}

- (void)setViewControllers:(NSArray *)viewControllers
{
    UIViewController *parentUIViewController = [self viewController];
    
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        self.topBar.itemTitles = [viewControllers valueForKey:@"title"];
        for (UIViewController *viewController in viewControllers) {
            [viewController willMoveToParentViewController:parentUIViewController];
            viewController.view.frame = CGRectMake(0., 0., CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
            viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:parentUIViewController];
        }
        [self layoutSubviews];
        self.selectedIndex = 0;
        self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                    self.pageIndicatorView.center.y);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topBar.frame = CGRectMake(0., 0., CGRectGetWidth(self.bounds), self.topBarHeight);
    self.scrollView.frame = CGRectMake(0.,
                                       self.topBarHeight-self.topBarShadowHeight+_contentMarginTop,
                                       CGRectGetWidth(self.frame),
                                       self.scrollHeight);
    self.pageIndicatorView.frame = CGRectMake(0.,
                                              self.topBarHeight-self.pageIndicatorViewSize.height-self.topBarShadowHeight-6,
                                              self.pageIndicatorViewSize.width,
                                              self.pageIndicatorViewSize.height);
    CGFloat x = 0.;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollWidth, 0.) animated:YES];
    self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                self.pageIndicatorView.center.y);
    self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex];
    self.scrollView.userInteractionEnabled = YES;
}

- (CGFloat)scrollHeight
{
    return CGRectGetHeight(self.frame)- self.topBarHeight+self.topBarShadowHeight-_contentMarginTop;
}

- (CGFloat)scrollWidth
{
    return CGRectGetWidth(self.scrollView.frame);
}

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.observingScrollView = scrollView;
}

- (void)stopObservingContentOffset
{
    if (self.observingScrollView) {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

#pragma mark - DAPagesContainerTopBar delegate

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(PagesContainerTopBar *)bar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageTopBarItemClickedAtIndex:)]) {
        [self.delegate pageTopBarItemClickedAtIndex:index];
    }
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = NO;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    CGFloat oldX = self.selectedIndex * CGRectGetWidth(self.scrollView.frame);
    if (oldX != self.scrollView.contentOffset.x && self.shouldObserveContentOffset) {
        BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
        NSInteger targetIndex = (scrollingTowards) ? self.selectedIndex + 1 : self.selectedIndex - 1;
        if (targetIndex >= 0 && targetIndex < self.viewControllers.count) {
            CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / CGRectGetWidth(self.scrollView.frame);
            CGFloat previousItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:targetIndex].x;
            CGFloat previousItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:targetIndex].x;
            UIButton *previosSelectedItem = self.topBar.itemViews[self.selectedIndex];
            UIButton *nextSelectedItem = self.topBar.itemViews[targetIndex];
            
//            [previosSelectedItem setTitleColor:[UIColor colorWithWhite:0.6 + 0.4 * (1 - fabsf(ratio))
//                                                                 alpha:1.] forState:UIControlStateNormal];
//            [nextSelectedItem setTitleColor:[UIColor colorWithWhite:0.6 + 0.4 * fabsf(ratio)
//                                                              alpha:1.] forState:UIControlStateNormal];
//            
//            CGFloat value = 0.01+0.79*fabsf(ratio); //1->0.6   0.01 -> 0.8
//            [previosSelectedItem setTitleColor:[UIColor colorWithRed:value green:value blue:value alpha:1.] forState:UIControlStateNormal];
//            
//            CGFloat value2 = 0.01+0.79*(1 - fabsf(ratio)); //0.6->1   0.8 -> 0.01
//            [nextSelectedItem setTitleColor:[UIColor colorWithRed:value2 green:value2 blue:value2 alpha:1.] forState:UIControlStateNormal];
            
            CGFloat value = 0.5+0.5*(1 - fabsf(ratio));
            CGFloat value2 = 0.5+0.5*fabsf(ratio);
            [previosSelectedItem setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:value] forState:UIControlStateNormal];
            
            [nextSelectedItem setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:value2] forState:UIControlStateNormal];
            
            if (scrollingTowards) {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX +
                                                                   (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX +
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            self.pageIndicatorView.center.y);
                
            } else {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX -
                                                                   (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX -
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            self.pageIndicatorView.center.y);
            }
        }
    }
}

@end






