//
//  PullTableView.h
//  Fisherman
//
//  Created by simon cai on 7/24/14.
//  Copyright (c) 2014 wopaiapp.com. All rights reserved.
//

#import "PullRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>

#define FLIP_ANIMATION_DURATION 0.18f

#define PULL_AREA_HEIGHT 30.0f
#define PULL_TRIGGER_HEIGHT (PULL_AREA_HEIGHT*2 + 5.0f)

@interface PullRefreshTableView () <RefreshTableHeaderDelegate,LoadMoreTableFooterDelegate> {
    CADisplayLink *_displayLink;
    NSInteger _framesInLastInterval;
    CFAbsoluteTime _lastLogTime;
    NSInteger _totalFrames;
    NSTimeInterval _scrollingTime;
    CGFloat _averageFPS;
    
    RefreshTableHeaderView *_headerView;
    LoadMoreTableFooterView *_footerView;
}

@property (nonatomic, assign, readwrite) CGFloat averageFPS;

@end

@implementation PullRefreshTableView

@synthesize averageFPS = _averageFPS;

#pragma mark - Object Lifecycle

- (void)dealloc {
    [_displayLink invalidate];
    
    _headerView = nil;
    _footerView = nil;
    
    _pullDelegate = nil;
}

- (void)didMoveToWindow {
    if ([self window] != nil) {
        [self _scrollingStatusDidChange];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

#pragma mark - Monitoring Scrolling Performance

- (void)resetScrollingPerformanceCounters {
    _framesInLastInterval = 0;
    _lastLogTime = CFAbsoluteTimeGetCurrent();
    _scrollingTime = 0;
    _totalFrames = 0;
}

- (void)_scrollingStatusDidChange {
//    NSString *currentRunLoopMode = [[NSRunLoop currentRunLoop] currentMode];
//    BOOL isScrolling = [currentRunLoopMode isEqualToString:UITrackingRunLoopMode];
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_scrollingStatusDidChange) object:nil];
//    
//    if (isScrolling) {
//        if (_displayLink == nil) {
//            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_screenDidUpdateWhileScrolling:)];
//            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:UITrackingRunLoopMode];
//        }
//        
//        _framesInLastInterval = 0;
//        _lastLogTime = CFAbsoluteTimeGetCurrent();
//        [_displayLink setPaused:NO];
//        
//        // Let us know when scrolling has stopped
//        [self performSelector:@selector(_scrollingStatusDidChange) withObject:nil afterDelay:0 inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
//    } else {
//        [_displayLink setPaused:YES];
//        
//        // Let us know when scrolling begins
//        [self performSelector:@selector(_scrollingStatusDidChange) withObject:nil afterDelay:0 inModes:[NSArray arrayWithObject:UITrackingRunLoopMode]];
//    }
}

- (void)_screenDidUpdateWhileScrolling:(CADisplayLink *)displayLink {
//    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
//    if (!_lastLogTime) {
//        _lastLogTime = currentTime;
//    }
//    CGFloat delta = currentTime - _lastLogTime;
//    if (delta >= 1) {
//        _scrollingTime += delta;
//        _totalFrames += _framesInLastInterval;
//        NSInteger lastFPS = (NSInteger)rintf((CGFloat)_framesInLastInterval / delta);
//        CGFloat averageFPS = (CGFloat)(_totalFrames / _scrollingTime);
//        [self setAverageFPS:averageFPS];
//        
//        static dispatch_queue_t __dispatchQueue = nil;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            __dispatchQueue = dispatch_queue_create("com.path.FastImageCacheDemo.ScrollingPerformanceMeasurement", 0);
//        });
//        
//        // We don't want the logging of scrolling performance to be able to impact the scrolling performance,
//        // so move both the logging and the string formatting onto a GCD serial queue.
//        dispatch_async(__dispatchQueue, ^{
//            NSLog(@"*** FMTableView: Last FPS = %d, Average FPS = %.2f", lastFPS, averageFPS);
//        });
//        
//        _framesInLastInterval = 0;
//        _lastLogTime = currentTime;
//    } else {
//        _framesInLastInterval++;
//    }
}

