//
//  PullTableView.h
//  Fisherman
//
//  Created by simon cai on 7/24/14.
//  Copyright (c) 2014 wopaiapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RefreshTableHeaderView;
@class LoadMoreTableFooterView;

///
@protocol PullRefreshTableViewDelegate;

@interface PullRefreshTableView : UITableView

@property (nonatomic, assign, readonly) CGFloat averageFPS;

@property(nonatomic,assign) CGFloat contentMarginTop;
@property(nonatomic,assign) CGFloat contentMarginBottom;

@property (nonatomic, strong) RefreshTableHeaderView *headerView;
@property (nonatomic, strong) LoadMoreTableFooterView *footerView;

@property(nonatomic,assign) id<PullRefreshTableViewDelegate> pullDelegate;

@property(nonatomic,assign) BOOL enableRefreshing;
@property(nonatomic,assign) BOOL enableLoadingMore;

@property(nonatomic,assign) BOOL pullTableIsRefreshing;
@property(nonatomic,assign) BOOL pullTableIsLoadingMore;
@property(nonatomic,assign) BOOL pullTableIsLoadFinish;
@property(nonatomic,assign) BOOL autoTriggerLoadMore;
@property(nonatomic,assign) CGFloat autoTriggerLoadMoreHeight;

- (id)initWithFrame:(CGRect)frame isShowTopIndicatorImage:(BOOL)isShowTopIndicatorImage;

- (void)resetScrollingPerformanceCounters;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)scrollViewToBottom:(BOOL)animated;
- (void)scrollViewToTop:(BOOL)animated;

@end


@protocol PullRefreshTableViewDelegate <NSObject>
@optional
- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)tableView;
- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)tableView;
@end

///
typedef enum{
	RefreshTableStatePulling = 0,
	RefreshTableStateNormal,
	RefreshTableStateLoading,
    RefreshTableStateLoadingEnd,
} RefreshTableState;


@protocol RefreshTableHeaderDelegate;

@interface RefreshTableHeaderView : UIView {
	
	RefreshTableState _state;
    
	UILabel *_statusLabel;
//	CALayer *_arrowImage;
    UIImageView *_indicatorImage;
    UIImageView *_arrowImage;
	UIActivityIndicatorView *_activityView;
    
    BOOL _isLoading;
}

@property(nonatomic,assign) id<RefreshTableHeaderDelegate> delegate;
@property(nonatomic,assign) CGFloat contentMarginTop;

- (id)initWithFrame:(CGRect)frame isShowTopIndicatorImage:(BOOL)isShowTopIndicatorImage;
- (void)setState:(RefreshTableState)aState;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)scrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;
- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView;
@end


@protocol RefreshTableHeaderDelegate <NSObject>
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view;
@end

///
@protocol LoadMoreTableFooterDelegate;

@interface LoadMoreTableFooterView : UIView {
    
	RefreshTableState _state;
    
	UIButton *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    BOOL _isLoading;
}

@property(nonatomic,assign) id <LoadMoreTableFooterDelegate> delegate;
@property(nonatomic,assign) CGFloat contentMarginTop;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView autoTriggerLoadMore:(BOOL)autoTriggerLoadMore autoTriggerLoadMoreHeight:(CGFloat)autoTriggerLoadMoreHeight;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)scrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;
- (void)scrollViewEndLoading:(UIScrollView *)scrollView isEndLoading:(BOOL)isEndLoading;
- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView;
@end


@protocol LoadMoreTableFooterDelegate <NSObject>
- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view;
@end

///
@protocol LoadMoreTableViewDelegate;

@interface LoadMoreTableView : UITableView

@property (nonatomic, assign) id<LoadMoreTableViewDelegate> loadMoreDelegate;
@property (nonatomic, assign) BOOL loadMoreTableIsLoadingMore;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

@end

@protocol LoadMoreTableViewDelegate <NSObject>
- (void)loadMoreTableViewDidTriggerLoadMore:(LoadMoreTableView*)tableView;
@end



