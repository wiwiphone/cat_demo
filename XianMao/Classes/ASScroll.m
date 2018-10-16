//
//  ASScroll.m
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import "ASScroll.h"

#import "Command.h"
#import "DataSources.h"
#import "Masonry.h"

#define kASScrollPageIndicatorWidth 160
#define minimumPageScale 1

@implementation ASScrollPageIndicatorView {
    CALayer *_indicatorLayer;
}

- (void)dealloc
{
    _indicatorLayer = nil;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        _indicatorLayer = [CALayer layer];
        _indicatorLayer.backgroundColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        [self.layer addSublayer:_indicatorLayer];
        _currentPage = 0;
        _numberOfPages = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_numberOfPages>0) {
        CGFloat width = self.width/_numberOfPages;
        _indicatorLayer.frame = CGRectMake(_currentPage*width, 0, width, self.height);
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:currentPage anim:NO completion:nil];
}

- (void)setCurrentPage:(NSInteger)currentPage anim:(BOOL)anim completion:(void (^)(BOOL finished))completion {
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        if (anim) {
            CGFloat width = self.width/_numberOfPages;
            CGRect endFrame = CGRectMake(_currentPage*width, 0, width, self.height);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _indicatorLayer.frame = endFrame;
            } completion:^(BOOL finished) {
                _indicatorLayer.frame = endFrame;
                if (completion) {
                    completion(finished);
                }
            }];
        } else {
            [self setNeedsLayout];
            if (completion) {
                completion(YES);
            }
        }
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        _indicatorLayer.hidden = _numberOfPages>0?NO:YES;
        [self setNeedsLayout];
    }
}

- (void)scrolling:(CGFloat)ratio scrollingTowards:(BOOL)scrollingTowards {
    CGFloat width = self.width/_numberOfPages;
    CGFloat X = _currentPage*width+width*ratio;
    if (X >=0 && X<self.width-width) {
        _indicatorLayer.frame = CGRectMake(X, 0, width, self.height);
    }
}

@end


@interface ASScroll ()

@property(strong, nonatomic) UIPageControl *pageIndicatorView;
@property(weak,  nonatomic) UIScrollView *observingScrollView;
@property(assign,nonatomic) BOOL shouldObserveContentOffset;

@property (nonatomic, assign) NSInteger arrOfImagesCount;
@property (nonatomic, strong) UILabel *currLbl;
@property (nonatomic, strong) UIButton * statusLbl;
@property (nonatomic, strong) UILabel * totalLbl;
@property (nonatomic, strong) NSArray *rollDataArr;   // 图片数据
@property (nonatomic, assign) float halfGap;   // 图片间距的一半
@property (nonatomic, assign) float distance;

@end

@implementation ASScroll


-(UIButton *)statusLbl{
    if (!_statusLbl) {
        _statusLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_statusLbl setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _statusLbl.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _statusLbl.backgroundColor = [UIColor whiteColor];
        _statusLbl.titleLabel.numberOfLines = 0;
        [_statusLbl setTitle:@"释放\n查\n看\n商\n品\n详参\n数\n" forState:UIControlStateNormal];
        [_statusLbl setImage:[UIImage imageNamed:@"seeMore"] forState:UIControlStateNormal];
        [_statusLbl.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.statusLbl.titleLabel.mas_centerY);
            make.right.equalTo(self.statusLbl.titleLabel.mas_left).offset(-15);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
    }
    return _statusLbl;
}

-(UILabel *)currLbl{
    if (!_currLbl) {
        _currLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _currLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _currLbl.font = [UIFont systemFontOfSize:20.f];
        [_currLbl sizeToFit];
    }
    return _currLbl;
}