- (void)setContentMarginTop:(CGFloat)contentMarginTop {
    if (_contentMarginTop != contentMarginTop) {
        _contentMarginTop = contentMarginTop;
        
        _headerView.contentMarginTop = _contentMarginTop;
        
        [self setContentInset:UIEdgeInsetsMake(_contentMarginTop, 0.0f, 0.0f, 0.0f)];
        [self setContentOffset:CGPointMake(0, -_contentMarginTop) animated:NO];
        [self setScrollIndicatorInsets:UIEdgeInsetsMake(_contentMarginTop, 0.0f, 0.0f, 0.0f)];
        
        [self setNeedsLayout];
    }
}

- (void)setContentMarginBottom:(CGFloat)contentMarginBottom {
    if (_contentMarginBottom != contentMarginBottom) {
        _contentMarginBottom = contentMarginBottom;
        
    }
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initialize:NO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isShowTopIndicatorImage:(BOOL)isShowTopIndicatorImage {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self initialize:isShowTopIndicatorImage];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize:NO];
}

- (void)initialize:(BOOL)isShowTopIndicatorImage {
    /* Status Properties */
    self.pullTableIsRefreshing = NO;
    self.pullTableIsLoadingMore = NO;
    
    /* Refresh View */
    _headerView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height) isShowTopIndicatorImage:isShowTopIndicatorImage];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _headerView.delegate = self;
    [self addSubview:_headerView];
    
    /* Load more view init */
    _footerView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _footerView.delegate = self;
    [self addSubview:_footerView];
    
    _contentMarginTop = 0.f;
    _autoTriggerLoadMore = YES;
    _autoTriggerLoadMoreHeight = 80.f;
    
    _enableRefreshing = YES;
    _enableLoadingMore = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _headerView.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    
    
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height+self.contentInset.top));
    CGRect loadMoreFrame = _footerView.frame;
//    visibleTableDiffBoundsHeight = 0;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    _footerView.frame = loadMoreFrame;
    
}

- (void)reloadData {
    [super reloadData];
    // Give the footers a chance to fix it self.
    [_footerView scrollViewDidScroll:self autoTriggerLoadMore:NO autoTriggerLoadMoreHeight:0.f];
}

- (void)setPullTableIsRefreshing:(BOOL)isRefreshing {
    if(!_pullTableIsRefreshing && isRefreshing) {
        // If not allready refreshing start refreshing
        [_headerView startAnimatingWithScrollView:self];
        _pullTableIsRefreshing = YES;
    } else if(_pullTableIsRefreshing && !isRefreshing) {
        [_headerView scrollViewDataSourceDidFinishLoading:self];
        _pullTableIsRefreshing = NO;
    }
}

- (void)setPullTableIsLoadingMore:(BOOL)isLoadingMore {
    if(!_pullTableIsLoadingMore && isLoadingMore) {
        // If not allready loading more start refreshing
        [_footerView startAnimatingWithScrollView:self];
        _pullTableIsLoadingMore = YES;
    } else if(_pullTableIsLoadingMore && !isLoadingMore) {
        [_footerView scrollViewDataSourceDidFinishLoading:self];
        _pullTableIsLoadingMore = NO;
    }
}

- (void)setPullTableIsLoadFinish:(BOOL)pullTableIsLoadFinish {
    [_footerView scrollViewEndLoading:self isEndLoading:pullTableIsLoadFinish];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_enableRefreshing) {
        [_headerView scrollViewDidScroll:scrollView];
    }
    if (_enableLoadingMore) {
        [_footerView scrollViewDidScroll:self autoTriggerLoadMore:_autoTriggerLoadMore autoTriggerLoadMoreHeight:_autoTriggerLoadMoreHeight];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (_enableRefreshing) {
        [_headerView scrollViewDidEndDragging:scrollView];
    }
    if (_enableLoadingMore) {
        [_footerView scrollViewDidEndDragging:self];
    }
}

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view {
    if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(pullTableViewDidTriggerRefresh:)] && !_pullTableIsLoadingMore) {
        [_pullDelegate pullTableViewDidTriggerRefresh:self];
    }
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view {
    if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(pullTableViewDidTriggerLoadMore:)] && !_pullTableIsRefreshing) {
        [_pullDelegate pullTableViewDidTriggerLoadMore:self];
    }
}

- (void)setEnableRefreshing:(BOOL)enableRefreshing {
    if (_enableRefreshing!=enableRefreshing) {
        _enableRefreshing = enableRefreshing;
    }
    _headerView.hidden = !enableRefreshing;
}

