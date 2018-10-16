//
//  ScorllLabelView.m
//  XianMao
//
//  Created by WJH on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ScrollLabelView.h"

@interface ScrollLabelView()<UIScrollViewDelegate>


@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat labelW;
@property (nonatomic,assign) CGFloat labelH;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger page;

@end

@implementation ScrollLabelView

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.pagingEnabled = YES;
        [_scrollView setContentOffset:CGPointMake(0 , self.labelH) animated:YES];
    }
    
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.labelW = frame.size.width;
        self.labelH = frame.size.height;
        self.scrollView.delegate = self;
        [self addSubview:_scrollView];
        [self addTimer];
    }
    
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    _page = (int)titleArray.count;
    if (titleArray == nil) {
        [self removeTimer];
        return;
    }
    
    if (titleArray.count == 1) {
        [self removeTimer];
    }
    
    id lastObj = [titleArray lastObject];
    NSMutableArray *objArray = [[NSMutableArray alloc] init];
    
    [objArray addObject:lastObj];
    [objArray addObjectsFromArray:titleArray];
    
    self.titleNewArray = objArray;
    CGFloat contentH = self.labelH *objArray.count;
    
    self.scrollView.contentSize = CGSizeMake(0, contentH);
    
    CGFloat labelW = self.scrollView.frame.size.width;
    self.labelW = labelW;
    CGFloat labelH = self.scrollView.frame.size.height;
    self.labelH = labelH;
    CGFloat labelX = 0;

    for (id label in self.scrollView.subviews) {
        [label removeFromSuperview];
    }
    
    for (int i = 0; i < objArray.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentRight;
        CGFloat labelY = i * labelH;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.frame = CGRectMake(labelX, labelY, labelW, 40);
        titleLabel.text = objArray[i];
        if (i == 2) {
            titleLabel.textColor = [UIColor colorWithHexString:@"f4433e"];
        }else{
            titleLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        }
        [self.scrollView addSubview:titleLabel];
        
    }
    
}

- (void)addTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextLabel {
    
    static NSInteger index = 1;
    if (index == _page) {
        [self removeTimer];
        index = 1;
        return;
    }else{
        index++;
        CGPoint oldPoint = CGPointMake(0, index*40);
        [self.scrollView setContentOffset:oldPoint animated:YES];
    }
 
}


- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)beginScroll{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

//当图片滚动时调用scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.scrollView.contentOffset.y == self.scrollView.frame.size.height*(self.titleArray.count )) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //开启定时器
    [self addTimer];
}




@end
