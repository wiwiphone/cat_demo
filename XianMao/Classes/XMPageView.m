//
//  XMPageView.m
//  XianMao
//
//  Created by darren on 15/1/23.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "XMPageView.h"

#import "ASScroll.h"

#define XMPAGEVIEW_SWITCH_PICTURE_INTERVAL 4.0 // 滚动图片间隔时间


@interface XMPageView()

@property(nonatomic,strong) UIScrollView  *scrollView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XMPageView {
    ASScrollPageIndicatorView *_pageControl;
    BOOL _enableDecelerating;
}

@synthesize scrollView = _scrollView;
@synthesize currentPage = _curPage;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _enableDecelerating = YES;
        return [self initWithFrame:CGRectZero];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame autoSwitch:(BOOL)autoSwitch {
    self = [super initWithFrame:frame];
    if (self) {
        
        _autoSwitch = autoSwitch;
        
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.userInteractionEnabled = YES;
        [self addSubview:_scrollView];
        
        _pageControl = [[ASScrollPageIndicatorView alloc] init];
        _pageControl.userInteractionEnabled = YES;
        _pageControl.frame = CGRectMake((self.width-_pageControl.width)/2, self.height-_pageControl.height, _pageControl.width, _pageControl.height);
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
        _enableDecelerating = YES;
        // 定时滚动视图
        //[self performSelector:@selector(switchImageItems) withObject:nil afterDelay:XMPAGEVIEW_SWITCH_PICTURE_INTERVAL];
        
        [self startTimer];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame autoSwitch:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
    _pageControl.frame = CGRectMake((self.width-_pageControl.width)/2, self.height-_pageControl.height, _pageControl.width, _pageControl.height);
    
    NSArray *subviews = [_scrollView subviews];
    for (NSInteger i=0;i<subviews.count;i++) {
        UIView *view = [subviews objectAtIndex:i];
        view.frame = CGRectMake(i*_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)reloadData
{
    [self resetTimer];
    NSInteger totalPages = [_datasource numberOfViewPages];
    if (totalPages>0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        _enableDecelerating = NO;
        
        _totalPages = totalPages;
        _pageControl.numberOfPages = totalPages;
        _pageControl.alpha = 1.0f;
        if (_curPage>=totalPages) {
            _curPage = 0;
        }
        
        NSArray *subViews = [_scrollView subviews];
        for (UIView *view in subViews) {
            [view  removeFromSuperview];
        }
        
        [self loadData];
        
        [self setNeedsLayout];
        
        _enableDecelerating = YES;
        
//        [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:XMPAGEVIEW_SWITCH_PICTURE_INTERVAL];
        
        [self startTimer];
        
    }
}

- (void)startTimer {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:XMPAGEVIEW_SWITCH_PICTURE_INTERVAL target:self selector:@selector(switchImageItems) userInfo:nil repeats:YES];
        }
//    });
}

- (void)resetTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)loadData
{
    if(_totalPages > 0) {
        _pageControl.currentPage = _curPage;
        
        NSInteger pre = [self validPageValue:_curPage-1];
        NSInteger last = [self validPageValue:_curPage+1];
        
        //从scrollView上移除所有的subview
        NSArray *subViews = [_scrollView subviews];
        if([subViews count] != 0) {
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        if (_datasource && [_datasource respondsToSelector:@selector(viewAtPageIndex:)]) {
            
            NSMutableArray *pages = [[NSMutableArray alloc] init];
            UIView *view = [_datasource viewAtPageIndex:pre];
            view.tag = pre;
            [pages addObject:view];
            view = [_datasource viewAtPageIndex:_curPage];
            view.tag = _curPage;
            [pages addObject:view];
            view = [_datasource viewAtPageIndex:last];
            view.tag = last;
            [pages addObject:view];
            
            for (NSInteger i=0;i<pages.count;i++) {
                UIView *view = [pages objectAtIndex:i];
                view.frame = CGRectOffset(view.frame, view.frame.size.width * i, 0);
                view.userInteractionEnabled = YES;
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
                [_scrollView addSubview:view];
            }
            
            pages = nil;
        }
    }
}

- (NSInteger)validPageValue:(NSInteger)value {
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(didClickViewPage:atPageIndex:)]) {
        [_delegate didClickViewPage:self atPageIndex:_curPage];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self resetTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollView.subviews count]>0) {
//        [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:XMPAGEVIEW_SWITCH_PICTURE_INTERVAL];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*aScrollView.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
        [self setNeedsLayout];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
        [self setNeedsLayout];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if (_enableDecelerating) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    }
    [self startTimer];
}

#pragma mark 定时滚动视图

- (void)switchImageItems
{
    int x = _scrollView.contentOffset.x;
    [_scrollView setContentOffset:CGPointMake(x+_scrollView.bounds.size.width, 0) animated:YES];
    
//    [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:XMPAGEVIEW_SWITCH_PICTURE_INTERVAL];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _scrollView = nil;
    _pageControl = nil;
    self.delegate = nil;
    self.datasource = nil;
}

//////////////////////////------------------/////////////////////////////
/////                                                             //////
/////                                                            //////
/////                                                           //////
/////                                                          //////
/////                 修改轮播器为CollectionView                      //////
/////                                                              //////
/////                                                                  //////
/////                                                                 //////
/////                                                                //////
/////                                                               //////
/////////////////////////------------------//////////////////////////////



@end