- (void)setEnableLoadingMore:(BOOL)enableLoadingMore {
    if (_enableLoadingMore!=enableLoadingMore) {
        _enableLoadingMore = enableLoadingMore;
    }
    _footerView.hidden = !enableLoadingMore;
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.contentSize.height > self.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
        [self setContentOffset:offset animated:YES];
    }
}

- (void)scrollViewToTop:(BOOL)animated
{
    if (self.contentSize.height > self.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, -_contentMarginTop);
        [self setContentOffset:offset animated:YES];
    }
}

@end


#import "UIImage+Color1.h"

@interface RefreshTableHeaderView ()
@property(nonatomic,strong) CALayer *circleImage;
@end

@implementation RefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame isShowTopIndicatorImage:NO];
}

- (id)initWithFrame:(CGRect)frame isShowTopIndicatorImage:(BOOL)isShowTopIndicatorImage {
    if((self = [super initWithFrame:frame])) {
        
        _isLoading = NO;
        _contentMarginTop = 0.f;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        CGFloat midY = frame.size.height - PULL_AREA_HEIGHT/2;
		
        /* Config Status Updated Label */
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height-PULL_AREA_HEIGHT, self.bounds.size.width, PULL_AREA_HEIGHT)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor colorWithHexString:@"AAAAAA"];//E5C98B
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
		
        //pull_refresh_arrow@2x
        
        /* Config Arrow Image */
//		_arrowImage = [[CALayer alloc] init];
//        _arrowImage.contents = (id)[UIImage imageNamed:@"pull_refresh_arrow"].CGImage;
//		_arrowImage.frame = CGRectMake((self.bounds.size.width-60)/2-20-5,midY - 10.f, 20.f, 20.f);
//		_arrowImage.contentsGravity = kCAGravityResizeAspect;
////        
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			_arrowImage.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
//		[[self layer] addSublayer:_arrowImage];
        
        if (isShowTopIndicatorImage) {
            _indicatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_refresh_indicator"]];
            _indicatorImage.frame = CGRectMake((self.bounds.size.width-_indicatorImage.width)/2,midY-_indicatorImage.height, _indicatorImage.width, _indicatorImage.height);
            _indicatorImage.contentMode = UIViewContentModeCenter;
            [self addSubview:_indicatorImage];
        }
        
        UIImage *arrow = [UIImage imageNamed:@"pull_refresh_arrow"];
        _arrowImage = [[UIImageView alloc] initWithImage:arrow];
        _arrowImage.frame = CGRectMake((self.bounds.size.width-60)/2-20-5,midY-10.f, arrow.size.width, arrow.size.height);
        _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_arrowImage];
        
		
        /* Config activity indicator */
		//_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		//_activityView.frame = CGRectMake(25.0f,midY - 8, 20.0f, 20.0f);
		//[self addSubview:_activityView];
        
        
        _circleImage = [[CALayer alloc] init];
        _circleImage.contents = (id)[UIImage imageNamed:@"pull_round_refreshing"].CGImage;
        _circleImage.frame = CGRectMake((self.bounds.size.width-60)/2-20-5,midY-10.f, arrow.size.width, arrow.size.height);
        _circleImage.contentsGravity = kCAGravityResizeAspectFill;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//            _circleImage.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        [[self layer] addSublayer:_circleImage];
        _circleImage.hidden = YES;
        
		
		[self setState:RefreshTableStateNormal];
        
        //self.backgroundColor = [UIColor colorWithHexString:@"392426"];
        
        _indicatorImage.alpha = 0.f;
        _arrowImage.alpha = 0.f;
        _statusLabel.alpha = 0.f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat midY = self.bounds.size.height - PULL_AREA_HEIGHT/2;
    [_statusLabel sizeToFit];
    _statusLabel.frame = CGRectMake(0.0f, self.bounds.size.height-PULL_AREA_HEIGHT+(PULL_AREA_HEIGHT-_statusLabel.height)/2, self.bounds.size.width, _statusLabel.height);
    _arrowImage.frame = CGRectMake((self.bounds.size.width-60)/2-18,midY-_arrowImage.height/2, _arrowImage.width, _arrowImage.height);
    //_activityView.frame = CGRectMake(25.0f,midY-8, 20.0f, 20.0f);
    //_activityView.backgroundColor = [UIColor clearColor];
    
    _circleImage.frame = _arrowImage.frame;
    
    _indicatorImage.frame = CGRectMake((self.bounds.size.width-_indicatorImage.width)/2,_statusLabel.top-_indicatorImage.height-4, _indicatorImage.width, _indicatorImage.height);
}