-(UILabel *)totalLbl{
    if (!_totalLbl) {
        _totalLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalLbl.textColor = [DataSources color99999];
        _totalLbl.font = [UIFont systemFontOfSize:10.f];
        [_totalLbl sizeToFit];
    }
    return _totalLbl;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.halfGap = 20/2;
        self.distance = 47.5f;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _currentPage = 0;
        _shouldObserveContentOffset = YES;
        
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(_distance, 0, self.frame.size.width - 2 * _distance, kScreenWidth/375*375)];
        [_scrollview setDelegate:self];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.pagingEnabled = YES;
        _scrollview.clipsToBounds = NO;
        [self addSubview:_scrollview];
        
        if (self.isHavePagePoint) {
            _pageIndicatorView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kASScrollPageIndicatorWidth, 2)];
            _pageIndicatorView.currentPageIndicatorTintColor = [UIColor blackColor];
            _pageIndicatorView.pageIndicatorTintColor = [UIColor darkGrayColor];
            [self addSubview:_pageIndicatorView];
        }
        
        [self insertSubview:self.currLbl aboveSubview:_scrollview];
        [self insertSubview:self.totalLbl aboveSubview:_scrollview];
        [self.currLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_scrollview.mas_centerX);
            make.top.equalTo(_scrollview.mas_bottom).offset(15);
        }];
        
        [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currLbl.mas_right);
            make.bottom.equalTo(self.currLbl.mas_bottom).offset(-3);
        }];
        
        [self startObservingContentOffsetForScrollView:_scrollview];
        [self.pageIndicatorView bringSubviewToFront:self];
        
        
        
        
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
    _pageIndicatorView = nil;
    _currLbl = nil;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSArray *subviews = [_scrollview subviews];
   
    for (int i=0;i<[subviews count];i++) {
        XMWebImageView * imageview = (XMWebImageView*)[[_scrollview subviews] objectAtIndex:i];
        imageview.frame = CGRectMake((2 * i) * self.halfGap + i * itemWidth, 0, itemWidth, self.frame.size.height);
    }
    self.statusLbl.frame = CGRectMake(_scrollview.frame.size.width * _rollDataArr.count+ kScreenWidth/375*10, 0, 60, self.height);
    
    _pageIndicatorView.frame = CGRectMake((self.width-_pageIndicatorView.width)/2, self.height-15-2, _pageIndicatorView.width, _pageIndicatorView.height);
     [self refreshVisibleCellAppearance];
    
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage != currentPage && currentPage>=0 && currentPage<[_scrollview subviews].count) {
        _currentPage = currentPage;
        
        _pageIndicatorView.currentPage = _currentPage;
        [_scrollview setContentOffset:CGPointMake(_scrollview.frame.size.width*_currentPage, 0)];
        
        _scrollview.userInteractionEnabled = YES;
    }
}

-(void)setArrOfImages:(NSMutableArray *)arrOfImages{
    
    
    if (arrOfImages) {
        _rollDataArr = arrOfImages;
    }
    
    NSArray *subviews = [_scrollview subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    
    WEAKSELF;
    for (NSInteger i=0;i<arrOfImages.count;i++) {
        XMWebImageView * imageview = [[XMWebImageView alloc] initWithFrame:_scrollview.bounds];
        imageview.clipsToBounds = YES;
        imageview.userInteractionEnabled = YES;
        //contentModel  模式修改为  fill   2016.5.7 Feng
        [imageview setContentMode:UIViewContentModeScaleAspectFill];//UIViewContentModeScaleAspectFit];
        imageview.backgroundColor = [DataSources globalWhiteColor];
        [_scrollview addSubview:imageview];
        imageview.hidden = YES;
    }
    
    
    
    for (int i =0; i<arrOfImages.count ; i++) {
        XMWebImageView * imageview = (XMWebImageView*)[[_scrollview subviews] objectAtIndex:i];
        imageview.hidden = NO;
        imageview.tag = i;
        
        [imageview setImageWithQNDownloadURL:[arrOfImages objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"placeholder_goods_640x640"] progressBlock:nil succeedBlock:nil failedBlock:nil];
        
        typeof(imageview) __weak weakImageview = imageview;
        typeof(NSArray*) __weak weakImageviewsArray = [_scrollview subviews];
        
        imageview.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            //NSInteger index = view.tag;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickViewPage:imageViewArray:)]) {
                [weakSelf.delegate didClickViewPage:weakImageview imageViewArray:weakImageviewsArray];
            }
        };
    }
    
    //+10 因为防止一张图片的时候contentSize不够,图片不能滑动
    _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width * arrOfImages.count+10,_scrollview.frame.size.height);
    _arrOfImagesCount = arrOfImages.count;
    self.currLbl.text = [NSString stringWithFormat:@"%ld",(long)_currentPage+1];
    self.totalLbl.text = [NSString stringWithFormat:@"/%ld",(unsigned long)(long)arrOfImages.count];
    _pageIndicatorView.numberOfPages = arrOfImages.count;
    _pageIndicatorView.currentPage = _currentPage;
    if ([arrOfImages count]>0) {
        _pageIndicatorView.hidden = NO;
        _pageIndicatorView.frame = CGRectMake((self.width-_pageIndicatorView.width)/2, self.height-15-2, _pageIndicatorView.width, _pageIndicatorView.height);
    } else {
        _pageIndicatorView.hidden = YES;
    }
    
    [_scrollview addSubview:self.statusLbl];
    
    
    [self setNeedsLayout];
}

