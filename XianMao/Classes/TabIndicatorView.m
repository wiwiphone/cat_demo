//
//  TabIndicatorView.m
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "TabIndicatorView.h"
#import "UIColor+Expanded.h"

@interface TabIndicatorView ()

@property(nonatomic,retain) CALayer *indicatorView;
@property(nonatomic,assign) NSInteger tabCount;

@end

@implementation TabIndicatorView

@synthesize curTabIndex = _curTabIndex;

+ (CGFloat)heightForOrientationPortrait {
    return 2.f;
}

- (id)initWithFrame:(CGRect)frame tabCount:(NSInteger)tabCount {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorView = [CALayer layer];
        self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        [self.layer addSublayer:_indicatorView];
        
        _tabCount = tabCount;
        _curTabIndex = -1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width/_tabCount;
    CGFloat X = width*_curTabIndex+25;
    _indicatorView.frame = CGRectMake(X, 0, width-50, self.bounds.size.height);
}


- (void)setCurTabIndex:(NSInteger)index {
    if (_curTabIndex!=index) {
        NSInteger oldCurTabIndex = _curTabIndex;
        _curTabIndex = index;
        
        CGFloat width = self.bounds.size.width/_tabCount;
        CGFloat X = width*_curTabIndex+25;
        CGRect endFrame = CGRectMake(X, 0, width-50, self.bounds.size.height);
        
        if (oldCurTabIndex == -1) {
            _indicatorView.frame = endFrame;
        } else {
            [UIView animateWithDuration:0.25f animations:^{
                _indicatorView.frame = endFrame;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (NSInteger)curTabIndex {
    return _curTabIndex;
}

@end