- (void)setContentMarginTop:(CGFloat)contentMarginTop {
    if (_contentMarginTop!=contentMarginTop) {
        _contentMarginTop = contentMarginTop;
    }
}

#pragma mark -
#pragma mark Setters

- (void)setState:(RefreshTableState)aState{
	
	switch (aState) {
		case RefreshTableStatePulling:
			_statusLabel.text = @"释放更新";
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:FLIP_ANIMATION_DURATION]; // Set how long your animation goes for
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            _arrowImage.transform = CGAffineTransformMakeRotation((M_PI / 180.0) * 180.0f);            // and change the above code to: player.transform = CGAffineTransformMakeRotation(degreesToRadians(angle));
            [UIView commitAnimations];
            
			break;
            
		case RefreshTableStateNormal:
            if (_state == RefreshTableStatePulling) {
//				[CATransaction begin];
//				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//				_arrowImage.transform = CATransform3DIdentity;
//				[CATransaction commit];
                
                _arrowImage.transform = CGAffineTransformIdentity;
			}
			
			_statusLabel.text = @"下拉刷新";
			//[_activityView stopAnimating];
            [_circleImage removeAllAnimations];
            _circleImage.hidden = YES;
            
            
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//			_arrowImage.hidden = NO;
//			_arrowImage.transform = CATransform3DIdentity;
//			[CATransaction commit];
            
            _arrowImage.hidden = NO;
            _arrowImage.transform = CGAffineTransformIdentity;
			break;
            
		case RefreshTableStateLoading:
        {
            _statusLabel.text = @"加载中...";
            //[_activityView startAnimating];
//            [CATransaction begin];
//            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//            _arrowImage.hidden = YES;
//            [CATransaction commit];
            _arrowImage.hidden = YES;
            
            [_circleImage removeAllAnimations];
            _circleImage.hidden = NO;
            NSLog(@"--->_circleImage.hidden = NO");
            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = FALSE;
            rotate.fillMode = kCAFillModeForwards;
            
            //Do a series of 5 quarter turns for a total of a 1.25 turns
            //(2PI is a full turn, so pi/2 is a quarter turn)
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = HUGE_VALF;
            
            rotate.duration = 0.25;
            //            rotate.beginTime = start;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [_circleImage addAnimation:rotate forKey:@"rotateAnimation"];
        }
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentPosition = scrollView.contentOffset.y;
    if (currentPosition<=-_contentMarginTop) {
        CGFloat alpha = -(currentPosition+_contentMarginTop)/_contentMarginTop;
        if (alpha>=1) alpha = 1;
        
        _arrowImage.alpha = alpha;
        _statusLabel.alpha = alpha;
        
        CGFloat alphaIndicator = 0;
        if (currentPosition<=-_contentMarginTop-PULL_AREA_HEIGHT/2-15) {
            alphaIndicator = -(currentPosition+_contentMarginTop+PULL_AREA_HEIGHT/2+15)/_contentMarginTop;
            if (alphaIndicator>=1) alphaIndicator = 1;
        }
        _indicatorImage.alpha = alphaIndicator;
    } else {
        _arrowImage.alpha = 0.f;
        _statusLabel.alpha = 0.f;
        
        _indicatorImage.alpha = 0.f;
    }
    
    if (_state == RefreshTableStateLoading) {
        
//        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//        offset = MIN(offset, PULL_AREA_HEIGHT);
//        if (offset <= PULL_AREA_HEIGHT) {
//            UIEdgeInsets currentInsets = scrollView.contentInset;
//            currentInsets.top = offset;
//            scrollView.contentInset = currentInsets;
//        }
		
	} else if (scrollView.isDragging) {
		if (_state == RefreshTableStatePulling && scrollView.contentOffset.y+_contentMarginTop > -PULL_TRIGGER_HEIGHT && scrollView.contentOffset.y < _contentMarginTop && !_isLoading) {
			[self setState:RefreshTableStateNormal];
		} else if (_state == RefreshTableStateNormal && scrollView.contentOffset.y+_contentMarginTop < -PULL_TRIGGER_HEIGHT && !_isLoading) {
			[self setState:RefreshTableStatePulling];
		}
        
//		if (scrollView.contentInset.top != 0) {
//            UIEdgeInsets currentInsets = scrollView.contentInset;
//            currentInsets.top = 0;
//            scrollView.contentInset = currentInsets;
//		}
        
        if (scrollView.contentInset.top != _contentMarginTop) {
            [scrollView setContentInset:UIEdgeInsetsMake(_contentMarginTop, 0.0f, 0.0f, 0.0f)];
            [scrollView setContentOffset:CGPointMake(0, -_contentMarginTop) animated:NO];
            [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(_contentMarginTop, 0.0f, 0.0f, 0.0f)];
        }
	}
}

- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView {
    _isLoading = YES;
    
    [self setState:RefreshTableStateLoading];
    
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.top = PULL_AREA_HEIGHT;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.28f animations:^{
//            scrollView.contentInset = currentInsets;
//            [scrollView setContentOffset:CGPointMake(0, -currentInsets.top) animated:NO];
            
            [scrollView setContentInset:UIEdgeInsetsMake(_contentMarginTop+PULL_AREA_HEIGHT, 0.0f, 0.0f, 0.0f)];
            [scrollView setContentOffset:CGPointMake(0, -(_contentMarginTop+PULL_AREA_HEIGHT)) animated:NO];
            [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(_contentMarginTop+PULL_AREA_HEIGHT, 0.0f, 0.0f, 0.0f)];
            
        } completion:^(BOOL finished) {
        }];
    });
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y+_contentMarginTop <= - PULL_TRIGGER_HEIGHT && !_isLoading) {
        _isLoading = YES;
        if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate refreshTableHeaderDidTriggerRefresh:self];
        } else {
            [self startAnimatingWithScrollView:scrollView];
        }
	}
}

- (void)scrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView {
    
    _isLoading = NO;
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:.3];
//    UIEdgeInsets currentInsets = scrollView.contentInset;
//    currentInsets.top = 0;
//    scrollView.contentInset = currentInsets;
//    [UIView commitAnimations];
//    
//    [self setState:RefreshTableStateNormal];
    
    
    WEAKSELF;
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.25];
//        UIEdgeInsets currentInsets = scrollView.contentInset;
//        currentInsets.top = 0;
//        scrollView.contentInset = currentInsets;
//        
        [scrollView setContentInset:UIEdgeInsetsMake(_contentMarginTop, 0.0f, 0.0f, 0.0f)];
        [scrollView setContentOffset:CGPointMake(0, -_contentMarginTop) animated:NO];
        [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(_contentMarginTop, 0.0f, 0.0f, 0.0f)];
        
        [UIView commitAnimations];
        [weakSelf setState:RefreshTableStateNormal];
    });
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
}
@end


@implementation LoadMoreTableFooterView {
    
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        
        _isLoading = NO;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
		
		UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0, self.frame.size.width, PULL_AREA_HEIGHT+4)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        label.backgroundColor = [UIColor clearColor];
        [label setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        [label setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [label addTarget:self action:@selector(handleLoadMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *highlightedBgImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"E6E6E6"]];
        [label setBackgroundImage:[highlightedBgImage stretchableImageWithLeftCapWidth:highlightedBgImage.size.width/2 topCapHeight:highlightedBgImage.size.height/2] forState:UIControlStateHighlighted];
        UIImage *normalBgImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"F7F7F7"]];
        [label setBackgroundImage:[normalBgImage stretchableImageWithLeftCapWidth:normalBgImage.size.width/2 topCapHeight:normalBgImage.size.height/2] forState:UIControlStateNormal];
		[self addSubview:label];
		_statusLabel=label;
        
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake((self.bounds.size.width-60)/2-20-8, 20.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		//layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake((self.bounds.size.width-60)/2-20-8, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:RefreshTableStateNormal];
        
        self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
	
    return self;
	
}

- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView {
    CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
    
    CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight+scrollView.contentInset.top);
    CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight; // If scrolled all the way down this should add upp to the content heigh.
    
    CGFloat normalizedOffset = scrollAreaContenHeight -scrolledDistance;
    
    return normalizedOffset;
    
}

- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView
{
    return (scrollView.bounds.size.height - MIN(scrollView.bounds.size.height, scrollView.contentSize.height+scrollView.contentInset.top));
}