- (BOOL)isCanSeeMore{
    NSInteger currentWidth = _scrollview.contentOffset.x - itemWidth*(self.rollDataArr.count-1);
    return currentWidth > 0 ? YES : NO;
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_pageIndicatorView setCurrentPage:_scrollview.bounds.origin.x/_scrollview.frame.size.width];
    NSInteger currText = _scrollview.bounds.origin.x/_scrollview.frame.size.width;
    self.currLbl.text = [NSString stringWithFormat:@"%ld",currText+1];
    _scrollview.userInteractionEnabled = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _shouldObserveContentOffset = YES;
    if ([self.delegate respondsToSelector:@selector(asscrollViewDidScroll:ASScrollView:)]) {
        [self.delegate asscrollViewDidScroll:scrollView ASScrollView:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _scrollview.userInteractionEnabled = YES;
    }
    _shouldObserveContentOffset = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    _scrollview.userInteractionEnabled = NO;
    [self refreshVisibleCellAppearance];
}

- (void)refreshVisibleCellAppearance{
    CGFloat offset = _scrollview.contentOffset.x;
    for (int i = 0 ; i< self.rollDataArr.count; i++) {
        UIImageView *cell = [_scrollview.subviews objectAtIndex:i];
        CGFloat origin = cell.frame.origin.x;
        CGFloat delta = fabs(origin - offset);
        CGRect originCellFrame = CGRectMake((2 * i) * self.halfGap + i * itemWidth, 0, itemWidth, self.frame.size.height);
        if (delta < itemWidth) {
            cell.alpha = 1;
            CGFloat inset = (itemWidth * (1 - minimumPageScale)) * (delta / itemWidth)/2.0;
            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
        }else{
            cell.alpha = 0.7;
            CGFloat inset = itemWidth * (1 - minimumPageScale) / 2.0 ;
            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
        }
    }
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _scrollview.userInteractionEnabled = YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSInteger selectedIndex = _pageIndicatorView.currentPage;
    CGFloat oldX = selectedIndex * CGRectGetWidth(_scrollview.frame);
    if (oldX != _scrollview.contentOffset.x && self.shouldObserveContentOffset) {
        BOOL scrollingTowards = (_scrollview.contentOffset.x > oldX);
        NSInteger targetIndex = (scrollingTowards) ? selectedIndex + 1 : selectedIndex - 1;
        if (targetIndex >= 0 && targetIndex < _pageIndicatorView.numberOfPages) {
//            CGFloat ratio = (_scrollview.contentOffset.x - oldX) / CGRectGetWidth(_scrollview.frame);
//            [self.pageIndicatorView scrolling:ratio scrollingTowards:scrollingTowards];
        }
    }
}

@end


@implementation ASScrollPageNewView



@end