- (void)handleLoadMoreBtnClick:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoadMore:)] && !_isLoading) {
        _isLoading = YES;
        [_delegate loadMoreTableFooterDidTriggerLoadMore:self];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setState:(RefreshTableState)aState{
	
	switch (aState) {
		case RefreshTableStatePulling:
			
            _statusLabel.hidden = NO;
//			_statusLabel.text = @"释放加载更多";
            [_statusLabel setTitle:@"释放加载更多" forState:UIControlStateNormal];
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case RefreshTableStateNormal:
			
			if (_state == RefreshTableStatePulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            _statusLabel.hidden = NO;
            //_statusLabel.text = @"上拉加载更多";
            [_statusLabel setTitle:@"上拉加载更多" forState:UIControlStateNormal];
            
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			//_arrowImage.transform = CATransform3DIdentity;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case RefreshTableStateLoading:
            _statusLabel.hidden = NO;
			//_statusLabel.text = @"点击加载更多...";
            [_statusLabel setTitle:@"点击加载更多..." forState:UIControlStateNormal];
			//[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
        case RefreshTableStateLoadingEnd:
            _statusLabel.hidden = NO;
//            _statusLabel.text = @"没有更多了";
            [_statusLabel setTitle:@"没有更多了" forState:UIControlStateNormal];
            break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView autoTriggerLoadMore:(BOOL)autoTriggerLoadMore autoTriggerLoadMoreHeight:(CGFloat)autoTriggerLoadMoreHeight {
    
    CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
    
    void (^autoTriggerLoadMoreFun)() = ^() {
        CGFloat pullTriggerHeight = autoTriggerLoadMoreHeight;
        if (scrollView.contentSize.height>scrollView.bounds.size.height) {
            if (bottomOffset < pullTriggerHeight && !_isLoading) {
                
                _isLoading = YES;
                [self setState:RefreshTableStateLoading];
                
                UIEdgeInsets currentInsets = scrollView.contentInset;
                currentInsets.bottom = PULL_AREA_HEIGHT + [self visibleTableHeightDiffWithBoundsHeight:scrollView];
                scrollView.contentInset = currentInsets;
                
                if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoadMore:)]) {
                    [_delegate loadMoreTableFooterDidTriggerLoadMore:self];
                }
                return;
            }
        } else {
            if (_state == RefreshTableStatePulling && bottomOffset > -PULL_TRIGGER_HEIGHT && bottomOffset < 0.0f && !_isLoading) {
                [self setState:RefreshTableStateNormal];
            } else if (_state == RefreshTableStateNormal && bottomOffset < -PULL_TRIGGER_HEIGHT && !_isLoading) {
                [self setState:RefreshTableStatePulling];
            }
        }
        
        if (scrollView.contentInset.bottom != 0) {
            UIEdgeInsets currentInsets = scrollView.contentInset;
            currentInsets.bottom = 0;
            scrollView.contentInset = currentInsets;
        }
    };
	
    if (_state == RefreshTableStateLoadingEnd) {
        
    }
	else if (_state == RefreshTableStateLoading) {
        
//		CGFloat offset = MAX(bottomOffset * -1, 0);
//		offset = MIN(offset, PULL_AREA_HEIGHT);
//        UIEdgeInsets currentInsets = scrollView.contentInset;
//        currentInsets.bottom = offset? offset + [self visibleTableHeightDiffWithBoundsHeight:scrollView]: 0;
//        scrollView.contentInset = currentInsets;
		
	} else if (scrollView.isDragging) {
        if (autoTriggerLoadMore) {
            autoTriggerLoadMoreFun();
        } else {
            if (_state == RefreshTableStatePulling && bottomOffset > -PULL_TRIGGER_HEIGHT && bottomOffset < 0.0f && !_isLoading) {
                [self setState:RefreshTableStateNormal];
            } else if (_state == RefreshTableStateNormal && bottomOffset < -PULL_TRIGGER_HEIGHT && !_isLoading) {
                [self setState:RefreshTableStatePulling];
            }
            
            if (scrollView.contentInset.bottom != 0) {
                UIEdgeInsets currentInsets = scrollView.contentInset;
                currentInsets.bottom = 0;
                scrollView.contentInset = currentInsets;
            }
        }
    } else if (!scrollView.isDragging) {
        if (autoTriggerLoadMore) {
            autoTriggerLoadMoreFun();
        }
    }
}

- (void)startAnimatingWithScrollView:(UIScrollView *) scrollView {
    _isLoading = YES;
    
    [self setState:RefreshTableStateLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.bottom = PULL_AREA_HEIGHT + [self visibleTableHeightDiffWithBoundsHeight:scrollView];
    scrollView.contentInset = currentInsets;
    [UIView commitAnimations];
    if([self scrollViewOffsetFromBottom:scrollView] == 0){
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + PULL_TRIGGER_HEIGHT) animated:YES];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if ([self scrollViewOffsetFromBottom:scrollView] <= - PULL_TRIGGER_HEIGHT && !_isLoading) {
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoadMore:)]) {
            [_delegate loadMoreTableFooterDidTriggerLoadMore:self];
        } else {
            [self startAnimatingWithScrollView:scrollView];
        }
    }
}

- (void)scrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView {
	
    _isLoading = NO;
    
//    //这段注释掉了，防止加载更多的时候table向下滚动
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:.3];
//    UIEdgeInsets currentInsets = scrollView.contentInset;
//    currentInsets.bottom = 0;
//    scrollView.contentInset = currentInsets;
//	[UIView commitAnimations];
	
    if (_state != RefreshTableStateNormal ) {
        [self setState:RefreshTableStateNormal];
    }
}

- (void)scrollViewEndLoading:(UIScrollView *)scrollView isEndLoading:(BOOL)isEndLoading {
    if (isEndLoading) {
        if (_state != RefreshTableStateLoadingEnd) {
            [self setState:RefreshTableStateLoadingEnd];
            
            if (scrollView.contentInset.bottom > 0) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:.3];
                UIEdgeInsets currentInsets = scrollView.contentInset;
                currentInsets.bottom = 0;
                scrollView.contentInset = currentInsets;
                [UIView commitAnimations];
            }
            
//            if (scrollView.contentInset.bottom != PULL_AREA_HEIGHT) {
//                [UIView beginAnimations:nil context:NULL];
//                [UIView setAnimationDuration:0.2];
//                UIEdgeInsets currentInsets = scrollView.contentInset;
//                currentInsets.bottom = PULL_AREA_HEIGHT;
//                scrollView.contentInset = currentInsets;
//                [UIView commitAnimations];
//                if([self scrollViewOffsetFromBottom:scrollView] == 0){
//                    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + PULL_TRIGGER_HEIGHT) animated:YES];
//                }
//            }
        }
    } else {
        if (_state != RefreshTableStateNormal) {
            _isLoading = NO;
            [self setState:RefreshTableStateNormal];
        }
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
}

@end


///
@interface LoadMoreTableView () <LoadMoreTableFooterDelegate>
{
     LoadMoreTableFooterView *_footerView;
}
@end

@implementation LoadMoreTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _loadMoreTableIsLoadingMore = NO;
        
        _footerView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _footerView.delegate = self;
        [self addSubview:_footerView];
    }
    return self;
}

- (void)dealloc
{
    _footerView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
    
    CGRect loadMoreFrame = _footerView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    _footerView.frame = loadMoreFrame;
}

- (void)reloadData
{
    [super reloadData];
    // Give the footers a chance to fix it self.
    [_footerView scrollViewDidScroll:self autoTriggerLoadMore:NO autoTriggerLoadMoreHeight:0.f];
}

- (void)setLoadMoreTableIsLoadingMore:(BOOL)isLoadingMore
{
    if(!_loadMoreTableIsLoadingMore && isLoadingMore) {
        // If not allready loading more start refreshing
        [_footerView startAnimatingWithScrollView:self];
        _loadMoreTableIsLoadingMore = YES;
    } else if(_loadMoreTableIsLoadingMore && !isLoadingMore) {
        [_footerView scrollViewDataSourceDidFinishLoading:self];
        _loadMoreTableIsLoadingMore = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_footerView scrollViewDidScroll:scrollView autoTriggerLoadMore:NO autoTriggerLoadMoreHeight:0.f];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    [_footerView scrollViewDidEndDragging:scrollView];
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    _loadMoreTableIsLoadingMore = YES;
    if (_loadMoreDelegate && [_loadMoreDelegate respondsToSelector:@selector(loadMoreTableViewDidTriggerLoadMore:)]) {
        [_loadMoreDelegate loadMoreTableViewDidTriggerLoadMore:self];
    }   
}

@end




